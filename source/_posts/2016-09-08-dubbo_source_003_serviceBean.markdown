---
layout: post
title:  "[KANMARS原创]-DUBBO源码解析(3)-serviceBean"
desc: "DUBBO源码解析(3)-serviceBean"
date: 2016-09-18 22:24:00
tags: [server,java]
---
DUBBO源码解析(3)-serviceBean

# 一、serviceBean概述 #
我们终于讲到了serviceBean这个看似和Dubbo有点直接关系的地方，因为对于dubbo来说，我们最常做的事情，就是配置一个
	
	<dubbo:service loadbalance="${dubbo.loadbalance}" timeout="${dubbo.run.timeout}" group="${dubbo.group}" interface="cn.com.gome.sn.dubbo.JkBusFacadeService" ref="jkBusFacadeServiceImpl" registry="SN-DubboProvider"/>	
此处假设你已经精通Spring的自定义标签NameSpaceHandler功能，如果不懂，你就简单认为上述代码定义了一个Bean对象并托管给了Spring即可。

从“定义了一个Bean对象并托管给了Spring”这个定义，我们能大致了解这个标签究竟发生了什么事情。

在一个完成的配置中

	<dubbo:application name="sn-provider"/>
    <dubbo:registry protocol="zookeeper" address="${dubbo.run.registryAddress}" id="SN-DubboProvider"/>
    <dubbo:protocol name="dubbo" port="${dubbo.run.port}"/>

    <dubbo:service loadbalance="${dubbo.loadbalance}" timeout="${dubbo.run.timeout}" group="${dubbo.group}" interface="cn.com.gome.sn.dubbo.JkBusFacadeService" ref="jkBusFacadeServiceImpl" registry="SN-DubboProvider"/>

其实是定义了四个Bean对象，applicationConfig，registryConfig,protocolConfig,ServiceBean

在此处，我们只讲serviceBean，这个对象的初始化操作中，已经包含了上述的所有的对象，具有较全的代表性。

# 二、serviceBean类图 #

![](http://i.imgur.com/FKFb44a.png)

以上即为serviceBean的类图，右侧的分支均为Spring支持，左侧的分支为最重要的Dubbo支持类。

最核心要关注的有两个：serviceBean和serviceConfig

# 三、serviceBean #

在serviceBean中有一个最重要的方法是afterPropertiesSet()，实现了Spring的InitializingBean接口,当spring在该对象newInstance之后，会调用afterPropertiesSet()方法，使得Bean进行初始化，而serviceBean的启动也来源于此。

从代码中我们可以看到，afterPropertiesSet的执行过程如下：

1、初始化Provider	->初始化一些配置->从spring上下文中获取已加载的provider

2、初始化application	->初始化一些配置->从spring上下文中获取已加载的applicationContext

3、初始化model       ->初始化一些配置->从spring上下文中获取已加载的model

4、初始化registries	->初始化一些配置->从spring上下文中获取已加载的registries

5、初始化monitor		->初始化一些配置->从spring上下文中获取已加载的monitor

6、初始化protocols	->初始化一些配置->从spring上下文中获取已加载的Protocols

7、初始化path		->初始化path=beanName，此为在dubbo中注册的路径

8、调用serviceConfig.export()

以上可以看到serviceBean的启动比较简单，从spring上下文中获取相应的对象并设置入serviceBean，然后调用serviceConfig.export()将此Bean暴露出去

# 四、serviceConfig #

此类为service启动的核心部分，入口在serviceConfig.export()方法

其调用堆栈如下：

	export();
	doExport();
	doExportUrls();
	
	//获取到注册服务的地址
	//例如registry://10.58.50.203:2181/com.alibaba.dubbo.registry.RegistryService?application=sn-provider&backup=10.58.50.204:2181,10.58.50.205:2181&dubbo=2.5.5.cat-SNAPSHOT&pid=8004&registry=zookeeper&timestamp=1474195361722
	List<URL> registryURLs = loadRegistries(true);	
    for (ProtocolConfig protocolConfig : protocols) {
        doExportUrlsFor1Protocol(protocolConfig, registryURLs);
    }
	
	//将每个protocol，在registry上暴露出去
	doExportUrlsFor1Protocol(ProtocolConfig protocolConfig, List<URL> registryURLs) 

	//生成本地提供服务的url
	//dubbo://10.144.33.185:20880/cn.com.gome.sn.dubbo.JkBusFacadeService?anyhost=true&application=sn-provider&dubbo=2.5.5.cat-SNAPSHOT&generic=false&group=SN-uat&interface=cn.com.gome.sn.dubbo.JkBusFacadeService&loadbalance=leastactive&methods=service&pid=8004&side=provider&timeout=1000000&timestamp=1474195593808
	URL url = new URL(name, host, port, (contextPath == null || contextPath.length() == 0 ? "" : contextPath + "/") + path, map);
	
	//暴露本地服务
	exportLocol(url)
	Invoker invoker = proxyFactory.getInvoker(ref, (Class) interfaceClass, local);
	Exporter<?> exporter = protocol.export(invoker);
	//此处proxyFactory.getInvoker参见《Dubbo源码解析2-proxyFactory》，如果没看，你就认为此处对ref生成了一个AbstractProxyInvoker代理，并对ref对象的每一个方法都进行了封装，封装成了一个Result invoke(Invocation invocation)方法即可

	此后invoker对象的protocol为dubbo，则根据ExtensionLoader.getExtensionLoader(Protocol.class).getAdaptiveExtension()获取到的自适应类为DubboProtocol

	同时、此处因为ExtensionLoader.getExtensionLoader中含有warpper自动封装的代码，会将com.alibaba.dubbo.rpc.protocol.ProtocolFilterWrapper和com.alibaba.dubbo.rpc.protocol.ProtocolListenerWrapper也封装到DubboProtocol中，生成一个调用序列

	因此会按照如下堆栈顺序调用:
	ProtocolListenerWrapper.export(invoker)
	ProtocolFilterWrapper.export(invoker)
	invoker=buildInvokerChain(invoker, Constants.SERVICE_FILTER_KEY, Constants.PROVIDER);
	List<Filter> filters = ExtensionLoader.getExtensionLoader(Filter.class).getActivateExtension(invoker.getUrl(), key, group);
	将filter附加到协议的执行队列中
	DubboProtocol.export(invoker)
	
	URL url = invoker.getUrl();
	DubboExporter<T> exporter = new DubboExporter<T>(invoker, key, exporterMap);
	exporterMap.put(key, exporter);
	openServer(url)
	serverMap.put(key, createServer(url));
	ExchangeServer server = Exchangers.bind(url, requestHandler);	//此处requestHandler为DubboProtocol中内部类

	ExtensionLoader.getExtensionLoader(Exchanger.class).getExtension(type);//获取到的Exchangers是HeaderExchanger

	HeaderExchanger.bind(URL url, ExchangeHandler handler)
	return new HeaderExchangeServer(Transporters.bind(url, new DecodeHandler(new HeaderExchangeHandler(handler))));
	getTransporter().bind(url, handler);//此处默认获得的是NettyTransporter
	
	return new NettyServer(url, listener);
	doOpen()
	netty启动代码
	......
		核心部分在于netty的pipeline，请参见netty使用教程
		bootstrap.setPipelineFactory(new ChannelPipelineFactory() {
            public ChannelPipeline getPipeline() {
                NettyCodecAdapter adapter = new NettyCodecAdapter(getCodec() ,getUrl(), NettyServer.this);
                ChannelPipeline pipeline = Channels.pipeline();
                /*int idleTimeout = getIdleTimeout();
                if (idleTimeout > 10000) {
                    pipeline.addLast("timer", new IdleStateHandler(timer, idleTimeout / 1000, 0, 0));
                }*/
                pipeline.addLast("decoder", adapter.getDecoder());
                pipeline.addLast("encoder", adapter.getEncoder());
                pipeline.addLast("handler", nettyHandler);
                return pipeline;
            }
        });
	......
	
	此处有两处需要重视的地方，1是pipeline中的adapter，2是pipeline中的handler。此处假设你已精通netty，不再赘述netty原理。


	1、Adapter
	adapter = new NettyCodecAdapter(getCodec() ,getUrl(), NettyServer.this);
	getCodec()的返回值是codec，此值在AbstractEndpoint中被设置为DubboCodec
	而adapter.getDecoder()的代码中，最终调用的是DubboCodec.decode(channel, message)方法
	而adapter.getEncoder()的代码中，最终调用的是DubboCodec.encode(channel, buffer, msg)方法

	2、handler
	handler的结构如下：
	NettyHandler nettyHandler = new NettyHandler(getUrl(), this);
	NettyServer.handler(...)
	NettyServer.hander.handler(...)
	new HeaderExchangeHandler(handler)
	new DecodeHandler()
	new DubboProtocol().requestHandler
	requestHandler内部
	Invoker<?> invoker = getInvoker(channel, inv);
	DubboExporter<?> exporter = (DubboExporter<?>) exporterMap.get(serviceKey);
	exporter.getInvoker();
	return invoker.invoke(inv);
	
	因此你可以看到
	1、Netty在启动端口后，会在Netty的管道线中注册NettyCodecAdapter
	2、在接受到消息后，会调用NettyCodecAdapter.getDecoder().decode()方法对对象进行解码
	3、也即调用DubboCodec.decode(channel,Message)方法（随着协议的不同，此处调用的编码不同）
	4、当在ExchangeCodec层把一次报文交互的所有byte接受完全，调用DubboCodec.decodeBody的request分支（第二分支）
	5、DecodeableRpcInvocation inv=new DecodeableRpcInvocation(channel, req, is, proto);
	6、调用decode()方法，将byte数组转化为ObjectInput，此处的对象序列化较为复杂，改天单独一章节
	7、req.setData(inv);//将RpcInvocation设置入Request对象
	8、触发HeaderExchangeHandler.received方法，在此方法内部，将request.getData()对象交给下一层handler
	9、触发DecodeHandler.received方法，调用DecodeableRpcInvocation.decode方法进行解密
	10、触发DubboProtocol.requestHandler的reply方法
	11、调用Invoker<?> invoker = getInvoker(channel, inv);获取到在这个Protocol的exporterMap上注册的DubboExporter
	12、调用DubboExporter.getInvoker().invoke()方法执行Invocation
	13、调用invoker，根据invokecation中记录的方法签名，对ref进行实际调用
	14、跳出至DecodeHandler.received()
	15、跳出至HeaderExchangeHandler.handleRequest()
	17、在HeaderExchangeHandler.handleRequest中，设置Response res = new Response(req.getId(), req.getVersion());
	18、设置res.setResult(result);
	19、跳出至HeaderExchangeHandler.received()
	20、在HeaderExchangeHandler.received()中调用channel.send(response)方法
	21、在NettyCodecAdapter中调用InternalEncoder.encode方法
	22、调用DubboCodec.encode方法，调用DubboCodec.encodeResponse方法
	23、调用DubboCodec.encodeResponseData(channel, out, res.getResult());
	24、调用NettyCodecAdapter.InternalEncoder.OneToOneEncoder的Channels.write(ctx, e.getFuture(), encodedMessage, e.getRemoteAddress());将消息写到channels中

至此，一次Dubbo调用在服务器端走完了调用流程

# 五、总结 #
Dubbo调用在服务器端的时间，是分层次实现的调用过程，大致为如下层次:

	Netty
		NettyCodecAdapter.getDecoder
			DubboCodec.decode
				DubboCodec.decodeBody
					new DecodeableRocInvocation();
						new Request();
							HeaderExchangeHandler.receive
								HeaderExchangeHandler.handleRequest()
									DecodeHandler.received
										DubboProtocol.requestHandler.reply
										Invoker<?> invoker = getInvoker(channel, inv);
										DubboExporter.getInvoker().invoke()
									DecodeHandler.received()
								HeaderExchangeHandler.handleRequest()
							HeaderExchangeHandler.received
							new Response()
							channel.send(response)
			DubboCodec.encode
				DubboCodec.encodeResponse
		NettyCodecAdapter.InternalEncoder.OneToOneEncoder
			Channels.write(ctx, e.getFuture(), encodedMessage, e.getRemoteAddress())

至此，Dubbo在服务器端的调用经过以上二十余步，完成了一次服务器调用过程。
		
	
	