---
layout: post
title:  "[KANMARS原创] - JETTY服务器源码全解析：从Jetty的组件结构，到Jetty是如何运行的"
desc: "这是一篇自己写的JETTY服务器源码解析，通过对源码的逐行阅读，描述了Jetty服务器的架构设计、组件结构、启动过程、运行过程。写这篇文章的起因是之前自己写了一个BSRWEB服务器，BSR服务器运行稳定，但是其缺点也比较严重，例如：服务器面向过程思想，全架构为过程函数等。因此我阅读了Jetty服务器的源码，以提升自己的见识和文化水平...."
date: 2015-07-26 00:10:17
tags: [server,java,linux,jetty]
---
<p>
&nbsp;
</p>
<p>
	今天学习了一下Jetty的代码，版本为V8.1.17.v20150415
</p>
<p>
	做个笔记，以防忘记
</p>
<p>
	比较专业的jetty架构解析，可以参考如下链接
</p>
<p>
	http://my.oschina.net/tryUcatchUfinallyU/blog?disp=1&amp;catalog=300813&amp;sort=time&amp;p=2
</p>
<p>
	http://www.ibm.com/developerworks/cn/web/wa-lo-jetty/
</p>
<p>
	http://ipjmc.iteye.com/blog/1839999
</p>
<p>
	http://www.blogjava.net/DLevin/archive/2014/05/07/413158.html
</p>
<p>
	最好看完这11+1+1+1篇文章之后再看我写的以下内容，否则容易急功近利......
</p>
<p>
	<br />
</p>
<p>
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
</p>
<p>
	------------------------------------------------------------------------------<span style="background-color:#000000;color:#E53333;">伟大的分割线</span>------------------------------------------------------------------------------------------
</p>
<p>
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
</p>
<p>
	<br />
</p>
<p>
	jetty的架构为基于LifyCycle的架构，每个组件都实现了该接口，具有LifyCyle的生命周期
</p>
<p>
	public interface LifeCycle{<br />
&nbsp;&nbsp;&nbsp; public void start() throws Exception;<br />
&nbsp;&nbsp;&nbsp; public void stop() throws Exception;<br />
&nbsp;&nbsp;&nbsp; public boolean isRunning();<br />
&nbsp;&nbsp;&nbsp; public boolean isStarted();<br />
&nbsp;&nbsp;&nbsp; public boolean isStarting();<br />
&nbsp;&nbsp;&nbsp; public boolean isStopping();<br />
&nbsp;&nbsp;&nbsp; public boolean isStopped();<br />
&nbsp;&nbsp;&nbsp; public boolean isFailed();<br />
&nbsp;&nbsp;&nbsp; public void addLifeCycleListener(LifeCycle.Listener listener);<br />
&nbsp;&nbsp;&nbsp; public void removeLifeCycleListener(LifeCycle.Listener listener);<br />
&nbsp;&nbsp;&nbsp; public interface Listener extends EventListener<br />
&nbsp;&nbsp;&nbsp; {<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; public void lifeCycleStarting(LifeCycle event);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; public void lifeCycleStarted(LifeCycle event);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; public void lifeCycleFailure(LifeCycle event,Throwable cause);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; public void lifeCycleStopping(LifeCycle event);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; public void lifeCycleStopped(LifeCycle event);<br />
&nbsp;&nbsp;&nbsp; }<br />
}
</p>
<p>
	通过实现该接口，一个Class类就具有了生命周期，可以作为Jetty的组件来管理
</p>
<p>
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
</p>
<p>
	------------------------------------------------------------------------------<span style="background-color:#000000;color:#E53333;">伟大的分割线</span>------------------------------------------------------------------------------------------
</p>
<p>
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
</p>
<p>
	我们看一段简单的代码，这段代码实现了一个简单的web服务器
</p>
<p>
	-------------------pom.xml
</p>
<p>
	&lt;dependencies&gt;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&lt;dependency&gt;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&lt;groupId&gt;org.eclipse.jetty&lt;/groupId&gt;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&lt;artifactId&gt;jetty-server&lt;/artifactId&gt;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&lt;version&gt;8.1.17.v20150415&lt;/version&gt;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&lt;/dependency&gt;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&lt;dependency&gt;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&lt;groupId&gt;org.eclipse.jetty&lt;/groupId&gt;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&lt;artifactId&gt;jetty-webapp&lt;/artifactId&gt;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&lt;version&gt;8.1.17.v20150415&lt;/version&gt;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&lt;/dependency&gt;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&lt;dependency&gt;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&lt;groupId&gt;org.eclipse.jetty&lt;/groupId&gt;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&lt;artifactId&gt;jetty-servlet&lt;/artifactId&gt;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&lt;version&gt;8.1.17.v20150415&lt;/version&gt;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&lt;/dependency&gt;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&lt;dependency&gt;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&lt;groupId&gt;org.eclipse.jetty&lt;/groupId&gt;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&lt;artifactId&gt;jetty-jsp&lt;/artifactId&gt;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&lt;version&gt;8.1.17.v20150415&lt;/version&gt;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&lt;/dependency&gt;<br />
&nbsp;&nbsp; &nbsp;&lt;/dependencies&gt;
</p>
<p>
	------------------------------main方法
</p>
<p>
	public static void main(String[] args) throws Exception {<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;Server server = new Server();<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;QueuedThreadPool threadPool = new QueuedThreadPool();<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;threadPool.setMinThreads(10);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;threadPool.setMaxThreads(100);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;threadPool.setDetailedDump(false);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;server.setThreadPool(threadPool);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;SelectChannelConnector selectChannelConnector = new SelectChannelConnector();<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;selectChannelConnector.setHost("0.0.0.0");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;selectChannelConnector.setPort(8080);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;selectChannelConnector.setMaxIdleTime(3000000);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;selectChannelConnector.setAcceptors(2);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;selectChannelConnector.setStatsOn(false);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;selectChannelConnector.setConfidentialPort(8443);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;selectChannelConnector.setLowResourcesConnections(20000);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;selectChannelConnector.setLowResourceMaxIdleTime(5000);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;server.addConnector(selectChannelConnector);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;WebAppContext webAppContext = new WebAppContext();<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;webAppContext.setContextPath("/");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;webAppContext.setWar("E:/workspace/workspace-jetty/webapp/target/webapp.war");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;server.setHandler(webAppContext);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;server.start();<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;server.join();<br />
&nbsp;&nbsp; &nbsp;}
</p>
<p>
	以上代码即为：把webapp.war作为一个服务发布出去。
</p>
<p>
	<br />
</p>
<p>
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
</p>
<p>
	----------------------------------------------------------------------<span style="background-color:#000000;color:#E53333;">Jetty服务器的组成结构</span>-------------------------------------------------------------------------------------
</p>
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
<p>
	<br />
</p>
<p>
	首先我们来分析jetty的组成结构
</p>
<p>
	&nbsp;&nbsp;&nbsp; 如上一个main方法示例所示：一个jetty服务器由以下四部分组成：
</p>
<p>
	&nbsp;&nbsp;&nbsp; <span style="background-color:#000000;color:#E53333;">Connector</span>&nbsp;&nbsp;&nbsp; -----------&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style="background-color:#000000;color:#E53333;">Server</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -----------&nbsp;&nbsp;&nbsp;&nbsp; <span style="background-color:#000000;color:#E53333;">ThreadPool</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ----------&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style="background-color:#000000;color:#E53333;">Handler</span>
</p>
<p>
	&nbsp;&nbsp;&nbsp; 从Jetty发布包中的etc/jetty.xml中你可以清楚的看到对应配置&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp; 如果想启动一个jetty服务器这四个组件必不可少
</p>
<p>
	&nbsp;&nbsp;&nbsp; 如果要想明确一下这四种组件的具体作用，可以大致定义如下：
</p>
<p>
	&nbsp;&nbsp;&nbsp; <span style="background-color:#FFE500;">1、Connector</span>：常用的是SelectChannelConnector，
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 重要变量如下：
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;private final SelectorManager _manager = new ConnectorSelectorManager();&nbsp;&nbsp;&nbsp; --连接选择管理器
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 重要方法如下：
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;open&nbsp;&nbsp;&nbsp; 打开一个新的SocketChannel通道
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;accept&nbsp;&nbsp;&nbsp; 尝试accept一个连接，如果发生连接，则将连接注册到SelectorManager中
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;newConnection&nbsp;&nbsp;&nbsp; 新建一个AsyncHttpConnection
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;newEndPoint&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 新建一个SelectChannelEndPoint&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;doStart&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 组件启动方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; <span style="background-color:#FFE500;">2、Server</span>：Jetty启动类
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 重要变量如下：
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;private final Container _container=new Container();&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 组件容器
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;private ThreadPool _threadPool;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 线程池<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;private Connector[] _connectors;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 连接
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 重要方法如下：
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;doStart&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 组件启动方法
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; doStop&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 组件停止方法
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; start&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 继承自AbstractLifeCycle的启动方法
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; stop&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;继承自AbstractLifeCycle的停止方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; <span style="background-color:#FFE500;">3、ThreadPool</span>：Jetty线程池,常用实现类为QueuedThreadPool
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 重要变量如下：
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;private final ConcurrentLinkedQueue&lt;Thread&gt; _threads=new ConcurrentLinkedQueue&lt;Thread&gt;();&nbsp;&nbsp;&nbsp; 可用线程
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;private BlockingQueue&lt;Runnable&gt; _jobs;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 需要执行的任务
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;private Runnable _runnable = new Runnable()......&nbsp;&nbsp;&nbsp; 默认启动任务：从_jobs中poll出一个任务并执行
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 重要方法如下
</p>
<p>
	<br />
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;doStart&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 组件启动方法
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; doStop&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 组件停止方法
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dispatch&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 将job任务增加到执行队列_jobs等待执行
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;startThread&nbsp;&nbsp;&nbsp; 在调用doStart时触发，启动_minThreads指定个数的“默认线程”_runnable默认任务
</p>
<p>
	&nbsp;&nbsp;&nbsp; <span style="background-color:#FFE500;">4、Handler</span>：即处理器，Jetty使用了Handler处理器的架构
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;参见http://my.oschina.net/tryUcatchUfinallyU/blog/110553
</p>
<p>
	&nbsp;&nbsp;&nbsp;<em>&nbsp;</em><em>从设计模板角度来看 Handler 的设计实际上就是一个责任链模式，接口类 HandlerCollection 
可以帮助开发者构建一个链，而另一个接口类 ScopeHandler 
可以帮助你控制这个链的访问顺序。另外一个用到的设计模板就是观察者模式，用这个设计模式控制了整个 Jetty 的生命周期，只要继承了 
LifeCycle 接口，你的对象就可以交给 Jetty 来统一管理了。所以扩展 Jetty 
非常简单，也很容易让人理解，整体架构上的简单也带来了无比的好处，Jetty 可以很容易被扩展和裁剪。</em>
</p>
<p>
	<br />
</p>
<p>
	&nbsp;&nbsp;&nbsp; Handler的接口如下：
</p>
<blockquote>
	<blockquote>
		<blockquote>
			<p>
				public interface Handler extends LifeCycle, Destroyable{<br />
&nbsp;&nbsp;&nbsp; public void handle(String target, Request baseRequest, HttpServletRequest request, HttpServletResponse response)<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; throws IOException, ServletException;<br />
&nbsp;&nbsp;&nbsp; public void setServer(Server server);<br />
&nbsp;&nbsp;&nbsp; public Server getServer();<br />
&nbsp;&nbsp;&nbsp; public void destroy();<br />
}
			</p>
		</blockquote>
	</blockquote>
</blockquote>
<p>
	&nbsp;&nbsp;&nbsp; HandlerContainer接口如下：
</p>
<blockquote>
	<blockquote>
		<blockquote>
			<p>
				public interface HandlerContainer extends LifeCycle{<br />
&nbsp;&nbsp;&nbsp; public Handler[] getHandlers();<br />
&nbsp;&nbsp;&nbsp; public Handler[] getChildHandlers();<br />
&nbsp;&nbsp;&nbsp; public Handler[] getChildHandlersByClass(Class&lt;?&gt; byclass);<br />
&nbsp;&nbsp;&nbsp; public &lt;T extends Handler&gt; T getChildHandlerByClass(Class&lt;T&gt; byclass);<br />
}
			</p>
		</blockquote>
	</blockquote>
</blockquote>
<p>
	&nbsp;&nbsp;&nbsp; 由代码可知：Handler的作用就是，对Request和Response对象进行处理，使之完成相应的功能。
</p>
<p>
	<br />
</p>
<p>
	&nbsp;&nbsp;&nbsp; 示例中的Handler是WebAppContext，此外，Handler还可以是HandlerList和HandlerCollection，其区别在于HandlerList在责任链模式下，如果一个请求被标记为已处理过或者已经报异常，则不会继续处理；而HandlerCollection无论什么情况，会执行所有的Handler。
</p>
<p>
	&nbsp;&nbsp;&nbsp; 对WebAppContext的分析需要较大篇幅，本文不予分析。
</p>
<p>
	<br />
</p>
<p>
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
</p>
<p>
	----------------------------------------------------------------------<span style="background-color:#000000;color:#E53333;">Jetty服务器的启动顺序</span>-------------------------------------------------------------------------------------
</p>
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
<p>
	<br />
</p>
<p>
	接下来我们来分析Jetty的启动顺序，网上的流程图很多，凑巧我的编辑器不能画图，所以我将启动顺序用写的方式写出来。
</p>
<p>
	1、new Server()
</p>
<p>
	&nbsp;&nbsp;&nbsp; 1.1&nbsp;&nbsp;&nbsp; 初始化server对象
</p>
<p>
	&nbsp;&nbsp;&nbsp; 1.2&nbsp;&nbsp;&nbsp; 初始化Container容器
</p>
<p>
	2、new QueuedThreadPool()
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.1&nbsp;&nbsp;&nbsp; 初始化_threads线程队列
</p>
<p>
	3、server.setThreadPool(threadPool);&nbsp;&nbsp;&nbsp; 对服务器设置线程池
</p>
<p>
	&nbsp;&nbsp;&nbsp; 3.1&nbsp;&nbsp;&nbsp; 调用server的祖宗类AggregateLifeCycle.addBean方法，将bean注册入_beans
</p>
<p>
	&nbsp;&nbsp;&nbsp; 3.2&nbsp;&nbsp;&nbsp;&nbsp;_container.addBean(threadPool)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; --------------------JettyV8.17版本似乎有BUG？此处代码会判断_listeners为0时不能加入对象，类似“空腹吃饭有害健康”的笑话。
</p>
<p>
	4、new SelectChannelConnector()&nbsp;&nbsp;&nbsp; 新建一个ChannelConnector
</p>
<p>
	&nbsp;&nbsp;&nbsp; 4.1&nbsp;&nbsp;&nbsp; 初始化&nbsp;&nbsp;&nbsp;&nbsp;private final SelectorManager _manager = new ConnectorSelectorManager();&nbsp;&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp; 4.2&nbsp;&nbsp;&nbsp; 调用addBean方法将_manager注册到SelectChannelConnector的祖宗类AggregateLifeCycle._beans中
</p>
<p>
	&nbsp;&nbsp;&nbsp; 4.3 &nbsp;&nbsp; 设置&nbsp; int&nbsp; _acceptors&nbsp;&nbsp;&nbsp; 根据(Runtime.getRuntime().availableProcessors+3)/4设置_acceptor的数量
</p>
<p>
	5、server.addConnector(selectChannelConnector);&nbsp;&nbsp;&nbsp; 对服务器增加Connector
</p>
<p>
	&nbsp;&nbsp;&nbsp; 5.1&nbsp;&nbsp;&nbsp; 更新server._connectors&nbsp;&nbsp;&nbsp; 数组对象为新的connector数组
</p>
<p>
	6、new WebAppContext()&nbsp;&nbsp;&nbsp; 新建Handler&nbsp;&nbsp;&nbsp; 比较复杂，不在此说明
</p>
<p>
	<br />
</p>
<p>
	7、server.setHandler(webAppContext);&nbsp;&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp; 7.1&nbsp;&nbsp;&nbsp;&nbsp;_handler=handler赋值为hander
</p>
<p>
	&nbsp;&nbsp;&nbsp; 7.2 &nbsp;&nbsp; handler.setServer(getServer());&nbsp;&nbsp;&nbsp; 建立server和handler的连接关系
</p>
<p>
	8、server.start();启动Jetty服务器
</p>
<p>
	&nbsp;&nbsp;&nbsp; 8.1&nbsp;&nbsp;&nbsp; server调用继承自AbstractLifeCycle的start方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 8.1.1&nbsp;&nbsp;&nbsp; server调用继承自AbstractLifeCycle的setStarting()方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 8.1.2&nbsp;&nbsp;&nbsp;&nbsp;server调用自身实现的抽象方法dostart
</p>
<p>
	&nbsp;&nbsp;&nbsp; 8.1.2.1&nbsp;&nbsp;&nbsp; server.dostart方法中ShutdownMonitor.getInstance().start()启动停机监控
</p>
<p>
	&nbsp;&nbsp;&nbsp; 8.1.2.2&nbsp;&nbsp;&nbsp; server.dostart方法中HttpGenerator设置服务器版本号8.1.17.v20150415
</p>
<p>
	&nbsp;&nbsp;&nbsp; 8.1.2.3&nbsp;&nbsp;&nbsp;&nbsp;server.dostart方法中super.doStart();
</p>
<p>
	&nbsp;&nbsp;&nbsp; 8.1.2.3.1&nbsp;&nbsp;&nbsp; server的父类HandlerWrapper.doStart()，调用父类doStart
</p>
<p>
	&nbsp;&nbsp;&nbsp; 8.1.2.3.1.1&nbsp;&nbsp;&nbsp; 如果server的_handler不为空，则执行_handler.start();&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; --------------------------------
</p>
<p>
	&nbsp;&nbsp;&nbsp; 8.1.2.3.1.2&nbsp;&nbsp;&nbsp; 调用server的父类HandlerWrapper的父类AbstractHandler的父类AggregateLifeCycle的doStart方法
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8.1.2.3.1.2.1&nbsp;&nbsp;&nbsp; 循环调用_beans.start()方法-》触发所有通过server.addBean注册到_beans中的组件的继承自LifeCycle的start方法
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8.1.2.3.1.2.2&nbsp;&nbsp;&nbsp; 设置server对象的已启动标志_started为true
</p>
<p>
	&nbsp;&nbsp;&nbsp; 8.1.2.3.1.3&nbsp;&nbsp;&nbsp;&nbsp;调用server的父类HandlerWrapper的父类AbstractHandler的父类AggregateLifeCycle的父类AbstractLifeCycle的dostart方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 8.1.2.4&nbsp;&nbsp;&nbsp;&nbsp;server.dostart方法中：由于server.addConnector时，没有addBean，所以在8.1.2.3.1.2.1步骤没有调用connector的start方法
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 因此,server.dostart中，循环调用_connectors.start
</p>
<p>
	&nbsp;&nbsp;&nbsp; 8.1.3&nbsp;&nbsp;&nbsp;&nbsp;server调用继承自AbstractLifeCycle的setStarted()方法<br />
&nbsp;&nbsp;&nbsp; 8.2&nbsp;&nbsp;&nbsp; server调用继承自AbstractLifeCycle的start结束
</p>
<p>
	9、接步骤8.1.2.3.1.1启动Handler继承自AbstractLifeCycle的start方法
</p>
<p>
	10、接步骤8.1.2.3.1.2启动AggregateLifeCycle._beans中注册的LifyCycle
</p>
<p>
	&nbsp;&nbsp;&nbsp; 10.1&nbsp;&nbsp;&nbsp; 启动步骤3.1通过server.addBean注册到AggregateLifeCycle._beans中的LifeCycle-&gt;QueuedThreadPool.start
</p>
<p>
	&nbsp;&nbsp;&nbsp; 10.1.1&nbsp;&nbsp;&nbsp; 调用_beans.start，即QueuedThreadPool.start
</p>
<p>
	&nbsp;&nbsp;&nbsp; 10.1.2&nbsp;&nbsp;&nbsp; QueuedThreadPool调用继承自父类AbstractLifeCycle的start方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 10.1.2.1&nbsp;&nbsp;&nbsp;&nbsp;QueuedThreadPool调用继承自父类AbstractLifeCycle的setStarting方法
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;10.1.2.2 &nbsp;&nbsp; QueuedThreadPool调用自身实现的doStart方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 10.1.2.2.1&nbsp;&nbsp;&nbsp;&nbsp;QueuedThreadPool调用继承自父类AbstractLifeCycle的doStart方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 10.1.2.2.2&nbsp;&nbsp;&nbsp;&nbsp;QueuedThreadPool如果_jobs，任务队列为空，则对任务队列赋初始值ArrayBlockingQueue或者BlockingArrayQueue
</p>
<p>
	&nbsp;&nbsp;&nbsp; 10.1.2.2.3&nbsp;&nbsp;&nbsp;&nbsp;QueuedThreadPool调用循环while(isRunning() &amp;&amp; threads&lt;_minThreads)，新建_minThreads
</p>
<p>
	&nbsp;&nbsp;&nbsp; 10.1.2.2.3.1&nbsp;&nbsp;&nbsp;&nbsp;QueuedThreadPool循环初始化线程时，调用startThread方法，新建线程
</p>
<p>
	&nbsp;&nbsp;&nbsp; 10.1.2.2.3.1.1&nbsp;&nbsp;&nbsp;&nbsp;QueuedThreadPool.startThread调用newThread(_runnable)方法，创建一个实现了_runable接口的线程
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 备注：_runable接口功能为为从_jobs中取出一个任务，并且调用该任务的_job.run方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 10.1.2.2.3.1.2&nbsp;&nbsp;&nbsp; 启动新创建的_runable线程
</p>
<p>
	&nbsp;&nbsp;&nbsp; 10.1.2.2.4&nbsp;&nbsp;&nbsp;&nbsp;QueuedThreadPool结束调用doStart方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 10.1.2.3 &nbsp;&nbsp; QueuedThreadPool调用继承自父类AbstractLifeCycle的setStarted方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 10.1.3&nbsp;&nbsp;&nbsp;&nbsp;QueuedThreadPool结束调用继承自父类AbstractLifeCycle的start方法
</p>
<p>
	11、接步骤8.1.2.4,server.doStart方法中，启动Connector组件，调用try{_connectors[i].start();}
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;（由于_connector没有注册到AggregateLifeCycle._beans中，也有可能是故意为之，使connector最后执行）
</p>
<p>
	&nbsp;&nbsp;&nbsp; 11.1&nbsp;&nbsp;&nbsp;&nbsp;SelectChannelConnector调用继承自父类AbstractLifeCycle的start方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 11.1.1&nbsp;&nbsp;&nbsp;&nbsp;SelectChannelConnector调用继承自父类AbstractLifeCycle的setStarting方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 11.1.2&nbsp;&nbsp;&nbsp;&nbsp;SelectChannelConnector调用自身实现的doStart方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 11.1.2.1&nbsp;&nbsp;&nbsp;&nbsp;SelectChannelConnector调用父类AbstractConnector的doStart方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 11.1.2.2&nbsp;&nbsp;&nbsp;&nbsp;SelectChannelConnector调用自身实现的open方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 11.1.2.2.1&nbsp;&nbsp;&nbsp;&nbsp;SelectChannelConnector初始化ServerSocketChannel _acceptChannel;
</p>
<p>
	&nbsp;&nbsp;&nbsp; 11.1.2.2.2&nbsp;&nbsp;&nbsp;&nbsp;SelectChannelConnector将ServerSocketChannel _acceptChannel绑定到指定端口new InetSocketAddress(getPort())<br />
&nbsp;&nbsp;&nbsp; 11.1.2.2.3&nbsp;&nbsp;&nbsp;&nbsp;SelectChannelConnector调用AggregateLifeCycle.addBean方法，将_acceptChannel注册入AggregateLifeCycle._beans
</p>
<p>
	&nbsp;&nbsp;&nbsp; 11.1.2.3&nbsp;&nbsp;&nbsp;&nbsp;SelectChannelConnector结束调用自身实现的open方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 11.1.2.4&nbsp;&nbsp;&nbsp;&nbsp;SelectChannelConnector调用父类AbstractConnector的父类AggregateLifeCycle的doStart方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 11.1.2.5&nbsp;&nbsp;&nbsp;&nbsp;SelectChannelConnector的祖宗类AggregateLifeCycle检查_beans是否已经全部启动，如果没有启动，则调用start方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 11.1.2.5.1&nbsp;&nbsp;&nbsp; 在步骤4.2中，ConnectorSelectorManager被注册到了SelectChannelConnector的祖宗类AggregateLifeCycle._beans中，此处SelectChannelConnector的隐含对象ConnectorSelectorManager的start方法被调用
</p>
<p>
	&nbsp;&nbsp;&nbsp; 11.1.2.5.2&nbsp;&nbsp;&nbsp;&nbsp;ConnectorSelectorManager调用继承自祖宗类AbstractLifeCycle的.start方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 11.1.2.5.3&nbsp;&nbsp;&nbsp;&nbsp;ConnectorSelectorManager调用继承自祖宗类AbstractLifeCycle的.setStarting方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 11.1.2.5.4&nbsp;&nbsp;&nbsp;&nbsp;ConnectorSelectorManager调用继承自父类SelectorManager实现的.doStart()方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 11.1.2.5.4.1&nbsp;&nbsp;&nbsp; ConnectorSelectorManager的父类SelectorManager初始化_selectSet[]数组为新的SelectSet数组
</p>
<p>
	&nbsp;&nbsp;&nbsp; 11.1.2.5.4.2&nbsp;&nbsp;&nbsp; ConnectorSelectorManager的父类SelectorManager调用父类AbstractLifeCycle.doStart()方法，空方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 11.1.2.5.4.3&nbsp;&nbsp;&nbsp;&nbsp;SelectorManager.doStart中对SelectSet进行循环
</p>
<p>
	&nbsp;&nbsp;&nbsp; 11.1.2.5.4.3.1&nbsp;&nbsp;&nbsp; 创建新的Runable接口对象"循环调用SelectSet.doSelect"
</p>
<p>
	&nbsp;&nbsp;&nbsp; 11.1.2.5.4.3.2&nbsp;&nbsp;&nbsp; 将Runable接口对象通过调用ConnectorSelectorManager.dispatch方法，委托给QueuedThreadPool执行
</p>
<p>
	&nbsp;&nbsp;&nbsp; 11.1.2.5.5&nbsp;&nbsp;&nbsp; ConnectorSelectorManager结束调用继承自父类SelectorManager实现的.doStart()方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 11.1.2.5.6&nbsp;&nbsp;&nbsp;&nbsp;ConnectorSelectorManager调用继承自祖宗类AbstractLifeCycle的.setStarted方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 11.1.2.6&nbsp;&nbsp;&nbsp;&nbsp;SelectChannelConnector的祖宗类AggregateLifeCycle设置_started启动标志为已启动
</p>
<p>
	&nbsp;&nbsp;&nbsp; 11.1.2.7&nbsp;&nbsp;&nbsp; SelectChannelConnector的祖宗类AggregateLifeCycle调用父类AbstractLifeCycle.doStart()空方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 11.1.2.8 &nbsp;&nbsp; SelectChannelConnector结束调用父类AbstractConnector的父类AggregateLifeCycle的doStart方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 11.1.2.9 &nbsp;&nbsp; SelectChannelConnector结束调用父类AbstractConnector的doStart方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 11.1.2.10&nbsp;&nbsp;&nbsp;&nbsp;SelectChannelConnector根据_acceptorThreads配置，创建相应数量的Acceptor委托给_threadPool执行
</p>
<p>
	&nbsp;&nbsp;&nbsp; 11.1.3 &nbsp;&nbsp; SelectChannelConnector结束调用自身实现的doStart方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 11.2&nbsp;&nbsp;&nbsp;&nbsp;SelectChannelConnector调用继承自父类AbstractLifeCycle的setStarted方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 11.3&nbsp;&nbsp;&nbsp;&nbsp;SelectChannelConnector的start结束。
</p>
<p>
	12、接步骤11.1.2.10,SelectChannelConnector根据_acceptorThreads配置，创建相应数量的Acceptor委托给_threadPool执行
</p>
<p>
	&nbsp;&nbsp;&nbsp; 12.1&nbsp;&nbsp;&nbsp; AbstractConnector的内部类Acceptor开始运行
</p>
<p>
	&nbsp;&nbsp;&nbsp; 12.2&nbsp;&nbsp;&nbsp; Acceptor调用accept方法（由于是SelectorChannelConnector创建了父类AbstractConnector的内部类Acceptor对象，则Acceptor对象调用的AbstractConnector的抽象方法accept，最终调用的是SelectorChannelConnector的accept方法）
</p>
<p>
	&nbsp;&nbsp;&nbsp; 12.3&nbsp;&nbsp;&nbsp;&nbsp;Acceptor调用SelectorChannelConnector的accept方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 12.4&nbsp;&nbsp;&nbsp;&nbsp;SelectorChannelConnector.accept方法中开始accept阻塞SocketChannel channel = server.accept();
</p>
<p>
	&nbsp;&nbsp;&nbsp; 12.5&nbsp;&nbsp;&nbsp; 客户端发起连接
</p>
<p>
	&nbsp;&nbsp;&nbsp; 12.6&nbsp;&nbsp;&nbsp; 阻塞释放
</p>
<p>
	&nbsp;&nbsp;&nbsp; 12.7&nbsp;&nbsp;&nbsp;&nbsp;SelectorChannelConnector.accept方法中，调用_manager.register(channel);，即SelectorManager.register(SocketChannel channel)
</p>
<p>
	&nbsp;&nbsp;&nbsp; 12.8&nbsp;&nbsp;&nbsp; 用取余算法随机取一个SelectorManager._selectSet[i]的SelecSet<br />
&nbsp;&nbsp;&nbsp; 12.9&nbsp;&nbsp;&nbsp; 将变更事件放入SelectSet中，调用wakup函数唤醒在SelectSet上睡眠的线程
</p>
<p>
	13、接步骤11.1.2.5.4.3.2&nbsp;&nbsp;&nbsp;&nbsp;将Runable接口对象"循环调用SelectSet.doSelect"通过调用ConnectorSelectorManager.dispatch方法，委托给QueuedThreadPool执行
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.1&nbsp;&nbsp;&nbsp; SelectSet调用doSelect方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2&nbsp;&nbsp;&nbsp; 从SelectSet内部对象ConcurrentLinkedQueue&lt;Object&gt; _changes变更事件队列中poll出一个事件
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.1&nbsp;&nbsp;&nbsp; 如果poll出的事件是EndPoint，进行相应处理
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.2&nbsp;&nbsp;&nbsp; 如果poll出的事件是ChannelAndAttachment，进行相应处理
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.3&nbsp;&nbsp;&nbsp; 如果poll出的事件是ChangeTask，则直接运行
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.4&nbsp;&nbsp;&nbsp; 如果poll出的事件是Runnable，则委托给线程池运行
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5 &nbsp;&nbsp; 如果poll出的事件是SocketChannel
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.1&nbsp;&nbsp;&nbsp; 在当前SelectSet的专用Selector上注册一个channel的read事件&nbsp;&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.2&nbsp;&nbsp;&nbsp; 调用createEndPoint方法创建一个SelectChannelEndPoint
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.2.1 &nbsp;&nbsp; 调用newEndPoint方法，创建一个SelectChannelEndPoint
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.2.2 &nbsp;&nbsp; 调用ConnectorSelectorManager.newEndPoint方法，return SelectChannelConnector.this.newEndPoint(channel,selectSet,sKey);
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.2.3 &nbsp;&nbsp; SelectChannelEndPoint endp= new SelectChannelEndPoint(channel,selectSet,key, SelectChannelConnector.this._maxIdleTime);
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.2.4 &nbsp;&nbsp; endp设置Connection为selectSet.getManager().newConnection(channel,endp, key.attachment())
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.2.4.1 &nbsp;&nbsp; 调用ConnectorSelectorManager.newConnection方法，创造一个new AsyncHttpConnection(SelectChannelConnector.this,endpoint,getServer());
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 内部已经生成一系列解析HTTP的工具，如：
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;HttpBuffersImpl _buffers = new HttpBuffersImpl();
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;protected final Parser _parser;
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;protected final Request _request;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;protected final HttpFields _requestFields;
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; protected final Generator _generator;
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;protected final HttpFields _responseFields;
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;protected final Response _response;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 等
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.3&nbsp;&nbsp;&nbsp; 调用key.attach(endpoint);将SelectChannelEndPoint附加到channel读事件的key上
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.4&nbsp;&nbsp;&nbsp; 调用SelectChannelEndPoint.schedule()
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.4.1&nbsp;&nbsp;&nbsp; 正常情况下，调用SelectChannelEndPoint.dispatch
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.4.2&nbsp;&nbsp;&nbsp; 调用_manager.dispatch(_handler);即ConnectorSelectorManager.dispatcher方法，将_handler交给线程池执行
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _handler接口如下
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;private final Runnable _handler = new Runnable()<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;public void run() { handle(); }<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;};
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.4.3&nbsp;&nbsp;&nbsp; 即：线程池会运行_handler接口，调用SelectChannelEndPoint.handle方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.4.3.1&nbsp;&nbsp;&nbsp; 调用AsyncConnection next = (AsyncConnection)_connection.handle();&nbsp;&nbsp;&nbsp; 此处的AsyncConnection是在步骤13.2.5.2.4.1中生成
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.4.3.1.1&nbsp;&nbsp;&nbsp; 调用AsyncHttpConnection.handle()方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.4.3.1.2&nbsp;&nbsp;&nbsp; 调用AsyncHttpConnection的父类AbstractHttpConnection的类变量_parser的parseAvailable()方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.4.3.1.2.1&nbsp;&nbsp;&nbsp; 调用_parser的parseNext()方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.4.3.1.2.2&nbsp;&nbsp;&nbsp; 生成_buffer=getHeaderBuffer();--&gt;从AsyncHttpConnection中获取new 时初始化的buffer
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.4.3.1.2.3&nbsp;&nbsp;&nbsp; 调用_parser的fill()方法给_buffer填充数据
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.4.3.1.2.3.1 &nbsp;&nbsp; 调用_endp.fill(_buffer)，即SelectChannelEndPoint.fill(_buffer)
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.4.3.1.2.3.2 &nbsp;&nbsp; 调用SelectChannelEndPoint的父类ChannelEndPoint.fill(_buffer)方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.4.3.1.2.3.3 &nbsp;&nbsp; 调用SelectChannelEndPoint的父类ChannelEndPoint的_channel.read(bbuf)方法填充数据，即：SocketChannelImpl.fill(bbuf)
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.4.3.1.2.3.4&nbsp;&nbsp;&nbsp; 结束调用_endp.fill(_buffer)，即SelectChannelEndPoint.fill(_buffer)
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.4.3.1.2.4&nbsp;&nbsp;&nbsp; 结束调用_parser的fill()方法给_buffer填充数据
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.4.3.1.2.5&nbsp;&nbsp;&nbsp; _parser开始解析http报文（起始代码HttpParse.java 343行while (_state&lt;STATE_END &amp;&amp; length--&gt;0)）
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 此处Http报文解析写的很经典，通过定义一定的状态位，控制解析报文的状态，从-14状态直至最终结束，推荐学习之，虽然这种写法很奇葩......
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;让我想起了以前我有幸参观的伟大的、独一无二的、软件定制巨头南天公司的一伙人写的一个配置文件的解析，也是一个while循环，读取配置文件
</p>
<blockquote>
	<blockquote>
		<blockquote>
			<p>
				&nbsp;&nbsp;&nbsp; // States<br />
&nbsp;&nbsp;&nbsp; public static final int STATE_START=-14;<br />
&nbsp;&nbsp;&nbsp; public static final int STATE_FIELD0=-13;<br />
&nbsp;&nbsp;&nbsp; public static final int STATE_SPACE1=-12;<br />
&nbsp;&nbsp;&nbsp; public static final int STATE_STATUS=-11;<br />
&nbsp;&nbsp;&nbsp; public static final int STATE_URI=-10;<br />
&nbsp;&nbsp;&nbsp; public static final int STATE_SPACE2=-9;<br />
&nbsp;&nbsp;&nbsp; public static final int STATE_END0=-8;<br />
&nbsp;&nbsp;&nbsp; public static final int STATE_END1=-7;<br />
&nbsp;&nbsp;&nbsp; public static final int STATE_FIELD2=-6;<br />
&nbsp;&nbsp;&nbsp; public static final int STATE_HEADER=-5;<br />
&nbsp;&nbsp;&nbsp; public static final int STATE_HEADER_NAME=-4;<br />
&nbsp;&nbsp;&nbsp; public static final int STATE_HEADER_IN_NAME=-3;<br />
&nbsp;&nbsp;&nbsp; public static final int STATE_HEADER_VALUE=-2;<br />
&nbsp;&nbsp;&nbsp; public static final int STATE_HEADER_IN_VALUE=-1;<br />
&nbsp;&nbsp;&nbsp; public static final int STATE_END=0;<br />
&nbsp;&nbsp;&nbsp; public static final int STATE_EOF_CONTENT=1;<br />
&nbsp;&nbsp;&nbsp; public static final int STATE_CONTENT=2;<br />
&nbsp;&nbsp;&nbsp; public static final int STATE_CHUNKED_CONTENT=3;<br />
&nbsp;&nbsp;&nbsp; public static final int STATE_CHUNK_SIZE=4;<br />
&nbsp;&nbsp;&nbsp; public static final int STATE_CHUNK_PARAMS=5;<br />
&nbsp;&nbsp;&nbsp; public static final int STATE_CHUNK=6;<br />
&nbsp;&nbsp;&nbsp; public static final int STATE_SEEKING_EOF=7;
			</p>
		</blockquote>
	</blockquote>
</blockquote>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 通过状态位的逐渐提升，逐步完成了method,url,version,header......等一系列报文的解析
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 以jetty8.17版本为例：
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;HttpParser379行完成Method解析
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;HttpParser438行完成URI解析
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; HttpParser491行完成对AbstractHttpConnection的request信息：Method,Uri,Protoco;的注入
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 通过调用AbstractHttpConnection.startRequest(Buffer method, Buffer uri, Buffer version)注入三个信息
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; HttpParser520,522行，完成了一对Header和value的解析
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; HttpParser596行，完成了_hander对Header的注入
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 通过调用AbstractHttpConnection.parsedHeader(Buffer name, Buffer value)
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 在_requestFields中add(name,value)<br />
&nbsp;&nbsp;&nbsp;&nbsp;13.2.5.4.3.1.2.6&nbsp;&nbsp;&nbsp; 在HttpParser644行----》在未知response状态的情况下，假设_contentLength=HttpTokens.NO_CONTENT;（619行,原因是：如果头部既没有长度532行又没有549行chunk，就认为是没有内容的，那么就是无长度的）
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 进入644行_handler.headerComplete();
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.4.3.1.2.7&nbsp;&nbsp;&nbsp; 调用AbstractHttpConnection.headerComplete()
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;13.2.5.4.3.1.2.7.1 &nbsp;&nbsp; 调用AbstractHttpConnection.headerComplete()
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.4.3.1.2.7.2&nbsp;&nbsp;&nbsp; 设置_generator.setVersion(11)代表http1.1
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.4.3.1.2.7.3&nbsp;&nbsp;&nbsp; 进入http1.1的switch处理分支
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.4.3.1.2.7.4&nbsp;&nbsp;&nbsp; 进入AbstractHttpConnection.handleRequest分支
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;13.2.5.4.3.1.2.7.5&nbsp;&nbsp;&nbsp;&nbsp;AbstractHttpConnection对uri进行处理，生成path,info
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.4.3.1.2.7.6 &nbsp;&nbsp; AbstractHttpConnection调用_request.setPathInfo(info)
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.4.3.1.2.7.7&nbsp;&nbsp;&nbsp;&nbsp;AbstractHttpConnection第494行server.handle(this);调用server方法处理AbstractHttpConnection，实现类为AsyncHttpConnection
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.4.3.1.2.7.8&nbsp;&nbsp;&nbsp; Server调用public void handle(AbstractHttpConnection connection)方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.4.3.1.2.7.8.1&nbsp;&nbsp;&nbsp;&nbsp;生成 target,Request,Response对象
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;13.2.5.4.3.1.2.7.8.2&nbsp;&nbsp;&nbsp; 调用Server.handle(String target, Request baseRequest, HttpServletRequest request, HttpServletResponse response)方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.4.3.1.2.7.8.3&nbsp;&nbsp;&nbsp; 调用Server._handler.handle(target,baseRequest, request, response)
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 即：WebAppContext.handle(String target, Request baseRequest, HttpServletRequest request, HttpServletResponse response)方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;..........
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.4.3.1.3 &nbsp;&nbsp; 结束调用AsyncHttpConnection的父类AbstractHttpConnection的类变量_parser的parseAvailable()方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 13.2.5.4.3.1.4&nbsp;&nbsp;&nbsp; 调用_endp.flush()，将输出内容传输到客户端浏览器上。
</p>
<p>
	<br />
</p>
<p>
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
</p>
<p>
	至此Jetty
服务器的启动顺序展示完毕：
</p>
<p>
	上文展示了从Jetty启动、生命周期对象初始化、建立IO监听、到一个客户端发起连接、客户端输入Http报文，输入事件经各组件之间的消息传递、报文交给处理器解析执行、最终交给WebAppCOntext的Handle处理的全过程
</p>
<p>
	从上文调用顺序可以看到,Jetty的模块化十分清晰，结构简单可靠，扩展性强，举个例子，如果你想用Jetty改造一下，做成一个其他协议的通讯框架，仅需在步骤13.2.5.4.3.1上扩展一个自己的Connection即可
</p>
<p>
	<br />
</p>
<p>
	<p>
		------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	</p>
	<p>
		----------------------------------------------------------------------<span style="background-color:#000000;color:#E53333;">Handle处理过程</span>-------------------------------------------------------------------------------------
	</p>
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
</p>
<p>
	下文要说一下Handle处理的过程
</p>
<p>
	关于Handle最好先阅读一下这两篇文章，以补充一下基础知识:
</p>
<p>
	http://my.oschina.net/tryUcatchUfinallyU/blog/112972
</p>
<p>
	http://www.blogjava.net/DLevin/archive/2014/05/07/413158.html
</p>
<p>
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
</p>
<p>
	Handler接口如下，可以看到，主要执行的是handle方法
</p>
<blockquote>
	<blockquote>
		<blockquote>
			<p>
				public interface Handler extends LifeCycle, Destroyable{<br />
&nbsp;&nbsp;&nbsp; public void handle(String target, Request baseRequest, HttpServletRequest request, HttpServletResponse response)<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; throws IOException, ServletException;<br />
&nbsp;&nbsp;&nbsp; public void setServer(Server server);<br />
&nbsp;&nbsp;&nbsp; public Server getServer();<br />
&nbsp;&nbsp;&nbsp; public void destroy();<br />
}
			</p>
		</blockquote>
	</blockquote>
</blockquote>
<p>
	其子类中比较重要的有：
</p>
<p>
	&nbsp;&nbsp;&nbsp; <span style="background-color:#000000;color:#E53333;">HandlerCollection</span>&nbsp;&nbsp;&nbsp; 具有Handler的集合，可以按照顺序全部执行内部的handler
</p>
<p>
	&nbsp;&nbsp;&nbsp; <span style="color:#E53333;background-color:#000000;">HandlerList</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 具有Handler的列表，按照顺序执行内部handler，如果内部发生异常或者request标记为已处理，则不再继续向下执行
</p>
<p>
	&nbsp;&nbsp;&nbsp; <span style="background-color:#000000;color:#E53333;">HandlerWrapper</span>&nbsp;&nbsp;&nbsp;&nbsp; 是内部一个_handler的包装，实现了HandlerContainer和LifyCycle接口，具有略微高级一点的功能。
</p>
<p>
	&nbsp;&nbsp;&nbsp; <span style="background-color:#000000;color:#E53333;">ScopedHandler</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 内部有两个方法doScoped和doHandle，类文档如是说：
</p>
<blockquote>
	<blockquote>
		<blockquote>
			<p>
				&nbsp;<span style="background-color:#FFFFFF;color:#003399;">* &lt;p&gt;For example if Scoped handlers A, B &amp; C were chained together, then </span><br />
<span style="background-color:#FFFFFF;color:#003399;">&nbsp;* the calling order would be:&lt;pre&gt;</span><br />
<span style="background-color:#FFFFFF;color:#003399;">&nbsp;* A.handle(...)</span><br />
<span style="background-color:#FFFFFF;color:#003399;">&nbsp;*&nbsp;&nbsp; A.doScope(...)</span><br />
<span style="background-color:#FFFFFF;color:#003399;">&nbsp;*&nbsp;&nbsp;&nbsp;&nbsp; B.doScope(...)</span><br />
<span style="background-color:#FFFFFF;color:#003399;">&nbsp;*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; C.doScope(...)</span><br />
<span style="background-color:#FFFFFF;color:#003399;">&nbsp;*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; A.doHandle(...)</span><br />
<span style="background-color:#FFFFFF;color:#003399;">&nbsp;*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; B.doHandle(...)</span><br />
<span style="background-color:#FFFFFF;color:#003399;">&nbsp;*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; C.doHandle(...)&nbsp; &nbsp;</span><br />
<span style="background-color:#FFFFFF;color:#003399;">&nbsp;* &lt;pre&gt;</span><br />
<span style="background-color:#FFFFFF;color:#003399;">&nbsp;* </span><br />
<span style="background-color:#FFFFFF;color:#003399;">&nbsp;* &lt;p&gt;If non scoped handler X was in the chained A, B, X &amp; C, then </span><br />
<span style="background-color:#FFFFFF;color:#003399;">&nbsp;* the calling order would be:&lt;pre&gt;</span><br />
<span style="background-color:#FFFFFF;color:#003399;">&nbsp;* A.handle(...)</span><br />
<span style="background-color:#FFFFFF;color:#003399;">&nbsp;*&nbsp;&nbsp; A.doScope(...)</span><br />
<span style="background-color:#FFFFFF;color:#003399;">&nbsp;*&nbsp;&nbsp;&nbsp;&nbsp; B.doScope(...)</span><br />
<span style="background-color:#FFFFFF;color:#003399;">&nbsp;*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; C.doScope(...)</span><br />
<span style="background-color:#FFFFFF;color:#003399;">&nbsp;*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; A.doHandle(...)</span><br />
<span style="background-color:#FFFFFF;color:#003399;">&nbsp;*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; B.doHandle(...)</span><br />
<span style="background-color:#FFFFFF;color:#003399;">&nbsp;*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; X.handle(...)</span><br />
<span style="background-color:#FFFFFF;color:#003399;">&nbsp;*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; C.handle(...)</span><br />
<span style="background-color:#FFFFFF;color:#003399;">&nbsp;*&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; C.doHandle(...)&nbsp;&nbsp; </span>
			</p>
		</blockquote>
	</blockquote>
</blockquote>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 但我认为这是一个然并卵的功能：请看ScopedHandler.handle的代码：
</p>
<blockquote>
	<blockquote>
		<blockquote>
			<p>
				<span style="background-color:#FFFFFF;">public final void <span style="background-color:#000000;color:#E53333;">handle</span>(String target, Request baseRequest, HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException</span><br />
<span style="background-color:#FFFFFF;">&nbsp;&nbsp;&nbsp; {</span><br />
<span style="background-color:#FFFFFF;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (_outerScope==null) &nbsp;</span><br />
<span style="background-color:#FFFFFF;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; doScope(target,baseRequest,request, response);</span><br />
<span style="background-color:#FFFFFF;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; else </span><br />
<span style="background-color:#FFFFFF;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; doHandle(target,baseRequest,request, response);</span><br />
<span style="background-color:#FFFFFF;">&nbsp;&nbsp;&nbsp; }</span>
			</p>
			<p>
				<span style="background-color:#FFFFFF;">public final void <span style="background-color:#000000;color:#E53333;">nextScope</span>(String target, Request baseRequest, HttpServletRequest request, HttpServletResponse response) </span><br />
<span style="background-color:#FFFFFF;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; throws IOException, ServletException</span><br />
<span style="background-color:#FFFFFF;">&nbsp;&nbsp;&nbsp; {</span><br />
<span style="background-color:#FFFFFF;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (_nextScope!=null)</span><br />
<span style="background-color:#FFFFFF;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _nextScope.doScope(target,baseRequest,request, response);</span><br />
<span style="background-color:#FFFFFF;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; else if (_outerScope!=null)</span><br />
<span style="background-color:#FFFFFF;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _outerScope.doHandle(target,baseRequest,request, response);</span><br />
<span style="background-color:#FFFFFF;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; else </span><br />
<span style="background-color:#FFFFFF;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; doHandle(target,baseRequest,request, response);</span><br />
<span style="background-color:#FFFFFF;">&nbsp;&nbsp;&nbsp; }</span>
			</p>
			<p>
				<span style="background-color:#FFFFFF;">public final void <span style="background-color:#000000;color:#E53333;">nextHandle</span>(String target, final Request baseRequest, HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException</span><br />
<span style="background-color:#FFFFFF;">&nbsp;&nbsp;&nbsp; {</span><br />
<span style="background-color:#FFFFFF;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (_nextScope!=null &amp;&amp; _nextScope==_handler)</span><br />
<span style="background-color:#FFFFFF;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _nextScope.doHandle(target,baseRequest,request, response);</span><br />
<span style="background-color:#FFFFFF;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; else if (_handler!=null)</span><br />
<span style="background-color:#FFFFFF;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; _handler.handle(target,baseRequest, request, response);</span><br />
<span style="background-color:#FFFFFF;">&nbsp;&nbsp;&nbsp; }</span>
			</p>
		</blockquote>
	</blockquote>
</blockquote>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;关键在于方法中的_nextScope和_outerScope究竟是什么东西
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 在SocpeHandler的doStart方法中可以看到：
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_outerScope就是处理序列中第一个doStart的ScopedHandle，而_nextScope是当前ScopedHandle的父类HandleWrapper的实例变量_handler
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 换句话说：只有用一种极其奇葩的写法，才能实现如文档说明的效果：参见http://www.blogjava.net/DLevin/archive/2014/05/07/413158.html文档
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; N句话总结之：
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1、在实现中，其Handler链表由HandlerWrapper构建，在doStart()方法中计算_nextScope字段以及
_outerScope字段，在handle()方法中，如果_outerScope为null，则调用doScope()方法，否则调用
doHandle()方法；
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2、在执行完doScope()方法后，调用nextScope()方法，该方法顺着_nextScope链表走，直到尽头，后调用doHandle()方法；
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3、而doHandle()方法在完成是调用nextHandle()方法，它也沿着_nextScope链表走，只要_nextScope和
_handler相同，则调用其doHandle()方法，但是如果_nextScope和_handler不同，则调用_handler中的
handle()方法，用于处理在ScopedHandler链表中插入非ScopedHandler的情况
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 使用示例可以参见jetty中的testCase，也可以参照下例：
</p>
<blockquote>
	<blockquote>
		<blockquote>
			<p>
				public class App003 {<br />
<br />
&nbsp;&nbsp; &nbsp;public static void main(String[] args) throws Exception {<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;Server server = new Server();<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;QueuedThreadPool threadPool = new QueuedThreadPool();<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;threadPool.setMaxThreads(100);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;server.setThreadPool(threadPool);
			</p>
			<p>
				&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; SelectChannelConnector selectChannelConnector = new SelectChannelConnector();<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;selectChannelConnector.setHost("0.0.0.0");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;selectChannelConnector.setPort(8080);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;server.addConnector(selectChannelConnector);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;ScopedHandlerA sa = new ScopedHandlerA();<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;ScopedHandlerB sb = new ScopedHandlerB();<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;ScopedHandlerC sc = new ScopedHandlerC();<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;HandlerWrapperA ha = new HandlerWrapperA();<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;sa.setHandler(sb);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;sb.setHandler(ha);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;ha.setHandler(sc);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; <br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;server.setHandler(sa);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;server.start();<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;server.join();<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;<br />
&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;<br />
&nbsp;&nbsp; &nbsp;public static class ScopedHandlerA extends ScopedHandler{<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;public void doScope(String target, Request baseRequest,<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;HttpServletRequest request, HttpServletResponse response)<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;throws IOException, ServletException {<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;System.out.println("SHA-Scoped--&gt;");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;nextScope(target, baseRequest, request, response);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;System.out.println("&lt;--SHA-Scoped");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;public void doHandle(String target, Request baseRequest,<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;HttpServletRequest request, HttpServletResponse response)<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;throws IOException, ServletException {<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;System.out.println("SHA-Handle--&gt;");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;nextHandle(target, baseRequest, request, response);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;System.out.println("&lt;--SHA-Handle");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;<br />
&nbsp;&nbsp; &nbsp;public static class ScopedHandlerB extends ScopedHandler{<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;public void doScope(String target, Request baseRequest,<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;HttpServletRequest request, HttpServletResponse response)<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;throws IOException, ServletException {<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;System.out.println("SHB-Scoped--&gt;");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;nextScope(target, baseRequest, request, response);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;System.out.println("&lt;--SHB-Scoped");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;public void doHandle(String target, Request baseRequest,<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;HttpServletRequest request, HttpServletResponse response)<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;throws IOException, ServletException {<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;System.out.println("SHB-Handle--&gt;");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;nextHandle(target, baseRequest, request, response);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;System.out.println("&lt;--SHB-Handle");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;<br />
&nbsp;&nbsp; &nbsp;public static class ScopedHandlerC extends ScopedHandler{<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;public void doScope(String target, Request baseRequest,<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;HttpServletRequest request, HttpServletResponse response)<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;throws IOException, ServletException {<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;System.out.println("SHC-Scoped--&gt;");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;nextScope(target, baseRequest, request, response);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;System.out.println("&lt;--SHC-Scoped");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;public void doHandle(String target, Request baseRequest,<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;HttpServletRequest request, HttpServletResponse response)<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;throws IOException, ServletException {<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;System.out.println("SHC-Handle--&gt;");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;nextHandle(target, baseRequest, request, response);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;System.out.println("&lt;--SHC-Handle");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;public static class HandlerWrapperA extends HandlerWrapper{<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;public void handle(String target, Request baseRequest,<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;HttpServletRequest request, HttpServletResponse response)<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;throws IOException, ServletException {<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;System.out.println("h-Handle--&gt;");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;super.handle(target, baseRequest, request, response);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;System.out.println("&lt;--h-Handle");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;}<br />
}
			</p>
			<p>
				执行结果如下：
			</p>
			<p>
				SHA-Scoped--&gt;<br />
SHB-Scoped--&gt;<br />
SHC-Scoped--&gt;<br />
SHA-Handle--&gt;<br />
SHB-Handle--&gt;<br />
h-Handle--&gt;<br />
SHC-Handle--&gt;<br />
&lt;--SHC-Handle<br />
&lt;--h-Handle<br />
&lt;--SHB-Handle<br />
&lt;--SHA-Handle<br />
&lt;--SHC-Scoped<br />
&lt;--SHB-Scoped<br />
&lt;--SHA-Scoped
			</p>
		</blockquote>
	</blockquote>
</blockquote>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 这种写法就会形成如文档描述的效果，但我个人认为这是一个然并卵的功能：
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 它的优点如下：
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1、可以在不同的handler之间集中执行scoped代码，例如配置加载等功能
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2、可以随时选择中断不同层级的scoped运行
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 但缺点非常严重
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1、构造方法奇特，需要对Handle,HandleWrapper,ScopedHandle等十分了解
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2、逻辑比较复杂，对嵌套递归写法的熟练度要求是“必须为50%，多一点少一点都不行”，开发人员对递归的熟练度低于50%则看不懂，高于50%则会换其他的写法。
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3、代码组装难懂，需要用多个HandleWrapper才能组装成Handle链，与责任链模式相比堪称四不像结构。
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4、代码使用复杂，必须将handle,doScope,doHandle,nextScope,nextHandle形成正确的顺序，才可以调用成功。
</p>
<p>
	<br />
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 换做是我，我会把三个scope和2个handler拆分成3*2+2=8个handler，直线结构的程序要比这四处乱跳的jumpto要更加稳固、更容易维护。
</p>
<p>
	<br />
</p>
<p>
	&nbsp;&nbsp;&nbsp; <span style="background-color:#000000;color:#E53333;">ContextHandle</span>：继承自ScopedHandler，最重要的方法是doScope和doHandle
</p>
<p>
	&nbsp;&nbsp;&nbsp; <span style="background-color:#000000;color:#E53333;">ServletContextHandler</span>：继承自ContextHandler，重要的是重写了的ContextHandler.startContext方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; <span style="background-color:#000000;color:#E53333;">WebAppContext</span>：继承自ServletContextHandler，重要的是实现了web应用支持的doStart，和从ContextHandle中继承来的doHandle方法。
</p>
<p>
	<br />
</p>
<p>
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
</p>
<p>
	------------------------------------------------------------------------------ <span style="background-color:#000000;color:#E53333;">伟大的分割线</span>----------------------------------------------------------------------------------------
</p>
<p>
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
</p>
Jetty服务器的启动、初始化、事件触发、组件消息传送、Handler处理就说到这儿。
<p>
	<br />
</p>
<p>
	以上内容是Jetty的核心部分，其他的附加组件如ajp、annotations、deploy、等都是从这个基础上扩展而来的。
</p>
<p>
	大家如果有深入学习Jetty的需要，最好直接翻看代码，比看文档要好懂的多。
</p>