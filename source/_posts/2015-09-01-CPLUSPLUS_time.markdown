---
layout: post
title:  "[KANMARS原创] - C++学习_时间操作_002"
desc: "初学C++，轻拍......"
date: 2015-09-01 05:01:22
tags: [server,c,c++]
---
<p>
	C++时间使用
</p>
<p>
	<br />
</p>
<p>
	<span style="background-color:#000000;color:#E53333;">一、时间和日期的概念</span>
</p>
<p>
	<span style="color:#3e3e3e;"><span style="color:#3e3e3e;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span><span style="background-color:#000000;color:#E53333;">Coordinated Universal 
Time（UTC）</span>：协调世界时，又称为世界标准时间，也就是大家所熟知的格林威治标准时间（Greenwich Mean 
Time，GMT）。比如，中国内地的时间与UTC的时差为+8，也就是UTC+8。美国是UTC-5。 <br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style="background-color:#000000;color:#E53333;">Calendar 
Time</span>：日历时间，是用“从一个标准时间点到此时的时间经过的秒数”来表示的时间。这个标准时间点对不同的编译器来说会有所不同，但对一个编译系统来
说，这个标准时间点是不变的，该编译系统中的时间对应的日历时间都通过该标准时间点来衡量，所以可以说日历时间是“相对时间”，但是无论你在哪一个时区，
在同一时刻对同一个标准时间点来说，日历时间都是一样的。 <br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style="background-color:#000000;color:#E53333;">epoch</span>：时间点。时间点在标准C/C++中是一个整数，它用此时的时间和标准时间点相差的秒数（即日历时间）来表示。 <br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style="background-color:#000000;color:#E53333;">clock tick</span>：时钟计时单元（而不把它叫做时钟滴答次数），一个时钟计时单元的时间长短是由CPU控制的。一个clock tick不是CPU的一个时钟周期，而是C/C++的一个基本计时单位。 <br />
<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 我们可以使用ANSI标准库中的time.h头文件。这个头文件中定义的时间和日期所使用的方法，无论是在结构定义，还是命名，都具有明显的C语言风格。下面，我将说明在C/C++中怎样使用日期的时间功能。 <br />
</span>
</p>
<p>
	<br />
<span style="color:#3e3e3e;"></span>
</p>
<p>
	<span style="color:#3e3e3e;"><span style="background-color:#000000;color:#E53333;">二、</span><span style="color:#E53333;background-color:#000000;"><span style="color:#E53333;background-color:#000000;">计时函数</span></span></span>
</p>
<p>
	<span style="color:#3e3e3e;"><span style="color:#3e3e3e;">C/C++中的计时函数是clock()，而与其相关的数据类型是clock_t。在MSDN中，查得对clock函数定义如下： <br />
<br />
clock_t clock( void ); <br />
</span></span>
</p>
<p>
	<span style="color:#3e3e3e;"><span style="color:#3e3e3e;"><span style="color:#3e3e3e;">这个函数返回从“开启这个程序进程”到“程序中调用clock()函数”时之间的CPU时钟计时单元（clock tick）数，</span></span></span>
</p>
<p>
	<span style="color:#3e3e3e;"><span style="color:#3e3e3e;"><span style="color:#3e3e3e;"><br />
</span></span></span>
</p>
<p>
	<span style="color:#3e3e3e;"><span style="color:#3e3e3e;"><span style="color:#3e3e3e;">可以用clock函数来计算你的机器运行一个循环或者处理其它事件到底花了多少时间</span></span></span>
</p>
<p>
	<br />
<span style="color:#3e3e3e;"><span style="color:#3e3e3e;"><span style="color:#3e3e3e;"></span></span></span>
</p>
<p>
	<span style="color:#E53333;background-color:#000000;"><span style="color:#E53333;background-color:#000000;"><span style="color:#E53333;background-color:#000000;">三、与日期和时间有关的函数</span></span></span>
</p>
<p>
	<br />
<span style="color:#3e3e3e;"><span style="color:#3e3e3e;"><span style="color:#3e3e3e;"></span></span></span>
</p>
<p>
	<span style="color:#3e3e3e;"><span style="color:#3e3e3e;"><span style="color:#3e3e3e;"><span style="color:#3e3e3e;">在标准C/C++中，我们可通过tm结构来获得日期和时间，tm结构在time.h中的定义如下： <br />
<br />
#ifndef _TM_DEFINED <br />
struct tm { <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int tm_sec;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* 秒 – 取值区间为[0,59] */ <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int tm_min;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* 分 - 取值区间为[0,59] */ <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int tm_hour;&nbsp;&nbsp;&nbsp;&nbsp; /* 时 - 取值区间为[0,23] */ <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int tm_mday;&nbsp;&nbsp;&nbsp;&nbsp; /* 一个月中的日期 - 取值区间为[1,31] */ <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int tm_mon;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* 月份（从一月开始，0代表一月） - 取值区间为[0,11] */ <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int tm_year;&nbsp;&nbsp;&nbsp;&nbsp; /* 年份，其值等于实际年份减去1900 */ <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
 int tm_wday;&nbsp;&nbsp;&nbsp;&nbsp; /* 星期 – 取值区间为[0,6]，其中0代表星期天，1代表星期一，以此推 */int 
tm_yday;&nbsp;&nbsp;&nbsp;&nbsp; /* 从每年的1月1日开始的天数 – 取值区间为[0,365]，其中0代表1月1日，1代表1月2日，以此类推 */ <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int tm_isdst;&nbsp;&nbsp;&nbsp; /* 夏令时标识符，实行夏令时的时候，tm_isdst为正。不实行夏令时的进候，tm_isdst为0；不了解情况时，tm_isdst()为负。*/ <br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }; <br />
</span></span></span></span>
</p>
<p>
	<span style="color:#3e3e3e;"><span style="color:#3e3e3e;"><span style="color:#3e3e3e;"><span style="color:#3e3e3e;"><span style="color:#3e3e3e;">#define _TM_DEFINED <br />
#endif <br />
</span></span></span></span></span>
</p>
<p>
	<br />
<span style="color:#3e3e3e;"><span style="color:#3e3e3e;"><span style="color:#3e3e3e;"><span style="color:#3e3e3e;"><span style="color:#3e3e3e;"></span></span></span></span></span>
</p>
<p>
	<span style="color:#3e3e3e;"><span style="color:#3e3e3e;"><span style="color:#3e3e3e;"><span style="color:#3e3e3e;"><span style="color:#3e3e3e;"><span style="color:#3e3e3e;">ANSI C标准称使用<span style="background-color:#000000;color:#E53333;">tm结构的这种时间表示为分解时间</span>(broken-down time)。&nbsp;</span></span></span></span></span></span>
</p>
<p>
	<br />
</p>
<p>
	<br />
</p>
<p>
	<span style="color:#3e3e3e;">而<span style="background-color:#000000;color:#E53333;">日历时间（Calendar Time）是通过time_t数据类型来表示的</span>，用time_t表示的时间（日历时间）是从一个时间点（例如：1970年1月1日0时0分0秒）到此时的秒数。在time.h中，我们也可以看到time_t是一个长整型数： <br />
<br />
#ifndef _TIME_T_DEFINED <br />
typedef long time_t;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* 时间值 */ <br />
#define _TIME_T_DEFINED&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* 避免重复定义 time_t */ <br />
#endif </span><br />
<span style="color:#3e3e3e;"><span style="color:#3e3e3e;"><span style="color:#3e3e3e;"><span style="color:#3e3e3e;"><span style="color:#3e3e3e;"></span></span></span></span></span>
</p>
<p>
	<br />
<span style="color:#3e3e3e;"><span style="color:#3e3e3e;"><span style="color:#3e3e3e;"><span style="color:#3e3e3e;"><span style="color:#3e3e3e;"></span></span></span></span></span>
</p>
<p>
	<span style="color:#3e3e3e;">在time.h头文件中，我们还可以看到一些函数，它们都是以time_t为参数类型或返回值类型的函数： <br />
<br />
double difftime(time_t time1, time_t time0); &nbsp;&nbsp;&nbsp; //计算时间的差，精度为秒<br />
time_t mktime(struct tm * timeptr); &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //将分解时间struct_tm转化为日历时间time_t<br />
time_t time(time_t * timer); &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //获取日历时间<br />
char * asctime(const struct tm * timeptr); &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //从分解时间获取UTC<span style="color:#3e3e3e;">时间</span><br />
char * ctime(const time_t *timer); &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //从日历时间获取UTC事件<br />
</span>
</p>
<p>
	<span style="color:#3e3e3e;"><br />
</span>
</p>
<p>
	<span style="color:#3e3e3e;">此外，time.h还提供了两种不同的函数<span style="background-color:#000000;color:#E53333;">将日历时间（一个用time_t表示的整数）转换为我们平时看到的把年月日时分秒分开显示的时间格式tm：</span> <br />
<br />
struct tm * gmtime(const time_t *timer); &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span style="color:#363636;">//与之相反是<span style="color:#3e3e3e;">time_t mktime(struct tm * timeptr); </span></span></span> 
</p>
<p>
	<span style="color:#3e3e3e;">&nbsp;</span>
</p>
<p>
	<span style="color:#363636;">struct tm * localtime(const time_t * timer); &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //与之相反是<span style="color:#3e3e3e;">time_t mktime(struct tm * timeptr); </span></span>
</p>
<p>
	<br />
</p>
<p>
	<span style="color:#363636;">其中gmtime()函数是将日历时间转化为世界标准时间（即格林尼治时间），并返回一个
tm结构体来保存这个时间，</span>
</p>
<p>
	<span style="color:#363636;">而localtime()函数是将日历时间转化为本地时间。比如现在用gmtime()函数获得的世界标准时间是2005年7月30日7点18分20秒，那么我用localtime()函数在中国地区获得的本地时间会比世界标准时间晚8个小时，即2005年7月30日15点18
分20秒。</span>
</p>
<p>
	<span style="color:#363636;"></span>#include &lt;iostream&gt;<br />
#include &lt;time.h&gt;<br />
<br />
using namespace std;<br />
int main (){<br />
&nbsp;&nbsp;&nbsp; time_t t = time(NULL);<br />
&nbsp;&nbsp;&nbsp; struct tm * local = localtime(&amp;t);<br />
<br />
&nbsp;&nbsp;&nbsp; cout &lt;&lt; (local-&gt;tm_year + 1900) &lt;&lt; "年"&lt;&lt;endl;<br />
&nbsp;&nbsp;&nbsp; cout &lt;&lt; (local-&gt;tm_mon + 1) &lt;&lt; "月"&lt;&lt;endl;<br />
&nbsp;&nbsp;&nbsp; cout &lt;&lt; (local-&gt;tm_mday) &lt;&lt; "日"&lt;&lt;endl;<br />
&nbsp;&nbsp;&nbsp; cout &lt;&lt; (local-&gt;tm_hour) &lt;&lt; "时"&lt;&lt;endl;<br />
&nbsp;&nbsp;&nbsp; cout &lt;&lt; (local-&gt;tm_min) &lt;&lt; "分"&lt;&lt;endl;<br />
&nbsp;&nbsp;&nbsp; cout &lt;&lt; (local-&gt;tm_sec) &lt;&lt; "秒"&lt;&lt;endl;<br />
&nbsp;&nbsp;&nbsp; cout &lt;&lt; "星期" &lt;&lt; (local-&gt;tm_wday) &lt;&lt; ""&lt;&lt;endl;<br />
&nbsp;&nbsp; &nbsp;<br />
&nbsp;&nbsp; &nbsp;<br />
}&nbsp;&nbsp; <br />
<br />
<span style="color:#3e3e3e;"></span>
</p>
<p>
	<span style="color:#E53333;background-color:#000000;">四、时间格式转换</span>
</p>
<p>
	<span style="color:#3e3e3e;">4.1&nbsp;&nbsp;&nbsp; 固定格式</span>
</p>
<p>
	<span style="color:#3e3e3e;"><span style="color:#363636;">char * asctime(const struct tm * timeptr); <br />
char * ctime(const time_t *timer); <br />
</span></span>
</p>
<p>
	转化结果为：
</p>
<p>
	Tue Sep&nbsp; 1 06:39:08 2015<br />
<br />
Tue Sep&nbsp; 1 06:39:08 2015
</p>
<p>
	<br />
</p>
<p>
	4.2&nbsp;&nbsp;&nbsp; 自定义时间格式
</p>
<p>
	<br />
</p>
<p>
	<span style="color:#363636;">我们可以使用strftime（）函数将时间格式化为我们想要的格式。它的原型如下： <br />
<br />
size_t strftime( <br />
&nbsp;&nbsp;&nbsp; char *strDest, <br />
&nbsp;&nbsp;&nbsp; size_t maxsize，</span> 
</p>
<p>
	<span style="color:#363636;">const char *format, <br />
&nbsp;&nbsp;&nbsp; const struct tm *timeptr&nbsp;&nbsp;<br />
); <br />
</span>
</p>
<p>
	<span style="color:#363636;">示例如下</span>
</p>
<p>
	<br />
<span style="color:#363636;"></span>
</p>
<p>
	<span style="color:#363636;"><span style="color:#363636;">char str[80]; <br />
&nbsp;&nbsp;&nbsp;&nbsp; lt=time(NUL); <br />
&nbsp;&nbsp;&nbsp;&nbsp; ptr=localtime(&amp;lt); </span><br />
</span>
</p>
<p>
	<span style="color:#363636;"><span style="color:#363636;">strftime(str,100,"It is now %I %p",ptr);&nbsp;</span></span>
</p>
<p>
	<br />
<span style="color:#363636;"></span>
</p>
<p>
	<span style="color:#363636;"><br />
</span>
</p>
<span style="color:#363636;">%a 星期几的简写&nbsp;&nbsp;<br />
%A 星期几的全称&nbsp;&nbsp;<br />
%b 月分的简写&nbsp;&nbsp;<br />
%B 月份的全称&nbsp;&nbsp;<br />
%c 标准的日期的时间串&nbsp;&nbsp;<br />
%C 年份的后两位数字&nbsp;&nbsp;<br />
%d 十进制表示的每月的第几天&nbsp;&nbsp;<br />
%D 月/天/年&nbsp;&nbsp;<br />
%e 在两字符域中，十进制表示的每月的第几天&nbsp;&nbsp;<br />
%F 年-月-日&nbsp;&nbsp;<br />
%g 年份的后两位数字，使用基于周的年&nbsp;&nbsp;<br />
%G 年分，使用基于周的年&nbsp;&nbsp;<br />
%h 简写的月份名&nbsp;&nbsp;<br />
%H 24小时制的小时&nbsp;&nbsp;<br />
%I 12小时制的小时 <br />
%j 十进制表示的每年的第几天&nbsp;&nbsp;<br />
%m 十进制表示的月份&nbsp;&nbsp;<br />
%M 十时制表示的分钟数&nbsp;&nbsp;<br />
%n 新行符&nbsp;&nbsp;<br />
%p 本地的AM或PM的等价显示&nbsp;&nbsp;<br />
%r 12小时的时间&nbsp;&nbsp;<br />
%R 显示小时和分钟：hh:mm&nbsp;&nbsp;<br />
%S 十进制的秒数&nbsp;&nbsp;<br />
%t 水平制表符&nbsp;&nbsp;<br />
%T 显示时分秒：hh:mm:ss&nbsp;&nbsp;<br />
%u 每周的第几天，星期一为第一天 （值从0到6，星期一为0） <br />
%U 第年的第几周，把星期日做为第一天（值从0到53） <br />
%V 每年的第几周，使用基于周的年&nbsp;&nbsp;<br />
%w 十进制表示的星期几（值从0到6，星期天为0） <br />
%W 每年的第几周，把星期一做为第一天（值从0到53）&nbsp;&nbsp;<br />
%x 标准的日期串&nbsp;&nbsp;<br />
%X 标准的时间串&nbsp;&nbsp;<br />
%y 不带世纪的十进制年份（值从0到99） <br />
%Y 带世纪部分的十进制年份&nbsp;&nbsp;<br />
%z，%Z 时区名称，如果不能得到时区名称则返回空字符。 <br />
%% 百分号 </span><br />
<span style="color:#3e3e3e;"><span style="color:#363636;"></span></span>
<p>
	<br />
</p>
<p>
	<br />
<span style="color:#3e3e3e;"><span style="color:#363636;"></span></span>
</p>
<p>
	<span style="color:#3e3e3e;">4.3、自定义时间格式的转化</span>
</p>
<p>
	&nbsp;&nbsp;&nbsp; 分解时间----&gt;为字符串<br />
<span style="color:#3e3e3e;"></span>
</p>
<p>
	<span style="color:#3e3e3e;"><span style="color:#363636;">size_t strftime( <br />
&nbsp;&nbsp;&nbsp; char *strDest, <br />
&nbsp;&nbsp;&nbsp; size_t maxsize，</span> </span>
</p>
<p>
	<span style="color:#363636;">const char *format, <br />
&nbsp;&nbsp;&nbsp; const struct tm *timeptr&nbsp;&nbsp;<br />
); <br />
</span>
</p>
<p>
	<span style="color:#363636;">&nbsp;&nbsp;&nbsp; 字符串----&gt;分解时间</span>
</p>
<p>
	<span style="color:#363636;"><span style="color:#363636;">size_t strptime( <br />
&nbsp;&nbsp;&nbsp; char *strSource,</span> </span>
</p>
<p>
	<span style="color:#363636;">const char *format, <br />
&nbsp;&nbsp;&nbsp; const struct tm *timeptr&nbsp;&nbsp;<br />
); <br />
</span>
</p>
<p>
	<br />
<span style="color:#363636;"></span>
</p>
<p>
	<span style="color:#363636;">即</span>
</p>
<p>
	<span style="color:#363636;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; gmtime(&amp;time_t),localtime(<span style="color:#3e3e3e;"><span style="color:#363636;"><span style="color:#363636;">&amp;time_t</span></span></span>)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; strftime(buff,maxsize,format,&amp;tm)<br />
</span>
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; -----------------------------------------------&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ---------------------------------------------------&gt;<br />
<span style="color:#363636;"></span>
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; time()==&gt; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; time_t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct tm&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; string<br />
<span style="color:#363636;"></span>
</p>
<p>
	<span style="color:#363636;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &lt;----------------------------------------------&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &lt;--------------------------------------------------</span>
</p>
<p>
	<span style="color:#363636;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mktime(&amp;struct tm)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; strptime(<span style="color:#3e3e3e;"><span style="color:#363636;"><span style="color:#363636;">buff</span></span></span>,format,&amp;tm)<br />
</span>
</p>
<br />
<p>
	<br />
</p>
至此，时间处理结束<br />
<p>
	<br />
</p>