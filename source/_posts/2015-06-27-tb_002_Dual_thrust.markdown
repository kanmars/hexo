---
layout: post
title:  "日内交易策略Dual Thrust"
desc: "介绍常用的日内交易策略DualThrust"
date: 2015-06-27 23:01:00
tags: [tb,strategy]
---
<body lang=ZH-CN style='tab-interval:21.0pt;text-justify-trim:punctuation'>

<div class=WordSection1 style='layout-grid:15.6pt'>

<p class=MsoNormal style='text-indent:21.0pt'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";color:#FF6600'>Dual
Thrust</span><span style='font-size:12.0pt;font-family:"微软雅黑","sans-serif"'>与<span
lang=EN-US style='color:#FF6600'>R-Breaker</span>一样，曾长期排名<b><span lang=EN-US
style='color:red'>&nbsp;Future Trust</span></b>杂志最赚钱的策略。该策略在形式上和开盘区间突破策略类似。不同点主要体现在两方面：<span
lang=EN-US style='color:#FF6600'>Dual Thrust</span>在<span lang=EN-US>Range(</span>代码中的浮动区间）的设置上，引入前<span
lang=EN-US>N</span>日的四个价位，使得一定时期内的<span lang=EN-US>Range</span>相对稳定，可以适用于日间的趋势跟踪；<span
lang=EN-US style='color:#FF6600'>Dual Thrust</span>对于多头和空头的触发条件，考虑了非对称的幅度，做多和做空参考的<span
lang=EN-US>Range</span>可以选择不同的周期数，也可以通过参数<span lang=EN-US>K1</span>和<span
lang=EN-US>K2</span>来确定。<span lang=EN-US><o:p></o:p></span></span></p>

<p class=MsoNormal style='text-indent:21.0pt'><span style='font-size:12.0pt;
font-family:"微软雅黑","sans-serif"'>当<span lang=EN-US>K1</span>时，多头相对容易被触发<span
lang=EN-US>,</span>当<span lang=EN-US>K1&gt;K2</span>时，空头相对容易被触发。因此，投资者在使用该策略时，一方面可以参考历史数据测试的最优参数，另一方面，则可以根据自己对后势的判断，或从其他大周期的技术指标入手，阶段性地动态调整<span
lang=EN-US>K1</span>和<span lang=EN-US>K2</span>的值。<span lang=EN-US><o:p></o:p></span></span></p>

<p class=MsoNormal><span lang=EN-US style='font-size:12.0pt;font-family:"微软雅黑","sans-serif"'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>Inputs: <span class=GramE>K1(</span>.5),K2(.5),<span
class=SpellE>Mday</span>(1),<span class=SpellE>Nday</span>(1);<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span class=SpellE><span
lang=EN-US style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>Vars</span></span><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>: <span class=SpellE><span class=GramE>BuyRange</span></span><span
class=GramE>(</span>0), <span class=SpellE>SellRange</span>(0);<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span class=SpellE><span
lang=EN-US style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>Vars</span></span><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>: <span class=SpellE><span class=GramE>BuyTrig</span></span><span
class=GramE>(</span>0),<span class=SpellE>SellTrig</span>(0);<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span class=SpellE><span
lang=EN-US style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>Vars</span></span><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>: <span class=GramE>HH(</span>0),LL(0),HC(0),LC(0);<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>If <span class=SpellE>CurrentBar</span>
&gt; 1 Then Begin<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>HH = <span class=GramE>Highest(</span><span
class=SpellE>High,Mday</span>);<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>HC = <span class=GramE>Highest(</span><span
class=SpellE>Close,Mday</span>);<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>LL = <span class=GramE>Lowest(</span><span
class=SpellE>Low,Mday</span>);<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>LC = <span class=GramE>Lowest(</span><span
class=SpellE>Close,Mday</span>);<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>If (HH - LC) &gt;= (HC - LL) Then Begin<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span class=SpellE><span
lang=EN-US style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>SellRange</span></span><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'> = HH - LC;<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>End Else Begin<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span class=SpellE><span
lang=EN-US style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>SellRange</span></span><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'> = HC - LL;<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>End;<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>HH = <span class=GramE>Highest(</span><span
class=SpellE>High,Nday</span>);<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>HC = <span class=GramE>Highest(</span><span
class=SpellE>Close,Nday</span>);<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>LL = <span class=GramE>Lowest(</span><span
class=SpellE>Low,Nday</span>);<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>LC = <span class=GramE>Lowest(</span><span
class=SpellE>Close,Nday</span>);<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>If (HH - LC) &gt;= (HC - LL) Then Begin<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span class=SpellE><span
lang=EN-US style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>BuyRange</span></span><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'> = HH - LC;<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>End Else Begin<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span class=SpellE><span
lang=EN-US style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>BuyRange</span></span><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'> = HC - LL;<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>End;<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span class=SpellE><span
lang=EN-US style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>BuyTrig</span></span><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'> = K1*<span class=SpellE>BuyRange</span>;<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span class=SpellE><span
lang=EN-US style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>SellTrig</span></span><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'> = K2*<span class=SpellE>SellRange</span>;<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>If <span class=SpellE>MarketPosition</span>
= 0 Then Begin<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>Buy at Open of next bar + <span
class=SpellE>BuyTrig</span> Stop;<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>Sell at Open of next bar - <span
class=SpellE>SellTrig</span> Stop;<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>End;<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>If <span class=SpellE>MarketPosition</span>
= -1 Then Begin<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>Buy at Open of next bar + <span
class=SpellE>Buytrig</span> Stop;<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>End;<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>If <span class=SpellE>MarketPosition</span>
= 1 Then Begin<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>Sell at Open of next bar - <span
class=SpellE>SellTrig</span> Stop;<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>End;<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>End;<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>1. </span><span style='font-size:12.0pt;
font-family:"微软雅黑","sans-serif";mso-bidi-font-family:宋体;color:black;mso-font-kerning:
0pt;mso-ansi-language:ZH-CN'>在今天的收盘</span><span style='font-size:12.0pt;
font-family:"微软雅黑","sans-serif";mso-bidi-font-family:宋体;color:black;mso-font-kerning:
0pt'>，</span><span style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";
mso-bidi-font-family:宋体;color:black;mso-font-kerning:0pt;mso-ansi-language:
ZH-CN'>计算两个值</span><span style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";
mso-bidi-font-family:宋体;color:black;mso-font-kerning:0pt'>：</span><span
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt;mso-ansi-language:ZH-CN'>最高价</span><span
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt'>－</span><span style='font-size:12.0pt;
font-family:"微软雅黑","sans-serif";mso-bidi-font-family:宋体;color:black;mso-font-kerning:
0pt;mso-ansi-language:ZH-CN'>收盘价</span><span style='font-size:12.0pt;
font-family:"微软雅黑","sans-serif";mso-bidi-font-family:宋体;color:black;mso-font-kerning:
0pt'>，</span><span style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";
mso-bidi-font-family:宋体;color:black;mso-font-kerning:0pt;mso-ansi-language:
ZH-CN'>和收盘价</span><span style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";
mso-bidi-font-family:宋体;color:black;mso-font-kerning:0pt'>－</span><span
style='font-size:12.0pt;font-family:"微软雅黑","sans-serif";mso-bidi-font-family:
宋体;color:black;mso-font-kerning:0pt;mso-ansi-language:ZH-CN'>最低价。然后取这两个值较大的那个，乘以k值0.7。把结果称为触发值。<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span style='font-size:12.0pt;
font-family:"微软雅黑","sans-serif";mso-bidi-font-family:宋体;color:black;mso-font-kerning:
0pt;mso-ansi-language:ZH-CN'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span style='font-size:12.0pt;
font-family:"微软雅黑","sans-serif";mso-bidi-font-family:宋体;color:black;mso-font-kerning:
0pt;mso-ansi-language:ZH-CN'>2. 在明天的开盘，记录开盘价，然后在价格超过（开盘＋触发值）时马上买入，或者价格低于（开盘－触发值）时马上卖空。<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span style='font-size:12.0pt;
font-family:"微软雅黑","sans-serif";mso-bidi-font-family:宋体;color:black;mso-font-kerning:
0pt;mso-ansi-language:ZH-CN'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span style='font-size:12.0pt;
font-family:"微软雅黑","sans-serif";mso-bidi-font-family:宋体;color:black;mso-font-kerning:
0pt;mso-ansi-language:ZH-CN'>3. 没有<span class=GramE>明确止</span>损。这个系统是反转系统，也就是说，如果在价格超过（开盘＋触发值）时手头有一口空单，则买入两口。同理，如果在价格低于（开盘－触发值）时手上有一口多单，则卖出两口。<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span style='font-size:12.0pt;
font-family:"微软雅黑","sans-serif";mso-bidi-font-family:宋体;color:black;mso-font-kerning:
0pt;mso-ansi-language:ZH-CN'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span style='font-size:12.0pt;
font-family:"微软雅黑","sans-serif";mso-bidi-font-family:宋体;color:black;mso-font-kerning:
0pt;mso-ansi-language:ZH-CN'>Dual Thrust在开盘区间突破策略上进行了相关改进：<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span style='font-size:12.0pt;
font-family:"微软雅黑","sans-serif";mso-bidi-font-family:宋体;color:black;mso-font-kerning:
0pt;mso-ansi-language:ZH-CN'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span style='font-size:12.0pt;
font-family:"微软雅黑","sans-serif";mso-bidi-font-family:宋体;color:black;mso-font-kerning:
0pt;mso-ansi-language:ZH-CN'><span style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;
</span>1、在范围（range）的设置上，引入前N日的四个价位，使得一定时期内的范围相对稳定，可以适用于日间的趋势跟踪；<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span style='font-size:12.0pt;
font-family:"微软雅黑","sans-serif";mso-bidi-font-family:宋体;color:black;mso-font-kerning:
0pt;mso-ansi-language:ZH-CN'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span style='font-size:12.0pt;
font-family:"微软雅黑","sans-serif";mso-bidi-font-family:宋体;color:black;mso-font-kerning:
0pt;mso-ansi-language:ZH-CN'><span style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;
</span>2、Dual Thrust对于多头和空头的触发条件，考虑了非对称的幅度，做多和做空参考的Range可以选择不同的周期数，也可以通过参数K1和K2来确定。当K1时，多头相对容易被触发,当K1&gt;K2时，空头相对容易被触发。<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span style='font-size:12.0pt;
font-family:"微软雅黑","sans-serif";mso-bidi-font-family:宋体;color:black;mso-font-kerning:
0pt;mso-ansi-language:ZH-CN'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span style='font-size:12.0pt;
font-family:"微软雅黑","sans-serif";mso-bidi-font-family:宋体;color:black;mso-font-kerning:
0pt;mso-ansi-language:ZH-CN'><span style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;
</span>因此，在使用该策略时，一方面可以参考历史数据测试的最优参数，另一方面，则可以根据自己对后势的判断，或从其他大周期的技术指标入手，阶段性地动态调整K1和K2的值。<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span style='font-size:12.0pt;
font-family:"微软雅黑","sans-serif";mso-bidi-font-family:宋体;color:black;mso-font-kerning:
0pt;mso-ansi-language:ZH-CN'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span style='font-size:12.0pt;
font-family:"微软雅黑","sans-serif";mso-bidi-font-family:宋体;color:black;mso-font-kerning:
0pt;mso-ansi-language:ZH-CN'>就是一个典型的观望、等待信号、进场、套利、离场的套路，却效果卓著。<o:p></o:p></span></p>

<p class=MsoNormal><span lang=EN-US style='font-size:12.0pt;font-family:"微软雅黑","sans-serif"'><o:p>&nbsp;</o:p></span></p>

</div>

</body>
