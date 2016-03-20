---
layout: post
title:  "我的策略测试:_MA_MDH30_30Reverse"
desc: "这是我自己写的一个MA均线策略，其思路是共振原理，当超长均线，长期均线，中期均线，短期均线都呈现多头排列时，容易出现多头行情......"
date: 2015-06-28 23:17:00
tags: [tb,strategy]
---
<p>
	自己写的一个程序化交易策略，其思路是共振原理，当超长均线，长期均线，中期均线，短期均线都呈现多头排列时，容易出现多头行情......
</p>
<p>
	但从实际测量结果看，效果很差
</p>
<p>
	//------------------------------------------------------------------------<br />
// 简称: _MA_MDH30_30Reverse<br />
// 名称: MA月日时30分同向30分反转<br />
// 类别: 公式应用<br />
// 类型: 用户应用<br />
// 输出:<br />
//------------------------------------------------------------------------<br />
Params<br />
&nbsp;&nbsp;&nbsp; Numeric length1(3);<br />
&nbsp;&nbsp;&nbsp; Numeric length2(6);<br />
&nbsp;&nbsp; &nbsp;Numeric length3(20);<br />
&nbsp;&nbsp; &nbsp;Numeric length4(50);<br />
&nbsp;&nbsp; &nbsp;Numeric length5(100);<br />
&nbsp;&nbsp;&nbsp; Numeric BuyLots(1);<br />
Vars&nbsp; &nbsp;<br />
&nbsp;&nbsp;&nbsp; NumericSeries AvgValue1;<br />
&nbsp;&nbsp;&nbsp; NumericSeries AvgValue2;<br />
&nbsp;&nbsp; &nbsp;NumericSeries AvgValue3;<br />
&nbsp;&nbsp; &nbsp;NumericSeries AvgValue4;<br />
&nbsp;&nbsp; &nbsp;NumericSeries AvgValue5;<br />
&nbsp;&nbsp; &nbsp;Numeric fangxiang;//0空，1多<br />
Begin<br />
&nbsp;&nbsp;&nbsp; AvgValue1 = AverageFC(Close,length1)-100; <br />
&nbsp;&nbsp;&nbsp; AvgValue2 = AverageFC(Close,length2)-100;<br />
&nbsp;&nbsp; &nbsp;AvgValue3 = AverageFC(Close,length3)-100;<br />
&nbsp;&nbsp; &nbsp;AvgValue4 = AverageFC(Close,length4)-100;<br />
&nbsp;&nbsp; &nbsp;AvgValue5 = AverageFC(Close,length5)-100;<br />
&nbsp;&nbsp; &nbsp;//判断大方向多空<br />
&nbsp;&nbsp; &nbsp;If(AvgValue5 &lt; AvgValue4){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;fangxiang = 1;<br />
&nbsp;&nbsp; &nbsp;}Else{<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;fangxiang = 0;<br />
&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;<br />
&nbsp;&nbsp; &nbsp;//大方向为空的持仓策略<br />
&nbsp;&nbsp; &nbsp;If(fangxiang == 0){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;If(&nbsp;&nbsp; &nbsp;//当前持有的非空仓（持平或者多仓），且线型呈现空头排列，出现最低级反转<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;MarketPosition!=-1<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;And <br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;(AvgValue5 &gt; AvgValue4)<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;And <br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;(AvgValue4 &gt; AvgValue3)<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;And <br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;(AvgValue3 &gt; AvgValue2)<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;And <br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;(AvgValue2 &gt; AvgValue1)<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;And<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;(AvgValue2[1] &lt; AvgValue1[1])<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;)<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;{<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;SellShort(BuyLots,Close);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;If(&nbsp;&nbsp; &nbsp;//当前持有空仓，线型初步呈现空头排列，出现线型破坏<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;MarketPosition==-1<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;And <br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;(AvgValue5 &gt; AvgValue4)<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;And <br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;(AvgValue4 &gt; AvgValue3)<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;And <br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;(AvgValue3 &gt; AvgValue2)<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;And <br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;(AvgValue2 &lt; AvgValue1)<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;)<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;{<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;BuyToCover(BuyLots,Close);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;//大方向为多的持仓策略<br />
&nbsp;&nbsp; &nbsp;If(fangxiang == 1){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;If(//当前持有的非多仓（持平或者空仓），且线型呈现多头排列，出现最低级反转<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;MarketPosition!=1<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;And <br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;(AvgValue5 &lt; AvgValue4)<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;And <br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;(AvgValue4 &lt; AvgValue3)<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;And <br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;(AvgValue3 &lt; AvgValue2)<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;And <br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;(AvgValue2 &lt; AvgValue1)<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;And<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;(AvgValue2[1] &gt; AvgValue1[1])<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;)<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;{<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;Buy(BuyLots,Close);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;If(&nbsp;&nbsp; &nbsp;//当前持有多仓，线型初步呈现多头排列，出现线型破坏<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;MarketPosition==1<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;And <br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;(AvgValue5 &lt; AvgValue4)<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;And <br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;(AvgValue4 &lt; AvgValue3)<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;And <br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;(AvgValue3 &lt; AvgValue2)<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;And <br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;(AvgValue2 &gt; AvgValue1)<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;)<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;{<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;Sell(BuyLots,Close);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;<br />
&nbsp;&nbsp; &nbsp;PlotNumeric("MA_01",AvgValue1);<br />
&nbsp;&nbsp; &nbsp;PlotNumeric("MA_02",AvgValue2);<br />
&nbsp;&nbsp; &nbsp;PlotNumeric("MA_03",AvgValue3);<br />
&nbsp;&nbsp; &nbsp;PlotNumeric("MA_04",AvgValue4);<br />
&nbsp;&nbsp; &nbsp;PlotNumeric("MA_05",AvgValue5);<br />
End<br />
<br />
<br />
//------------------------------------------------------------------------<br />
// 编译版本&nbsp;&nbsp; &nbsp;GS2010.12.08<br />
// 用户版本&nbsp;&nbsp; &nbsp;2015/06/28 22:59<br />
// 版权所有&nbsp;&nbsp; &nbsp;zlqh29000620<br />
// 更改声明&nbsp;&nbsp; &nbsp;TradeBlazer Software保留对TradeBlazer平台<br />
//&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;每一版本的TrabeBlazer公式修改和重写的权利<br />
//------------------------------------------------------------------------<br />
<br />
</p>