---
layout: post
title:  "[KANMARS原创] - JETTY服务器WEBAPPCONTEXT详解"
desc: "WebAppContext是一个服务器的核心组件，有了WebAppContext才能将一个war包封装为一个服务发布出去，本文致力于分析WebAppContext的启动流程和运行流程"
date: 2015-07-31 01:04:17
tags: [server,java,linux,jetty]
---
<<p>
	1.new WebAppContext()
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;1.1&nbsp;&nbsp; &nbsp;private MetaData _metadata=new MetaData();
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;1.2 调用构造方法
</p>
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;ServletContextHandler(HandlerContainer parent, String contextPath, SessionHandler sessionHandler, SecurityHandler securityHandler, ServletHandler servletHandler, ErrorHandler errorHandler)<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;初始化&nbsp;&nbsp; &nbsp;ContextHandler._scontext = new Context();<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;设置&nbsp;&nbsp; &nbsp;_sessionHandler&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;即使为空<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;设置&nbsp;&nbsp; &nbsp;_securityHandler&nbsp;&nbsp; &nbsp;即使为空<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;设置&nbsp;&nbsp; &nbsp;_servletHandler&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;即使为空<br />
2、经server._handler._beans.start调用 &nbsp; -- &gt;WebAppContext(AbstractLifeCycle).start()<br />
&nbsp;&nbsp;&nbsp; 2.1&nbsp;&nbsp;&nbsp;&nbsp;WebAppContext._metadata.setAllowDuplicateFragmentNames(isAllowDuplicateFragmentNames());<br />
&nbsp;&nbsp;&nbsp; 2.2&nbsp;&nbsp;&nbsp;&nbsp;WebAppContext.doStart()<br />
&nbsp;&nbsp;&nbsp; 2.2.1&nbsp;&nbsp;&nbsp;&nbsp;WebAppContext.preConfigure()&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //预先配置<br />
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.1&nbsp;&nbsp;&nbsp;&nbsp;WebAppContext.loadConfigurations&nbsp;&nbsp;&nbsp; //加载配置信息-》
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 用sun.misc.Launcher$AppClassLoader的类加载器预先加载储存于__dftConfigurationClasses的class信息，并且初始化到_configurations[i]中
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_configurations[i]=(Configuration)Loader.loadClass(this.getClass(), _configurationClasses[i]).newInstance();
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 这些类包括：
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"org.eclipse.jetty.webapp.WebInfConfiguration"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; WEBINFO文件解压等处理
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"org.eclipse.jetty.webapp.WebXmlConfiguration"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; WebXml配置文件读取
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"org.eclipse.jetty.webapp.MetaInfConfiguration"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 根据webxml生成filter,servlet等对象
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"org.eclipse.jetty.webapp.FragmentConfiguration"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 未知，但似乎没什么用&nbsp;&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"org.eclipse.jetty.webapp.JettyWebXmlConfiguration"&nbsp;&nbsp;&nbsp; 未知，但似乎某种情况下会起到什么用处
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.2&nbsp;&nbsp;&nbsp;&nbsp;WebAppContext.loadSystemClasses&nbsp;&nbsp;&nbsp; //加载系统类
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 设置private ClasspathPattern _systemClasses = new ClasspathPattern(__dftSystemClasses);
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 而dftSystemClasses=
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;public final static String[] __dftSystemClasses =<br />
{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "java.",&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Java SE classes (per servlet spec v2.5 / SRV.9.7.2)<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "javax.",&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // Java SE classes (per servlet spec v2.5 / SRV.9.7.2)<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "org.xml.",&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // needed by javax.xml<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "org.w3c.",&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // needed by javax.xml<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "org.apache.commons.logging.",&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // TODO: review if special case still needed<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "org.eclipse.jetty.continuation.",&nbsp; // webapp cannot change continuation classes<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "org.eclipse.jetty.jndi.",&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // webapp cannot change naming classes<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "org.eclipse.jetty.plus.jaas.",&nbsp;&nbsp;&nbsp;&nbsp; // webapp cannot change jaas classes<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "org.eclipse.jetty.websocket.WebSocket", // WebSocket is a jetty extension<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "org.eclipse.jetty.websocket.WebSocketFactory", // WebSocket is a jetty extension<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "org.eclipse.jetty.websocket.WebSocketServlet", // webapp cannot change WebSocketServlet<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "org.eclipse.jetty.servlet.DefaultServlet" // webapp cannot change default servlets<br />
&nbsp;&nbsp;&nbsp; } ;
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.3&nbsp;&nbsp;&nbsp;&nbsp;WebAppContext.loadServerClasses()&nbsp;&nbsp;&nbsp; //加载服务类
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 设置private ClasspathPattern _serverClasses = new ClasspathPattern(__dftServerClasses);
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 而__dftServerClasses=
</p>
<p>
	public final static String[] __dftServerClasses =<br />
&nbsp;&nbsp;&nbsp; {<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "-org.eclipse.jetty.continuation.", // don't hide continuation classes<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "-org.eclipse.jetty.jndi.",&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // don't hide naming classes<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "-org.eclipse.jetty.plus.jaas.",&nbsp;&nbsp;&nbsp; // don't hide jaas classes<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "-org.eclipse.jetty.websocket.WebSocket", // WebSocket is a jetty extension<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "-org.eclipse.jetty.websocket.WebSocketFactory", // WebSocket is a jetty extension<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "-org.eclipse.jetty.websocket.WebSocketServlet", // don't hide WebSocketServlet<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "-org.eclipse.jetty.servlet.DefaultServlet", // don't hide default servlet<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "-org.eclipse.jetty.servlet.listener.", // don't hide useful listeners<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "org.eclipse.jetty."&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // hide other jetty classes<br />
&nbsp;&nbsp;&nbsp; } ;
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.4&nbsp;&nbsp;&nbsp; 创建<span style="background-color:#000000;color:#E53333;">WebAppClassLo</span><span style="background-color:#000000;color:#E53333;">ader </span>WebAppClassLoader classLoader = new WebAppClassLoader(this);
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.4.1&nbsp;&nbsp;&nbsp; 按照如下构造参数顺序构造URLClassLoader
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="background-color:#000000;color:#E53333;"></span>WebAppClassLoader构造参数中的parent-&gt;Classloader
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Thread.currentThread().getContextClassLoader()
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;WebAppClassLoader.class.getClassLoader()
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ClassLoader.getSystemClassLoader()
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5&nbsp;&nbsp;&nbsp; WebAppContext.preConfigure().&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 最后一步&nbsp;&nbsp;&nbsp;&nbsp;_configurations[i].preConfigure(this);调用2.2.1.1生成的对象中的preConfigure方法
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5.1&nbsp;&nbsp;&nbsp;&nbsp;WebInfConfiguration.findWorkDirectory()&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 查找context是否已经设置了webINF的参数
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //如果有，就直接使用
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5.2&nbsp;&nbsp;&nbsp;&nbsp;WebInfConfiguration.resolveTempDirectory().makeTempDirectory&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //在用户的个人临时文件夹目录创建文件夹&nbsp;&nbsp;&nbsp;&nbsp;new File(System.getProperty("java.io.tmpdir")) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;context.<span style="background-color:#000000;color:#E53333;">setTem</span><span style="background-color:#000000;color:#E53333;">pDirectory</span>(tmpDir);
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 文件夹的创建规则，可以参考&nbsp;&nbsp;&nbsp;&nbsp;resolveTempDirectory方法的文档
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;A. Try to use an explicit directory specifically for this webapp:
</p>
<blockquote>
	<blockquote>
		<ol>
			<li>
				&nbsp;Iff an explicit directory is set for this webapp, use it. Do NOT set delete 
on exit.
			</li>
			<li>
				Iff javax.servlet.context.tempdir context attribute is set for this webapp 
&amp;&amp; exists &amp;&amp; writeable, then use it. Do NOT set delete on exit.
			</li>
		</ol>
	</blockquote>
</blockquote>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;B. Create a directory based on global settings. The new directory will be 
called "Jetty_"+host+"_"+port+"__"+context+"_"+virtualhost Work out where to 
create this directory:
</p>
<blockquote>
	<blockquote>
		<ol>
			<li>
				Iff $(jetty.home)/work exists create the directory there. Do NOT set delete 
on exit. Do NOT delete contents if dir already exists.
			</li>
			<li>
				Iff WEB-INF/work exists create the directory there. Do NOT set delete on 
exit. Do NOT delete contents if dir already exists.
			</li>
			<li>
				Else create dir in $(java.io.tmpdir). Set delete on exit. Delete contents if 
dir already exists.
			</li>
		</ol>
	</blockquote>
</blockquote>
<p>
	<br />
</p>
<p>
	<br />
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5.3&nbsp;&nbsp;&nbsp; WebInfConfiguration.unpack (context);
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5.3.1 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; web_app = context.newResource(war);&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5.3.1.1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return&nbsp; Resource.newResource(urlOrPath);&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; URL = file.toURI().toURL()&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;file:/E:/webapp.war&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 返回了一个FileResources
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5.3.2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Resource jarWebApp = JarResource.newJarResource(web_app);&nbsp;&nbsp;&nbsp; 将FileResources转化为一个jarsource &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 采用方式为将file:/E:/webapp.war修改为jar:file:/E:/webapp.war~/
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5.3.3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;context.getTempDirectory(), ".extract_lock"位置生成一个控制锁
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5.3.4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;extractedWebAppDir.mkdir();&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;extractedWebAppDir即为临时文件夹
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 例如C:\Documents and Settings\Administrator\Local Settings\Temp\jetty-0.0.0.0-8080-webapp.war-_-any-\webapp
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5.3.5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;jar_web_app.copyTo(extractedWebAppDir);&nbsp;&nbsp;&nbsp; <span style="background-color:#000000;color:#E53333;">将</span><span style="background-color:#000000;color:#E53333;">jar</span><span style="background-color:#000000;color:#E53333;">资源，即war包</span><span style="background-color:#000000;color:#E53333;">进行解</span><span style="background-color:#000000;color:#E53333;">压</span>，拷贝到extractedWebAppDir即临时目录中
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5.3.6&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 删除控制锁context.getTempDirectory(), ".extract_lock"
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5.3<span style="background-color:#000000;"></span>.7&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;context.<span style="background-color:#000000;color:#E53333;">setBaseRe</span><span style="background-color:#000000;color:#E53333;">source</span>(web_app);&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 设置context的基础资源位置是刚才申请的临时文件夹
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5.4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 对父类的container进行处理&nbsp;&nbsp;&nbsp; 把父类依赖的jar包加入当前的上下文classloader中&nbsp;&nbsp;&nbsp;&nbsp;//Apply ordering to container jars - if no pattern is specified, we won't match any of the container jars
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 最终执行的方法context.getMetaData().addContainerJar(Resource.newResource(uri));
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5.5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 对WEBINF的jar包进行处理
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 最终执行的方法context.getMetaData().addWebInfJar(Resource.newResource(uri));
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5.5.1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;List&lt;Resource&gt; jars = findJars(context);&nbsp;&nbsp;&nbsp; 获取到web-inf/lib目录下的所有jar包
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 调用2.2.1.5.5执行webInfJarNameMatcher.match(webInfPattern, uris, true)
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;最终调用context.getMetaData().addWebInfJar(Resource.newResource(uri));，将web-inf/lib下的jar包或者zip包加入classpath
</p>
<p>
	<br />
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5.6&nbsp;&nbsp;&nbsp;&nbsp;<span style="background-color:#337FE5;color:#E53333;">WebXmlConfiguration.preConfigure</span>&nbsp;&nbsp;&nbsp; 预处理webxml
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5.6.1&nbsp;&nbsp;&nbsp;&nbsp;String defaultsDescriptor = context.getDefaultsDescriptor();&nbsp;&nbsp;&nbsp; 解析&nbsp;&nbsp;&nbsp;&nbsp;webdefault.xml&nbsp;&nbsp;&nbsp;&nbsp;org/eclipse/jetty/webapp/webdefault.xml
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5.6.2&nbsp;&nbsp;&nbsp;&nbsp;context.getMetaData().setDefaults (dftResource);&nbsp;&nbsp;&nbsp; 给MetaData设置webdefault.xml配置
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5.6.2.1&nbsp;&nbsp;&nbsp; MetaData._webDefaultsRoot =&nbsp; new DefaultsDescriptor(webDefaults);&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5.6.2.1.1&nbsp;&nbsp;&nbsp;&nbsp;_webDefaultsRoot.parse();&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 解析webdefault.xml
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5.6.2.1.1.1 &nbsp;&nbsp; webDescriptor.newParse()&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 新建一个XmlParser xmlParser=new XmlParser()&nbsp;&nbsp;&nbsp; 底层为SAXParserFactory
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5.6.2.1.1.2 &nbsp;&nbsp; 在xmlParse中注册dtd和URL的关系
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5.6.2.1.1.3 &nbsp;&nbsp; webDescriptor._root = _parser.parse(_xml.getInputStream())&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 将webdefault.xml解析为一个Node对象
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5.6.2.1.1.4&nbsp;&nbsp;&nbsp; webDescriptor.processVersion&nbsp;&nbsp;&nbsp; ，解析webdefault.xml中的版本号、metadata-complete（是否启用注解）
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5.6.2.1.1.5&nbsp;&nbsp;&nbsp;&nbsp;webDescriptor.processOrdering&nbsp;&nbsp;&nbsp; 解析如下参数
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;absolute-ordering&nbsp;&nbsp;&nbsp; 是否WebFragment要排序
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5.6.3&nbsp;&nbsp;&nbsp; <span style="background-color:#000000;color:#E53333;">Resource webxml = findWebXml(context);</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 寻找web.xml，解析，但是不执行
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5.6.4&nbsp;&nbsp;&nbsp;&nbsp;//parse but don't process override-web.xml&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5.7&nbsp;&nbsp;&nbsp;&nbsp;MetaInfConfiguration.preConfigure&nbsp;&nbsp;&nbsp; 预处理MetaINF
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5.7.1&nbsp;&nbsp;&nbsp;&nbsp;//Merge all container and webinf lib jars to look for META-INF resources&nbsp;&nbsp;&nbsp; 将所有ContainerJars和WEBINF jars进行合并
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5.7.2&nbsp;&nbsp;&nbsp;&nbsp;JarScanner scanner新建jar包扫描类
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5.7.3&nbsp;&nbsp;&nbsp; scanner扫描WEBINF下的文件，如果是：web-fragment.xml和META-INF/resources/或者以DTD结尾，则分别加载到
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;addResource(context,METAINF_FRAGMENTS,Resource.newResource(jarUri));
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;addResource(context,METAINF_RESOURCES,Resource.newResource("jar:"+jarUri+"!/META-INF/resources"));<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;addResource(context,METAINF_TLDS,Resource.newResource("jar:"+jarUri+"!/"+name));
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 中
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5.8&nbsp;&nbsp;&nbsp;&nbsp;FragmentConfiguration.preConfigure&nbsp;&nbsp;&nbsp; 预处理Fragment
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.5.8.1&nbsp;&nbsp;&nbsp;&nbsp;findWebFragments(context, context.getMetaData());，最终完成的是
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;metaData.addFragment(frag, Resource.newResource(frag.getURL()+"/META-INF/web-fragment.xml"));&nbsp;&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;metaData.addFragment(frag, Resource.newResource("jar:"+frag.getURL()+"!/META-INF/web-fragment.xml"));
</p>
<p>
	&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;2.2.1.5.9&nbsp;&nbsp;&nbsp;&nbsp;JettyWebXmlConfiguration.preConfigure&nbsp;&nbsp;&nbsp; 预处理jetty的webxml&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 空
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6&nbsp;&nbsp;&nbsp;&nbsp;WebAppContext.super.doStart()&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ContextHandler.doStart()&nbsp;&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.1&nbsp;&nbsp;&nbsp; 设置当前线程的类加载器为WebAppClassLoader
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.2&nbsp;&nbsp;&nbsp; 设置 contexthandler._mimeTypes = new MimeTypes()
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.3&nbsp;&nbsp;&nbsp; 设置当前线程的线程局部变量__context.set(_scontext);
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4&nbsp;&nbsp;&nbsp; <span style="background-color:#000000;color:#E53333;">调用startContext方法，即调用WebAppContext.startContext()</span>
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.1&nbsp;&nbsp;&nbsp;&nbsp;<span style="background-color:#337FE5;color:#E53333;">WebAppContext.configure()</span>
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.2&nbsp;&nbsp;&nbsp; 调用2.2.1.1五个变量的configure方法
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"org.eclipse.jetty.webapp.WebInfConfiguration"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; WEBINFO文件解压等处理
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"org.eclipse.jetty.webapp.WebXmlConfiguration"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; WebXml配置文件读取
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"org.eclipse.jetty.webapp.MetaInfConfiguration"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 根据webxml生成filter,servlet等对象
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"org.eclipse.jetty.webapp.FragmentConfiguration"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 未知，但似乎没什么用&nbsp;&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"org.eclipse.jetty.webapp.JettyWebXmlConfiguration"&nbsp;&nbsp;&nbsp; 未知，但似乎某种情况下会起到什么用处
</p>
<p>
	<br />
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.2.1&nbsp;&nbsp;&nbsp;&nbsp; WebInfConfiguration.configure
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.2.1.1&nbsp;&nbsp;&nbsp;&nbsp;((WebAppClassLoader)context.getClassLoader()).addClassPath(classes);&nbsp;&nbsp;&nbsp; 将/WEB-INF/classes增加到classpath中&nbsp;&nbsp;&nbsp; 最终增加到了URLClassLoader中的&nbsp;&nbsp;&nbsp;&nbsp;private final URLClassPath ucp;上
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.2.1.2&nbsp;&nbsp;&nbsp;&nbsp;((WebAppClassLoader)context.getClassLoader()).addJars(lib);&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 将/WEB-INF/lib中的jar包或者zip包增加到classpath中，&nbsp; &nbsp; 最终增加到了URLClassLoader中的&nbsp;&nbsp;&nbsp;&nbsp;private final URLClassPath ucp;上
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.2.1.3&nbsp;&nbsp;&nbsp;&nbsp;Look for extra resource&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 查找扩展资源
</p>
<p>
	&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.2.2&nbsp;&nbsp;&nbsp;&nbsp;WebXmlConfiguration.configure
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.2.2.1&nbsp;&nbsp;&nbsp;&nbsp;context.getMetaData().addDescriptorProcessor(new StandardDescriptorProcessor());&nbsp;&nbsp;&nbsp; 为MetaData增加webxml描述的处理器，是StandardDescriptorProcessor
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.2.2.2&nbsp;&nbsp;&nbsp;&nbsp;new StandardDescriptorProcessor()时，需要注册一系列解析器
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;registerVisitor("context-param", this.getClass().getDeclaredMethod("visitContextParam", __signature));<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;registerVisitor("display-name", this.getClass().getDeclaredMethod("visitDisplayName", __signature));<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; registerVisitor("servlet", this.getClass().getDeclaredMethod("visitServlet",&nbsp; __signature));<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; registerVisitor("servlet-mapping", this.getClass().getDeclaredMethod("visitServletMapping",&nbsp; __signature));<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; registerVisitor("session-config", this.getClass().getDeclaredMethod("visitSessionConfig",&nbsp; __signature));<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; registerVisitor("mime-mapping", this.getClass().getDeclaredMethod("visitMimeMapping",&nbsp; __signature)); <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp; registerVisitor("welcome-file-list", this.getClass().getDeclaredMethod("visitWelcomeFileList",&nbsp; __signature));<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; registerVisitor("locale-encoding-mapping-list", this.getClass().getDeclaredMethod("visitLocaleEncodingList",&nbsp; __signature));<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; registerVisitor("error-page", this.getClass().getDeclaredMethod("visitErrorPage",&nbsp; __signature));<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; registerVisitor("taglib", this.getClass().getDeclaredMethod("visitTagLib",&nbsp; __signature));<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; registerVisitor("jsp-config", this.getClass().getDeclaredMethod("visitJspConfig",&nbsp; __signature));<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; registerVisitor("security-constraint", this.getClass().getDeclaredMethod("visitSecurityConstraint",&nbsp; __signature));<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; registerVisitor("login-config", this.getClass().getDeclaredMethod("visitLoginConfig",&nbsp; __signature));<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; registerVisitor("security-role", this.getClass().getDeclaredMethod("visitSecurityRole",&nbsp; __signature));<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; registerVisitor("filter", this.getClass().getDeclaredMethod("visitFilter",&nbsp; __signature));<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; registerVisitor("filter-mapping", this.getClass().getDeclaredMethod("visitFilterMapping",&nbsp; __signature));<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; registerVisitor("listener", this.getClass().getDeclaredMethod("visitListener",&nbsp; __signature));<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; registerVisitor("distributable", this.getClass().getDeclaredMethod("visitDistributable",&nbsp; __signature));
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 这些解析器，既是web.xml的解析处理器
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;2.2.1.6.4.2.3 &nbsp; &nbsp; MetaInfConfiguration.configure&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 空
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.2.4&nbsp;&nbsp;&nbsp;&nbsp; FragmentConfiguration.configure&nbsp;&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.2.4.1&nbsp;&nbsp;&nbsp;&nbsp;context.getMetaData().orderFragments()&nbsp;&nbsp;&nbsp; 对Servlet3.0片段Fragment进行排序&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;----需要看protected Ordering _ordering是否有值;
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ----如果没有值，则只执行_orderedWebInfJars.addAll(_webInfJars);方法，将webINF的jar全部放到_orderedWebInfJars中 &nbsp;
</p>
<p>
	<br />
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.2.5 &nbsp;&nbsp; JettyWebXmlConfiguration.configure
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.2.5.1&nbsp;&nbsp;&nbsp; 在web-inf下寻找jetty8-web.xml,否则寻找web-jetty.xml，
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;XmlConfiguration jetty_config = (XmlConfiguration)context.getAttribute(XML_CONFIGURATION);
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 寻找到之后，调用jetty_config.configure(context);进行解析
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.3 &nbsp;&nbsp; <span style="background-color:#337FE5;color:#E53333;">WebAppContext.</span><span style="background-color:#337FE5;color:#E53333;">_metadata.resolve(this);</span>&nbsp;&nbsp;&nbsp; 对webAppContext进行解析处理
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.3.1&nbsp;&nbsp;&nbsp;&nbsp;_origins.clear();
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.3.2&nbsp;&nbsp;&nbsp;&nbsp;// set the webxml version&nbsp;&nbsp;&nbsp; 给context.getServletContext()设置版本号,即给_scontext设置版本号
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.3.3&nbsp;&nbsp;&nbsp; 执行StandardDescriptorProcessor&nbsp;&nbsp;&nbsp; p
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.3.3.1&nbsp;&nbsp;&nbsp;&nbsp;p.process(context,getWebDefault()); &nbsp;&nbsp; 解析webdefault.xml&nbsp;&nbsp;&nbsp; 使用StandardDescriptorProcessor解析webdefault.xml中的标签<br />
&nbsp;&nbsp;&nbsp; 2.2.1.6.4.3.3.2&nbsp;&nbsp;&nbsp;&nbsp;<span style="background-color:#000000;color:#E53333;">p.process(context,getWebXml())</span><span style="background-color:#000000;color:#E53333;">&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="background-color:#000000;color:#E53333;">&nbsp;&nbsp;&nbsp;&nbsp;</span><span style="background-color:#000000;color:#E53333;">&nbsp;&nbsp;&nbsp; </span><span style="background-color:#000000;color:#E53333;">解析web.xml</span><span style="background-color:#000000;color:#E53333;">&nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;使用StandardDescriptorProcessor解析web.xml中的标签
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 举例说明,servlet加载过程：&nbsp;&nbsp;&nbsp; 参见StandardDescriptorProcessor.protected void visitServlet(WebAppContext context, Descriptor descriptor, XmlParser.Node node)方法
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1、获取ID
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2、获取servlet-name
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3、创建ServletHolder，设置servletName为 servlet-name
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4、将ServletHolder设置入Context中的ServletHandler&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;org.eclipse.jetty.servlet.ServletHandler&nbsp;&nbsp;&nbsp; 在步骤1.2或者首次调用getServletHandler时创建<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5、解析init-param&nbsp;&nbsp;&nbsp; 并设置入ServletHolder
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 6、解析servlet-class
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7、如果servlet-class是jspservlet，则设置初始化参数scratchdir
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8、如果servlet-class不为空，则
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8.1&nbsp;&nbsp;&nbsp;&nbsp;((WebDescriptor)descriptor).addClassName(servlet_class);&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 在WebDescriptor中增加一条记录
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 8.2&nbsp;&nbsp;&nbsp;&nbsp;Origin o = context.getMetaData().getOrigin(servlet_name+".servlet.servlet-class");&nbsp;&nbsp;&nbsp; 尝试从缓存中获取servlet_name+".servlet.servlet-class"
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 如果获取不到，则holder.setClassName(servlet_class);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; context.getMetaData().setOrigin(servlet_name+".servlet.servlet-class", descriptor);
</p>
<p>
	&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9、加载load-on-startup参数
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 10、加载security-role-ref参数
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 11、加载run-as参数
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 12、加载async-supported参数
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 13、加载enabled参数
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 14、加载multipart-config参数
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.3.3.3&nbsp;&nbsp;&nbsp;&nbsp;p.process(context,wd);&nbsp;&nbsp;&nbsp; 解析WebDescriptor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; getOverrideWebs()
</p>
<p>
	&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.4&nbsp;&nbsp;&nbsp;&nbsp;<span style="background-color:#337FE5;color:#E53333;">W<span style="background-color:#337FE5;color:#E53333;">ebAppContext.</span></span><span style="background-color:#337FE5;color:#E53333;">super.startContext()</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 加载父类的startContext
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.4.1&nbsp;&nbsp;&nbsp; 将SessionHandler，SecurityHandler，ServletHandler组成管道队列
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.4.2&nbsp;&nbsp;&nbsp; 将sessionHandler作为第一个管道，设置入WebAppContext（handlerWrapper._handler）
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.4.3&nbsp;&nbsp;&nbsp;&nbsp;<span style="background-color:#337FE5;color:#E53333;">W<span style="background-color:#337FE5;color:#E53333;">ebAppContext</span></span>(ServletContextHandler)super.startContext()
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.4.4&nbsp;&nbsp;&nbsp;&nbsp;<span style="background-color:#337FE5;color:#E53333;">W<span style="background-color:#337FE5;color:#E53333;">ebAppContext</span></span>().super.doStart()-&gt;scopeHandler.dostart()-&gt;scopeHandler.doStart()----&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;&gt;.......
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.4.4.1&nbsp;&nbsp;&nbsp;&nbsp;sessionhandler.start()
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.4.4.2&nbsp;&nbsp;&nbsp;&nbsp;ConstraintSecurityHandler.start()
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.4.4.3&nbsp;&nbsp;&nbsp;&nbsp;ServletHandler.start()
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.4.4.3.1&nbsp;&nbsp;&nbsp;&nbsp;updateNameMappings()&nbsp;&nbsp;&nbsp; 更新_servletNameMap和_servlets数组
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.4.4.3.2&nbsp;&nbsp;&nbsp;&nbsp;updateMappings()&nbsp;&nbsp;&nbsp; 更新_filterPathMappings和_filterNameMappings，_servletPathMap，
</p>
<p>
	&nbsp;&nbsp;
</p>
<p>
	&nbsp; &nbsp; 2.2.1.6.4.4.5&nbsp;&nbsp;&nbsp;&nbsp;WebAppContext(ContextHandler)._errorHandler.start();
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.4.6&nbsp;&nbsp;&nbsp;&nbsp;callContextInitialized(((ServletContextListener)LazyList.get(_contextListeners, i)), event);&nbsp;&nbsp;&nbsp; 通知监听事件
</p>
<p>
	&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.4.7&nbsp;&nbsp;&nbsp; 结束&nbsp;&nbsp;&nbsp; 2.2.1.6.4.4.3&nbsp;&nbsp;&nbsp;&nbsp;<span style="background-color:#337FE5;color:#E53333;">W<span style="background-color:#337FE5;color:#E53333;">ebAppContext</span></span>(ServletContextHandler)super.startContext()
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.4.8 &nbsp;&nbsp; OK to Initialize servlet handler now&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ServletContextHandler.startContext&nbsp; --&gt;&nbsp; _servletHandler.initialize()
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.4.8.1&nbsp;&nbsp;&nbsp;&nbsp;_filters.start()&nbsp;&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.4.8.2&nbsp;&nbsp;&nbsp;&nbsp;servlets[i].start()&nbsp;&nbsp;&nbsp;&nbsp;ServletHolder.start
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.4.8.2.1 &nbsp;&nbsp; ServletHolder -&gt; Holder -&gt; Holder._class=Loader.loadClass(Holder.class, _className);&nbsp;&nbsp;&nbsp;&nbsp; 加载class类
</p>
&nbsp;&nbsp;&nbsp; 2.2.1.6.4.4.8.2.2&nbsp;&nbsp;&nbsp;&nbsp;checkServletType();&nbsp;&nbsp;&nbsp;&nbsp;检查servlet类型 &nbsp;&nbsp;
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.4.4.8.2.3&nbsp;&nbsp;&nbsp;&nbsp;initServlet();&nbsp;&nbsp;&nbsp; 包括实例化，调用初始化方法等
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_servlet=newInstance();&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_config=new Config();
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_servlet.init(_config);
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.5&nbsp;&nbsp;&nbsp; 结束2.2.1.6.4 WebContext.startContext()
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.6.6&nbsp;&nbsp;&nbsp;&nbsp;current_thread.setContextClassLoader(old_classloader);将classloader恢复原样
</p>
<p>
	&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2.2.1.7&nbsp;&nbsp;&nbsp; WebAppContext.postConfigure()&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;WebInfConfiguration.postConfigure 空
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;WebXmlConfiguration.postConfigure空
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;MetaInfConfiguration.postConfigure空
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;FragmentConfiguration.postConfigure空
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;JettyWebXmlConfiguration.postConfigure空
</p>
<p>
	<br />
</p>
<p>
	&nbsp; ---------------------------至此webAppContext启动完毕
</p>
<p>
	<br />
</p>
<p>
	<br />
</p>
<p>
	作为Handler的运行过程如下，Servlet对象将请求交给webAppContext执行handler方法，WebAppContext含有三个handler链，顺序为sessionhandler,ConstraintSecurityHandler,ServletHandler
</p>
<p>
	由于sessionhandler和ServletHandler是scopeHandler，而ConstraintSecurityHandler是普通Handler，因此执行顺序如下<br />
&nbsp;&nbsp;&nbsp; 3.1&nbsp;&nbsp;&nbsp;&nbsp;sessionhandler.doScope() &nbsp;&nbsp;&nbsp;&nbsp;创建session，对 cookie写出jsessionid
</p>
<p>
	&nbsp;&nbsp;&nbsp; 3.2&nbsp;&nbsp;&nbsp;&nbsp;ServletHandler.doScope() &nbsp;&nbsp;&nbsp;&nbsp;根据target，从_servletNameMap中获取到一个ServletHolder&nbsp;&nbsp;&nbsp;&nbsp;servlet_holder=
(ServletHolder)_servletNameMap.get(target);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;设置到baseRequest.setUserIdentityScope(servlet_holder)中
</p>
<p>
	&nbsp;&nbsp;&nbsp; 3.3&nbsp;&nbsp;&nbsp;&nbsp;sessionhandler.doHandler()&nbsp;&nbsp;&nbsp; 空，正常后延
</p>
<p>
	&nbsp;&nbsp;&nbsp; 3.4&nbsp;&nbsp;&nbsp;&nbsp;ConstraintSecurityHandler.doHandler()&nbsp;&nbsp;&nbsp; 未知代码
</p>
<p>
	&nbsp;&nbsp;&nbsp; 3.5&nbsp;&nbsp;&nbsp;&nbsp;ServletHandler.doHandler()
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ServletHolder servlet_holder=(ServletHolder) baseRequest.getUserIdentityScope();&nbsp;&nbsp;&nbsp; 公益企业ServletHolder
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;FilterChain&nbsp;&nbsp;&nbsp; 获取过滤器链
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 执行过滤器链
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;如果过滤器链执行完毕，执行servlet_holder.handle(baseRequest,req,res);
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 即：servlet.service(request,response);
</p>
<p>
	<br />
</p>
<p>
	---------------------------------至此WebAppContext运行完毕
</p>
<p>
	<br />
</p>
<p>
	以上就是花三天时间整理的jetty-webAppContext运行过程
</p>
<p>
	-----------
</p>
<p>
	对于我自己，要把代码忘掉，记住核心的部分。记得太多反而没用。
</p>
<p>
	比如WebAppContext,最核心的部分应该是WebAppClassLoader类对不同的应用环境进行隔离的部分：
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;通过类加载器实现了不同应用在同一个进程内的妥善隔离，值得学习。这是一种非常有效的沙盒机制。
</p>
<p>
	<br />
</p>
<p>
	还有web.xml的解析部分，通过反射机制实现了每个标签的处理程序
</p>
<p>
	<br />
</p>
<p>
	但其中糟粕的地方也挺多，例如WebAppClassLoader被设置到了ThreadLocal变量中，这样意味着：服务器启动只能用单线程启动，否则就会异常。
</p>
<p>
	虽然并没什么太大影响，但是仍然不太建议这么做。
</p>
<p>
	<br />
</p>
<p>
	<br />
</p>
<p>
	<br />
</p>