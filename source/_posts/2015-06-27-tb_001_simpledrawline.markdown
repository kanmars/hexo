---
layout: post
title:  "交易开拓者画线"
desc: "介绍交易开拓者系统的画线功能"
date: 2015-06-27 22:42:00
tags: [tb,drawline]
---
<body lang=ZH-CN style='tab-interval:21.0pt;text-justify-trim:punctuation'>

<div class=WordSection1 style='layout-grid:15.6pt'>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:11.0pt;font-family:宋体;mso-hansi-font-family:Calibri;
mso-hansi-theme-font:minor-latin;mso-bidi-font-family:宋体;color:black;
mso-font-kerning:0pt'>Params<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:11.0pt;font-family:宋体;mso-hansi-font-family:Calibri;
mso-hansi-theme-font:minor-latin;mso-bidi-font-family:宋体;color:black;
mso-font-kerning:0pt'><span style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;
</span>Numeric FastLength(5);<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:11.0pt;font-family:宋体;mso-hansi-font-family:Calibri;
mso-hansi-theme-font:minor-latin;mso-bidi-font-family:宋体;color:black;
mso-font-kerning:0pt'><span style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;
</span>Numeric SlowLength(20);<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:11.0pt;font-family:宋体;mso-hansi-font-family:Calibri;
mso-hansi-theme-font:minor-latin;mso-bidi-font-family:宋体;color:black;
mso-font-kerning:0pt'><span style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;
</span>Numeric BuyLots(1);<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:11.0pt;font-family:宋体;mso-hansi-font-family:Calibri;
mso-hansi-theme-font:minor-latin;mso-bidi-font-family:宋体;color:black;
mso-font-kerning:0pt'>Vars<span style='mso-spacerun:yes'>&nbsp;&nbsp; </span><o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:11.0pt;font-family:宋体;mso-hansi-font-family:Calibri;
mso-hansi-theme-font:minor-latin;mso-bidi-font-family:宋体;color:black;
mso-font-kerning:0pt'><span style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;
</span>NumericSeries AvgValue1;<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:11.0pt;font-family:宋体;mso-hansi-font-family:Calibri;
mso-hansi-theme-font:minor-latin;mso-bidi-font-family:宋体;color:black;
mso-font-kerning:0pt'><span style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;
</span>NumericSeries AvgValue2; <o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:11.0pt;font-family:宋体;mso-hansi-font-family:Calibri;
mso-hansi-theme-font:minor-latin;mso-bidi-font-family:宋体;color:black;
mso-font-kerning:0pt'>Begin<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:11.0pt;font-family:宋体;mso-hansi-font-family:Calibri;
mso-hansi-theme-font:minor-latin;mso-bidi-font-family:宋体;color:black;
mso-font-kerning:0pt'><span style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;
</span>AvgValue1 = AverageFC(Close,FastLength) - 100; <o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:11.0pt;font-family:宋体;mso-hansi-font-family:Calibri;
mso-hansi-theme-font:minor-latin;mso-bidi-font-family:宋体;color:black;
mso-font-kerning:0pt'><span style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;
</span>AvgValue2 = AverageFC(Close,SlowLength) - 100;<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:11.0pt;font-family:宋体;mso-hansi-font-family:Calibri;
mso-hansi-theme-font:minor-latin;mso-bidi-font-family:宋体;color:black;
mso-font-kerning:0pt'><span style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;
</span>If(MarketPosition!=1 And (AvgValue1[1] &gt; AvgValue2[2]))<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:11.0pt;font-family:宋体;mso-hansi-font-family:Calibri;
mso-hansi-theme-font:minor-latin;mso-bidi-font-family:宋体;color:black;
mso-font-kerning:0pt'><span style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;
</span>{<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:11.0pt;font-family:宋体;mso-hansi-font-family:Calibri;
mso-hansi-theme-font:minor-latin;mso-bidi-font-family:宋体;color:black;
mso-font-kerning:0pt'><span
style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span>//Buy(BuyLots,Open); <o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:11.0pt;font-family:宋体;mso-hansi-font-family:Calibri;
mso-hansi-theme-font:minor-latin;mso-bidi-font-family:宋体;color:black;
mso-font-kerning:0pt'><span style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;
</span>}<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:11.0pt;font-family:宋体;mso-hansi-font-family:Calibri;
mso-hansi-theme-font:minor-latin;mso-bidi-font-family:宋体;color:black;
mso-font-kerning:0pt'><span style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp; </span><o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:11.0pt;font-family:宋体;mso-hansi-font-family:Calibri;
mso-hansi-theme-font:minor-latin;mso-bidi-font-family:宋体;color:black;
mso-font-kerning:0pt'><span style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;
</span>If(MarketPosition!=-1 And (AvgValue1[1] &lt; AvgValue2[2]))<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:11.0pt;font-family:宋体;mso-hansi-font-family:Calibri;
mso-hansi-theme-font:minor-latin;mso-bidi-font-family:宋体;color:black;
mso-font-kerning:0pt'><span style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;
</span>{<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:11.0pt;font-family:宋体;mso-hansi-font-family:Calibri;
mso-hansi-theme-font:minor-latin;mso-bidi-font-family:宋体;color:black;
mso-font-kerning:0pt'><span
style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</span>//SellShort(BuyLots,Open);<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:11.0pt;font-family:宋体;mso-hansi-font-family:Calibri;
mso-hansi-theme-font:minor-latin;mso-bidi-font-family:宋体;color:black;
mso-font-kerning:0pt'><span style='mso-spacerun:yes'>&nbsp;&nbsp;&nbsp;
</span>}<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:11.0pt;font-family:宋体;mso-hansi-font-family:Calibri;
mso-hansi-theme-font:minor-latin;mso-bidi-font-family:宋体;color:black;
mso-font-kerning:0pt'><span style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span>PlotNumeric(&quot;MA_01&quot;,AvgValue1);<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span lang=EN-US
style='font-size:11.0pt;font-family:宋体;mso-hansi-font-family:Calibri;
mso-hansi-theme-font:minor-latin;mso-bidi-font-family:宋体;color:black;
mso-font-kerning:0pt'><span style='mso-tab-count:1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </span></span><span
style='font-size:11.0pt;font-family:宋体;mso-hansi-font-family:Calibri;
mso-hansi-theme-font:minor-latin;mso-bidi-font-family:宋体;color:black;
mso-font-kerning:0pt;mso-ansi-language:ZH-CN'>PlotNumeric(&quot;MA_02&quot;,AvgValue2);
<o:p></o:p></span></p>

<p class=MsoNormal align=left style='text-align:left;tab-stops:60.0pt 120.0pt 180.0pt 240.0pt 300.0pt 360.0pt 420.0pt 480.0pt 540.0pt 600.0pt 660.0pt 720.0pt 780.0pt 840.0pt 900.0pt 960.0pt 1020.0pt 1080.0pt 1140.0pt 1200.0pt 1260.0pt 1320.0pt 1380.0pt 1440.0pt 1500.0pt 1560.0pt;
mso-layout-grid-align:none;text-autospace:none'><span style='font-size:11.0pt;
font-family:宋体;mso-hansi-font-family:Calibri;mso-hansi-theme-font:minor-latin;
mso-bidi-font-family:宋体;color:black;mso-font-kerning:0pt;mso-ansi-language:
ZH-CN'><o:p>&nbsp;</o:p></span></p>

<p class=MsoNormal><span style='font-size:11.0pt;font-family:宋体;mso-hansi-font-family:
Calibri;mso-hansi-theme-font:minor-latin;mso-bidi-font-family:宋体;color:black;
mso-font-kerning:0pt;mso-ansi-language:ZH-CN'>End<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:11.0pt;font-family:宋体;mso-hansi-font-family:
Calibri;mso-hansi-theme-font:minor-latin;mso-bidi-font-family:宋体;color:black;
mso-font-kerning:0pt;mso-ansi-language:ZH-CN'>以上代码的作用是：用快速方法计算5日MA均线和20日MA均线，<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:11.0pt;font-family:宋体;mso-hansi-font-family:
Calibri;mso-hansi-theme-font:minor-latin;mso-bidi-font-family:宋体;color:black;
mso-font-kerning:0pt;mso-ansi-language:ZH-CN'>然后将线向下平移100元<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:11.0pt;font-family:宋体;mso-hansi-font-family:
Calibri;mso-hansi-theme-font:minor-latin;mso-bidi-font-family:宋体;color:black;
mso-font-kerning:0pt;mso-ansi-language:ZH-CN'>在图形上画出来<o:p></o:p></span></p>

<p class=MsoNormal><span style='font-size:11.0pt;font-family:宋体;mso-hansi-font-family:
Calibri;mso-hansi-theme-font:minor-latin;mso-bidi-font-family:宋体;color:black;
mso-font-kerning:0pt;mso-ansi-language:ZH-CN'><o:p>&nbsp;</o:p></span></p>

</div>

</body>
