---
layout: post
title:  "[KANMARS原创]-SpringCloud-实用篇(1)-什么是springCLoud"
desc: "[KANMARS原创]-SpringCloud-实用篇(1)-什么是springCLoud"
date: 2016-12-11 13:42:00
tags: [server,java]
---
# 一、SpringCloud概述

springCloud 是Spring社区+Netflix公司推出的一款分布式服务框架，其网站位于<a href="http://projects.spring.io/spring-cloud/">SpringCloud官方地址</a>和<a href="https://springcloud.cc/">SpringCloud中国</a>。

一般而言，SpringCloud在国外比较流行，而国内由于阿里系工程师的推行，Dubbo服务化的IT结构比较盛行。

但最新的消息是：阿里内部也逐步在放弃使用DUBBO，目前正在研究SpringCloud或者其他的开源框架。

用过Dubbo的人比较了解，Dubbo是一个服务治理框架，是逐步从集中式应用->独立系统应用->服务化->大规模分布式这样的步骤发展而来的。由于Dubbo是一个“RPC框架”，因此RPC是核心功能，其他的功能都需要“自行实现”，例如限流、协议扩充、服务自动发现等。这就导致了一个问题是如果要使用DUBBO，那么意味着你还需要研究下zookeeper的集群负载，还需要研究下Dubbo的限流机制，研究下配置自动管理等等一系列的开源组件。

而SpringCloud不必如此，在SpringCloud中已经集成了：

	1.Spring Cloud Config配置管理

	2.Eureka服务发现
	
	3.Hystrix断路器
	
	4.Zuul统一网关
	
	5.Ribbon云端负载均衡
	
	6.Turbine服务事件发现
	
	7.Feign模板化Http客户端
	
	8.完全基于springboot，脱离了web容器而存在

	
这“几乎”就是一套完整的分布式应用系统，足够让任何一个组织直接从集中式应用的封建时代一步踏进蒸汽时代。

当然，此处的“几乎”还是需要考虑一下的，没有任何一个系统是完美的，我们身为程序员，必须取其精华去其糟粕，如果单看SpringCloud的官方页面，他们提供了很多神奇的绚烂的功能，但28定律尚未失效，对于SpringCloud来说也是相同。只有上面我列出的8点是有用的内容（有异议勿喷，尤其是看到我说springCloudRedis插件和springCloudBus插件无甚大用的人）

# 二、开启你的SpringCloud生涯

你仅需安装一个maven，然后设置setting.xml中的代理为：

	<servers>
      <server>
        <id>releases</id>
        <username>ali</username>
        <password>ali</password>
      </server>
      <server>
        <id>Snapshots</id>
        <username>ali</username>
        <password>ali</password>
      </server>
	</servers>
	<mirrors>
		<mirror>
		  <id>nexus</id>
		  <mirrorOf>*</mirrorOf> 
		  <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
		</mirror>
		<mirror>
		  <id>nexus-public-snapshots</id>
		  <mirrorOf>public-snapshots</mirrorOf> 
		  <url>http://maven.aliyun.com/nexus/content/repositories/snapshots/</url>
		</mirror>
	</mirrors>
  
	  <profiles> 
		<profile>
		  <id>development</id>
		  <repositories>
			<repository>
			  <id>central</id>
			  <url>http://central</url>
			  <releases><enabled>true</enabled><updatePolicy>always</updatePolicy></releases>
			  <snapshots><enabled>true</enabled><updatePolicy>always</updatePolicy></snapshots>
			</repository>
		  </repositories>
		 <pluginRepositories>
			<pluginRepository>
			  <id>central</id>
			  <url>http://central</url>
			  <releases><enabled>true</enabled><updatePolicy>always</updatePolicy></releases>
			  <snapshots><enabled>true</enabled><updatePolicy>always</updatePolicy></snapshots>
			</pluginRepository>
		  </pluginRepositories>
		</profile>
		<profile>
		  <!--this profile will allow snapshots to be searched when activated-->
		  <id>public-snapshots</id>
		  <repositories>
			<repository>
			  <id>public-snapshots</id>
			  <url>http://public-snapshots</url>
			  <releases><enabled>false</enabled></releases>
			  <snapshots><enabled>true</enabled><updatePolicy>always</updatePolicy></snapshots>
			</repository>
		  </repositories>
		 <pluginRepositories>
			<pluginRepository>
			  <id>public-snapshots</id>
			  <url>http://public-snapshots</url>
			  <releases><enabled>false</enabled></releases>
			  <snapshots><enabled>true</enabled><updatePolicy>always</updatePolicy></snapshots>
			</pluginRepository>
		  </pluginRepositories>
		</profile>
	  </profiles>
	 
	   <activeProfiles>
		<activeProfile>development</activeProfile>
		<activeProfile>public-snapshots</activeProfile>
	   </activeProfiles>

之后，就可以开启你的SpringCloud生涯了












	