---
layout: post
title:  "[KANMARS原创] - Linux下的CPU信息"
desc: "本文介绍Linux下的CPU信息查看，主要介绍/proc/cpuinfo文件"
date: 2014-11-22 13:50:00
tags: [it,server,cpu]
---
<body lang=ZH-CN link=blue vlink=purple style='tab-interval:21.0pt;text-justify-trim:
punctuation'>

<div class=WordSection1 style='layout-grid:15.6pt'>

<p style='text-indent:21.25pt;mso-char-indent-count:1.77'><span
style='font-family:"微软雅黑","sans-serif"'>在<span lang=EN-US><a
href="http://en.wikipedia.org/wiki/Linux" target="_blank"><span
style='color:windowtext;text-decoration:none;text-underline:none'>Linux</span></a></span>系统中，提供了<span
lang=EN-US><a href="http://en.wikipedia.org/wiki/Procfs" target="_blank"><span
style='color:windowtext;text-decoration:none;text-underline:none'>proc</span><span
lang=EN-US style='color:windowtext;text-decoration:none;text-underline:none'><span
lang=EN-US>文件系统</span></span></a></span>显示系统的软硬件信息。如果想了解系统中<span lang=EN-US>CPU</span>的提供商和相关配置信息，则可以通过<span
lang=EN-US>/proc/cpuinfo</span>文件得到。本文章针对该文件进行简单的总结。<span lang=EN-US><o:p></o:p></span></span></p>

<p style='text-indent:21.25pt;mso-char-indent-count:1.77'><span
style='font-family:"微软雅黑","sans-serif"'>基于不同指令集（<span lang=EN-US>ISA</span>）的<span
lang=EN-US>CPU</span>产生的<span lang=EN-US>/proc/cpuinfo</span>文件不一样，基于<span
lang=EN-US>X86</span>指令集<span lang=EN-US>CPU</span>的<span lang=EN-US>/proc/cpuinfo</span>文件包含如下内容：<span
lang=EN-US><o:p></o:p></span></span></p>

<p><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>processor</span><span
style='font-family:"微软雅黑","sans-serif"'>　　：<span lang=EN-US> 0<br>
vendor_id</span>　　：<span lang=EN-US>GenuineIntel<br>
cpu family</span>　　：<span lang=EN-US>6<br>
model</span>　　　　：<span lang=EN-US>26<br>
model name</span>　：<span lang=EN-US>Intel(R) Xeon(R)
CPU&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; E5520&nbsp; @
2.27GHz<br>
stepping</span>　　<span lang=EN-US>&nbsp; </span>：<span lang=EN-US>5<br>
cpu MHz</span>　　<span lang=EN-US> &nbsp;</span>：<span lang=EN-US>1600.000<br>
cache size</span>　　：<span lang=EN-US> 8192 KB<br>
physical id</span>　　：<span lang=EN-US>0<br>
siblings</span>　　　 ：<span lang=EN-US>8<br>
core id</span>　　　<span lang=EN-US>&nbsp; </span>：<span lang=EN-US> 0<br>
cpu cores</span>　　 ：<span lang=EN-US>4<br>
apicid</span>　　<span lang=EN-US>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>：<span
lang=EN-US>0<br>
fpu</span>　　　　　<span lang=EN-US>&nbsp; </span>：<span lang=EN-US>yes<br>
fpu_exception </span>：<span lang=EN-US>yes<br>
cpuid level</span>　　 ：<span lang=EN-US> 11<br>
wp</span>　　　　　　：<span lang=EN-US>yes<br>
flags </span>　　　　　：<span lang=EN-US> fpu vme de pse tsc msr pae mce cx8 apic
sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm
syscall nx rdtscp lm constant_tsc ida nonstop_tsc pni monitor ds_cpl vmx est
tm2 cx16 xtpr popcnt lahf_lm<br>
bogomips</span>　　 ：<span lang=EN-US>4522.12<br>
clflush size</span>　　：<span lang=EN-US>64<br>
cache_alignment</span>　　：<span lang=EN-US> 64<br>
address sizes</span>　　　 ：<span lang=EN-US> 40 bits physical, 48 bits virtual<br>
power management </span>：<span lang=EN-US><o:p></o:p></span></span></p>

<p style='text-indent:21.25pt;mso-char-indent-count:1.77'><span
style='font-family:"微软雅黑","sans-serif"'>以上输出项的含义如下：<span lang=EN-US><o:p></o:p></span></span></p>

<p><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>processor</span><span
style='font-family:"微软雅黑","sans-serif"'>　：系统中逻辑处理核的编号。对于单核处理器，则课认为是其<span
lang=EN-US>CPU</span>编号，对于多核处理器则可以是物理核、或者使用超线程技术虚拟的逻辑核<span lang=EN-US><br>
vendor_id</span>　：<span lang=EN-US>CPU</span>制造商<span lang=EN-US>
&nbsp;&nbsp;&nbsp;&nbsp; <br>
cpu family</span>　：<span lang=EN-US>CPU</span>产品系列代号<span lang=EN-US><br>
model</span>　　　：<span lang=EN-US>CPU</span>属于其系列中的哪一代的代号<span lang=EN-US><br>
model name</span>：<span lang=EN-US>CPU</span>属于的名字及其编号、标称主频<span lang=EN-US><br>
stepping</span>　<span lang=EN-US>&nbsp; </span>：<span lang=EN-US>CPU</span>属于制作更新版本<span
lang=EN-US><br>
cpu MHz</span>　<span lang=EN-US>&nbsp; </span>：<span lang=EN-US>CPU</span>的实际使用主频<span
lang=EN-US><br>
cache size&nbsp;&nbsp; </span>：<span lang=EN-US>CPU</span>二级缓存大小<span
lang=EN-US><br>
physical id&nbsp;&nbsp; </span>：单个<span lang=EN-US>CPU</span>的标号<span
lang=EN-US><br>
siblings&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>：单个<span lang=EN-US>CPU</span>逻辑物理核数<span
lang=EN-US><br>
core id&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>：当前物理核在其所处<span
lang=EN-US>CPU</span>中的编号，这个编号不一定连续<span lang=EN-US><br>
cpu cores&nbsp;&nbsp;&nbsp; </span>：该逻辑核所处<span lang=EN-US>CPU</span>的物理核数<span
lang=EN-US><br>
apicid&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>：用来区分不同逻辑核的编号，系统中每个逻辑核的此编号必然不同，此编号不一定连续<span
lang=EN-US><br>
fpu&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>：是否具有浮点运算单元（<span
lang=EN-US>Floating Point Unit</span>）<span lang=EN-US><br>
fpu_exception&nbsp; </span>：是否支持浮点计算异常<span lang=EN-US><br>
cpuid level&nbsp;&nbsp; </span>：执行<span lang=EN-US>cpuid</span>指令前，<span
lang=EN-US>eax</span>寄存器中的值，根据不同的值<span lang=EN-US><a
href="http://en.wikipedia.org/wiki/CPUID" target="_blank">cpuid</a></span>指令会返回不同的内容<span
lang=EN-US><br>
wp&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>：表明当前<span
lang=EN-US>CPU</span>是否在内核态支持对用户空间的写保护（<span lang=EN-US>Write Protection</span>）<span
lang=EN-US><br>
flags&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>：当前<span
lang=EN-US>CPU</span>支持的功能<span lang=EN-US><br>
</span></span><span lang=EN-US><a href="http://en.wikipedia.org/wiki/Bogomips"
target="_blank"><span style='font-family:"微软雅黑","sans-serif";color:windowtext;
text-decoration:none;text-underline:none'>bogomips</span></a></span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;&nbsp; </span><span
style='font-family:"微软雅黑","sans-serif"'>：在系统内核启动时粗略测算的<span lang=EN-US>CPU</span>速度（<span
lang=EN-US>Million Instructions Per Second</span>）<span lang=EN-US><br>
clflush size&nbsp; </span>：每次刷新缓存的大小单位<span lang=EN-US><br>
cache_alignment </span>：缓存地址对齐单位<span lang=EN-US><br>
address sizes&nbsp; &nbsp;&nbsp; </span>：可访问地址空间位数<span lang=EN-US><br>
power management </span>：对能源管理的支持，有以下几个可选支持功能：<span lang=EN-US><o:p></o:p></span></span></p>

<p><span style='font-family:"微软雅黑","sans-serif"'>　　<span lang=EN-US>ts</span>：　　<span
lang=EN-US>temperature sensor<o:p></o:p></span></span></p>

<p><span style='font-family:"微软雅黑","sans-serif"'>　　<span lang=EN-US>fid</span>：　<span
lang=EN-US>&nbsp; frequency id control<o:p></o:p></span></span></p>

<p><span style='font-family:"微软雅黑","sans-serif"'>　　<span lang=EN-US>vid</span>：　<span
lang=EN-US> voltage id control<o:p></o:p></span></span></p>

<p><span style='font-family:"微软雅黑","sans-serif"'>　　<span lang=EN-US>ttp</span>：　<span
lang=EN-US> thermal trip<o:p></o:p></span></span></p>

<p><span style='font-family:"微软雅黑","sans-serif"'>　　<span lang=EN-US>tm</span>：<span
lang=EN-US><o:p></o:p></span></span></p>

<p><span style='font-family:"微软雅黑","sans-serif"'>　　<span lang=EN-US>stc</span>：<span
lang=EN-US><o:p></o:p></span></span></p>

<p><span style='font-family:"微软雅黑","sans-serif"'>　　<span lang=EN-US>100mhzsteps</span>：<span
lang=EN-US><o:p></o:p></span></span></p>

<p><span style='font-family:"微软雅黑","sans-serif"'>　　<span lang=EN-US>hwpstate</span>：<span
lang=EN-US><o:p></o:p></span></span></p>

<p><span style='font-family:"微软雅黑","sans-serif"'>　　<span lang=EN-US><o:p></o:p></span></span></p>

<p style='text-indent:21.25pt;mso-char-indent-count:1.77'><span lang=EN-US
style='font-family:"微软雅黑","sans-serif"'>CPU</span><span style='font-family:
"微软雅黑","sans-serif"'>信息中<span lang=EN-US>flags</span>各项含义：<span lang=EN-US><o:p></o:p></span></span></p>

<p><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>fpu</span><span
style='font-family:"微软雅黑","sans-serif"'>：<span lang=EN-US> Onboard (x87)
Floating Point Unit<br>
vme</span>：<span lang=EN-US> Virtual Mode Extension<br>
de</span>：<span lang=EN-US> Debugging Extensions<br>
pse</span>：<span lang=EN-US> Page Size Extensions<br>
tsc</span>：<span lang=EN-US> Time Stamp Counter: support for RDTSC and WRTSC
instructions<br>
msr</span>：<span lang=EN-US> Model-Specific Registers<br>
pae</span>：<span lang=EN-US> Physical Address Extensions: ability to access
64GB of memory; only 4GB can be accessed at a time though<br>
mce</span>：<span lang=EN-US> Machine Check Architecture<br>
cx8</span>：<span lang=EN-US> CMPXCHG8 instruction<br>
apic</span>：<span lang=EN-US> Onboard Advanced Programmable Interrupt
Controller<br>
sep</span>：<span lang=EN-US> Sysenter/Sysexit Instructions; SYSENTER is used
for jumps to kernel memory during system calls, and SYSEXIT is used for jumps</span>：<span
lang=EN-US> back to the user code<br>
mtrr</span>：<span lang=EN-US> Memory Type Range Registers<br>
pge</span>：<span lang=EN-US> Page Global Enable<br>
mca</span>：<span lang=EN-US> Machine Check Architecture<br>
cmov</span>：<span lang=EN-US> CMOV instruction<br>
pat</span>：<span lang=EN-US> Page Attribute Table<br>
pse36</span>：<span lang=EN-US> 36-bit Page Size Extensions: allows to map 4 MB
pages into the first 64GB RAM, used with PSE.<br>
pn</span>：<span lang=EN-US> Processor Serial-Number; only available on Pentium
3<br>
clflush</span>：<span lang=EN-US> CLFLUSH instruction<br>
dtes</span>：<span lang=EN-US> Debug Trace Store<br>
acpi</span>：<span lang=EN-US> ACPI via MSR<br>
mmx</span>：<span lang=EN-US> MultiMedia Extension<br>
fxsr</span>：<span lang=EN-US> FXSAVE and FXSTOR instructions<br>
sse</span>：<span lang=EN-US> Streaming SIMD Extensions. Single instruction
multiple data. Lets you do a bunch of the same operation on different pieces of
input</span>：<span lang=EN-US> in a single clock tick.<br>
sse2</span>：<span lang=EN-US> Streaming SIMD Extensions-2. More of the same.<br>
selfsnoop</span>：<span lang=EN-US> CPU self snoop<br>
acc</span>：<span lang=EN-US> Automatic Clock Control<br>
IA64</span>：<span lang=EN-US> IA-64 processor Itanium.<br>
ht</span>：<span lang=EN-US> HyperThreading. Introduces an imaginary second
processor that doesn’t do much but lets you run threads in the same process
a&nbsp; bit quicker.<br>
nx</span>：<span lang=EN-US> No Execute bit. Prevents arbitrary code running via
buffer overflows.<br>
pni</span>：<span lang=EN-US> Prescott New Instructions aka. SSE3<br>
vmx</span>：<span lang=EN-US> Intel Vanderpool hardware virtualization
technology<br>
svm</span>：<span lang=EN-US> AMD “Pacifica” hardware virtualization technology<br>
lm</span>：<span lang=EN-US> “Long Mode,” which means the chip supports the
AMD64 instruction set<br>
tm</span>：<span lang=EN-US> “Thermal Monitor” Thermal throttling with IDLE
instructions. Usually hardware controlled in response to CPU temperature.<br>
tm2</span>：<span lang=EN-US> “Thermal Monitor 2″ Decrease speed by reducing
multipler and vcore.<br>
est</span>：<span lang=EN-US> “Enhanced SpeedStep”<o:p></o:p></span></span></p>

<p style='text-indent:21.25pt;mso-char-indent-count:1.77'><span
style='font-family:"微软雅黑","sans-serif"'>根据以上内容，我们则可以很方便的知道当前系统关于<span
lang=EN-US>CPU</span>、<span lang=EN-US>CPU</span>的核数、<span lang=EN-US>CPU</span>是否启用超线程等信息。<span
lang=EN-US><o:p></o:p></span></span></p>

<p><span style='font-family:"微软雅黑","sans-serif";color:red;background:black;
mso-highlight:black'>查询系统具有多少个逻辑核：<span lang=EN-US>cat /proc/cpuinfo | grep
&quot;processor&quot; | wc -l</span></span><span lang=EN-US style='font-family:
"微软雅黑","sans-serif";color:red'><o:p></o:p></span></p>

<p><span style='font-family:"微软雅黑","sans-serif";color:red;background:black;
mso-highlight:black'>查询系统<span lang=EN-US>CPU</span>的物理核数：<span lang=EN-US>cat
/proc/cpuinfo | grep &quot;cpu cores&quot; | uniq<o:p></o:p></span></span></p>

<p><span style='font-family:"微软雅黑","sans-serif";color:red;background:black;
mso-highlight:black'>查询系统<span lang=EN-US>CPU</span>是否启用超线程：<span lang=EN-US>cat
/proc/cpuinfo | grep -e &quot;cpu cores&quot;&nbsp; -e &quot;siblings&quot; |
sort | uniq<o:p></o:p></span></span></p>

<p><span style='font-family:"微软雅黑","sans-serif"'>　　输出举例：<span lang=EN-US><o:p></o:p></span></span></p>

<p><span style='font-family:"微软雅黑","sans-serif"'>　　　　<span lang=EN-US>cpu
cores&nbsp;&nbsp; &nbsp;: 6<br>
</span>　　　　<span lang=EN-US>siblings&nbsp;&nbsp; &nbsp;</span>　<span
lang=EN-US>: 6<o:p></o:p></span></span></p>

<p><span style='font-family:"微软雅黑","sans-serif"'>　　如果<span lang=EN-US>cpu cores</span>数量和<span
lang=EN-US>siblings</span>数量一致，则没有启用超线程，否则超线程被启用。<span lang=EN-US><o:p></o:p></span></span></p>

<p><span style='font-family:"微软雅黑","sans-serif"'>查询系统<span lang=EN-US>CPU</span>的个数：<span
lang=EN-US>cat /proc/cpuinfo | grep &quot;physical id&quot; | sort | uniq | wc
-l<o:p></o:p></span></span></p>

<p><span style='font-family:"微软雅黑","sans-serif"'>查询系统<span lang=EN-US>CPU</span>是否支持某项功能，则根以上类似，输出结果进行<span
lang=EN-US>sort</span>，<span lang=EN-US> uniq</span>和<span lang=EN-US>grep</span>就可以得到结果。<span
lang=EN-US><o:p></o:p></span></span></p>

<p><span style='font-family:"微软雅黑","sans-serif"'>【<span lang=EN-US>/proc/cpuinfo</span>内容举例】<span
lang=EN-US><o:p></o:p></span></span></p>

<p><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>1</span><span
style='font-family:"微软雅黑","sans-serif"'>，<span lang=EN-US>Intel(R) Xeon(R)
X5355<o:p></o:p></span></span></p>

<pre><span lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>processor</span><span
style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>　　<span lang=EN-US>: 0</span></span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>vendor_id</span><span
style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>　　<span lang=EN-US>: GenuineIntel</span></span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu famil</span><span
style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>　　<span lang=EN-US>: 6</span></span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>model</span><span
style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>　　　　<span lang=EN-US> : 15</span></span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>model name</span><span
style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>　<span lang=EN-US> : Intel(R) Xeon(R) CPU&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; X5355&nbsp; @ 2.66GHz</span></span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>stepping</span><span
style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>　　<span lang=EN-US> : 7</span></span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu MHz</span><span
style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>　　　<span lang=EN-US>: 2666.766</span></span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cache size</span><span
style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>　<span lang=EN-US>: 4096 KB</span></span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>physical id</span><span
style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>　<span lang=EN-US>: 0</span></span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>siblings</span><span
style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>　　<span lang=EN-US> : 4</span></span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>core id</span><span
style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>　　<span lang=EN-US><span style='mso-spacerun:yes'>&nbsp; </span>: 0</span></span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu cores</span><span
style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>　　<span lang=EN-US>: 4</span></span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>fpu</span><span
style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>　　　　　<span lang=EN-US> : yes</span></span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>fpu_exception</span><span
style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>　　<span lang=EN-US>: yes</span></span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpuid level</span><span
style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>　　　<span lang=EN-US>: 10</span></span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>wp</span><span
style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>　　　　　　<span
lang=EN-US>: yes</span></span><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>flags</span><span
style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>　　　　<span lang=EN-US>: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall lm constant_tsc pni monitor ds_cpl vmx est tm2 cx16 xtpr dca lahf_lm</span></span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>bogomips&nbsp;&nbsp;&nbsp; : 5338.26</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>clflush size&nbsp;&nbsp;&nbsp; : 64</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cache_alignment : 64</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>address sizes&nbsp;&nbsp; : 36 bits physical, 48 bits virtual</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>power management:</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p>&nbsp;</o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>processor&nbsp;&nbsp;&nbsp; : 1</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>vendor_id&nbsp;&nbsp;&nbsp; : GenuineIntel</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu family&nbsp;&nbsp;&nbsp; : 6</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>model&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : 15</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>model name&nbsp;&nbsp;&nbsp; : Intel(R) Xeon(R) CPU&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; X5355&nbsp; @ 2.66GHz</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>stepping&nbsp;&nbsp;&nbsp; : 7</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu MHz&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : 2666.766</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cache size&nbsp;&nbsp;&nbsp; : 4096 KB</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>physical id&nbsp;&nbsp;&nbsp; : 1</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>siblings&nbsp;&nbsp;&nbsp; : 4</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>core id&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : 0</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu cores&nbsp;&nbsp;&nbsp; : 4</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>fpu&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : yes</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>fpu_exception&nbsp;&nbsp;&nbsp; : yes</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpuid level&nbsp;&nbsp;&nbsp; : 10</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>wp&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : yes</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>flags&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall lm constant_tsc pni monitor ds_cpl vmx est tm2 cx16 xtpr dca lahf_lm</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>bogomips&nbsp;&nbsp;&nbsp; : 5333.75</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>clflush size&nbsp;&nbsp;&nbsp; : 64</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cache_alignment&nbsp;&nbsp;&nbsp; : 64</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>address sizes&nbsp;&nbsp;&nbsp; : 36 bits physical, 48 bits virtual</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>power management:</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p>&nbsp;</o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>processor&nbsp;&nbsp;&nbsp; : 2</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>vendor_id&nbsp;&nbsp;&nbsp; : GenuineIntel</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu family&nbsp;&nbsp;&nbsp; : 6</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>model&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : 15</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>model name&nbsp;&nbsp;&nbsp; : Intel(R) Xeon(R) CPU&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; X5355&nbsp; @ 2.66GHz</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>stepping&nbsp;&nbsp;&nbsp; : 7</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu MHz&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : 2666.766</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cache size&nbsp;&nbsp;&nbsp; : 4096 KB</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>physical id&nbsp;&nbsp;&nbsp; : 0</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>siblings&nbsp;&nbsp;&nbsp; : 4</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>core id&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : 2</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu cores&nbsp;&nbsp;&nbsp; : 4</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>fpu&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : yes</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>fpu_exception&nbsp;&nbsp;&nbsp; : yes</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpuid level&nbsp;&nbsp;&nbsp; : 10</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>wp&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : yes</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>flags&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall lm constant_tsc pni monitor ds_cpl vmx est tm2 cx16 xtpr dca lahf_lm</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>bogomips&nbsp;&nbsp;&nbsp; : 5333.67</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>clflush size&nbsp;&nbsp;&nbsp; : 64</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cache_alignment&nbsp;&nbsp;&nbsp; : 64</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>address sizes&nbsp;&nbsp;&nbsp; : 36 bits physical, 48 bits virtual</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>power management:</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p>&nbsp;</o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>processor&nbsp;&nbsp;&nbsp; : 3</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>vendor_id&nbsp;&nbsp;&nbsp; : GenuineIntel</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu family&nbsp;&nbsp;&nbsp; : 6</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>model&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : 15</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>model name&nbsp;&nbsp;&nbsp; : Intel(R) Xeon(R) CPU&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; X5355&nbsp; @ 2.66GHz</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>stepping&nbsp;&nbsp;&nbsp; : 7</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu MHz&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : 2666.766</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cache size&nbsp;&nbsp;&nbsp; : 4096 KB</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>physical id&nbsp;&nbsp;&nbsp; : 1</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>siblings&nbsp;&nbsp;&nbsp; : 4</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>core id&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : 2</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu cores&nbsp;&nbsp;&nbsp; : 4</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>fpu&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : yes</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>fpu_exception&nbsp;&nbsp;&nbsp; : yes</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpuid level&nbsp;&nbsp;&nbsp; : 10</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>wp&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : yes</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>flags&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall lm constant_tsc pni monitor ds_cpl vmx est tm2 cx16 xtpr dca lahf_lm</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>bogomips&nbsp;&nbsp;&nbsp; : 5333.68</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>clflush size&nbsp;&nbsp;&nbsp; : 64</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cache_alignment&nbsp;&nbsp;&nbsp; : 64</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>address sizes&nbsp;&nbsp;&nbsp; : 36 bits physical, 48 bits virtual</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>power management:</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p>&nbsp;</o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>processor&nbsp;&nbsp;&nbsp; : 4</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>vendor_id&nbsp;&nbsp;&nbsp; : GenuineIntel</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu family&nbsp;&nbsp;&nbsp; : 6</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>model&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : 15</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>model name&nbsp;&nbsp;&nbsp; : Intel(R) Xeon(R) CPU&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; X5355&nbsp; @ 2.66GHz</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>stepping&nbsp;&nbsp;&nbsp; : 7</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu MHz&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : 2666.766</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cache size&nbsp;&nbsp;&nbsp; : 4096 KB</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>physical id&nbsp;&nbsp;&nbsp; : 0</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>siblings&nbsp;&nbsp;&nbsp; : 4</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>core id&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : 1</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu cores&nbsp;&nbsp;&nbsp; : 4</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>fpu&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : yes</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>fpu_exception&nbsp;&nbsp;&nbsp; : yes</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpuid level&nbsp;&nbsp;&nbsp; : 10</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>wp&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : yes</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>flags&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall lm constant_tsc pni monitor ds_cpl vmx est tm2 cx16 xtpr dca lahf_lm</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>bogomips&nbsp;&nbsp;&nbsp; : 5333.67</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>clflush size&nbsp;&nbsp;&nbsp; : 64</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cache_alignment&nbsp;&nbsp;&nbsp; : 64</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>address sizes&nbsp;&nbsp;&nbsp; : 36 bits physical, 48 bits virtual</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>power management:</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p>&nbsp;</o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>processor&nbsp;&nbsp;&nbsp; : 5</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>vendor_id&nbsp;&nbsp;&nbsp; : GenuineIntel</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu family&nbsp;&nbsp;&nbsp; : 6</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>model&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : 15</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>model name&nbsp;&nbsp;&nbsp; : Intel(R) Xeon(R) CPU&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; X5355&nbsp; @ 2.66GHz</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>stepping&nbsp;&nbsp;&nbsp; : 7</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu MHz&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : 2666.766</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cache size&nbsp;&nbsp;&nbsp; : 4096 KB</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>physical id&nbsp;&nbsp;&nbsp; : 1</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>siblings&nbsp;&nbsp;&nbsp; : 4</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>core id&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : 1</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu cores&nbsp;&nbsp;&nbsp; : 4</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>fpu&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : yes</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>fpu_exception&nbsp;&nbsp;&nbsp; : yes</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpuid level&nbsp;&nbsp;&nbsp; : 10</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>wp&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : yes</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>flags&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall lm constant_tsc pni monitor ds_cpl vmx est tm2 cx16 xtpr dca lahf_lm</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>bogomips&nbsp;&nbsp;&nbsp; : 5333.68</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>clflush size&nbsp;&nbsp;&nbsp; : 64</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cache_alignment&nbsp;&nbsp;&nbsp; : 64</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>address sizes&nbsp;&nbsp;&nbsp; : 36 bits physical, 48 bits virtual</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>power management:</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p>&nbsp;</o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>processor&nbsp;&nbsp;&nbsp; : 6</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>vendor_id&nbsp;&nbsp;&nbsp; : GenuineIntel</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu family&nbsp;&nbsp;&nbsp; : 6</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>model&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : 15</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>model name&nbsp;&nbsp;&nbsp; : Intel(R) Xeon(R) CPU&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; X5355&nbsp; @ 2.66GHz</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>stepping&nbsp;&nbsp;&nbsp; : 7</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu MHz&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : 2666.766</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cache size&nbsp;&nbsp;&nbsp; : 4096 KB</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>physical id&nbsp;&nbsp;&nbsp; : 0</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>siblings&nbsp;&nbsp;&nbsp; : 4</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>core id&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : 3</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu cores&nbsp;&nbsp;&nbsp; : 4</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>fpu&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : yes</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>fpu_exception&nbsp;&nbsp;&nbsp; : yes</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpuid level&nbsp;&nbsp;&nbsp; : 10</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>wp&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : yes</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>flags&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall lm constant_tsc pni monitor ds_cpl vmx est tm2 cx16 xtpr dca lahf_lm</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>bogomips&nbsp;&nbsp;&nbsp; : 5333.69</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>clflush size&nbsp;&nbsp;&nbsp; : 64</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cache_alignment&nbsp;&nbsp;&nbsp; : 64</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>address sizes&nbsp;&nbsp;&nbsp; : 36 bits physical, 48 bits virtual</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>power management:</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p>&nbsp;</o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>processor&nbsp;&nbsp;&nbsp; : 7</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>vendor_id&nbsp;&nbsp;&nbsp; : GenuineIntel</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu family&nbsp;&nbsp;&nbsp; : 6</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>model&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : 15</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>model name&nbsp;&nbsp;&nbsp; : Intel(R) Xeon(R) CPU&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; X5355&nbsp; @ 2.66GHz</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>stepping&nbsp;&nbsp;&nbsp; : 7</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu MHz&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : 2666.766</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cache size&nbsp;&nbsp;&nbsp; : 4096 KB</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>physical id&nbsp;&nbsp;&nbsp; : 1</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>siblings&nbsp;&nbsp;&nbsp; : 4</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>core id&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : 3</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu cores&nbsp;&nbsp;&nbsp; : 4</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>fpu&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : yes</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>fpu_exception&nbsp;&nbsp;&nbsp; : yes</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpuid level&nbsp;&nbsp;&nbsp; : 10</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>wp&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : yes</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>flags&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm syscall lm constant_tsc pni monitor ds_cpl vmx est tm2 cx16 xtpr dca lahf_lm</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>bogomips&nbsp;&nbsp;&nbsp; : 5333.68</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>clflush size&nbsp;&nbsp;&nbsp; : 64</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cache_alignment&nbsp;&nbsp;&nbsp; : 64</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>address sizes&nbsp;&nbsp;&nbsp; : 36 bits physical, 48 bits virtual</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>power management:</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre>

<p><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>2</span><span
style='font-family:"微软雅黑","sans-serif"'>，<span lang=EN-US> Intel(R) Core(TM) i7
930 @ 2.80GHz<o:p></o:p></span></span></p>

<pre><span lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>processor<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 0<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>vendor_id<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: GenuineIntel<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu family<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 6<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>model<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 26<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>model name<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: Intel(R) Core(TM) i7 CPU<span style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>930<span style='mso-spacerun:yes'>&nbsp; </span>@ 2.80GHz<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>stepping<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 5<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu MHz<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 2807.024<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cache size<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 8192 KB<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>fpu<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: yes<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>fpu_exception<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: yes<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpuid level<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 11<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>wp<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: yes<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>flags<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: fpu de tsc msr pae mce cx8 apic sep mtrr mca cmov pat clflush acpi mmx fxsr sse sse2 ss ht syscall nx lm constant_tsc rep_good nonstop_tsc aperfmperf pni est ssse3 cx16 sse4_1 sse4_2 popcnt hypervisor lahf_lm ida<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>bogomips<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 5614.04<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>clflush size<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 64<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cache_alignment<span
style='mso-tab-count:1'>&nbsp; </span>: 64<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>address sizes<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 36 bits physical, 48 bits virtual<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>power management:<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'><o:p>&nbsp;</o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>processor<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 1<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>vendor_id<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: GenuineIntel<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu family<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 6<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>model<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 26<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>model name<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: Intel(R) Core(TM) i7 CPU<span style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>930<span style='mso-spacerun:yes'>&nbsp; </span>@ 2.80GHz<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>stepping<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 5<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu MHz<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 2807.024<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cache size<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 8192 KB<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>fpu<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: yes<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>fpu_exception<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: yes<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpuid level<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 11<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>wp<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: yes<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>flags<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: fpu de tsc msr pae mce cx8 apic sep mtrr mca cmov pat clflush acpi mmx fxsr sse sse2 ss ht syscall nx lm constant_tsc rep_good nonstop_tsc aperfmperf pni est ssse3 cx16 sse4_1 sse4_2 popcnt hypervisor lahf_lm ida<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>bogomips<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 5614.04<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>clflush size<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 64<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cache_alignment<span
style='mso-tab-count:1'>&nbsp; </span>: 64<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>address sizes<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 36 bits physical, 48 bits virtual<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>power management:<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'><o:p>&nbsp;</o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>processor<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 2<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>vendor_id<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: GenuineIntel<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu family<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 6<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>model<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 26<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>model name<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: Intel(R) Core(TM) i7 CPU<span style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>930<span style='mso-spacerun:yes'>&nbsp; </span>@ 2.80GHz<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>stepping<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 5<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu MHz<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 2807.024<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cache size<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 8192 KB<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>fpu<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: yes<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>fpu_exception<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: yes<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpuid level<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 11<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>wp<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: yes<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>flags<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: fpu de tsc msr pae mce cx8 apic sep mtrr mca cmov pat clflush acpi mmx fxsr sse sse2 ss ht syscall nx lm constant_tsc rep_good nonstop_tsc aperfmperf pni est ssse3 cx16 sse4_1 sse4_2 popcnt hypervisor lahf_lm ida<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>bogomips<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 5614.04<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>clflush size<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 64<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cache_alignment<span
style='mso-tab-count:1'>&nbsp; </span>: 64<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>address sizes<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 36 bits physical, 48 bits virtual<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>power management:<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'><o:p>&nbsp;</o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>processor<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 3<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>vendor_id<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: GenuineIntel<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu family<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 6<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>model<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 26<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>model name<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: Intel(R) Core(TM) i7 CPU<span style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>930<span style='mso-spacerun:yes'>&nbsp; </span>@ 2.80GHz<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>stepping<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 5<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu MHz<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 2807.024<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cache size<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 8192 KB<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>fpu<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: yes<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>fpu_exception<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: yes<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpuid level<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 11<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>wp<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: yes<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>flags<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: fpu de tsc msr pae mce cx8 apic sep mtrr mca cmov pat clflush acpi mmx fxsr sse sse2 ss ht syscall nx lm constant_tsc rep_good nonstop_tsc aperfmperf pni est ssse3 cx16 sse4_1 sse4_2 popcnt hypervisor lahf_lm ida<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>bogomips<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 5614.04<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>clflush size<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 64<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cache_alignment<span
style='mso-tab-count:1'>&nbsp; </span>: 64<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>address sizes<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 36 bits physical, 48 bits virtual<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>power management:<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'><o:p>&nbsp;</o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>processor<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 4<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>vendor_id<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: GenuineIntel<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu family<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 6<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>model<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 26<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>model name<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: Intel(R) Core(TM) i7 CPU<span style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>930<span style='mso-spacerun:yes'>&nbsp; </span>@ 2.80GHz<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>stepping<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 5<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu MHz<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 2807.024<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cache size<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 8192 KB<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>fpu<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: yes<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>fpu_exception<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: yes<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpuid level<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 11<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>wp<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: yes<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>flags<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: fpu de tsc msr pae mce cx8 apic sep mtrr mca cmov pat clflush acpi mmx fxsr sse sse2 ss ht syscall nx lm constant_tsc rep_good nonstop_tsc aperfmperf pni est ssse3 cx16 sse4_1 sse4_2 popcnt hypervisor lahf_lm ida<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>bogomips<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 5614.04<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>clflush size<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 64<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cache_alignment<span
style='mso-tab-count:1'>&nbsp; </span>: 64<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>address sizes<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 36 bits physical, 48 bits virtual<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>power management:<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'><o:p>&nbsp;</o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>processor<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 5<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>vendor_id<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: GenuineIntel<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu family<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 6<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>model<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 26<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>model name<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: Intel(R) Core(TM) i7 CPU<span style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>930<span style='mso-spacerun:yes'>&nbsp; </span>@ 2.80GHz<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>stepping<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 5<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu MHz<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 2807.024<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cache size<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 8192 KB<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>fpu<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: yes<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>fpu_exception<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: yes<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpuid level<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 11<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>wp<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: yes<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>flags<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: fpu de tsc msr pae mce cx8 apic sep mtrr mca cmov pat clflush acpi mmx fxsr sse sse2 ss ht syscall nx lm constant_tsc rep_good nonstop_tsc aperfmperf pni est ssse3 cx16 sse4_1 sse4_2 popcnt hypervisor lahf_lm ida<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>bogomips<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 5614.04<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>clflush size<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 64<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cache_alignment<span
style='mso-tab-count:1'>&nbsp; </span>: 64<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>address sizes<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 36 bits physical, 48 bits virtual<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>power management:<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'><o:p>&nbsp;</o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>processor<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 6<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>vendor_id<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: GenuineIntel<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu family<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 6<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>model<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 26<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>model name<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: Intel(R) Core(TM) i7 CPU<span style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>930<span style='mso-spacerun:yes'>&nbsp; </span>@ 2.80GHz<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>stepping<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 5<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu MHz<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 2807.024<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cache size<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 8192 KB<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>fpu<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: yes<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>fpu_exception<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: yes<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpuid level<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 11<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>wp<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: yes<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>flags<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: fpu de tsc msr pae mce cx8 apic sep mtrr mca cmov pat clflush acpi mmx fxsr sse sse2 ss ht syscall nx lm constant_tsc rep_good nonstop_tsc aperfmperf pni est ssse3 cx16 sse4_1 sse4_2 popcnt hypervisor lahf_lm ida<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>bogomips<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 5614.04<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>clflush size<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 64<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cache_alignment<span
style='mso-tab-count:1'>&nbsp; </span>: 64<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>address sizes<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 36 bits physical, 48 bits virtual<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>power management:<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'><o:p>&nbsp;</o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>processor<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 7<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>vendor_id<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: GenuineIntel<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu family<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 6<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>model<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 26<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>model name<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: Intel(R) Core(TM) i7 CPU<span style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>930<span style='mso-spacerun:yes'>&nbsp; </span>@ 2.80GHz<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>stepping<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 5<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpu MHz<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 2807.024<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cache size<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 8192 KB<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>fpu<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: yes<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>fpu_exception<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: yes<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cpuid level<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 11<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>wp<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: yes<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>flags<span
style='mso-tab-count:2'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: fpu de tsc msr pae mce cx8 apic sep mtrr mca cmov pat clflush acpi mmx fxsr sse sse2 ss ht syscall nx lm constant_tsc rep_good nonstop_tsc aperfmperf pni est ssse3 cx16 sse4_1 sse4_2 popcnt hypervisor lahf_lm ida<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>bogomips<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 5614.04<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>clflush size<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 64<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>cache_alignment<span
style='mso-tab-count:1'>&nbsp; </span>: 64<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>address sizes<span
style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>: 36 bits physical, 48 bits virtual<o:p></o:p></span></pre><pre><span
lang=EN-US style='font-size:10.5pt;font-family:"微软雅黑","sans-serif"'>power management:</span><span
lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p></o:p></span></pre>

<p class=MsoNormal><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'><o:p>&nbsp;</o:p></span></p>

</div>

</body>
