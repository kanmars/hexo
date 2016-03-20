---
layout: post
title:  "[KANMARS原创] - 从零单排-BSR服务器介绍--从0开始构建web服务器"
desc: "最近，我从0开始做了一个web服务器。起因是：我被鄙视了，之前我基于netty做了一个web服务器，参见QQ日志《昨夜热的睡不着，写了个web服务器》，旋即，被人鄙视了:'基于netty封装了一个嘛，没什么大不了的'。于是，这次我从0开始实现了一个......"
date: 2015-07-14 23:17:00
tags: [server,java,linux]
---
<p>
	<br />
</p>
<p>
	<br />
</p>
<p>
	两个月前基于Netty写了一个web服务器框架。
</p>
<p>
	当时候主要的目的是，朋友托我写个支持web通讯的东西，但是现在websocket又不通用，所以只好在服务器上打心思，基于netty写了一个web通讯框架，可以单机轻松实现上万并发。
</p>
<p>
	后来拿出去吹牛，被人鄙视了，被鄙视的缘由是：通讯框架用netty，协议层用netty，日志层用log4j，JSON层用阿里巴巴的jsonlib.........是对现有框架的封装，没有任何“自主知识产权”的东西......
</p>
<p>
	<br />
</p>
<p>
	于是，抽了一点时间从0开始写了个web服务器，名称是BSR-半兽人，GIT地址位于&nbsp;&nbsp;&nbsp; https://github.com/kanmars/bsr.git
</p>
<p>
	其特点如下：
</p>
<p>
	&nbsp;&nbsp;&nbsp; 1、整个服务器采用分模块设计，共有：server,event,http,pipe,demo四个模块
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2、通讯层使用NIO实现，使用注册表机制储存链接上下文
</p>
<p>
	&nbsp;&nbsp;&nbsp; 3、链接分发机制采用reactor反应炉模式，由BossThread分发到注册表中，由WorkerThread线程进行后续处理
</p>
<p>
	&nbsp;&nbsp;&nbsp; 4、工作线程处理采用管道Pipe机制，采用管道序列来实现复杂的处理操作，纵向可扩展，扩展能力优秀
</p>
<p>
	&nbsp;&nbsp;&nbsp; 5、支持三种简单管道：
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;EchoPipe，回声管道
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;HttpProtocolPipe，HTTP协议解析管道
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;HttpResourcePipe，HTTP静态资源处理管道
</p>
<p>
	&nbsp;&nbsp;&nbsp; 6、对管道进行顺序组装，可以生成复杂逻辑
</p>
<p>
	&nbsp;&nbsp;&nbsp; 7、HttpProtocolPipe，HTTP协议解析完全独立实现，不依赖现有框架，实现了较为完整的HTTP报文处理，如request,response,session,cookie等
</p>
<p>
	&nbsp;&nbsp;&nbsp; 8、MainDemo.java中是服务器的启动示例
</p>
<p>
	目前的缺点：
</p>
<p>
	&nbsp;&nbsp;&nbsp; 1、功能较为原始
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2、稳定性有待改善
</p>
<p>
	&nbsp;&nbsp;&nbsp; 3、没有参照现有框架如jetty等的设计
</p>
<p>
	下一步可做的进一步优化：
</p>
<p>
	&nbsp;&nbsp;&nbsp; 1、对MainDemo的启动进程进行优化，优化多线程结构
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2、对服务器Bean实现jmx协议，便于远程控制
</p>
<p>
	&nbsp;&nbsp;&nbsp; 3、实现springmvc的处理管道，使程序具有springmvc功能
</p>
<p>
	&nbsp;&nbsp;&nbsp; 4、完善异常机制，使程序稳定运行
</p>
<p>
	&nbsp;&nbsp;&nbsp; 5、对常用资源进行池化操作
</p>
<p>
	<br />
</p>
<p>
	<br />
</p>
<p>
	下一次的优化，可能就是用c语言写一个了，我一直对自己的设定，是c+java双精通
</p>
<p>
	<br />
</p>
<p>
	但是正如我所说的，编程是一个然并卵的行业。
</p>