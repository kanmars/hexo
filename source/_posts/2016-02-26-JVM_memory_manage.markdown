---
layout: post
title:  "[KANMARS原创] - (一)从JVM源码理解JVM内存结构"
desc: "最近看了一些JVM内存结构，但纸上得来终觉浅，绝知此事要躬行。看别人画的，总归是别人的，所以自己画一个"
date: 2016-02-26 16:47:11
tags: [server,java]
---
<p>
	最近看了一些JVM内存结构，但纸上得来终觉浅，绝知此事要躬行。看别人画的，总归是别人的，所以自己画一个
</p>
<p>
	JVM内存入口位于如下三个位置中
</p>
<p>
	hotspot\src\share\vm\memory\universe.hpp
</p>
<p>
	<span>hotspot\src\share\vm\memory\</span>universe.inline.hpp
</p>
<p>
	<span>hotspot\src\share\vm\memory\</span>universe.cpp
</p>
<p>
	这个入口之后是JVM堆内存的初始化、分配策略、垃圾回收策略、堆的扩大与收缩，年轻代的管理，老年代的管理，永久区的管理。
</p>
<p>
	因此画图展示。
</p>
<p>
	<img src="http://kanmars.github.io/images/photo/20160226/JVM_memory_manage.png" alt="" />
</p>
<p>
	<br />
</p>
<p>
	Universe作为内存的核心，创建了垃圾回收策略和堆结构。
</p>
<p>
	而上图中的每一个类，都是比较重要的数据+算法结构。
</p>
<p>
	通过对每个描述对象的加工，完成了堆的申请、初始化、扩展、收缩等操作。
</p>
<p>
	---------------
</p>
<p>
	后续会从如下角度来解释这个内存核心：
</p>
<p>
	1、堆是如何创建、映射、扩展、收缩的？
</p>
<p>
	2、堆的种类
</p>
<p>
	3、常用参数对堆种类的影响
</p>
<p>
	4、对象的创建过程
</p>
<p>
	5、对象在堆代中的移动
</p>
<p>
	6、常用垃圾回收策略
</p>