---
layout: post
title:  "[KANMARS原创] - SPRING源码解析-AbstractApplicationContext"
desc: "本文描述Spring启动过程中的AbstractApplicationContext的作用"
date: 2015-08-06 19:20:11
tags: [server,java]
---
<br />
包含最重要的Spring方法&nbsp;&nbsp; &nbsp;refresh<br />
<br />
内部调用顺序<br />
&nbsp;&nbsp; &nbsp;public void refresh() throws BeansException, IllegalStateException {<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;synchronized (this.startupShutdownMonitor) {<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// Prepare this context for refreshing.&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// 初始化环境，包含Environment&nbsp;&nbsp; &nbsp;StandardEnvironment {activeProfiles=[], defaultProfiles=[default], propertySources=[systemProperties,systemEnvironment]}<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;prepareRefresh();<br />
<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// Tell the subclass to refresh the internal bean factory.<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// 初始化BeanFactory，&nbsp;&nbsp; &nbsp;DefaultListableBeanFactory<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// 包含<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// 1、加载Resources&nbsp;&nbsp; &nbsp;XmlBeanDefinitionReader&nbsp;&nbsp; &nbsp;ResourcePatternResolver&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DefaultResourceLoader&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// 2、根据Resources加载BeanDefinition&nbsp;&nbsp; &nbsp;BeanDefinitionParserDelegate &nbsp;&nbsp; &nbsp;BeanDefinitionHolder&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;GenericBeanDefinition&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// 3、注册BeanDefinition到BeanFactory中&nbsp;&nbsp; &nbsp;BeanDefinitionReaderUtils.registerBeanDefinition(bdHolder, getReaderContext().getRegistry());<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// 4、通知Bean定义事件&nbsp;&nbsp; &nbsp;getReaderContext().fireComponentRegistered(new BeanComponentDefinition(bdHolder));&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;内部将依赖的BeanDefinition进行依赖添加innerBeanDefinitions,beanReferences&nbsp;&nbsp; &nbsp;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;ConfigurableListableBeanFactory beanFactory = obtainFreshBeanFactory();<br />
<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// Prepare the bean factory for use in this context.<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// 对BeanFactory进行预处理<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// 1、设置默认值，如classloader等&nbsp;&nbsp; &nbsp;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// 2、设置默认处理对象ApplicationContextAwareProcessor<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// 3、设置被忽略的依赖接口&nbsp;&nbsp; &nbsp;ignoredDependencyInterfaces，如ResourceLoaderAware,ApplicationEventPublisherAware等<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// 4、设置被忽略的依赖类&nbsp;&nbsp; &nbsp;resolvableDependencies，如BeanFactory.class等<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// 5、如果包含运行时注入类&nbsp;&nbsp; &nbsp;loadTimeWeaver，则添加BeanFactoryProcess对象<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// 6、注册一些默认Bean&nbsp;&nbsp; &nbsp;beanFactory.registerSingleton(ENVIRONMENT_BEAN_NAME, getEnvironment());<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// &nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;beanFactory.registerSingleton(SYSTEM_PROPERTIES_BEAN_NAME, getEnvironment().getSystemProperties());<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// &nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;beanFactory.registerSingleton(SYSTEM_ENVIRONMENT_BEAN_NAME, getEnvironment().getSystemEnvironment());<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;prepareBeanFactory(beanFactory);<br />
<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;try {<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// Allows post-processing of the bean factory in context subclasses.<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;postProcessBeanFactory(beanFactory);<br />
<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// Invoke factory processors registered as beans in the context.<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// 1、执行&nbsp;&nbsp; &nbsp;BeanDefinitionRegistryPostProcessor.postProcessBeanDefinitionRegistry注册前时间处理<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// 2、通过beanFactory.getBeansOfType(BeanDefinitionRegistryPostProcessor.class, true, false);&nbsp;&nbsp; &nbsp;获取所有的BeanDefinitionRegistryPostProcessor<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// 3、执行invokeBeanFactoryPostProcessors(registryPostProcessors, beanFactory);&nbsp;&nbsp; &nbsp;执行注册前的BeanFactoryProcessor<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// 4、invokeBeanFactoryPostProcessors(registryPostProcessorBeans, beanFactory);&nbsp;&nbsp; &nbsp;执行注册的<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// 5、invokeBeanFactoryPostProcessors(regularPostProcessors, beanFactory);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;invokeBeanFactoryPostProcessors(beanFactory);<br />
<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// Register bean processors that intercept bean creation.<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// 1、注册BeanPostProcessors<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;registerBeanPostProcessors(beanFactory);<br />
<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// Initialize message source for this context.<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// 1、初始化DelegatingMessageSource&nbsp;&nbsp; &nbsp;信息国际化<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;initMessageSource();<br />
<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// Initialize event multicaster for this context.<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// 1、初始化Spring事件体系&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;SimpleApplicationEventMulticaster，通过multicastEvent方法可以对增加的ApplicationListener通知消息<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;initApplicationEventMulticaster();<br />
<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// Initialize other special beans in specific context subclasses.<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// 初始化其他Bean，暂为空方法<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;onRefresh();<br />
<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// Check for listener beans and register them.<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// 1、对Listeners进行注册<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;registerListeners();<br />
<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// Instantiate all remaining (non-lazy-init) singletons.<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// 对Bean进行初始化，执行BeanPostProcessors<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;finishBeanFactoryInitialization(beanFactory);<br />
<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// Last step: publish corresponding event.<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// 刷新生命周期对象<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// 发送初始化结束信号<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// 在全局上下文视图中注册ApplicationContext<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// LiveBeansView.registerApplicationContext(this);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;finishRefresh();<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;catch (BeansException ex) {<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// Destroy already created singletons to avoid dangling resources.<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;destroyBeans();<br />
<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// Reset 'active' flag.<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;cancelRefresh(ex);<br />
<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;// Propagate exception to caller.<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;throw ex;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;}<br />
<br />