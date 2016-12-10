---
layout: post
title:  "[KANMARS原创] - Lua源码阅读_DAY_001"
desc: "本文从初学者的角度试探性的看了一下Lua的实现"
date: 2015-08-16 18:22:33
tags: [server,lua]
---
<p>
	<br />
</p>
<p>
	本文从初学者的角度试探性的看了一下Lua的实现
</p>
<p>
	最近草草的看了点lua的结构，看这门语言的原因，是因为lua很短，并且是程序员从应用开发到语言开发的一个比较简单的路径。
</p>
<p>
	学艺不精，但是必须总结一下以防忘记
</p>
<p>
	------------------
</p>
<p>
	lua语法请查询官方文档，本处不再赘述
</p>
<p>
	------------------
</p>
<p>
	lua最重要的是内部的数据结构，可以参照阿里云大神<strong>罗日健</strong>的相关博客：
</p>
<p>
	http://blog.aliyun.com/761?spm=0.0.0.0.Bbv98y&nbsp;&nbsp;&nbsp;&nbsp;<span id="__kindeditor_bookmark_start_19__">&nbsp;&nbsp; Lua数据结构 — TValue（一）</span>
</p>
<p>
	<span id="__kindeditor_bookmark_start_19__">http://blog.aliyun.com/768?spm=0.0.0.0.IIIJKM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Lua数据结构 — TString（二）</span>
</p>
<p>
	<span id="__kindeditor_bookmark_start_19__">http://blog.aliyun.com/787?spm=0.0.0.0.nwRCjZ&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span id="__kindeditor_bookmark_start_19__">Lua数据结构 — Table（三）</span></span>
</p>
<p>
	<span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__">http://blog.aliyun.com/845?spm=0.0.0.0.BvDyCO&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__">Lua数据结构 — 闭包（四）</span></span></span></span>
</p>
<p>
	<span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__">http://blog.aliyun.com/789?spm=0.0.0.0.SHkRm9&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__">&nbsp;<span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__">Lua数据结构 — Udata（五）</span></span></span></span></span></span></span></span>
</p>
<p>
	<span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__">http://blog.aliyun.com/795?spm=0.0.0.0.xddNuq&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__">&nbsp;<span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__">Lua数据结构 — Lua_state（六）</span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span>
</p>
<p>
	<br />
<span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span>
</p>
<p>
	<span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__">此外，参照网易<span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__">前</span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span>杭州研究中心总监吴云洋的博客，也是不错的</span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span>
</p>
<p>
	<span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__">http://blog.codingnow.com/<br />
</span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span>
</p>
<p>
	<span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__">PS:我从2004到2011，玩《大话西游》七年，人生因这个游戏而改变。</span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span>
</p>
<p>
	<span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__">我看云风的博客一年，学习lua的一些语法或者内存结构......</span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span>
</p>
<p>
	<span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__">直到今天上午，才知道:《大话西游》是吴云洋开发的，而吴云洋就是云风。</span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span>
</p>
<p>
	<br />
<span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span>
</p>
<p>
	<span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__">------------------</span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span>
</p>
<p>
	<span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__">lua最常用的地方是游戏引擎的开发，其优势如下：</span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span>
</p>
<p>
	<span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__">1、Lua脚本可以很容易的被C/C++ 代码调用，也可以反过来调用C/C++的函数，这使得Lua在应用程序中可以被广泛应用。</span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span>
</p>
<p>
	<span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__">2、在目前所有的解释器语言中，Lua的速度是最快的。</span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span>
</p>
<p>
	<span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__">3、Lua足够的小，可以在嵌入平台大范围使用。</span></span></span></span></span></span></span></span></span></span></span></span></span></span></span></span>
</p>
<p>
	<span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"></span></span></span></span></span></span></span></span></span></span></span></span></span></span>------------------<br />
</span> 
</p>
<p>
	但对我来说,其优点就是：小，能让我短时间了解一门语言是如何运行的。
</p>
<p>
	Lua是用纯C语言实现的，幸好我的C语言已经达到了可以出去混饭吃的水平。
</p>
<p>
	<br />
</p>
<p>
	Lua的数据结构由TValue，TString，UData，GCObject等构成，
</p>
<p>
	要点如下：大范围应用了TValue作为值引用，而TString和UData等都是可垃圾回收的对象，通过GCObject链接到了垃圾回收链上。
</p>
<p>
	而TString和UData都采用的是一个头+体的结构，即从TString后开始读取TString中的长度，即为字符串的真正内容。UData类似。
</p>
<p>
	<br />
</p>
<p>
	Table是Lua比较重要的数据类型，在内部实现上，分别使用散列表Node *node和数组TValue *array来存放下标是"Value"和[index]的键和下标。
</p>
<p>
	当长度不够时，会调用luaH_resize函数对这两个内存进行扩容，而扩容在底层使用的是luaM_reallocvector--》realloc内存分配，可以对已分配内存进行扩容重新分配
</p>
<p>
	即Table可以实现动态的扩容或者缩容
</p>
<p>
	<br />
</p>
<p>
	接下来是Lua_state，Lua_state是一个全局的上下文信息。储存了Lua执行过程的栈信息，函数调用信息等，参照Lua_state结构体的源码
</p>
<p>
	<br />
</p>
<p>
	<br />
</p>
<p>
	/*<br />
** 'per thread' state<br />
*/<br />
struct lua_State {<br />
&nbsp; CommonHeader;<br />
&nbsp; lu_byte status;<br />
&nbsp; StkId top;&nbsp; /* first free slot in the stack */ <br />
&nbsp; global_State *l_G;<br />
&nbsp; CallInfo *ci;&nbsp; /* call info for current function */<br />
&nbsp; const Instruction *oldpc;&nbsp; /* last pc traced */<br />
&nbsp; StkId stack_last;&nbsp; /* last free slot in the stack */<br />
&nbsp; StkId stack;&nbsp; /* stack base */<br />
&nbsp; UpVal *openupval;&nbsp; /* list of open upvalues in this stack */<br />
&nbsp; GCObject *gclist;<br />
&nbsp; struct lua_State *twups;&nbsp; /* list of threads with open upvalues */ <br />
&nbsp; struct lua_longjmp *errorJmp;&nbsp; /* current error recover point */<br />
&nbsp; CallInfo base_ci;&nbsp; /* CallInfo for first level (C calling Lua) */<br />
&nbsp; lua_Hook hook;<br />
&nbsp; ptrdiff_t errfunc;&nbsp; /* current error handling function (stack index) */<br />
&nbsp; int stacksize;<br />
&nbsp; int basehookcount;<br />
&nbsp; int hookcount;<br />
&nbsp; unsigned short nny;&nbsp; /* number of non-yieldable calls in stack */<br />
&nbsp; unsigned short nCcalls;&nbsp; /* number of nested C calls */<br />
&nbsp; lu_byte hookmask;<br />
&nbsp; lu_byte allowhook;<br />
};
</p>
<p>
	<br />
</p>
<p>
	需要注意这几个东西：
</p>
<p>
	StkId top;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 即当前运行lua程序的栈顶
</p>
<p>
	StkId stack;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 即当前运行lua程序的栈底
</p>
<p>
	StkId stack_last&nbsp;&nbsp;&nbsp; 即当前运行lua程序的最高栈？
</p>
<p>
	GCObject *gclist;&nbsp;&nbsp;&nbsp; 根垃圾回收链
</p>
<p>
	CallInfo *ci;&nbsp;&nbsp;&nbsp; 正在运行的函数信息
</p>
<p>
	CallInfo base_ci;&nbsp;&nbsp;&nbsp; 最开始调用的函数信息
</p>
<p>
	<br />
</p>
<p>
	在运行过程中,lua.c会将一个函数压入栈顶top，然后将参数从左至右压入栈顶，之后运行之前压入函数的指令，执行完成后指令执行下一条，直至所有命令执行完成。
</p>
<p>
	（参见http://blog.aliyun.com/845?spm=0.0.0.0.BvDyCO&nbsp;&nbsp;&nbsp; 罗日健&nbsp;&nbsp;&nbsp; <span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__"><span id="__kindeditor_bookmark_start_19__">Lua数据结构 — 闭包（四）</span></span></span></span>）
</p>
<p>
	<br />
</p>
<p>
	世界上的虚拟机有两种，一种是类似JAVA的堆栈结构，另一种就是Lua用的寄存器结构。据说寄存器结构的性能要笔堆栈结构要快得多，理由是：寄存器结构可以采用更简化的虚拟机命令来执行计算操作，而堆栈结构的虚拟机命令极其繁多。比如Lua的虚拟机指令只有不到四十条，而JAVA的虚拟机指令会有两百多条。（参见http://blog.csdn.net/lidatou/article/details/3866114&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; LUA虚拟机指令）
</p>
<p>
	<br />
</p>
<p>
	接下来我们要说“闭包”
</p>
<p>
	之所以将闭包放在数据结构的最后一个说，是因为在Lua中，闭包与函数密不可分
</p>
<p>
	在Lua的Function中，即lua.c将函数压入栈顶top的那个不明物体，是一个叫做Closure的联合体，位于
</p>
<p>
	<br />
</p>
<p>
	typedef struct CClosure {&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;<br />
&nbsp; ClosureHeader;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;<br />
&nbsp; lua_CFunction f;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;<br />
&nbsp; TValue upvalue[1];&nbsp; /* list of upvalues */<br />
} CClosure;<br />
<br />
<br />
typedef struct LClosure {&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;<br />
&nbsp; ClosureHeader;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;<br />
&nbsp; struct Proto *p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;<br />
&nbsp; UpVal *upvals[1];&nbsp; /* list of upvalues */<br />
} LClosure;<br />
<br />
<br />
typedef union Closure {&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;<br />
&nbsp; CClosure c;<br />
&nbsp; LClosure l;<br />
} Closure;
</p>
<p>
	<br />
</p>
<p>
	大家可以看到，Closure有两种可能，一种是C语言的函数lua_CFunction，另一种就是lua原生闭包LClosure，原生闭包中包含了这么几个东西
</p>
<p>
	struct Proto *p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 方法原型-》即每个方法都是一个原型，具有自己的字节码可执行
</p>
<p>
	UpVal *upvals[1];&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 容量为1的upvals，即上层运行环境(即常识意义上的闭包)
</p>
<p>
	我们再看Proto方法原型
</p>
<p>
	typedef struct Proto {<br />
&nbsp; CommonHeader;<br />
&nbsp; lu_byte numparams;&nbsp; /* number of fixed parameters */<br />
&nbsp; lu_byte is_vararg;<br />
&nbsp; lu_byte maxstacksize;&nbsp; /* maximum stack used by this function */<br />
&nbsp; int sizeupvalues;&nbsp; /* size of 'upvalues' */<br />
&nbsp; int sizek;&nbsp; /* size of 'k' */<br />
&nbsp; int sizecode;<br />
&nbsp; int sizelineinfo;<br />
&nbsp; int sizep;&nbsp; /* size of 'p' */<br />
&nbsp; int sizelocvars;<br />
&nbsp; int linedefined;<br />
&nbsp; int lastlinedefined;<br />
&nbsp; TValue *k;&nbsp; /* constants used by the function */<br />
&nbsp; Instruction *code;<br />
&nbsp; struct Proto **p;&nbsp; /* functions defined inside the function */<br />
&nbsp; int *lineinfo;&nbsp; /* map from opcodes to source lines (debug information) */<br />
&nbsp; LocVar *locvars;&nbsp; /* information about local variables (debug information) */<br />
&nbsp; Upvaldesc *upvalues;&nbsp; /* upvalue information */<br />
&nbsp; struct LClosure *cache;&nbsp; /* last created closure with this prototype */<br />
&nbsp; TString&nbsp; *source;&nbsp; /* used for debug information */<br />
&nbsp; GCObject *gclist;<br />
} Proto;
</p>
<p>
	重要的有这么几个东西
</p>
<p>
	TValue *k;&nbsp;&nbsp;&nbsp;&nbsp; 带下标的常量池<br />
Instruction *code;&nbsp;&nbsp;&nbsp; 执行的字节码
</p>
<p>
	Proto的所有参数都是在语法分析和中间代码生成时获取的，相当于编译出来的汇编码一样是不会变的，动态性是在Closure中体现的。
</p>
<p>
	<br />
</p>
<p>
	当lua.c开始执行，会把整个lua脚本进行解析编译，生成一个大的闭包，压入堆栈，然后开始执行第一个闭包的字节码，当发生了调用，则将新的函数生成一个闭包，重新压入栈......循环往复......
</p>
<p>
	<br />
</p>
<p>
	之后说到了闭包的常用功能或者“特色”：如果想访问一个函数内部的临时变量，在lua中是如何实现的？
</p>
<p>
	即闭包的实现：
</p>
<p>
	在闭包刚刚创建，父函数还未执行完毕，闭包尚未关闭时，子函数中对父层变量是一个引用，即upvals中是对lua_state的栈的StkId的引用，所以保持了函数的实时更新
</p>
<p>
	而如果父函数已经执行完成，闭包已经关闭时，子函数将把这个变量作为一个值进行保存。（换句话说：如果一个父函数返回了两个函数，而且两个函数中都有闭包，那么两个函数在执行过程中的闭包是相互独立的）
</p>
<p>
	<br />
</p>
<ul>
	<li>
		<strong>闭包关闭后</strong>（即函数退出后），UpVal不再是指针，而是<strong>值</strong>。 知道UpVal的原理后，就只需要简要叙述一下UpVal的数据结构：（lobject.h 274 – 284）
	</li>
</ul>
<p>
	<a href="http://blog.aliyun.com/wp-content/uploads/2014/06/lua-closure-structure-9.png"><img class="alignnone size-full wp-image-858" alt="lua-closure-structure-9" src="http://blog.aliyun.com/wp-content/uploads/2014/06/lua-closure-structure-9.png" height="211" width="329" /></a>
</p>
<ol>
	<li>
		CommHeader： UpVal也是可回收的类型，一般有的CommHeader也会有
	</li>
	<li>
		TValue* v：当函数打开时是指向对应stack位置值，当关闭后则指向自己
	</li>
	<li>
		TValue value：函数关闭后保存的值
	</li>
	<li>
		UpVal* prev、UpVal* next：用于GC，全局绑定的一条UpVal回收链表
	</li>
</ol>
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
<p>
	<br />
</p>
<p>
	接下来说一下lua.c启动之前。
</p>
<p>
	lua.c启动之前，需要进行lua脚本的编译和加载。这个需要对编译原理非常熟悉，而比较惭愧的是，我大学时编译原理学的比较差，只有在工作后曾经替别人写过一个词法分析器和语法分析器，还偶尔学了点Schema之类的面向函数编程......所以编译原理略知大概
</p>
<p>
	<br />
</p>
<p>
	在lua.c启动之前，在main函数中
</p>
<p>
	int main (int argc, char **argv) {<br />
&nbsp; int status, result;<br />
&nbsp; lua_State *L = luaL_newstate();&nbsp; /*创建一个Lua_State运行上下文*/&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br />
&nbsp; if (L == NULL) {<br />
&nbsp;&nbsp;&nbsp; l_message(argv[0], "cannot create state: not enough memory");<br />
&nbsp;&nbsp;&nbsp; return EXIT_FAILURE;<br />
&nbsp; }<br />
&nbsp; lua_pushcfunction(L, &amp;pmain);&nbsp; /*将pmain函数压入栈准备执行*/ &nbsp;<br />
&nbsp; lua_pushinteger(L, argc);&nbsp; /* 把参数数量压入栈*/<br />
&nbsp; lua_pushlightuserdata(L, argv); /*把参数压入栈 */<br />
&nbsp; status = lua_pcall(L, 2, 1, 0);&nbsp; /*执行pmain函数*/<br />
&nbsp; result = lua_toboolean(L, -1);&nbsp; /* get result */<br />
&nbsp; report(L, status);<br />
&nbsp; lua_close(L);<br />
&nbsp; return (result &amp;&amp; status == LUA_OK) ? EXIT_SUCCESS : EXIT_FAILURE;<br />
}
</p>
<p>
	而下一步，在pmain函数中
</p>
<p>
	static int pmain (lua_State *L) {<br />
&nbsp; int argc = (int)lua_tointeger(L, 1);<br />
&nbsp; char **argv = (char **)lua_touserdata(L, 2);<br />
&nbsp; int script;<br />
&nbsp; int args = collectargs(argv, &amp;script);<br />
&nbsp; luaL_checkversion(L);&nbsp; /* check that interpreter has correct version */<br />
&nbsp; if (argv[0] &amp;&amp; argv[0][0]) progname = argv[0];<br />
&nbsp; if (args == has_error) {&nbsp; /* bad arg? */<br />
&nbsp;&nbsp;&nbsp; print_usage(argv[script]);&nbsp; /* 'script' has index of bad arg. */<br />
&nbsp;&nbsp;&nbsp; return 0;<br />
&nbsp; }<br />
&nbsp; if (args &amp; has_v)&nbsp; /* option '-v'? */<br />
&nbsp;&nbsp;&nbsp; print_version();<br />
&nbsp; if (args &amp; has_E) {&nbsp; /* option '-E'? */<br />
&nbsp;&nbsp;&nbsp; lua_pushboolean(L, 1);&nbsp; /* signal for libraries to ignore env. vars. */<br />
&nbsp;&nbsp;&nbsp; lua_setfield(L, LUA_REGISTRYINDEX, "LUA_NOENV");<br />
&nbsp; }
</p>
<p>
	//打开标准库，包括base,io,os,等，会将http://www.codingnow.com/2000/download/lua_manual.html的第五章节中包含的所有方法全部导入&nbsp; luaL_openlibs(L);&nbsp; /* open standard libraries */&nbsp;&nbsp;&nbsp; <br />
&nbsp; createargtable(L, argv, argc, script);&nbsp; /* create table 'arg' */&nbsp;&nbsp;&nbsp; //创建参数Table<br />
&nbsp; if (!(args &amp; has_E)) {&nbsp; /* no option '-E'? */<br />
&nbsp;&nbsp;&nbsp; if (handle_luainit(L) != LUA_OK)&nbsp; /* run LUA_INIT */<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;&nbsp; /* error running LUA_INIT */ &nbsp;<br />
&nbsp; }&nbsp;&nbsp; &nbsp;<br />
&nbsp; if (!runargs(L, argv, script))&nbsp; /* execute arguments -e and -l */<br />
&nbsp;&nbsp;&nbsp; return 0;&nbsp; /* something failed */&nbsp; &nbsp;<br />
&nbsp; if (script &lt; argc &amp;&amp;&nbsp; /* execute main script (if there is one) */<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; handle_script(L, argv + script) != LUA_OK)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //脚本模式执行<br />
&nbsp;&nbsp;&nbsp; return 0;<br />
&nbsp; if (args &amp; has_i)&nbsp; /* -i option? */&nbsp; &nbsp;<br />
&nbsp;&nbsp;&nbsp; doREPL(L);&nbsp; /* do read-eval-print loop */&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //命令行模式执行<br />
&nbsp; else if (script == argc &amp;&amp; !(args &amp; (has_e | has_v))) {&nbsp; /* no arguments? */ <br />
&nbsp;&nbsp;&nbsp; if (lua_stdin_is_tty()) {&nbsp; /* running in interactive mode? */<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; print_version();&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; doREPL(L);&nbsp; /* do read-eval-print loop */<br />
&nbsp;&nbsp;&nbsp; } &nbsp;<br />
&nbsp;&nbsp;&nbsp; else dofile(L, NULL);&nbsp; /* executes stdin as a file */<br />
&nbsp; }
</p>
<p>
	&nbsp; lua_pushboolean(L, 1);&nbsp; /* signal no errors */<br />
&nbsp; return 1;
</p>
<p>
	}
</p>
<p>
	<br />
</p>
<p>
	如果是执行lua脚本的话，会执行handle_script(L, argv + script) != LUA_OK)&nbsp; 这一行代码
</p>
<p>
	在这一行代码中会通过如下调用顺序
</p>
<p>
	luaL_loadfile-》luaL_loadfile-》luaL_loadfilex-》lua_load-》luaD_protectedparser-》luaD_pcall-》luaD_rawrunprotected-》f_parser-》luaY_parser
</p>
<p>
	<br />
</p>
<p>
	最终执行到lparser.c的luaY_parser中
</p>
<p>
	<br />
</p>
<p>
	在luaY_parser中会对LexState和FuncState进行初始化，调用mainfunc
</p>
<p>
	<br />
</p>
<p>
	static void mainfunc (LexState *ls, FuncState *fs) {<br />
&nbsp; BlockCnt bl;<br />
&nbsp; expdesc v;<br />
&nbsp; open_func(ls, fs, &amp;bl);<br />
&nbsp; fs-&gt;f-&gt;is_vararg = 1;&nbsp; /* main function is always vararg */<br />
&nbsp; init_exp(&amp;v, VLOCAL, 0);&nbsp; /* create and... */<br />
&nbsp; newupvalue(fs, ls-&gt;envn, &amp;v);&nbsp; /* ...set environment upvalue */<br />
&nbsp; luaX_next(ls);&nbsp; /* read first token */<br />
&nbsp; statlist(ls);&nbsp; /* parse main body */<br />
&nbsp; check(ls, TK_EOS);<br />
&nbsp; close_func(ls);<br />
}
</p>
<p>
	<br />
</p>
<p>
	在该方法内部，会用luaX_next获取到一个token语素(内部采用的是llex.c的llex进行词法切割)，然后用statlist开始执行词法分析与语法分析
</p>
<p>
	<br />
</p>
<p>
	static void statlist (LexState *ls) {<br />
&nbsp; /* statlist -&gt; { stat [';'] } */<br />
&nbsp; while (!block_follow(ls, 1)) {<br />
&nbsp;&nbsp;&nbsp; if (ls-&gt;t.token == TK_RETURN) {<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; statement(ls);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return;&nbsp; /* 'return' must be last statement */<br />
&nbsp;&nbsp;&nbsp; }<br />
&nbsp;&nbsp;&nbsp; statement(ls);<br />
&nbsp; }<br />
}
</p>
<p>
	<br />
</p>
<p>
	在statement方法内部通过LL(2)递归下降语法分析法，对语法进行分析
</p>
<p>
	如果语法无误，则调用该语法对应的函数生成对应的字节码，放入FuncState &amp;fs-&gt;f-&gt;code[pc]中，完成字节码的生成。
</p>
<p>
	<br />
</p>
<p>
	之后开始运行时，则重复闭包入栈，参数入栈，开始调用......的重复过程。
</p>
<p>
	-------------------------------------------------------------------------------------------------------------------------------------------------
</p>
<p>
	似乎说到这儿还是没有说lua的函数是怎么运行的。
</p>
<p>
	请注意：Lua是基于寄存器的JVM结构，可以认为一个正在运行的lua_state中包含如下内容：
</p>
<p>
	字节码，pc指针，用栈实现的寄存器，常量池，闭包变量池
</p>
<p>
	可以举例如下，看一下编译后的字节码实现：
</p>
<p>
	<br />
</p>
<p>
	local u = 0; &nbsp;<br />
&nbsp;&nbsp;&nbsp; function f()&nbsp; &nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; local l; &nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; u = 1;&nbsp; &nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; l = u; &nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; g = 1; &nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; l = g; &nbsp;<br />
&nbsp;&nbsp;&nbsp; end &nbsp;<br />
<br />
<br />
<br />
main &lt;test.lua:0,0&gt; (4 instructions at 0x80048eb0) &nbsp;<br />
&nbsp;&nbsp;&nbsp; 0+ params, 2 slots, 1 upvalue, 1 local, 2 constants, 1 function &nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp; [1] LOADK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 -1&nbsp;&nbsp;&nbsp; ; 0 &nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp;&nbsp; [8] CLOSURE&nbsp;&nbsp;&nbsp;&nbsp; 1 0 ; 0x80049140 &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;--函数的定义就是创建闭包1<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp; [2] SETTABUP&nbsp;&nbsp;&nbsp; 0 -2 1&nbsp; ; _ENV "f" &nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp; [8] RETURN&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 1 &nbsp;<br />
&nbsp;&nbsp;&nbsp; constants (2) for 0x80048eb0: &nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp; 0 &nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp;&nbsp; "f" &nbsp;<br />
&nbsp;&nbsp;&nbsp; locals (1) for 0x80048eb0: &nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp; u&nbsp;&nbsp; 2&nbsp;&nbsp; 5 &nbsp;<br />
&nbsp;&nbsp;&nbsp; upvalues (1) for 0x80048eb0: &nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp; _ENV&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp; 0 &nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;<br />
function &lt;test.lua:2,8&gt; (7 instructions at 0x80049140) &nbsp;<br />
&nbsp;&nbsp;&nbsp; 0 params, 2 slots, 2 upvalues, 1 local, 2 constants, 0 functions &nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp; [3] LOADNIL&nbsp;&nbsp;&nbsp;&nbsp; 0 0 &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;//初始化local l 定义为nil<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp;&nbsp; [4] LOADK&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1 -1&nbsp;&nbsp;&nbsp; ; 1 &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;//R(A) := Kst(Bx)&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;加载常量1到寄存器1<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 3&nbsp;&nbsp; [4] SETUPVAL&nbsp;&nbsp;&nbsp; 1 0 ; u &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;//UpValue[B] := R(A)&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;将寄存器1的值赋值给闭包0&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;即给u进行赋值<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 4&nbsp;&nbsp; [5] GETUPVAL&nbsp;&nbsp;&nbsp; 0 0 ; u &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;//R(A) := UpValue[B]&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;将闭包0的值复制给寄存器0&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;将u的值复制给l<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5&nbsp;&nbsp; [6] SETTABUP&nbsp;&nbsp;&nbsp; 1 -2 -1 ; _ENV "g" 1 &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;//UpValue[A][RK(B)] := RK(C)&nbsp;&nbsp; &nbsp;将常量-1代表的“1”设置到闭包1即"_ENV"的RK(-2)即“g”的值中&nbsp;&nbsp; &nbsp;而_ENV是在创建主函数的时候创建的<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 6&nbsp;&nbsp; [7] GETTABUP&nbsp;&nbsp;&nbsp; 0 1 -2&nbsp; ; _ENV "g" &nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 7&nbsp;&nbsp; [8] RETURN&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0 1 &nbsp;<br />
&nbsp;&nbsp;&nbsp; constants (2) for 0x80049140: &nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp; 1 &nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2&nbsp;&nbsp; "g" &nbsp;<br />
&nbsp;&nbsp;&nbsp; locals (1) for 0x80049140: &nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp; l&nbsp;&nbsp; 2&nbsp;&nbsp; 8 &nbsp;<br />
&nbsp;&nbsp;&nbsp; upvalues (2) for 0x80049140: &nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp; u&nbsp;&nbsp; 1&nbsp;&nbsp; 0 &nbsp;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp; _ENV&nbsp;&nbsp;&nbsp; 0&nbsp;&nbsp; 0&nbsp;&nbsp; &nbsp;<br />
<br />
<br />
上面的代码片段生成一个主函数和一个内嵌函数。根据前面说到的变量规则，在内嵌函数中，l是local变量，u是upvalue，g由于既不是local变量，也不是upvalue，当作全局变量处理。我们先来看内嵌函数，生成的指令从17行开始。<br />
<br />
第17行的LOADNIL前面已经讲过，为local变量赋值。下面的LOADK和SETUPVAL组合，完成了u = 1。因为1是一个常量，存在于常量表中，而lua没有常量与upvalue的直接操作指令，所以需要先把常量1装在到临时寄存器1种，然后将寄存器1的值赋给upvalue 0，也就是u。<br />
第20行的GETUPVAL将upvalue u赋给local变量l。<br />
第21行开始的SETTABUP和GETTABUP就是前面提到的对全局变量的处理了。g=1被转化为_ENV.g=1。_ENV是系统预先设置在主函数中的upvalue，所以对于全局变量g的访问被转化成对upvalue[_ENV][g]的访问。<br />
&nbsp;&nbsp; &nbsp;SETTABUP将upvalue 1(_ENV代表的upvalue)作为一个table，将常量表2（常量"g"）作为key的值设置为常量表1（常量1）；<br />
<br />
GETTABUP则是将upvalue 1作为table，将常量表2为key的值赋给寄存器0（local l）。<br />
<br />
</p>
<p>
	<br />
</p>
<p>
	---------------------------------------------------------------------------------------
</p>
<p>
	以上是今天学习的内容，虽然木有什么用，但似乎可以让自己从程序开发人员的角度脱离出来，探索一下语言设计人员的世界。
</p>
<p>
	以后需要逐行阅读代码了，只有逐行的读，才能真正的看懂。
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