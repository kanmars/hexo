---
layout: post
title:  "[KANMARS原创] - Spring 源码解析-BeanDefinition"
desc: "此文是BeanDefinition的结构"
date: 2015-10-19 19:17:00
tags: [server,java,linux,spring]
---
<p>
	Spring源码解析
</p>
<p>
	Spring BeanDefinition结构
</p>
<p>
	<br />
</p>
<p>
	<br />
</p>
<p>
	SpringBeanDefinition是一个重要的结构，在spring初始化的时候，ApplicationContext在加载DefaultListableBeanFactory时，会对Spring的xml配置文件进行解析，将每一个标记生成一个BeanDefinition，然后封装为BeanDefinitionHolder，最终存放在DefaultListableBeanFactory中
</p>
<p>
	<br />
</p>
<p>
	下图是BeanDefinition的结构图
</p>
<p>
	<img src="http://kanmars.github.io/images/photo/20151019/BeanDifinition.png" alt="" /> 
</p>
<p>
	可以看到BeanDefinition其实就是一个配置项生成的Bean的定义
</p>
<p>
	最常用的BeanDefinition是GenericBeanDefinition
</p>
<p>
	而属性在BeanDefinition中是以PropertiesValue的形式存在的，
</p>
<p>
	每一个PropertiesValue含有两个关键的属性
</p>
<p>
	name，即名称
</p>
<p>
	value，即对应的值，对应的值可能是如下几种类型：
</p>
<p>
	TypedStringValue&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 字符串
</p>
<p>
	RuntimeBeanReference&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 运行时Bean指向
</p>
<p>
	BeanDefition&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 另一个BeanDefition
</p>
<p>
	Ref&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 动态生成运行时Bean指向
</p>
<p>
	idRef&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; RuntimeBeanNameReference
</p>
<p>
	ManagedArray&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; array
</p>
<p>
	ManagedList&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; list
</p>
<p>
	ManagedSet&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; set
</p>
<p>
	ManagedMap&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; map
</p>
<p>
	ManagedProperties&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; properties
</p>
<p>
	<br />
</p>
<p>
	------------------------------------------------------------------------------------------------------------------------------------------------
</p>
<p>
	请期待下一集BeanDefinition的合并
</p>
<p>
	------------------------------------------------------------------------------------------------------------------------------------------------
</p>
<p>
	在BeanDefinition中有这么几个很混淆的定义：
</p>
<p>
	GenericBeanDefinition
</p>
<p>
	AbstractBeanDefinition
</p>
<p>
	<br />
</p>
<pre>RootBeanDefinition
在最开始解析一个Spring标签时，生成的是一个GenericBeanDefinition，并注册到BeanFactory中
在BeanDefinition进行实例化时，会调用AbstractBeanFactory.getMergedBeanDefition方法获取到合并的BeanDefition，即RootBeanDefinition

，在生成RootBeanDefinition时，会传入parentBeanDefinition
<pre>mbd = <span style="color:#000080;font-weight:bold;">new </span>RootBeanDefinition(parentBeanDefinition);

在RootBeanDefinition的构造方法中，会调用各种方法，将parentBeanDefinition的属性放到RootBeanDefinition中

这样就形成了BeanDefinition和parentBeanDefinition的合并merge机制。
最终获取到的即是RootBeanDefinition
之后再根据RootBeanDefinition对Bean进行实例化。

</pre>
</pre>
<p>
	<br />
</p>
<p>
	<br />
</p>
<p>
	<br />
</p>