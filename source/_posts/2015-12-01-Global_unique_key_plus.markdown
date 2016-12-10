---
layout: post
title:  "[KANMARS原创] - 分布式系统一致性hash中的key-全局唯一ID生成器-加强版"
desc: "本文描述了一种全局唯一ID生成器的实现，全局唯一ID生成器经常用于分布式系统架构，是项目构建中的基础性设施"
date: 2015-12-01 11:51:00
tags: [server,java,linux,spring]
---
<p>
	上次写了个IDCreateUtils，有点累赘，这次更新了一下，这个是通用版，直接给一个数字设置第start到第end位的值
</p>
<p>
	<br />
</p>
<p>
	package cn.kanmars;
</p>
<br />
/**<br />
&nbsp;* Created by baolong on 2015/12/1.<br />
&nbsp;*/<br />
public class IDCreaterPlusUtils {<br />
&nbsp;&nbsp;&nbsp; /**<br />
&nbsp;&nbsp;&nbsp;&nbsp; * 掩码制造，从0开始，包含start，包含end，start&gt;=0，end&lt;=63<br />
&nbsp;&nbsp;&nbsp;&nbsp; * @param start 0&lt;=start&lt;=63<br />
&nbsp;&nbsp;&nbsp;&nbsp; * @param end&nbsp;&nbsp; 0&lt;=end&lt;=63<br />
&nbsp;&nbsp;&nbsp;&nbsp; * @return<br />
&nbsp;&nbsp;&nbsp;&nbsp; */<br />
&nbsp;&nbsp;&nbsp; public static long createMask(int start,int end) throws Exception{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if(start &lt;0 || start &gt;63 ) throw new Exception("IDCreaterPlusUtils createMask must: 0&lt;=start&lt;=63 ");<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if(end&nbsp;&nbsp; &lt;0 || end&nbsp;&nbsp; &gt;63 ) throw new Exception("IDCreaterPlusUtils createMask must: 0&lt;=end&lt;=63 ");<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if(end &lt; start) throw new Exception("IDCreaterPlusUtils createMask must: end &gt;= start");<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; long result = 0xffffffffffffffffl;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; result = result &lt;&lt; (64-(end+1-start));<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; result = result &gt;&gt;&gt; start;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return result;<br />
&nbsp;&nbsp;&nbsp; }<br />
<br />
&nbsp;&nbsp;&nbsp; /**<br />
&nbsp;&nbsp;&nbsp;&nbsp; * 给old代表的64位数字中的第start到第end位，设置一个数字为val，如果val超出start和end的长度区间，则舍弃掉超出的内容<br />
&nbsp;&nbsp;&nbsp;&nbsp; * @param old&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 原始数据<br />
&nbsp;&nbsp;&nbsp;&nbsp; * @param val&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 要设置进去的数据<br />
&nbsp;&nbsp;&nbsp;&nbsp; * @param start&nbsp;&nbsp;&nbsp;&nbsp; 开始位置，0&lt;=start&lt;=end&lt;=63，闭区间<br />
&nbsp;&nbsp;&nbsp;&nbsp; * @param end&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 结束位置，0&lt;=start&lt;=end&lt;=63, 闭区间<br />
&nbsp;&nbsp;&nbsp;&nbsp; * @return<br />
&nbsp;&nbsp;&nbsp;&nbsp; * @throws Exception<br />
&nbsp;&nbsp;&nbsp;&nbsp; */<br />
&nbsp;&nbsp;&nbsp; public static long setValue(long old,long val,int start,int end) throws Exception{<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if(start &lt;0 || start &gt;63 ) throw new Exception("IDCreaterPlusUtils createMask must: 0&lt;=start&lt;=63 ");<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if(end&nbsp;&nbsp; &lt;0 || end&nbsp;&nbsp; &gt;63 ) throw new Exception("IDCreaterPlusUtils createMask must: 0&lt;=end&lt;=63 ");<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if(end &lt; start) throw new Exception("IDCreaterPlusUtils createMask must: end &gt;= start");<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; long result = old;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; long mask = createMask(start,end);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; result = result &amp; (0xffffffffffffffffl ^ mask);//result与掩码的反码进行与操作，将指定位置为0<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; long value = val;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; value = value &lt;&lt; (64-(end+1-start));&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //左移到指定位置<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; value = value &gt;&gt;&gt;&nbsp; start;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; value = value &amp; mask;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //与掩码进行计算<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; result = result | value;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //将原值与新值进行组合<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return result;<br />
&nbsp;&nbsp;&nbsp; }<br />
<br />
<br />
&nbsp;&nbsp;&nbsp; /**<br />
&nbsp;&nbsp;&nbsp;&nbsp; * 打印一个long的二进制码，不分割<br />
&nbsp;&nbsp;&nbsp;&nbsp; * @param l<br />
&nbsp;&nbsp;&nbsp;&nbsp; * @return<br />
&nbsp;&nbsp;&nbsp;&nbsp; */<br />
&nbsp;&nbsp;&nbsp; public static String pl64(long l){<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return pl64(l,false);<br />
&nbsp;&nbsp;&nbsp; }<br />
&nbsp;&nbsp;&nbsp; /**<br />
&nbsp;&nbsp;&nbsp;&nbsp; * 打印一个long的二进制码<br />
&nbsp;&nbsp;&nbsp;&nbsp; * @param l&nbsp;&nbsp; &nbsp;要打印的数值<br />
&nbsp;&nbsp;&nbsp;&nbsp; * @param split&nbsp;&nbsp; &nbsp;是否每4位分割<br />
&nbsp;&nbsp;&nbsp;&nbsp; * @return<br />
&nbsp;&nbsp;&nbsp;&nbsp; */<br />
&nbsp;&nbsp;&nbsp; public static String pl64(long l,boolean split){<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; StringBuilder sb = new StringBuilder();<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; for(int i=0;i&lt;64;i++){<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sb.append(pl(l, i));<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if((i+1)%4 ==0 &amp;&amp; split){<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sb.append(" ");<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sb.append("\r\n");<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return sb.toString();<br />
&nbsp;&nbsp;&nbsp; }<br />
&nbsp;&nbsp;&nbsp; /**<br />
&nbsp;&nbsp;&nbsp;&nbsp; * 打印l 的从0开始第index位的数据<br />
&nbsp;&nbsp;&nbsp;&nbsp; * @param l<br />
&nbsp;&nbsp;&nbsp;&nbsp; * @param index<br />
&nbsp;&nbsp;&nbsp;&nbsp; */<br />
&nbsp;&nbsp;&nbsp; public static String pl(long l,int index){<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return (0x0000000000000001L &amp; (l&gt;&gt; (63-index)))+"";<br />
&nbsp;&nbsp;&nbsp; }<br />
<br />
&nbsp;&nbsp;&nbsp; public static void main(String[] args) throws Exception {<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //System.out.println(pl64(createMask(5,7)));<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; long val = 0;<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; val = setValue(val,15,3,6);<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; System.out.println(pl64(val));<br />
&nbsp;&nbsp;&nbsp; }<br />
<p>
	}
</p>
<p>
	<br />
</p>
<p>
	--------------------------------------------------------------------
</p>
<p>
	package cn.kanmars;<br />
<br />
import java.util.Date;<br />
<br />
public class LongTransfer {<br />
&nbsp;&nbsp; &nbsp;<br />
&nbsp;&nbsp; &nbsp;/**char 62 ,<br />
&nbsp;&nbsp; &nbsp; * 用来处理62进制<br />
&nbsp;&nbsp; &nbsp; */<br />
&nbsp;&nbsp; &nbsp;private static char[] info = {<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;'0','1','2','3','4','5','6','7','8','9',<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z',<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',<br />
&nbsp;&nbsp; &nbsp;};<br />
&nbsp;&nbsp; &nbsp;<br />
&nbsp;&nbsp; &nbsp;private static int jz_ = 62;<br />
&nbsp;&nbsp; &nbsp;<br />
&nbsp;&nbsp; &nbsp;public static void main(String[] args) {<br />
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;System.out.println(new Date(100,11,31));<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;//long long的最大值：9223372036854775807<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;//long long的最小值：-9223372036854775808<br />
//&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;System.out.println(getStrFrom(9223372036854775807l));//hezMo7<br />
//&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;System.out.println(getLongFrom("aZl8N0y58M7"));<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;for(int i=0;i&lt;10;i++){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;long date = new Date(100,11,31).getTime();//获取1900+300 = 2200年的时间<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;date = date/1000;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;String str = getStrFrom(date);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;long result = getLongFrom(str);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;System.out.print(date+"&nbsp;&nbsp;&nbsp; ");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;System.out.print(str+"&nbsp;&nbsp;&nbsp; ");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;System.out.print(result+"&nbsp;&nbsp;&nbsp; ");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;System.out.println("&nbsp; "+(date==result?"true":"false"));<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;try {<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;Thread.sleep(100);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;} catch (InterruptedException e) {<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;e.printStackTrace();<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;public static String getStrFrom(long l){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;StringBuffer sb = new StringBuffer();<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;if(l==0)return "0";<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;int jz = jz_;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;while(l/jz &gt;= 0){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;if(l==0){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;//sb.insert(0, info[0]);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;break;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;char c = info[(int)(l%jz)];<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;//System.out.println((int)(l%62));<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;sb.insert(0, c);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;l=l/jz;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;return sb.toString();<br />
&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;public static long getLongFrom(String str){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;long result = 0;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;int jz = jz_;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;int strlength = str.length();<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;char[] cc = new char[strlength];<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;str.getChars(0, strlength, cc, 0);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;for(int i=0,j=strlength;i&lt;j;i++ ){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;int num = -1;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;char c = cc[i];<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;if('0'&lt;=c&amp;&amp;c&lt;='9'){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;num = c-'0';<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;if('a'&lt;=c&amp;&amp;c&lt;='z'){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;num = c-'a'+10;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;if('A'&lt;=c&amp;&amp;c&lt;='Z'){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;num = c-'A'+36;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;//System.out.println(num);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;result = result*jz + num;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;return result;<br />
&nbsp;&nbsp; &nbsp;}<br />
}<br />
</p>
<p>
	<br />
</p>
<p>
	<br />
</p>
<br />