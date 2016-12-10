---
layout: post
title:  "[KANMARS原创] - DEBUG分析SPRING IOC容器启动过程"
desc: "最近觉得，不能让自己沉迷与业务性代码了，需要深入一下技术。于是计划今年用设计者的角度学习IT技术。本文即是我通过DEBUG分析的SPRING IOC容器的启动过程"
date: 2015-07-20 23:17:00
tags: [server,java,linux,spring]
---
<p>
	以ClassPathXmlApplicationContext为例，分析Spring启动步骤
</p>
<p>
	Spring启动步骤
</p>
<p>
	&nbsp;&nbsp;&nbsp; 1、<span style="background-color:#E53333;">ClassPathXmlApplicationContext</span>
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.1&nbsp;&nbsp;&nbsp;&nbsp;ClassPathXmlApplicationContext.setConfigLocations()&nbsp;&nbsp;&nbsp; 设置配置文件
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.2&nbsp;&nbsp;&nbsp;&nbsp;ClassPathXmlApplicationContext.refresh()&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style="background-color:#E53333;">根据配置文件进行刷新</span>
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.3&nbsp;&nbsp;&nbsp;&nbsp;AbstractApplicationContext.refresh()
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4&nbsp;&nbsp;&nbsp;&nbsp;AbstractApplicationContext.obtainFreshBeanFactory()&nbsp;&nbsp;&nbsp; <span style="background-color:#E53333;">初始化BeanFactory</span>
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.1&nbsp;&nbsp;&nbsp;&nbsp;AbstractRefreshableApplicationContext.refreshBeanFactory()&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 刷新BeanFactory
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.2&nbsp;&nbsp;&nbsp;&nbsp;AbstractRefreshableApplicationContext.createBeanFactory()&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 创建<span style="background-color:#E53333;">DefaultListableBeanFactory</span>
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.3&nbsp;&nbsp;&nbsp;&nbsp;AbstractXmlApplicationContext.loadBeanDefinitions(DefaultListableBeanFactory beanFactory)&nbsp;&nbsp;&nbsp;&nbsp; 给beanFacroty加载BeanDefinition
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.3.1&nbsp;&nbsp;&nbsp; 创建<span style="background-color:#E53333;">XmlBeanDefinitionReader</span>，&nbsp;&nbsp;&nbsp; 给XmlBeanDefinitionReader设置beanFactory
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4&nbsp;&nbsp;&nbsp;&nbsp;AbstractXmlApplicationContext.loadBeanDefinitions(XmlBeanDefinitionReader reader)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 通过XmlBeanDefinition加载BeanDefinition
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.1&nbsp;&nbsp;&nbsp;&nbsp;AbstractXmlApplicationContext.getConfigResources()&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 获取资源配置信息
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2&nbsp;&nbsp;&nbsp;&nbsp;AbstractXmlApplicationContext.getConfigLocations()&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 获取资源配置字符串
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.1&nbsp;&nbsp;&nbsp;&nbsp;XmlBeanDefinitionReader.loadBeanDefinitions(configLocations)&nbsp;&nbsp;&nbsp; 加载资源配置
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.2&nbsp;&nbsp;&nbsp;&nbsp;AbstractBeanDefinitionReader.loadBeanDefinitions(String... locations)&nbsp;&nbsp;&nbsp; 根据资源配置字符串加载beanDefinition
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.3&nbsp;&nbsp;&nbsp;&nbsp;AbstractBeanDefinitionReader.loadBeanDefinitions(String location, Set&lt;Resource&gt; actualResources)&nbsp;&nbsp;&nbsp; 根据资源配置字符串加载beanDefinition
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.4&nbsp;&nbsp;&nbsp;&nbsp;AbstractBeanDefinitionReader.getResourceLoader()&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 获取resourceLoader，即ClassPathXmlApplicationContext
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.5&nbsp;&nbsp;&nbsp;&nbsp;AbstractApplicationContext.getResources(String locationPattern)&nbsp;&nbsp;&nbsp; 获取Resources&nbsp;&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.6&nbsp;&nbsp;&nbsp;&nbsp;AbstractApplicationContext.resourcePatternResolver.getResources(String locationPattern)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;获取Resources
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.7&nbsp;&nbsp;&nbsp;&nbsp;PathMatchingResourcePatternResolver.getResources(String locationPattern)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 获取Resources
</p>
<p>
	&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; 1.4.4.2.8 &nbsp;&nbsp; getResourceLoader().getResource(locationPattern)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 即ClassPathXmlApplicationContext.getResource(locationPattern)
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.9&nbsp;&nbsp;&nbsp;&nbsp;DefaultResourceLoader.getResource(locationPattern)
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.10&nbsp;&nbsp;&nbsp;&nbsp;DefaultResourceLoader.getResourceByPath(location)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.11&nbsp;&nbsp;&nbsp; return new ClassPathContextResource(path, getClassLoader());
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.12&nbsp;&nbsp;&nbsp; 返回1.4.4.2.3
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.13&nbsp;&nbsp;&nbsp;&nbsp;AbstractBeanDefinitionReader.loadBeanDefinitions(Resource... resources)&nbsp;&nbsp;&nbsp; 根据加载出的<span style="background-color:#E53333;">ClassPathContextResource</span>读取配置
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.14&nbsp;&nbsp;&nbsp;&nbsp;XmlBeanDefinitionReader.loadBeanDefinitions(EncodedResource encodedResource)
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.15&nbsp;&nbsp;&nbsp;&nbsp;XmlBeanDefinitionReader.doLoadBeanDefinitions(encodedResource.getResource().getInputStream())&nbsp;&nbsp;&nbsp; 从resource中获取输入流，交给下一步执行
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.16&nbsp;&nbsp;&nbsp;&nbsp;XmlBeanDefinitionReader.doLoadBeanDefinitions(InputSource inputSource, Resource resource)
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.17&nbsp;&nbsp;&nbsp;&nbsp;Document doc = this.documentLoader.loadDocument(<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;inputSource, getEntityResolver(), this.errorHandler, validationMode, isNamespaceAware());
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 加载Document配置
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.18&nbsp;&nbsp;&nbsp;&nbsp;XmlBeanDefinitionReader.registerBeanDefinitions(Document doc, Resource resource)&nbsp;&nbsp;&nbsp; 根据Document 来加载配置
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.19&nbsp;&nbsp;&nbsp;&nbsp;XmlBeanDefinitionReader.createBeanDefinitionDocumentReader()&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 即创建DefaultBeanDefinitionDocumentReader
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.20&nbsp;&nbsp;&nbsp;&nbsp;documentReader.registerBeanDefinitions(doc, createReaderContext(resource))&nbsp;&nbsp;&nbsp; 注册doc，并且用resource创建上下文
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.21&nbsp;&nbsp;&nbsp;&nbsp;DefaultBeanDefinitionDocumentReader.doRegisterBeanDefinitions(doc.getDocumentElement())&nbsp;&nbsp;&nbsp; 执行解析并注册
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.22&nbsp;&nbsp;&nbsp;&nbsp;BeanDefinitionParserDelegate delegate = DefaultBeanDefinitionDocumentReader.createDelegate() &nbsp;&nbsp; 创建<span style="background-color:#E53333;">BeanDefinitionDelegate</span>代理
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.23&nbsp;&nbsp;&nbsp;&nbsp;DefaultBeanDefinitionDocumentReader.preProcessXml(root)&nbsp;&nbsp;&nbsp; 空操作
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.24&nbsp;&nbsp;&nbsp;&nbsp;DefaultBeanDefinitionDocumentReader.parseBeanDefinitions(root,this.delegate)&nbsp;&nbsp;&nbsp; 用DeanDefinitionParseDelegate代理解析root
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.25&nbsp;&nbsp;&nbsp;&nbsp;DefaultBeanDefinitionDocumentReader.processBeanDefinition&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;用DeanDefinitionParseDelegate代理解析root
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.26&nbsp;&nbsp;&nbsp;&nbsp;DefaultBeanDefinitionDocumentReader.processBeanDefinition(Element ele, BeanDefinitionParserDelegate delegate)
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.27&nbsp;&nbsp;&nbsp;&nbsp;BeanDefinitionHolder bdHolder=delegate.parseBeanDefinitionElement(ele)&nbsp;&nbsp;&nbsp;&nbsp; 解析bdHolder
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.27.1&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; AbstractBeanDefinition beanDefinition = BeanDefinitionParserDelegate.parseBeanDefinitionElement(ele, beanName, containingBean)
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.27.2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BeanDefinitionParserDelegate.createBeanDefinition(className,parent)
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.27.3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BeanDefinitionReaderUtils.createBeanDefinition()
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.27.4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BeanDefinitionReaderUtils.createBeanDefinition()&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style="background-color:#E53333;">生成BeanDefinition，即：GenericBeanDefinition</span>
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.28&nbsp;&nbsp;&nbsp; return new BeanDefinitionHolder(beanDefinition, beanName, aliasesArray);&nbsp;&nbsp;&nbsp; 返回步骤1.4.4.2.27
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.29&nbsp;&nbsp;&nbsp;&nbsp;BeanDefinitionReaderUtils.registerBeanDefinition(bdHolder, getReaderContext().getRegistry());&nbsp;&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 第一个参数为1.4.4.2.28生成的holder，第二个参数为DefaultListableBeanFactory
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.30&nbsp;&nbsp;&nbsp;&nbsp;registry.registerBeanDefinition(beanName, definitionHolder.getBeanDefinition());
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.30.1&nbsp;&nbsp;&nbsp;&nbsp;registry.beanDefinitionNames.add(beanName);
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.30.2&nbsp;&nbsp;&nbsp; registry.beanDefinitionMap.put(beanName, beanDefinition);
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.30.3&nbsp;&nbsp;&nbsp;&nbsp;registry.resetBeanDefinition(String beanName)&nbsp;&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.30.3.1 &nbsp;&nbsp; clearMergedBeanDefinition(beanName);
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.30.3.2&nbsp;&nbsp;&nbsp;&nbsp;destroySingleton(beanName);
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.30.3.3&nbsp;&nbsp;&nbsp;&nbsp;clearByTypeCache();
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.30.3.4&nbsp;&nbsp;&nbsp;&nbsp;if (beanName.equals(bd.getParentName())) {resetBeanDefinition(bdName);}&nbsp;&nbsp;&nbsp; 清除父类的BeanDefinition
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.30.3&nbsp;&nbsp;&nbsp;&nbsp;registry.registerAlias(beanName, aliase);
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.31&nbsp;&nbsp;&nbsp;&nbsp;DefaultBeanDefinitionDocumentReader.processBeanDefinition()
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;getReaderContext().fireComponentRegistered(new BeanComponentDefinition(bdHolder));
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.32&nbsp;&nbsp;&nbsp; 返回步骤1.4.4.2.26
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.33&nbsp;&nbsp;&nbsp;&nbsp;DefaultBeanDefinitionDocumentReader.postProcessXml(root)&nbsp;&nbsp;&nbsp;&nbsp;空操作
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.34&nbsp;&nbsp;&nbsp; 返回步骤1.4.4.2.20
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.35&nbsp;&nbsp;&nbsp; 返回步骤1.4.4.2.16
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.36&nbsp;&nbsp;&nbsp; 返回步骤1.4.4.2.15
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.37&nbsp;&nbsp;&nbsp; 返回步骤1.4.4.2.14
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.38&nbsp;&nbsp;&nbsp; 返回步骤1.4.4.2.13
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.39&nbsp;&nbsp;&nbsp; 返回步骤1.4.4.2.2
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.4.2.40&nbsp;&nbsp;&nbsp; 返回步骤1.4.4
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 返回步骤1.4.3
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.4.6&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 步骤1.4.3继续&nbsp;&nbsp;&nbsp;<span style="background-color:#E53333;">&nbsp;AbstractApplicationContext.obtainFreshBeanFactory()</span>
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ConfigurableListableBeanFactory beanFactory = getBeanFactory();
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 执行步骤1.4AbstractApplicationContext.obtainFreshBeanFactory()完毕
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;AbstractApplicationContext.prepareBeanFactory()&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 设置一些初始配置，设置默认bean和BeanPostProcessor&nbsp;&nbsp;&nbsp;&nbsp;LoadTimeWeaverAwareProcessor
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.6&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;AbstractApplicationContext.postProcessBeanFactory()&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;// Allows post-processing of the bean factory in context subclasses.&nbsp;&nbsp;&nbsp; 空方法
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.7&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;AbstractApplicationContext.invokeBeanFactoryPostProcessors()&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Instantiate and invoke all registered BeanFactoryPostProcessor beans,
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;AbstractApplicationContext.initMessageSource()&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 加载国际化信息
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.9&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;AbstractApplicationContext.initApplicationEventMulticaster()&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 加载Spring容器事件体系
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.10&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;AbstractApplicationContext.onRefresh()&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 刷新一些特殊的bean&nbsp;&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.11&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;AbstractApplicationContext.finishBeanFactoryInitialization(beanFactory)&nbsp;&nbsp;&nbsp; 初始化非延时加载的单例bean
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.11.1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;beanFactory.preInstantiateSingletons();&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 初始化实例
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.11.2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;DefaultListableBeanFactory.preInstantiateSingletons()
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.11.2.1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;RootBeanDefinition bd = getMergedLocalBeanDefinition(beanName);&nbsp;&nbsp;&nbsp; 获取到BeanDefinition
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.11.2.2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DefaultListableBeanFactory.getBean(beanName)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 获取bean
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.11.2.3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;AbstractBeanFactory.doGetBean(final String name, final Class&lt;T&gt; requiredType, final Object[] args, boolean typeCheckOnly)
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.11.2.4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Object sharedInstance = getSingleton(beanName);
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.11.2.5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;this.singletonObjects.get(beanName);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.11.2.6&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;mbd.isSingleton()&nbsp;&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;getSingleton()-&gt;createBean()
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.11.2.6.1 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; AbstractAutowireCapableBeanFactory.doCreateBean(beanName,mbd, args)
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.11.2.6.2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;AbstractAutowireCapableBeanFactory.resolveBeanClass()
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.11.2.6.3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Constructor&lt;?&gt;[] ctors = determineConstructorsFromBeanPostProcessors(beanClass, beanName);
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.11.2.6.4&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;BeanWrapper instantiateBean(final String beanName, final RootBeanDefinition mbd)
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;.getInstantiationStrategy().instantiate(mbd, beanName, parent);
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.11.2.6.5&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="background-color:#E53333;">&nbsp;SimpleInstantiationStrategy.BeanUtils.instantiateClass(constructorToUse);</span>
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.11.2.6.6&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 返回1.11.2.6
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.11.2.7&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;bean = getObjectForBeanInstance(sharedInstance, name, beanName, mbd);
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.11.2.8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 返回1.11.2.2
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.11.2.9&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 返回1.11.1
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.11.3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 返回1.11
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.12&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;beanFactory.preInstantiateSingletons(); 结束
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.13&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;AbstractApplicationContext.finishRefresh()
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.13.1 &nbsp;&nbsp;&nbsp;&nbsp;AbstractApplicationContext.initLifecycleProcessor()&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 初始化DefaultLifecycleProcessor
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.13.2&nbsp;&nbsp;&nbsp;&nbsp;AbstractApplicationContext.getLifecycleProcessor().onRefresh();&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 运行DefaultLifecycleProcessor
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.13.3&nbsp;&nbsp;&nbsp; publishEvent(new ContextRefreshedEvent(this));&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;getApplicationEventMulticaster().multicastEvent(event);
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.13.4&nbsp;&nbsp;&nbsp;&nbsp;LiveBeansView.registerApplicationContext(this);&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 在LiveBeansView中注册当前的applicationContext
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1.13.5&nbsp;&nbsp;&nbsp; 返回ClassPathXmlApplicationContext
</p>
<p>
	&nbsp;&nbsp;&nbsp; 加载结束
</p>
<p>
	<br />
</p>
<p>
	<br />
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</p>
<p>
	<br />
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
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
<p>
	<br />
</p>