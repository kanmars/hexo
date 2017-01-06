---
layout: post
title:  "[KANMARS原创]-SpringCloud-实用篇(2)-configserver"
desc: "[KANMARS原创]-SpringCloud-实用篇(2)-configserver"
date: 2017-01-06 23:13:00
tags: [server,java]
---
# 一、configserver概述

springCloud的configserver组件是用于管理配置信息的组件，类似于Diamond或者Disconf。

在很遥远的古代，我们修改配置时，需要修改配置文件，然后应用重启......

在中世纪，有人开发了一个叫做DynabeanMaster的组件(我们公司在用，用于管理spring中的bean)

现在我们走到了近代，Diamond、DisConf、SpringCloud等工具出现了......

# 二、configserver搭建

搭建步骤很简单，共三步：1)配置Pom。2)配置properties 3)配置java文件。然后就可以启动了。

## 2.1 POM的配置
	需要增加如下四项配置
	
	继承
	
	<parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>1.4.1.RELEASE</version>
    </parent>
	
	自动版本管理

	
	<dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>Camden.SR3</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>
	
	springCloud-configserver的依赖jar包
	
	<dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-config-server</artifactId>
            <version>1.2.0.RELEASE</version>
        </dependency>
        <dependency>
            <groupId>org.tmatesoft.svnkit</groupId>
            <artifactId>svnkit</artifactId>
            <version>1.8.10</version>
        </dependency>
    </dependencies>
	
	自动打包并指定主类
	
	<build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <executions>
                    <execution>
                        <goals>
                            <goal>repackage</goal>
                        </goals>
                    </execution>
                </executions>
                <configuration>
                    <mainClass>cn.kanmars.ConfigServerApplication</mainClass>
                    <layout>ZIP</layout>
                </configuration>
            </plugin>
        </plugins>
    </build>
	
## 2.2 properties的配置

需要在\src\main\resources\application.properties配置文件中增加如下配置：


	server.port=9000
	#########################################################################
	#配置成功则可看到成功数据：http://localhost:8888/{application}/{profile}/{label}
	#例如:http://127.0.0.1:9000/ServiceAProps/live
	#########################################################################
	#URL与配置文件的映射关系如下：
	#
	#/{application}/{profile}[/{label}]
	#/{application}-{profile}.yml
	#/{label}/{application}-{profile}.yml
	#/{application}-{profile}.properties                 --最常用模式
	#/{label}/{application}-{profile}.properties
	#################git模式#################################################
	#本人可用
	#spring.cloud.config.server.git.uri=https://github.com/kanmars/config.git
	#网络资料
	#spring.cloud.config.server.git.uri=http://git.oschina.net/didispace/SpringBoot-Learning/
	#spring.cloud.config.server.git.searchPaths=Chapter9-1-4/config-repo
	#spring.cloud.config.server.git.username=username
	#spring.cloud.config.server.git.password=password
	#为了验证上面完成的配置服务器，
	#在 http://git.oschina.net/didispace/SpringBoot-Learning/Chapter9-1-4/ 下创建了一个config-repo目录
	#作为配置仓库，并根据不同环境新建了下面四个配置文件：
	#didispace.properties
	#didispace-dev.properties
	#didispace-test.properties
	#didispace-prod.properties
	#################本地文件模式############################################
	spring.profiles.active=native
	spring.cloud.config.server.native.searchLocations=classpath:/prop
	#spring.cloud.config.server.native.searchLocations=file:F:/properties/
	#################SVN模式#################################################
	#spring.profiles.active=subversion
	#spring.cloud.config.server.svn.uri=https://www.xxx.com/svn/demo/demo-config-repo
	#spring.cloud.config.server.svn.username=username
	#spring.cloud.config.server.svn.password=password

此处配置有多种形式,上文采用的是本地配置，从classpath:/prop中作为配置仓库来搜索配置

而/prop中存放有如下文件：

	sn-serviceProps-dev.properties
	sn-serviceProps-live.properties
	sn-serviceProps-pre.properties
	sn-serviceProps-uat.properties

可知，此处是配置了一个“配置库”的信息，而非配置了“单个配置文件”的信息，在分析代码时可以看到，springCloud-configserver的EnvironmentRepositoryConfiguration中通过spring.profiles.active来获取对应的EnvironmentRepository，再从EnvironmentRepository中调用findone方法获取到一个配置文件，最终通过配置文件再获取到一个真正的配置。


## 2.3 java文件的配置

	package cn.kanmars;
	
	import org.springframework.boot.SpringApplication;
	import org.springframework.boot.autoconfigure.SpringBootApplication;
	import org.springframework.cloud.config.server.EnableConfigServer;
	
	/**
	 * Created by kanmars on 2016/12/3.
	 */
	@SpringBootApplication
	@EnableConfigServer
	public class ConfigServerApplication {
	    public static void main(String[] args) {
	        SpringApplication.run(ConfigServerApplication.class, args);
	    }
	}

即可运行，在SpringBoot中，是通过@SpringBootApplication来启动SpringBoot，而SpringCloud中通过@EnableConfigServer来标记当前近程为一个ConfigServer

## 2.4 启动

	mvn clean package
	java -jar target\sn_configserver-1.0-SNAPSHOT.jar

即可运行，访问

	http://localhost:9000/sn-serviceProps/live

即可看到响应

	{"name":"sn-serviceProps","profiles":["live"],"label":null,"version":null,"state":null,"propertySources":[{"name":"classpath:/prop/sn-serviceProps-live.properties","source":{"id3":"id3-live","id2":"id2-live","id1":"id1-live"}}]}

特别注意：因为http协议自身的限制，在涉及网络交互时springBoot中要禁止使用下划线，否则会出一些很神奇的错误，例如上文：

	sn-serviceProps是正确的
	sn_serviceProps是错误的,HTTP解析时，会错误

至此配置管理服务端配置成功，在客户端连接上服务端后，就可以自动：启动时获取配置，并在客户端支持配置重新刷新的功能了。具体细节等到了对应的章节再细讲。
