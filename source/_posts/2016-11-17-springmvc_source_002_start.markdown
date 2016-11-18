---
layout: post
title:  "[KANMARS原创]-SpringMVC源码解析(2) - 启动过程"
desc: "[KANMARS原创]-SpringMVC源码解析(2) - 启动过程"
date: 2016-11-17 17:48:00
tags: [server,java]
---
#一、SpringMVC的启动过程#

SpringMVC的启动过程即为Servlet的启动和Spring的启动两部分。

我们对SpringMVC的典型配置，是在web.xml中配置一个DispatcherServlet

因此我们需要从DispatcherServlet的启动说起。

##1.1、DispatcherServlet的继承结构##
DispatcherServlet的继承结构简单来说如下：

DispatcherServlet->FrameworkServlet->HttpServletBean->HttpServlet

因此如果要看DispatcherServlet是如何启动的，需要从init()方法开始。

即：HttpServletBean.init();

##1.2、DispatcherServlet的启动过程##

有人喜欢用时序图来画启动过程，而我喜欢用调用顺序来画。

	DispatcherServlet.init()
		├new ServletConfigPropertyValues(getServletConfig(), this.requiredProperties)//读取配置信息
		└DispatcherServlet.initServletBean()初始化ServletBean
			└FrameworkServlet.initServletBean()
				├FrameworkServlet.webApplicationContext = initWebApplicationContext()//启动Spring
				│	├FrameworkServlet.wac = createWebApplicationContext(rootContext);
				│	│	├wac =(ConfigurableWebApplicationContext) BeanUtils.instantiateClass(XmlWebApplicationContext.class);
				│	│	└FrameworkServlet.configureAndRefreshWebApplicationContext(wac)
				│	│		└wac.refresh()//根据springXML文件启动Spring
				│	└FrameworkServlet.onRefresh(wac)
				│		└DispatcherServlet.onRefresh(wac)
				│			└DispatcherServlet.initStrategies(wac)
				│				├DispatcherServlet.initMultipartResolver(context)//从wac中获取对象
				│				├DispatcherServlet.initLocaleResolver(context)//从wac中获取对象
				│				├DispatcherServlet.initThemeResolver(context)//从wac中获取对象
				│				├DispatcherServlet.initHandlerMappings(context)//从wac中获取对象
				│				├DispatcherServlet.initHandlerAdapters(context)//从wac中获取对象
				│				├DispatcherServlet.initHandlerExceptionResolvers(context)//从wac中获取对象
				│				├DispatcherServlet.initRequestToViewNameTranslator(context)//从wac中获取对象
				│				├DispatcherServlet.initViewResolvers(context)//从wac中获取对象
				│				└DispatcherServlet.initFlashMapManager(context)//从wac中获取对象
				└FrameworkServlet.initFrameworkServlet()//从wac中获取对象

##1.3、DispatcherServlet的默认配置##
DispatcherServlet的默认配置在DispatcherServlet.properties中

	org.springframework.web.servlet.LocaleResolver=org.springframework.web.servlet.i18n.AcceptHeaderLocaleResolver
	
	org.springframework.web.servlet.ThemeResolver=org.springframework.web.servlet.theme.FixedThemeResolver
	
	org.springframework.web.servlet.HandlerMapping=org.springframework.web.servlet.handler.BeanNameUrlHandlerMapping,\
		org.springframework.web.servlet.mvc.annotation.DefaultAnnotationHandlerMapping
	
	org.springframework.web.servlet.HandlerAdapter=org.springframework.web.servlet.mvc.HttpRequestHandlerAdapter,\
		org.springframework.web.servlet.mvc.SimpleControllerHandlerAdapter,\
		org.springframework.web.servlet.mvc.annotation.AnnotationMethodHandlerAdapter
	
	org.springframework.web.servlet.HandlerExceptionResolver=org.springframework.web.servlet.mvc.annotation.AnnotationMethodHandlerExceptionResolver,\
		org.springframework.web.servlet.mvc.annotation.ResponseStatusExceptionResolver,\
		org.springframework.web.servlet.mvc.support.DefaultHandlerExceptionResolver
	
	org.springframework.web.servlet.RequestToViewNameTranslator=org.springframework.web.servlet.view.DefaultRequestToViewNameTranslator
	
	org.springframework.web.servlet.ViewResolver=org.springframework.web.servlet.view.InternalResourceViewResolver
	
	org.springframework.web.servlet.FlashMapManager=org.springframework.web.servlet.support.SessionFlashMapManager

分别代表了不同模块的实现类，我们需要注意的、最重要的有如下几种(其他的一些类也有作用，但是对我个人而言，最重要的还是这三种)：

	handlerMapping:RequestMappingHandlerMapping
	
	handlerAdapter:RequestMappingHandlerAdapter
	
	viewResolver:FreeMarkerViewResolver

##1.4、Spring的启动过程wac.refresh()##
Spring的启动过程是一致的，从spring.xml开始加载，例如：

	<?xml version="1.0" encoding="UTF-8"?>
	<beans xmlns="http://www.springframework.org/schema/beans"
		xmlns:util="http://www.springframework.org/schema/util"  
		xmlns:aop="http://www.springframework.org/schema/aop" 
		xmlns:context="http://www.springframework.org/schema/context"
		xmlns:tx="http://www.springframework.org/schema/tx"
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		xmlns:mongo="http://www.springframework.org/schema/data/mongo"
		xmlns:task="http://www.springframework.org/schema/task"
		xmlns:mvc="http://www.springframework.org/schema/mvc"
		xsi:schemaLocation="http://www.springframework.org/schema/aop  
	        http://www.springframework.org/schema/aop/spring-aop.xsd  
	        http://www.springframework.org/schema/beans  
	        http://www.springframework.org/schema/beans/spring-beans.xsd  
	        http://www.springframework.org/schema/context  
	        http://www.springframework.org/schema/context/spring-context.xsd  
	        http://www.springframework.org/schema/tx  
	        http://www.springframework.org/schema/tx/spring-tx.xsd
	        http://www.springframework.org/schema/task  
			http://www.springframework.org/schema/task/spring-task-3.1.xsd
			http://www.springframework.org/schema/util 
			http://www.springframework.org/schema/util/spring-util-3.1.xsd
			http://www.springframework.org/schema/mvc
			http://www.springframework.org/schema/mvc/spring-mvc-3.1.xsd">
		
		<mvc:default-servlet-handler />
		<mvc:annotation-driven ignoreDefaultModelOnRedirect="true"/>
		<aop:aspectj-autoproxy proxy-target-class="true"/>
		<context:annotation-config></context:annotation-config>
		<context:component-scan base-package="cn.com.gome.sn.admin" />

		<!-- 文件上传解析器 -->  
		<bean id="multipartResolver" class="org.springframework.web.multipart.commons.CommonsMultipartResolver">  
		    <property name="defaultEncoding" value="utf-8"></property>  
		    <property name="maxInMemorySize" value="10960"></property>  
		</bean>
		<bean id="springBeanFactory" class="cn.com.gome.frame.util.SpringBeanFactory"/>
	    <util:properties id="SN_admin" location="classpath:props/SN-admin.properties" />
		<!--登录验证-->
		<mvc:interceptors>
			<mvc:interceptor>
				<mvc:mapping path="/**/*.dhtml"/>
				<bean class="cn.com.gome.sn.admin.intercepter.SessionInterceptor">
					<property name="allowUrls">
						<list>
							<value>/login/login.dhtml</value>
						</list>
					</property>
				</bean>
			</mvc:interceptor>
		</mvc:interceptors>
	</beans>
可以看到其中比较重要的Bean如下：

<mvc:default-servlet-handler />

<mvc:annotation-driven ignoreDefaultModelOnRedirect="true"/>

<aop:aspectj-autoproxy proxy-target-class="true"/>

经查看SpringMVC的NamespaceHandler为org.springframework.web.servlet.config.MvcNamespaceHandler


**1、default-servlet-handler的解析过程如下：**

	DefaultServletHandlerBeanDefinitionParser.parse()
		├defaultServletHandlerDef=new RootBeanDefinition(DefaultServletHttpRequestHandler.class);
		├handlerMappingDef=new RootBeanDefinition(SimpleUrlHandlerMapping.class);
		└MvcNamespaceUtils.registerDefaultComponents(parserContext, source);
			├registerBeanNameUrlHandlerMapping(parserContext, source);
			│	└beanNameMappingDef = new RootBeanDefinition(BeanNameUrlHandlerMapping.class);
			├registerHttpRequestHandlerAdapter(parserContext, source);
			│	└handlerAdapterDef = new RootBeanDefinition(HttpRequestHandlerAdapter.class);
			└registerSimpleControllerHandlerAdapter(parserContext, source);
				└handlerAdapterDef = new RootBeanDefinition(SimpleControllerHandlerAdapter.class);

在使用该标签之后，注册了一些BeanDefinition到SpringFactory中

**2、annotation-driven的解析过程如下：**

	AnnotationDrivenBeanDefinitionParser.parse()
		├handlerMappingDef = new RootBeanDefinition(RequestMappingHandlerMapping.class);
		├bindingDef = new RootBeanDefinition(ConfigurableWebBindingInitializer.class);
		├handlerAdapterDef = new RootBeanDefinition(RequestMappingHandlerAdapter.class);
		├csInterceptorDef = new RootBeanDefinition(ConversionServiceExposingInterceptor.class);
		├exceptionHandlerExceptionResolver = new RootBeanDefinition(ExceptionHandlerExceptionResolver.class);
		├responseStatusExceptionResolver = new RootBeanDefinition(ResponseStatusExceptionResolver.class);
		└defaultExceptionResolver = new RootBeanDefinition(DefaultHandlerExceptionResolver.class);


**3、aspectj-autoproxy的解析过程：**

	纯技术上说aspectj-autoproxy与SpringMVC没关系，此处仅说明一个参数：
	<aop:aspectj-autoproxy proxy-target-class="true"/>
	
	a)  proxy-target-class如果为true，则代理使用cglib实现
	b)  proxy-target-class如果为false，则代理使用java原生接口代理实现

## 1.5、回头来看DispatcherServlet的启动过程 ##

	DispatcherServlet.init()
		├new ServletConfigPropertyValues(getServletConfig(), this.requiredProperties)//读取配置信息
		└DispatcherServlet.initServletBean()初始化ServletBean
			└FrameworkServlet.initServletBean()
				├FrameworkServlet.webApplicationContext = initWebApplicationContext()//启动Spring
				│	├FrameworkServlet.wac = createWebApplicationContext(rootContext);
				│	│	├wac =(ConfigurableWebApplicationContext) BeanUtils.instantiateClass(XmlWebApplicationContext.class);
				│	│	└FrameworkServlet.configureAndRefreshWebApplicationContext(wac)
				│	│		└wac.refresh()//根据springXML文件启动Spring
				│	└FrameworkServlet.onRefresh(wac)
				│		└DispatcherServlet.onRefresh(wac)
				│			└DispatcherServlet.initStrategies(wac)
				│				├DispatcherServlet.initMultipartResolver(context)//从wac中获取对象
				│				├DispatcherServlet.initLocaleResolver(context)//从wac中获取对象
				│				├DispatcherServlet.initThemeResolver(context)//从wac中获取对象
				│				├DispatcherServlet.initHandlerMappings(context)//从wac中获取对象
				│				├DispatcherServlet.initHandlerAdapters(context)//从wac中获取对象
				│				├DispatcherServlet.initHandlerExceptionResolvers(context)//从wac中获取对象
				│				├DispatcherServlet.initRequestToViewNameTranslator(context)//从wac中获取对象
				│				├DispatcherServlet.initViewResolvers(context)//从wac中获取对象
				│				└DispatcherServlet.initFlashMapManager(context)//从wac中获取对象
				└FrameworkServlet.initFrameworkServlet()//从wac中获取对象


在DispatcherServlet.initStrategies(wac)中
	
	├DispatcherServlet.initMultipartResolver(context)//从wac中获取对象
	├DispatcherServlet.initLocaleResolver(context)//从wac中获取对象
	├DispatcherServlet.initThemeResolver(context)//从wac中获取对象
	├DispatcherServlet.initHandlerMappings(context)//从wac中获取对象
	├DispatcherServlet.initHandlerAdapters(context)//从wac中获取对象
	├DispatcherServlet.initHandlerExceptionResolvers(context)//从wac中获取对象
	├DispatcherServlet.initRequestToViewNameTranslator(context)//从wac中获取对
	├DispatcherServlet.initViewResolvers(context)//从wac中获取对象
	└DispatcherServlet.initFlashMapManager(context)//从wac中获取对象

所获取的HandlerMappings、HandlerAdapters等信息，都是通过

	<mvc:default-servlet-handler />
	
	<mvc:annotation-driven ignoreDefaultModelOnRedirect="true"/>

定义出来，然后在DispatcherServlet的启动过程的最后一步初始化的。

## 1.6、SpringMVC的@RequestMapping自动扫描过程 ##

SpringMVC的自动扫描是通过RequestMappingHandlerMapping.java的afterPropertiesSet()方法实现的。

在RequestMappingHandlerMapping实例化后，会调用initControllerAdviceCache()方法，在此方法内，会遍历全部的bean，判断其方法是否有Annotation注解
	
	ControllerAdvice.class
	RequestMapping.class
	ModelAttribute.class

然后将对应的方法设置为bridgedMethod添加到modelAttributeAdviceCache中或者initBinderAdviceCache中


