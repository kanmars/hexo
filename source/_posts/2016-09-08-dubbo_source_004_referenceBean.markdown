---
layout: post
title:  "[KANMARS原创]-DUBBO源码解析(4)-referenceBean"
desc: "DUBBO源码解析(4)-referenceBean"
date: 2016-09-19 22:24:00
tags: [server,java]
---
DUBBO源码解析(4)-referenceBean

# 一、referenceBean概述 #

referenceBean也是较为常见的一个bean，当我们做如下配置的时候：

	<dubbo:reference timeout="1000000" group="${dubbo.group}" id="jkBusFacadeServiceImpl" interface="cn.com.gome.sn.dubbo.JkBusFacadeService" registry="SN-DubboProvider" retries="0" check="false" />

就是创建了一个referenceBean对象

# 二、referenceBean类图 #

![](http://i.imgur.com/7rwDLB0.png)

可以看到referenceBean的层次结构与serviceBean基本类似，最核心的类我们要关注两个:ReferenceBean和ReferenceConfig

# 三、ReferenceBean #

referenceBean实现了InitializingBean接口，因此在初始化之后会调用afterPropertiesSet方法，从代码中我们可以看到referenceBean的初始化过程如下：

1、初始化consumer对象		->初始化一些配置->从spring上下文中获取已加载的consumer

2、初始化application对象	->初始化一些配置->从spring上下文中获取已加载的application

3、初始化model       ->初始化一些配置->从spring上下文中获取已加载的model

4、初始化registries	->初始化一些配置->从spring上下文中获取已加载的registries

5、初始化monitor		->初始化一些配置->从spring上下文中获取已加载的monitor

6、调用getObject()对该对象进行初始化

7、调用ReferenceConfig().init()方法对ref对象进行初始化

由于referenceBean实现了FactoryBean接口，因此在自动注入时，会将ref注入到spring托管对象中，继而实现间接的调用

# 四、ReferenceConfig #

referenceConfig为reference启动的核心部分

其大致逻辑如下：

1、从系统变量和dubbo-resolve.properties中获取当前interfaceName的URL

2、对consumer、module、application、registries进行校验以及关系关联

3、ref = createProxy(map)	针对map的配置创建一个代理对象

4、Invoker invoker = refprotocol.refer(interfaceClass, urls)

5、如果protocol的address是采用分号分割，则使用集群模式	

	List<Invoker<?>> invokers = new ArrayList<Invoker>();
	invokers.add(invoker);
	invoker = cluster.join(new StaticDirectory(u, invokers));

6、return (T) proxyFactory.getProxy(invoker);


## 4.1 invoker = cluster.join(new StaticDirectory(u, invokers)); ##

而在cluster.join内部，则为分发与负载均衡的实现

Cluster.java的代码如下：

	@SPI(FailoverCluster.NAME)
	public interface Cluster {
	    @Adaptive
	    <T> Invoker<T> join(Directory<T> directory) throws RpcException;
	}
可以看到Cluster默认使用的是FailoverCluster

	public class FailoverCluster implements Cluster {
	    public final static String NAME = "failover";
	    public <T> Invoker<T> join(Directory<T> directory) throws RpcException {
	        return new FailoverClusterInvoker<T>(directory);
	    }
	}
可以看到FailoverCluster.join是新建一个FailoverClusterInvoker对象

其类图如下：

![](http://i.imgur.com/JzrAaWd.png)


## 4.2 FailoverClusterInvoker.invoke方法 ##


我们从AbstractClusterInvoker.invoke方法开始看，其调用堆栈顺序如下：

	AbstractClusterInvoker.invoke
		List<Invoker<T>> invokers = list(invocation);
			List<Invoker<T>> invokers = directory.list(invocation);
			return invokers;//此处获取到生成new StaticDirectory(u, invokers)时传入的invokers
		//此处获取到LoadBalance对象，默认为com.alibaba.dubbo.rpc.cluster.loadbalance.RandomLoadBalance
		LoadBalance loadbalance = ExtensionLoader.getExtensionLoader(LoadBalance.class).getExtension(invokers.get(0).getUrl().getMethodParameter(invocation.getMethodName(),Constants.LOADBALANCE_KEY, Constants.DEFAULT_LOADBALANCE));
		
		FailoverClusterInvoker.doInvoke(Invocation invocation, final List<Invoker<T>> invokers, LoadBalance loadbalance)
			Invoker<T> invoker = select(loadbalance, invocation, copyinvokers, invoked);
				List<Invoker<T>> ruleInvokers = new ArrayList<Invoker<T>>(); 
				Invoker<T> invoker = doselect(loadbalance, invocation, invokers, selected);
					Invoker<T> invoker = loadbalance.select(invokers, getUrl(), invocation);
						AbstractLoadBalance.select(List<Invoker<T>> invokers, URL url, Invocation invocation);
							RandomLoadBalance.doSelect(List<Invoker<T>> invokers, URL url, Invocation invocation)
								int offset = random.nextInt(totalWeight);
								return invokers.get(i);
					if(碰撞)Invoker<T> rinvoker = reselect(loadbalance, invocation, invokers, selected, availablecheck);//此处代码写的好潦草......
				return invoker;
			Result result = invoker.invoke(invocation);
			return result;


以上步骤即为调用顺序。

## 4.3 ReferenceBean调用顺序总结 ##

在调用某个referenceBean的某方法时：

	调用proxyFactory.getProxy(invoker)生成的代理，
	该代理内部会生成一个invokeHandler，
	将调用封装为一个RpcInvocation对象
	然后调用预先准备好的FailoverClusterInvoker对象的invoke方法
	然后获取到储存在FailoverClusterInvoker中的StaticDirectory对象的invokers
	然后调用loadbalance.doSelect方法，获取到真正的invoker
	然后调用该invoker执行消息发送->此步骤的invoker是通过refprotocol.refer(interfaceClass, url)生成的invoker
		当url在第一次调用时，协议为registry，因此refprotocol首次使用的是RegistryProtocol
		调用RegistryProtocol.refer方法
		Registry registry = registryFactory.getRegistry(url);//此处获取的是ZookeeperRegistryFactory
			ZookeeperRegistryFactory.getRegistry(url)
			ZookeeperRegistryFactory.createRegistry(url)
				ZookeeperTransporter zookeeperTransporter = new ZkclientZookeeperTransporter();
				new ZookeeperRegistry(url, zookeeperTransporter);
					zkClient = zookeeperTransporter.connect(url);
						client.subscribeStateChanges(new IZkStateListener() {...});
					zkClient.addStateListener(new StateListener() {
			            public void stateChanged(int state) {
			            	if (state == RECONNECTED) {
				            	try {
									recover();
								} catch (Exception e) {
									logger.error(e.getMessage(), e);
								}
			            	}
			            }
			        });
					FailbackRegistry.recover()
						addFailedSubscribed
			registry.doRefer
				directory.subscribe()
				zookeeperRegistry.subscribe(url, this);//this是RegistryDirectory对象
					FailbackRegistry.subscribe(url, this)
						zookeeperRegistry.doSubscribe(final URL url, final NotifyListener listener)//此处listener为RegistryDirectory对象
						listeners.putIfAbsent(listener, new ChildListener() {
                            public void childChanged(String parentPath, List<String> currentChilds) {
                            	ZookeeperRegistry.this.notify(url, listener, toUrlsWithEmpty(url, parentPath, currentChilds));
                            }
                        });
						List<String> children = zkClient.addChildListener(path, zkListener);
						urls.addAll(toUrlsWithEmpty(url, path, children));
						notify(url, listener, urls);
						RegistryDirectory.notify(List<URL> urls)
							refreshInvoker(invokerUrls);
								destroyAllInvokers();

其最复杂的地方，在于zookeeper的注册与订阅，以及订阅到数据后对invokers的更新
	
# 五、总结 #

referenceBean核心的流程有两个：
1、如何生成代理：用于将一个对某个接口的调用，封装成为一个invocation对象，通过负载均衡选择invoker，序列化后，传递给目标通讯层，发送出结果，并且接受到响应，并且把响应解码为目标结果的过程。
2、如何在启动时，根据registry的配置信息，从registry所标注的地址中获取到zookeeper的服务器地址，并且根据服务器地址刷新本地的invoker列表

其细节则非常多了，例如loadbalance对invoker的选择，StaticDirectory和RegistryDirectory对url的选择，zookeeper对Transporter的封装等等。
如果第一次看这个，会被ExtensionLoader,AdaptiveExtension,各种层级的wrapper,filter给绕晕，

例如：当看到一个invoker.invoke的时候，你得先判断这个invoker究竟是什么invoker，才能知道这个操作究竟代表了什么含义
更有甚者：当看到一个adaptiveInvoker.invoke(url)的时候，你得先根据url的协议，判断adaptiveInvoker究竟是什么，然后再根据Extension机制，判断adaptiveInvoker的最终wrapper类是什么，然后再从最后一个wrapper进去，才能找到真正的调用顺序

......

但看熟了，你就会觉得好有意思了...






