---
layout: post
title:  "[KANMARS原创]-DUBBO源码解析(5)-consumerCall"
desc: "DUBBO源码解析(5)-consumerCall"
date: 2016-10-18 21:24:00
tags: [server,java]
---
DUBBO源码解析(5)-consumerCall客户端调用过程

# 一、Dubbo客户端调用过程概述 #

dubbo调用过程如下（集群模式的zookeeper,）：

1、通过依赖注入，注入一个ProxyBean

2、客户端调用ProxyBean的某方法

3、客户端调用已实例化到ProxyBean中的invoker(此处为AvailableCluster.join(new StaticDirectory(registryUrlsInvokers))生成的AbstractClusterInvoker)

4、调用步骤3中的AbstractClusterInvoker的invoke(final Invocation invocation) 方法

5、在步骤3中的AbstractClusterInvoker的doInvoke方法中，选择一个可用的注册中心地址，然后执行invoker.invoke(invocation);
此处的invoker对象为directory.list(invocation)，即步骤3的new StaticDirectory(registryUrlsInvokers)的list(invocation)返回的invokers对象，参见代码：
	
	public class StaticDirectory<T> extends AbstractDirectory<T> {
		... ...
		@Override
	    protected List<Invoker<T>> doList(Invocation invocation) throws RpcException {
	        return invokers;
	    }
	｝
因此此处执行的是随机从步骤3传入的注册中心的地址所代表的invoker列表中选择一个，然后调用invoker.invoke(invocation);

6、因为ExtensionLoader的自动封装机制，因此此处的invoker的封装关系为：MockClusterInvoker->FailoverClusterInvoker

7、调用FailoverClusterInvoker->AbstractClusterInvoker的invoke方法

8、根据FailoverClusterInvoker->AbstractClusterInvoker->list(invocation)获取可用的invoke(此处为具体的服务提供者)；而list(invocation)内部是调用了RegistryDirectory.list()->RegistryDirectory.list()，其代码如下。

	public List<Invoker<T>> doList(Invocation invocation) {
        if (forbidden) {
            throw new RpcException(RpcException.FORBIDDEN_EXCEPTION, "Forbid consumer " +  NetUtils.getLocalHost() + " access service " + getInterface().getName() + " from registry " + getUrl().getAddress() + " use dubbo version " + Version.getVersion() + ", Please check registry access list (whitelist/blacklist).");
        }
        List<Invoker<T>> invokers = null;
        Map<String, List<Invoker<T>>> localMethodInvokerMap = this.methodInvokerMap; //此处为重点
        if (localMethodInvokerMap != null && localMethodInvokerMap.size() > 0) {
            String methodName = RpcUtils.getMethodName(invocation);
            Object[] args = RpcUtils.getArguments(invocation);
            if(args != null && args.length > 0 && args[0] != null
                    && (args[0] instanceof String || args[0].getClass().isEnum())) {
                invokers = localMethodInvokerMap.get(methodName + "." + args[0]); 
            }
            if(invokers == null) {
                invokers = localMethodInvokerMap.get(methodName);//此处为重点，一般在此分支获取到真正的invokers
            }
            if(invokers == null) {
                invokers = localMethodInvokerMap.get(Constants.ANY_VALUE);
            }
            if(invokers == null) {
                Iterator<List<Invoker<T>>> iterator = localMethodInvokerMap.values().iterator();
                if (iterator.hasNext()) {
                    invokers = iterator.next();
                }
            }
        }
        return invokers == null ? new ArrayList<Invoker<T>>(0) : invokers;
    }

而RegistryDirectory是从哪儿来的？位于referenceBean的初始化过程中，在

	referenceConfig.createProxy
	invokers.add(refprotocol.refer(interfaceClass, url));
	RegistryProtocol.refer(Class<T> type, URL url)
	RegistryProtocol.doRefer(cluster, registry, type, url);
	RegistryDirectory<T> directory = new RegistryDirectory<T>(type, url);	//--此处实例化
	directory.subscribe(subscribeUrl.addParameter(Constants.CATEGORY_KEY, 	//--此处创建监听
                Constants.PROVIDERS_CATEGORY 
                + "," + Constants.CONFIGURATORS_CATEGORY 
                + "," + Constants.ROUTERS_CATEGORY));
	return cluster.join(directory);		//此处cluster为Cluster$Adaptive，使用的是FailoverCluster
	则join生成的FailoverClusterInvoker

再细看一下FailoverClusterInvoker的doList方法，使用的localMethodInvokerMap是从哪儿来的，invokers是从什么地方写进去的？

可以从RegistryDirectory.subscribe看

	public void subscribe(URL url) {
        setConsumerUrl(url);
        registry.subscribe(url, this);//注意此处的this，是一个listener接口的实现，含有notify方法
    }

可以看到调用的是registry.subscribe(url,this)，此处的registry是RegistryProtocol.doRefer(cluster, registry, type, url);的第二个参数，来自
	RegistryProtocol.refer(Class<T> type, URL url)
	Registry registry = registryFactory.getRegistry(url);	->获取到zookeeperRegistry
	
调用zookeeperRegistry.subscribe，调用FailbackRegistry.subscribe，调用zookeeperRegistry.doSubscribe，经过一番复杂的调用，在zookeeperRegistry->FailbackRegistry->AbstractRegistry.notify(URL url, NotifyListener listener, List<URL> urls)中调用了

listener.notify(categoryList);函数	此处的listener即为RegistryDirectory.subscribe传入的this，也即RegistryDirectory

那么我们看一下，在zookeeper的信息发生变化的时候,是如何更新，更新到什么位置的？

详见RegistryDirectory.notify，为帮助大家理解，我删除了一些不重要的代码

	public synchronized void notify(List<URL> urls) {
        List<URL> invokerUrls = new ArrayList<URL>();
        for (URL url : urls) {
            String protocol = url.getProtocol();
            String category = url.getParameter(Constants.CATEGORY_KEY, Constants.DEFAULT_CATEGORY);
            if (Constants.PROVIDERS_CATEGORY.equals(category)) {//如果是provider的话
                invokerUrls.add(url);
            }
        }
        // providers
        refreshInvoker(invokerUrls);//刷新从zookeeper中获取的invokerUrls参数
    }

	private void refreshInvoker(List<URL> invokerUrls){
        ... ... 
		Map<String, Invoker<T>> newUrlInvokerMap = toInvokers(invokerUrls) ;//将url转换为Invoker
		Map<String, List<Invoker<T>>> newMethodInvokerMap = toMethodInvokers(newUrlInvokerMap); // 换方法名映射Invoker列表
		... ...
        this.methodInvokerMap = 
			multiGroup ? toMergeMethodInvokerMap(newMethodInvokerMap) : newMethodInvokerMap;
        ... ...
    }


	private Map<String, Invoker<T>> toInvokers(List<URL> urls) {
        Map<String, Invoker<T>> newUrlInvokerMap = new HashMap<String, Invoker<T>>();
        
        Set<String> keys = new HashSet<String>();
        String queryProtocols = this.queryMap.get(Constants.PROTOCOL_KEY);
        for (URL providerUrl : urls) {
        	... ... 
            URL url = mergeUrl(providerUrl);
            
            // 缓存key为没有合并消费端参数的URL，不管消费端如何合并参数，如果服务端URL发生变化，则重新refer
            Map<String, Invoker<T>> localUrlInvokerMap = this.urlInvokerMap; // local reference
            Invoker<T> invoker = localUrlInvokerMap == null ? null : localUrlInvokerMap.get(key);
            if (invoker == null) { // 缓存中没有，重新refer
                try {
                	if (enabled) {
                		invoker = new InvokerDelegete<T>(protocol.refer(serviceType, url), url, providerUrl);
                	}
                } catch (Throwable t) {
                    logger.error("Failed to refer invoker for interface:"+serviceType+",url:("+url+")" + t.getMessage(), t);
                }
                if (invoker != null) { // 将新的引用放入缓存
                    newUrlInvokerMap.put(key, invoker);
                }
            }else {
                newUrlInvokerMap.put(key, invoker);
            }
        }
        keys.clear();
        return newUrlInvokerMap;
    }

	

可以看到methodInvokerMap即为最终获取到的调用URL的来源

结合本小节的开头，FailoverClusterInvoker.list函数，查询出来的即为从zookeeper集群中获取的真实服务端地址

9、回到7、调用FailoverClusterInvoker->AbstractClusterInvoker的invoke方法

	public Result invoke(final Invocation invocation) throws RpcException {

        checkWheatherDestoried();

        LoadBalance loadbalance;
        
        List<Invoker<T>> invokers = list(invocation);
        if (invokers != null && invokers.size() > 0) {
            loadbalance = ExtensionLoader.getExtensionLoader(LoadBalance.class).getExtension(invokers.get(0).getUrl()
                    .getMethodParameter(invocation.getMethodName(),Constants.LOADBALANCE_KEY, Constants.DEFAULT_LOADBALANCE));
        } else {
            loadbalance = ExtensionLoader.getExtensionLoader(LoadBalance.class).getExtension(Constants.DEFAULT_LOADBALANCE);
        }
        RpcUtils.attachInvocationIdIfAsync(getUrl(), invocation);
        return doInvoke(invocation, invokers, loadbalance);
    }

此步骤可以获取到loadbalance对象，默认为random

10、调用FailoverClusterInvoker.doInvoke方法，为了简单，我删除掉了与主流程无关的代码

	public Result doInvoke(Invocation invocation, final List<Invoker<T>> invokers, LoadBalance loadbalance) throws RpcException {
        for (int i = 0; i < invokers.size(); i++) {
            Invoker<T> invoker = select(loadbalance, invocation, invokers, invoked);
            Result result = invoker.invoke(invocation);
            return result;
        }
    }
	
	protected Invoker<T> select(LoadBalance loadbalance, Invocation invocation, List<Invoker<T>> invokers, List<Invoker<T>> selected) throws RpcException {
        ......
        Invoker<T> invoker = doselect(loadbalance, invocation, invokers, selected);
        ......
        return invoker;
    }

	private Invoker<T> doselect(LoadBalance loadbalance, Invocation invocation, List<Invoker<T>> invokers, List<Invoker<T>> selected) throws RpcException {
        ......
        Invoker<T> invoker = loadbalance.select(invokers, getUrl(), invocation);//此处的负载均衡算法比较简单，可以自己看
        ......
        return invoker;
    } 

11、然后调用Result result = invoker.invoke(invocation);//此处的invoker为最终的某个服务器上的调用，为步骤8的notify->refreshInvoker->toInvokers中生成的new InvokerDelegete<T>(protocol.refer(serviceType, url), url, providerUrl);

12、此处的protocol为referenceBean的protocol，常用为DubboProtocol，即此处的Result result = invoker.invoke(invocation);实质上调用的是new InvokerDelegete<T>(DubboProtocol.refer(serviceType, url), url, providerUrl).invoke(invocation)

13、参见DubboProtocol.refer函数
	
	public <T> Invoker<T> refer(Class<T> serviceType, URL url) throws RpcException {
        // create rpc invoker.
        DubboInvoker<T> invoker = new DubboInvoker<T>(serviceType, url, getClients(url), invokers);
        invokers.add(invoker);
        return invoker;
    }

	private ExchangeClient[] getClients(URL url){
        //是否共享连接
        boolean service_share_connect = false;
        int connections = url.getParameter(Constants.CONNECTIONS_KEY, 0);
        //如果connections不配置，则共享连接，否则每服务每连接
        if (connections == 0){
            service_share_connect = true;
            connections = 1;
        }
        
        ExchangeClient[] clients = new ExchangeClient[connections];
        for (int i = 0; i < clients.length; i++) {
            if (service_share_connect){
                clients[i] = getSharedClient(url);
            } else {
                clients[i] = initClient(url);
            }
        }
        return clients;
    }
	

即实际调用为new InvokerDelegete<T>(new DubboInvoker<T>(serviceType, url, getClients(url), invokers), url, providerUrl).invoke(invocation)
在InvokerDelegete的invoke中无实质有用的代码，因此此处实际上调用的是DubboInvoker.invoke->AbstractInvoker.invoke->DubboInvoker.doInvoke
	
	protected Result doInvoke(final Invocation invocation) throws Throwable {
		ExchangeClient currentClient = clients[0];
		boolean isAsync = RpcUtils.isAsync(getUrl(), invocation);//是否异步
        boolean isOneway = RpcUtils.isOneway(getUrl(), invocation);//是否单向
		if (isOneway) {
        	boolean isSent = getUrl().getMethodParameter(methodName, Constants.SENT_KEY, false);
            currentClient.send(inv, isSent);
            RpcContext.getContext().setFuture(null);
            return new RpcResult();
        } else if (isAsync) {//异步调用
        	ResponseFuture future = currentClient.request(inv, timeout) ;
            RpcContext.getContext().setFuture(new FutureAdapter<Object>(future));
            return new RpcResult();
        } else {//同步调用，默认情况
        	RpcContext.getContext().setFuture(null);
            return (Result) currentClient.request(inv, timeout).get();
        }
	}

14、调用currentClient即new ExchangeClient()的request方法，此处同步调用和异步调用的底层是相同的

	public ResponseFuture request(Object request, int timeout) throws RemotingException {
        if (closed) {
            throw new RemotingException(this.getLocalAddress(), null, "Failed to send request " + request + ", cause: The channel " + this + " is closed!");
        }
        // create request.
        Request req = new Request();
        req.setVersion("2.0.0");
        req.setTwoWay(true);
        req.setData(request);
        DefaultFuture future = new DefaultFuture(channel, req, timeout);
        try{
            channel.send(req);
        }catch (RemotingException e) {
            future.cancel();
            throw e;
        }
        return future;
    }
再看DefaultFuture这个类，构造方法如下
	
	private static final Map<Long, DefaultFuture> FUTURES   = new ConcurrentHashMap<Long, DefaultFuture>();

	public DefaultFuture(Channel channel, Request request, int timeout){
        this.channel = channel;
        this.request = request;
        this.id = request.getId();
        this.timeout = timeout > 0 ? timeout : channel.getUrl().getPositiveParameter(Constants.TIMEOUT_KEY, Constants.DEFAULT_TIMEOUT);
        // put into waiting map.
        FUTURES.put(id, this);//此处是重点，根据id，在FUTURES中已ID为key储存了每一个future，用于异步消息返回之后，与请求消息对应
        CHANNELS.put(id, channel);
    }

此处我们就简单以同步调用为例，同步调用的关键在于get方法

	return (Result) currentClient.request(inv, timeout).get();
	
调用的是DefaultFuture的get()函数

	public Object get(int timeout) throws RemotingException {
        if (timeout <= 0) {
            timeout = Constants.DEFAULT_TIMEOUT;
        }
        if (! isDone()) {
            long start = System.currentTimeMillis();
            lock.lock();
            try {
                while (! isDone()) {
                    done.await(timeout, TimeUnit.MILLISECONDS);
                    if (isDone() || System.currentTimeMillis() - start > timeout) {
                        break;
                    }
                }
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            } finally {
                lock.unlock();
            }
            if (! isDone()) {
                throw new TimeoutException(sent > 0, channel, getTimeoutMessage(false));
            }
        }
        return returnFromResponse();
    }
可见，在调用get的时候会阻塞，直到有数据返回

15、在发送消息的channel.send(req);函数中，会对req进行解码，解码是由NettyClient创建时的管道流所决定的

	@Override
    protected void doOpen() throws Throwable {
        NettyHelper.setNettyLoggerFactory();
        bootstrap = new ClientBootstrap(channelFactory);
        // config
        // @see org.jboss.netty.channel.socket.SocketChannelConfig
        bootstrap.setOption("keepAlive", true);
        bootstrap.setOption("tcpNoDelay", true);
        bootstrap.setOption("connectTimeoutMillis", getTimeout());
        final NettyHandler nettyHandler = new NettyHandler(getUrl(), this);
        bootstrap.setPipelineFactory(new ChannelPipelineFactory() {
            public ChannelPipeline getPipeline() {
                NettyCodecAdapter adapter = new NettyCodecAdapter(getCodec(), getUrl(), NettyClient.this);
                ChannelPipeline pipeline = Channels.pipeline();
                pipeline.addLast("decoder", adapter.getDecoder());
                pipeline.addLast("encoder", adapter.getEncoder());
                pipeline.addLast("handler", nettyHandler);
                return pipeline;
            }
        });
    }
可以看到，使用的是NettyCodecAdapter的decoder和encoder作为解码、编码器

在此解码编码器内部即可完成对象的序列化，发送，接受，反序列化等操作

16、特别注意，由于ExtensionLoader的getExtension()机制中有一个自动封装机制，因此，使用ExtensionLoader加载的对象，会自动封装上其封装对象，例如步骤12获取DubboProtocol，实际获取的是如下内容：
	
	ProtocolListenerWrapper
		- ProtocolFilterWrapper
			- DubboProtocol

而在ProtocolFilterWrapper中，因为有如下代码

	public <T> Invoker<T> refer(Class<T> type, URL url) throws RpcException {
        if (Constants.REGISTRY_PROTOCOL.equals(url.getProtocol())) {
            return protocol.refer(type, url);
        }
        return buildInvokerChain(protocol.refer(type, url), Constants.REFERENCE_FILTER_KEY, Constants.CONSUMER);
    }

	private static <T> Invoker<T> buildInvokerChain(final Invoker<T> invoker, String key, String group) {
        Invoker<T> last = invoker;
		//此处为获取Filter中配置的ActivateExtension的拦截器，作为invoker的拦截对象
        List<Filter> filters = ExtensionLoader.getExtensionLoader(Filter.class).getActivateExtension(invoker.getUrl(), key, group);
        if (filters.size() > 0) {
            for (int i = filters.size() - 1; i >= 0; i --) {
                final Filter filter = filters.get(i);
                final Invoker<T> next = last;
                last = new Invoker<T>() {

                    public Class<T> getInterface() {
                        return invoker.getInterface();
                    }

                    public URL getUrl() {
                        return invoker.getUrl();
                    }

                    public boolean isAvailable() {
                        return invoker.isAvailable();
                    }

                    public Result invoke(Invocation invocation) throws RpcException {
                        return filter.invoke(next, invocation);
                    }

                    public void destroy() {
                        invoker.destroy();
                    }

                    @Override
                    public String toString() {
                        return invoker.toString();
                    }
                };
            }
        }
        return last;
    }
		
因这个原理，实现了dubboProtocol的拦截器拦截

本公司比较著名的例子，就是gcat的jar包，Maven: com.dianping.cat:cat-client:1.3.4-SNAPSHOT
里面有个/META-INF/dubbo/com.alibaba.dubbo.rpc.Filter文件，内容为

	catDubboFilter=com.gome.track.dubbo.CatDubboFilter

于是在ProtocolFilterWrapper.refer的过程中，因ExtensionLoader.getExtensionLoader(Filter.class).getActivateExtension机制加载了进来，形成了拦截所有的Dubbo调用的效果。

但是也可以看到，天下的代码一大抄，我们抄的大众点评的，连jar包名字都没改............


# 二、Dubbo服务端调用过程概述 #

Dubbo的服务端调用就简单多了，参见本系列的第三章serviceConfig即可。