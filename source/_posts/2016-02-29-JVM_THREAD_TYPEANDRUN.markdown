---
layout: post
title:  "[KANMARS原创] - (五) 从JVM源码来理解JVM中的线程种类与启动方式"
desc: "本文描述了从JVM源码的角度看JVM中包含的线程种类，如NamedThread，JavaThread，WatcherThread。并且对NamedThread内部的VMThread、ConcurrentGCThread、WorkerThread进行了解析，对WorkerThread的两种实现GangWorker和GCTaskThread进行了描述。"
date: 2016-02-29 21:20:01
tags: [server,java]
---
<p>
	JVM中的线程详解
</p>
<p>
	在JVM的\hotsopt\src\share\vm\runtime\Thread.hpp中可以看到关于THREAD的子类结构
</p>
<p>
	// Class hierarchy<br />
// - Thread<br />
// &nbsp; - NamedThread<br />
// &nbsp; &nbsp; - VMThread<br />
// &nbsp; &nbsp; - ConcurrentGCThread<br />
// &nbsp; &nbsp; - WorkerThread<br />
// &nbsp; &nbsp; &nbsp; - GangWorker<br />
// &nbsp; &nbsp; &nbsp; - GCTaskThread<br />
// &nbsp; - JavaThread
</p>
<p>
	// &nbsp; &nbsp; -&nbsp;LowMemoryDetectorThread
</p>
<p>
	// &nbsp; &nbsp; - CompilerThread
</p>
<p>
	// &nbsp; - WatcherThread<br />
Thread是最基础的基类
</p>
<p>
	重要属性如下：
</p>
<p>
	OSThread* _osthread;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 在OSThread内部set_thread_id方法可以设置为操作系统级的线程ID &nbsp;pthreadid
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 在JVM的线程管理中,THREAD是一个数据结构，THREAD中含有抽象的OSThread数据结构，OSThread中的pthreadid或者threadid指向的是操作系统内核级别的线程id
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 关于操作系统内核级别的线程，大家可以阅读原生C语言的多线程编程接口POSIX threads 简称pthread库
</p>
<p>
	重要函数如下：
</p>
<p>
	virtual void run();&nbsp; &nbsp; 为最终的线程运行方法
</p>
<p>
	<br />
</p>
<p>
	此外有一个工具性质的类Th<span>r</span>eads
</p>
<p>
	重要属性如下：
</p>
<p>
	&nbsp; static JavaThread* _thread_list;<br />
&nbsp; static int &nbsp; &nbsp; &nbsp; &nbsp; _number_of_threads;<br />
&nbsp; static int &nbsp; &nbsp; &nbsp; &nbsp; _number_of_non_daemon_threads;<br />
&nbsp; static int &nbsp; &nbsp; &nbsp; &nbsp; _return_code;
</p>
<p>
	储存了所有正在运行的Java线程
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
	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
</p>
<p>
	可以看到，线程粗分为三类：<br />
NamedThread、JavaThread、WatcherThread
</p>
<p>
	这三类中
</p>
<p>
	<span style="color:#E53333;background-color:#000000;">NamedThread</span>是一个大类
</p>
<p>
	<br />
</p>
<p>
	按照源码中的注释：
</p>
<p>
	// Name support for threads. &nbsp;non-JavaThread subclasses with multiple<br />
// uniquely named instances should derive from this.<br />
max_name_len = 64，最大名称长度为64个字符
</p>
<p>
	重要属性为
</p>
<p>
	char* _name;
</p>
<p>
	JavaThread* _processed_thread;
</p>
<p>
	也就是说NamedThread中可以有OSThread也可以有JavaThread
</p>
<div>
	<span style="line-height:1.5;"></span> 
</div>
<p>
	<br />
</p>
<p>
	<span style="color:#E53333;background-color:#000000;">JavaThread</span>是JAVA线程
</p>
<p>
	重要属性如下：
</p>
<p>
	JavaThread* &nbsp; &nbsp;_next;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; //&nbsp;The next thread in the Threads list
</p>
<p>
	oop &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;_threadObj;&nbsp; &nbsp; //&nbsp;The Java level thread object
</p>
<p>
	int _java_call_counter;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; // java调用次数
</p>
<p>
	JavaFrameAnchor _anchor; // JavaFrame锚点
</p>
<p>
	ThreadFunction _entry_point;
</p>
<p>
	JNIEnv &nbsp; &nbsp; &nbsp; &nbsp;_jni_environment;
</p>
<p>
	vframeArray* &nbsp;_vframe_array_head;
</p>
<p>
	vframeArray* &nbsp;_vframe_array_last;
</p>
<p>
	GrowableArray&lt;jvmtiDeferredLocalVariableSet*&gt;* _deferred_locals_updates;&nbsp; &nbsp; 本地变量表
</p>
<p>
	oop &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; _vm_result; &nbsp; &nbsp;// Used to pass back an oop result into Java code, GC-preserved
</p>
<p>
	oop &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; _vm_result_2; &nbsp;// Used to pass back an oop result into Java code, GC-preserved
</p>
<p>
	ThreadSafepointState *_safepoint_state;
</p>
<p>
	address &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; _saved_exception_pc;
</p>
<p>
	volatile oop &nbsp; &nbsp; _exception_oop;
</p>
<p>
	volatile address _exception_pc;
</p>
<p>
	volatile address _exception_handler_pc;
</p>
<p>
	volatile int &nbsp; &nbsp; _exception_stack_size;
</p>
<p>
	volatile int &nbsp; &nbsp; _is_method_handle_return;
</p>
<p>
	<br />
</p>
<p>
	重要方法如下：
</p>
<p>
	void java_suspend();
</p>
<p>
	void java_resume();
</p>
<p>
	int &nbsp;java_suspend_self();
</p>
<p>
	virtual void run();
</p>
<p>
	<span style="color:#E53333;background-color:#000000;"></span><span><span style="color:#E53333;background-color:#000000;">WatcherThread</span>是用来模拟时间中断</span> 
</p>
<p>
	<span>重要属性如下：</span> 
</p>
<p>
	<span>static WatcherThread* _watcher_thread;</span> 
</p>
<p>
	<span>volatile static bool _should_terminate;</span> 
</p>
<p>
	<span><span>------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------</span><br />
</span> 
</p>
<p>
	<span><span><span><span>// &nbsp; - NamedThread</span><br />
<span>// &nbsp; &nbsp; - VMThread</span><br />
<span>// &nbsp; &nbsp; - ConcurrentGCThread</span><br />
<span>// &nbsp; &nbsp; - WorkerThread</span><br />
<span>// &nbsp; &nbsp; &nbsp; - GangWorker</span><br />
<span>// &nbsp; &nbsp; &nbsp; - GCTaskThread</span></span></span></span> 
</p>
<p>
	<span><span><span><span>NameThread下分为三大类VMTh<span>r</span>ead,ConcurrentGCThread,WorkerThread</span></span></span></span> 
</p>
<p>
	<span style="color:#E53333;background-color:#000000;">首先看VMThread</span> 
</p>
<p>
	VMThread位于\hotspot\src\share\vm\runtime\vmThread.hpp中
</p>
<p>
	重要属性如下:
</p>
<p>
	static VM_Operation* &nbsp; &nbsp; _cur_vm_operation;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 当前正在执行的VM操作
</p>
<p>
	static VMOperationQueue* _vm_queue;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 所有VM操作的对象
</p>
<p>
	static VMThread* &nbsp; &nbsp; _vm_thread;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 单例模式的VMThread
</p>
<p>
	重要方法如下：
</p>
<p>
	void evaluate_operation(VM_Operation* op);&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 执行一个VM操作
</p>
<p>
	bool is_VM_thread() const &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ return true; }&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; //默认为VMThread<br />
bool is_GC_thread() const &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;{ return true; }&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; //默认为GCThread
</p>
<p>
	与VMThread配套使用的是VMOperationQueue和VM_Operation
</p>
<p>
	<span><span style="color:#E53333;background-color:#000000;">VMOperationQueue</span>位于</span><span>\hotspot\src\share\vm\runtime\vmThread.hpp中</span> 
</p>
<p>
	重要属性如下：
</p>
<p>
	int &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; _queue_length[nof_priorities];
</p>
<p>
	VM_Operation* _queue &nbsp; &nbsp; &nbsp; [nof_priorities];
</p>
<p>
	int &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; _queue_counter;
</p>
<p>
	VM_Operation* _drain_list;
</p>
<p>
	<span style="color:#E53333;background-color:#000000;"></span><span><span style="color:#E53333;background-color:#000000;">VM_Operation</span>位于</span><span></span><span>\hotspot\src\share\vm\runtime\Vm_operations.hpp中</span> 
</p>
<p>
	重要属性如下：
</p>
<p>
	Thread* &nbsp; &nbsp; &nbsp; &nbsp; _calling_thread;
</p>
<p>
	VM_Operation* &nbsp; _next;
</p>
<p>
	VM_Operation* &nbsp; _prev;
</p>
<p>
	void evaluate();
</p>
<p>
	virtual void doit()
</p>
<p>
	virtual bool doit_prologue()
</p>
<p>
	virtual void doit_epilogue()
</p>
<p>
	VM_ThreadStop<span>位于</span><span></span><span></span><span>\hotspot\src\share\vm\runtime\Vm_operations.hpp中</span> 
</p>
<p>
	重要属性如下
</p>
<p>
	oop &nbsp; &nbsp; _thread;
</p>
<p>
	oop &nbsp; &nbsp; _throwable;
</p>
<p>
	此外和VMThread相关联的VM_Operation还有
</p>
<p>
	VM_ForceSafepoint
</p>
<p>
	VM_ForceAsyncSafepoint
</p>
<p>
	VM_Deoptimize
</p>
<p>
	VM_DeoptimizeFrame
</p>
<p>
	VM_HandleFullCodeCache
</p>
<p>
	VM_DeoptimizeAll
</p>
<p>
	VM_ZombieAll
</p>
<p>
	VM_Verify
</p>
<p>
	VM_PrintThreads
</p>
<p>
	VM_PrintJNI
</p>
<p>
	VM_FindDeadlocks
</p>
<p>
	VM_ThreadDump
</p>
<p>
	VM_Exit
</p>
<p>
	可从名称中看到其用途
</p>
<p>
	举个简单的栗子，<span>VM_PrintJNI</span> 
</p>
<p>
	<span>void VM_Operation::evaluate() {<br />
&nbsp; ResourceMark rm;<br />
&nbsp; if (TraceVMOperation) {<br />
&nbsp; &nbsp; tty-&gt;print("[");<br />
&nbsp; &nbsp; NOT_PRODUCT(print();)<br />
&nbsp; }<br />
&nbsp; doit();<br />
&nbsp; if (TraceVMOperation) {<br />
&nbsp; &nbsp; tty-&gt;print_cr("]");<br />
&nbsp; }<br />
}<br />
</span> 
</p>
<p>
	<span>void VM_PrintJNI::doit() {<br />
&nbsp; JNIHandles::print_on(_out);<br />
}</span> 
</p>
<p>
	<span>----------------------------------------------------------------</span> 
</p>
<p>
	<span><span style="color:#E53333;background-color:#000000;">Concurr</span><span style="color:#E53333;background-color:#000000;">entGCThread</span>位于\hotspot\src\share\vm\gc_implementation\shared\concurrentGCThread.hpp中</span> 
</p>
<p>
	<span>含义如其名称，并发垃圾回收线程</span> 
</p>
<p>
	<span><br />
</span> 
</p>
<p>
	<span><br />
</span> 
</p>
<p>
	<span><span style="color:#E53333;background-color:#000000;">WorkerT</span><span><span style="color:#E53333;background-color:#000000;">hread</span><span style="color:#E53333;background-color:#000000;">有两个子类：</span></span><span style="color:#E53333;background-color:#000000;">GangWorker、</span><span style="color:#E53333;background-color:#000000;">GCTaskT</span><span style="color:#E53333;background-color:#000000;">hread</span></span> 
</p>
<p>
	<span>子类极多。启动过程有很大区别，例如</span> 
</p>
<p>
	<span>GangWorker在WorkGang::initialize_workers()中GangWorker* new_worker = allocate_worker(worker);中创建</span> 
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 例如FlexibleWorkGang &nbsp;&nbsp;_workers-&gt;initialize_workers();<br />
</span> 
</p>
<p>
	<span>GCTaskThread的初始化与启动在</span> 
</p>
<p>
	<span>ParallelScavengeHeap::initialize()</span> 
</p>
<p>
	<span>_gc_task_manager = GCTaskManager::create(ParallelGCThreads);</span> 
</p>
<p>
	<span>在构造函数中调用:initialize();<br />
</span> 
</p>
<p>
	<span>GCTaskManager::initialize()</span> 
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;set_thread(t, GCTaskThread::create(this, t, processor_assignment[t]));</span> 
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;new GCTaskThread(manager, which, processor_id)</span> 
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;os::create_thread(this, os::pgc_thread)</span> 
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span>&nbsp;&nbsp;&nbsp;&nbsp;osthread-&gt;set_thread_type(thr_type);</span><br />
</span> 
</p>
<p>
	<span><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;thread-&gt;run();</span></span> 
</p>
<p>
	<span><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span>GCTaskT</span><span>hread-&gt;run();</span><br />
</span></span> 
</p>
<p>
	<span><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;GCTask* task = manager()-&gt;get_task(which());&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 即：任何一个进程，只要在manager的任务队列中放入task，后续将会立刻执行</span></span> 
</p>
<p>
	<span><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;task-&gt;do_it(manager(), which());&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; <br />
</span></span> 
</p>
<p>
	<span>从这段描述中可以看到，WorkerThread本身即为垃圾回收线程，大致分为两类：</span> 
</p>
<p>
	<span>1、GangWorker，作用于SharedHeap，在ShareHeap创建成功后，等待AbstractWorkGang-&gt;AbstractGangTask* _task中获取到task，然后执行</span> 
</p>
<p>
	<span>2、<span>GCTaskT</span><span>hread，作用于</span>parallelscavenge,在<span>ParallelScavengeHeap创建成功后，生成</span><span>GCTaskManager，进而生成任务队列</span>SynchronizedGCTaskQueue* &nbsp;_queue，等待有程序将任务放入队列，然后执行</span> 
</p>
<p>
	<br />
</p>
<p>
	<span style="line-height:1.5;"><span>----------------------------------------------------------------</span></span> 
</p>
<p>
	<span style="line-height:1.5;">下文我们来看一下VMThread的启动过程</span> 
</p>
<p>
	<span>VMThread是用于JVM虚拟机操作 </span> 
</p>
<p>
	<span>其启动过程为随着JVM虚拟机java.c一起启动</span> 
</p>
<p>
	<span>调用堆栈序列为:</span> 
</p>
<p>
	<span>java.c:main-&gt;javaMain-&gt;InitializeJVM-&gt;CreateJavaVM-&gt;JNI_CreateJavaVM-&gt;Threads::create_vm</span> 
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;VMThread::create();&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 生成单例模式的_vm_thread</span> 
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;_vm_thread = new VMThread();</span> 
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_vm_queue = new VMOperationQueue();</span> 
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;os::create_thread(vmthread, os::vm_thread)&nbsp; &nbsp; 给VMThread创建真实线程</span> 
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;OSThread* osthread = new OSThread(NULL, NULL);</span> 
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;pd_initialize();</span> 
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;_startThread_lock = new Monitor(Mutex::event, "startThread_lock", true); &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;锁监视器，第一个和第三个参数均没有用，只有第二个参数会作为Monitor的名名称</span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 内部具有_LockWord关键字，同时具有CASPTR宏Atomic::cmpxchg_ptr用来对数据进行原子性操作，底层采用AMD64汇编指令cmpxchgq来完成原子性操作<br />
</span> 
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Monitor::Monitor() { ClearMonitor(this); }</span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;void Monitor::ClearMonitor (Monitor * m, const char *name) {<br />
&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;m-&gt;_owner &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; = NULL ;<br />
&nbsp; <span>&nbsp; &nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp; &nbsp;&nbsp;</span>m-&gt;_snuck &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; = false ;<br />
<span>&nbsp; &nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp; &nbsp;&nbsp;</span>&nbsp; if (name == NULL) {<br />
&nbsp;<span>&nbsp; &nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp; &nbsp;&nbsp;</span> &nbsp; strcpy(m-&gt;_name, "UNKNOWN") ;<br />
&nbsp;<span>&nbsp; &nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp; &nbsp;&nbsp;</span> } else {<br />
&nbsp; <span>&nbsp; &nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp; &nbsp;&nbsp;</span>&nbsp; strncpy(m-&gt;_name, name, MONITOR_NAME_LEN - 1);<br />
&nbsp; <span>&nbsp; &nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp; &nbsp;&nbsp;</span>&nbsp; m-&gt;_name[MONITOR_NAME_LEN - 1] = '\0';<br />
<span>&nbsp; &nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp; &nbsp;&nbsp;</span>&nbsp; }<br />
<span>&nbsp; &nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp; &nbsp;&nbsp;</span>&nbsp; m-&gt;_LockWord.FullWord = 0 ;<br />
<span>&nbsp; &nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp; &nbsp;&nbsp;</span>&nbsp; m-&gt;_EntryList &nbsp; &nbsp; &nbsp; &nbsp; = NULL ;<br />
<span>&nbsp; &nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp; &nbsp;&nbsp;</span>&nbsp; m-&gt;_OnDeck &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;= NULL ;<br />
<span>&nbsp; &nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp; &nbsp;&nbsp;</span>&nbsp; m-&gt;_WaitSet &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; = NULL ;<br />
<span>&nbsp; &nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp; &nbsp;&nbsp;</span>&nbsp; m-&gt;_WaitLock[0] &nbsp; &nbsp; &nbsp; = 0 ;<br />
<span>&nbsp; &nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp; &nbsp;&nbsp;</span>}<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 可看到锁的初始值是<span>m-&gt;_LockWord.FullWord = 0 ;</span></span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 此处需要注意:Monitor中的lockWord为SplitWord</span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;union SplitWord { &nbsp; // full-word with separately addressable LSB<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; volatile intptr_t FullWord ;<br />
&nbsp; <span>&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;</span>volatile void * Address ;<br />
&nbsp; <span>&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;</span>volatile jbyte Bytes [sizeof(intptr_t)] ;<br />
<span>&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;</span>}</span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 因此，lockWord初始值为0</span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 而ILock中代码如下intptr_t v = CASPTR (&amp;_LockWord, 0, _LBIT) ;</span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 锁定后<span>_LockWord = 1,解锁后<span>_LockWord = 0;</span></span></span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 初始值为未锁定0<br />
</span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; vmthread-&gt;set_osthread(osthread);<br />
</span> 
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;pthread_t tid;</span> 
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;int ret = pthread_create(&amp;tid, &amp;attr, (void* (*)(void*)) java_start, thread);</span> 
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;osthread-&gt;set_pthread_id(tid);</span> 
</p>
<p>
	<span>&nbsp; &nbsp; &nbsp; &nbsp; 在java_start函数中<br />
</span> 
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;while (osthread-&gt;get_state() == INITIALIZED) {</span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;sync-&gt;wait(Mutex::_no_safepoint_check_flag);&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 开始等待<br />
</span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 等待函数的写法如下：<br />
</span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Thread * const Self = Thread::current() ;</span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;set_owner(NULL);</span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;wait_status = IWait (Self, timeout) ;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 开始等待--&gt;内部实现细节需要研究<br />
</span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;set_owner (Self) ;<br />
</span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; }<br />
</span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;thread-&gt;run();&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 开始调用thread-&gt;run函数</span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;os::start_thread(vmthread);&nbsp;&nbsp;&nbsp;&nbsp;</span> 
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 调用:&nbsp;&nbsp;&nbsp;&nbsp;pd_start_thread(thread);<br />
</span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;调用:&nbsp;&nbsp;&nbsp;&nbsp;Monitor* sync_with_child = osthread-&gt;startThread_lock();</span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 调用:&nbsp;&nbsp;&nbsp;&nbsp;MutexLockerEx ml(sync_with_child, Mutex::_no_safepoint_check_flag);</span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 调用:&nbsp;&nbsp;&nbsp;&nbsp;sync_with_child-&gt;notify();&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 通知<span>java_start继续</span>运行<br />
</span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 调用:&nbsp;&nbsp;&nbsp;&nbsp;thread-&gt;run()<br />
</span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 调用:&nbsp;&nbsp;&nbsp;&nbsp;this-&gt;loop();&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br />
</span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 代码:&nbsp; &nbsp; while(true)<br />
</span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 代码:&nbsp;&nbsp;&nbsp;&nbsp;_cur_vm_operation = _vm_queue-&gt;remove_next();</span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 代码:&nbsp;&nbsp;&nbsp;&nbsp;evaluate_operation(_cur_vm_operation);<br />
</span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;代码:&nbsp;&nbsp;&nbsp;&nbsp;<span>_cur_vm_operation</span>-&gt;evaluate();<br />
</span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 代码:&nbsp;&nbsp;&nbsp;&nbsp;<span>_cur_vm_operation-&gt;doit();</span></span>
</p>
<p>
	<span><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 在最终的doit()函数中，即执行的是VM_Operation</span>的操作。<br />
</span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 例如：<br />
</span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;void VM_PrintThreads::doit() {<br />
<span>&nbsp; &nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp; &nbsp;&nbsp;</span>&nbsp; Threads::print_on(_out, true, false, _print_concurrent_locks);<br />
<span>&nbsp; &nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp;&nbsp;&nbsp;&nbsp;</span><span>&nbsp; &nbsp;&nbsp;</span>}</span>
</p>
<p>
	<span>&nbsp; &nbsp; 这个就是VMThread的执行步骤，以及最终调用函数的过程。<br />
<br />
</span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br />
</span>
</p>
<p>
	<span><br />
</span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br />
</span>
</p>
<p>
	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<br />
</span> 
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
	<span><br />
</span> 
</p>
<p>
	<span><br />
</span> 
</p>