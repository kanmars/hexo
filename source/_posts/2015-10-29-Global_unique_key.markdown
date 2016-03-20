---
layout: post
title:  "[KANMARS原创] - 分布式系统一致性hash中的key-全局唯一ID生成器"
desc: "本文描述了一种全局唯一ID生成器的实现，全局唯一ID生成器经常用于分布式系统架构，是项目构建中的基础性设施"
date: 2015-10-27 18:43:00
tags: [server,java,linux,spring]
---
<p>
	分布式系统一致性hash中的key
</p>
<p>
	--曾经和公司一个大神讨论分布式系统架构，提起一致性hash，他曾经给介绍了一种一致性hashkey的生成方式，例如一个long型数据，第0位存标志位，1-8位存放国家，9-16位存放省，17-24位存放城市，25-27位存放机房编号，28-30位存放集群编号，31-38存放物理机实例编号..........最终生成的一致性hash再通过环形hash空间完成负载均衡，借此实现高并发系统。
</p>
<p>
	<br />
</p>
<p>
	万事都是想起来容易，做起来难。
</p>
<p>
	例如分布式系统一致性hash的全局ID生成器，前段时间公司貌似需要写一个，由于项目紧张，我们直接使用的是创建的一个NumberCreateUtil的简版工具类。
</p>
<p>
	“粗略的”实现了全局唯一ID生成，
</p>
<p>
	<br />
</p>
<p>
	近日进行了反省，是因为“没有技术积累”，例如一些简单的工具没有，比如全局唯一ID生成器，例如短链接生成器之类的。
</p>
<p>
	<br />
</p>
<p>
	因此写了一个全局ID生成器+long数据可见性转换工具。
</p>
<p>
	大概原理是：传入时间，国家，城市，集群，机器，随机数，用户ID，生成一个long数据，可以作为一致性Hash的唯一的key
</p>
<p>
	代码如下：
</p>
<p>
	-------------------------------------------------------------------------------IDCreaterUtils------------------------------------------------------------------------------------------------------
</p>
<p>
	import java.util.ArrayList;<br />
import java.util.Date;<br />
import java.util.List;<br />
<br />
/**<br />
&nbsp;* ID生成器<br />
&nbsp;* @author baolong<br />
&nbsp;*<br />
&nbsp;*/<br />
public class IDCreaterUtils {<br />
<br />
&nbsp;&nbsp; &nbsp;/**<br />
&nbsp;&nbsp; &nbsp; * 系统创建时间<br />
&nbsp;&nbsp; &nbsp; */<br />
&nbsp;&nbsp; &nbsp;public static final long BEGIN_TM = new Date(115,9,10).getTime();//<br />
<br />
&nbsp;&nbsp; &nbsp;/**正负号掩码，0位为0，其余为1*/<br />
&nbsp;&nbsp; &nbsp;public static long MASK_FLAG = 0x7FFFFFFFFFFFFFFFL;<br />
<br />
&nbsp;&nbsp; &nbsp;/**<br />
&nbsp;&nbsp; &nbsp; * 所有掩码之和为0x7FFFFFFFFFFFFFFFL;<br />
&nbsp;&nbsp; &nbsp; */<br />
&nbsp;&nbsp; &nbsp;/**时间掩码，长度29，范围限定[0-536870912]，[1-29]位为1，其余为0，秒为单位，够用17年*/<br />
&nbsp;&nbsp; &nbsp;public static long MASK_TIME= 0x7FFFFFFC00000000L;<br />
&nbsp;&nbsp; &nbsp;/**国家掩码，长度3，范围限定[0-8]，[30-32]位为1，其余为0*/<br />
&nbsp;&nbsp; &nbsp;public static long MASK_COUNTRY=0x0000000380000000L;<br />
&nbsp;&nbsp; &nbsp;/**城市掩码，长度6，范围限定[0-63]，[33-38]位为1，其余为0*/<br />
&nbsp;&nbsp; &nbsp;public static long MASK_CITY = 0x000000007E000000L;<br />
&nbsp;&nbsp; &nbsp;/**集群掩码，长度2，范围限定[0-3]，[39-40]位为1，其余为0*/<br />
&nbsp;&nbsp; &nbsp;public static long MASK_CLUSTER = 0x0000000001800000L;<br />
&nbsp;&nbsp; &nbsp;/**机器掩码，长度6，范围限定[0-63]，[41-46]位为1，其余为0*/<br />
&nbsp;&nbsp; &nbsp;public static long MASK_MACHINE = 0x00000000007E0000L;<br />
&nbsp;&nbsp; &nbsp;/**随机数掩码，长度7，范围限定[0-127]，[47-53]位为1，其余为0*/<br />
&nbsp;&nbsp; &nbsp;public static long MASK_RANDOM = 0x000000000001FC00L;<br />
&nbsp;&nbsp; &nbsp;/**用户ID掩码，长度10，[54-63]位为1，其余为0*/<br />
&nbsp;&nbsp; &nbsp;public static long MASK_USER = 0x00000000000003FFL;<br />
<br />
<br />
&nbsp;&nbsp; &nbsp;/**<br />
&nbsp;&nbsp; &nbsp; * 64位ID生成器，正数<br />
&nbsp;&nbsp; &nbsp; * @param time&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;时间，[1-29]位，长度29，范围限定[0-536870912]，以秒为单位，够用17年，如果该参数传递为0，则默认使用当前时间<br />
&nbsp;&nbsp; &nbsp; * @param country&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;国家，[30-32]位，长度3，范围限定[0-8]<br />
&nbsp;&nbsp; &nbsp; * @param city&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;城市，[33-38]位，长度6，范围限定[0-63]<br />
&nbsp;&nbsp; &nbsp; * @param cluster&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;集群，[39-40]位，长度2，范围限定[0-3]<br />
&nbsp;&nbsp; &nbsp; * @param machine&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;机器，[41-46]位，长度6，范围限定[0-63]<br />
&nbsp;&nbsp; &nbsp; * @param random&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;随机数，[47-53]位，长度7，范围限定[0-127]<br />
&nbsp;&nbsp; &nbsp; * @param user&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;用户ID尾数，[54-63]位，长度10，范围限定[0-1023]<br />
&nbsp;&nbsp; &nbsp; * @return<br />
&nbsp;&nbsp; &nbsp; */<br />
&nbsp;&nbsp; &nbsp;public static long createId(long time,long country,long city,long cluster,long machine,long random,long user) throws Exception {<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;if(time&lt;0 || time &gt; 536870911 ){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;throw new Exception("time时间范围超出[0-536870912]");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;if(country&lt;0 || country&gt; 7){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;throw new Exception("国家范围超出[0-7]");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;if(city&lt;0 || city&gt; 63){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;throw new Exception("城市范围超出[0-63]");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;if(cluster&lt;0 || cluster&gt; 3){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;throw new Exception("集群范围超出[0-3]");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;if(machine&lt;0 || machine&gt; 63){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;throw new Exception("机器范围超出[0-63]");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;if(random&lt;0 || random&gt; 127){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;throw new Exception("随机数范围超出[0-127]");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;if(user&lt;0 || user&gt; 1023){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;throw new Exception("用户ID尾数范围超出[0-1023]");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;long result = 0;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;long time_base = time;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;if(time_base ==0){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;time_base = (System.currentTimeMillis() - BEGIN_TM)/1000;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;result = result | ((time_base &lt;&lt; (63 - 29)) &amp; MASK_FLAG );<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;result = result | ((country &lt;&lt; (63 - 32)) &amp; MASK_COUNTRY );<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;result = result | ((city &lt;&lt; (63 - 38)) &amp; MASK_CITY );<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;result = result | ((cluster &lt;&lt; (63 - 40)) &amp; MASK_CLUSTER );<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;result = result | ((machine &lt;&lt; (63 - 46)) &amp; MASK_MACHINE );<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;result = result | ((random &lt;&lt; (63 - 53)) &amp; MASK_RANDOM );<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;result = result | ( user &amp; MASK_USER );<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;return result;<br />
&nbsp;&nbsp; &nbsp;}<br />
<br />
&nbsp;&nbsp; &nbsp;/**<br />
&nbsp;&nbsp; &nbsp; * 传入一个ID，解析为LONG数组<br />
&nbsp;&nbsp; &nbsp; * @param id<br />
&nbsp;&nbsp; &nbsp; * @return<br />
&nbsp;&nbsp; &nbsp; * new long[]{<br />
&nbsp;&nbsp; &nbsp; * time,<br />
&nbsp;&nbsp; &nbsp; * country,<br />
&nbsp;&nbsp; &nbsp; * city,<br />
&nbsp;&nbsp; &nbsp; * cluster,<br />
&nbsp;&nbsp; &nbsp; * machine,<br />
&nbsp;&nbsp; &nbsp; * random,<br />
&nbsp;&nbsp; &nbsp; * user<br />
&nbsp;&nbsp; &nbsp;};<br />
&nbsp;&nbsp; &nbsp; * @throws Exception<br />
&nbsp;&nbsp; &nbsp; */<br />
&nbsp;&nbsp; &nbsp;public static long[] parseId(long id) throws Exception {<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;long time=0;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;long country=0;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;long city=0;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;long cluster=0;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;long machine=0;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;long random=0;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;long user=0;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;time &nbsp;&nbsp; &nbsp;= id &gt;&gt; (63 - 29) &amp; 0x0000000001FFFFFFL;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;country = id &gt;&gt; (63 - 32) &amp; 0x0000000000000007L;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;city &nbsp;&nbsp; &nbsp;= id &gt;&gt; (63 - 38) &amp; 0x000000000000003FL;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;cluster = id &gt;&gt; (63 - 40) &amp; 0x0000000000000003L;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;machine = id &gt;&gt; (63 - 46) &amp; 0x000000000000003FL;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;random &nbsp;&nbsp; &nbsp;= id &gt;&gt; (63 - 53) &amp; 0x000000000000007FL;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;user &nbsp;&nbsp; &nbsp;= id&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &amp; 0x00000000000003FFL;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;return new long[]{<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;time,<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;country,<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;city,<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;cluster,<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;machine,<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;random,<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;user<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;};<br />
&nbsp;&nbsp; &nbsp;}<br />
<br />
&nbsp;&nbsp; &nbsp;/**<br />
&nbsp;&nbsp; &nbsp; * 打印一个long的二进制码，不分割<br />
&nbsp;&nbsp; &nbsp; * @param l<br />
&nbsp;&nbsp; &nbsp; * @return<br />
&nbsp;&nbsp; &nbsp; */<br />
&nbsp;&nbsp; &nbsp;public static String pl64(long l){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;return pl64(l,false);<br />
&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp;&nbsp; &nbsp;/**<br />
&nbsp;&nbsp; &nbsp; * 打印一个long的二进制码<br />
&nbsp;&nbsp; &nbsp; * @param l&nbsp;&nbsp; &nbsp;要打印的数值<br />
&nbsp;&nbsp; &nbsp; * @param split&nbsp;&nbsp; &nbsp;是否每4位分割<br />
&nbsp;&nbsp; &nbsp; * @return<br />
&nbsp;&nbsp; &nbsp; */<br />
&nbsp;&nbsp; &nbsp;public static String pl64(long l,boolean split){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;StringBuilder sb = new StringBuilder();<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;for(int i=0;i&lt;64;i++){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;sb.append(pl(l, i));<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;if((i+1)%4 ==0 &amp;&amp; split){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;sb.append(" ");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;sb.append("\r\n");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;return sb.toString();<br />
&nbsp;&nbsp; &nbsp;}<br />
<br />
&nbsp;&nbsp; &nbsp;/**<br />
&nbsp;&nbsp; &nbsp; * 打印l 的从0开始第index位的数据<br />
&nbsp;&nbsp; &nbsp; * @param l<br />
&nbsp;&nbsp; &nbsp; * @param index<br />
&nbsp;&nbsp; &nbsp; */<br />
&nbsp;&nbsp; &nbsp;public static String pl(long l,int index){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;return (0x0000000000000001L &amp; (l&gt;&gt; (63-index)))+"";<br />
&nbsp;&nbsp; &nbsp;}<br />
<br />
&nbsp;&nbsp; &nbsp;/**<br />
&nbsp;&nbsp; &nbsp; * 掩码创建工具，传递一个int数组，生成的掩码字符串会将该int中的位设置为1<br />
&nbsp;&nbsp; &nbsp; * 例如System.out.println(createMask(63,62));，返回结果为0x0000000000000003L<br />
&nbsp;&nbsp; &nbsp; * @param cc<br />
&nbsp;&nbsp; &nbsp; * @return<br />
&nbsp;&nbsp; &nbsp; */<br />
&nbsp;&nbsp; &nbsp;public static String createMask(int ... cc){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;StringBuilder sb = new StringBuilder();<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;for(int i=0;i&lt; 64;i++){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;String s_v = "0";<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;for(int idx : cc){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;if(idx == i){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;s_v = "1";<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;break;<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;sb.append(s_v);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;String str = sb.toString();<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;StringBuilder sb1= new StringBuilder();<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;sb1.append("0x");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;for (int i=0;i&lt;64;i+=4){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;if(str.substring(i,i+4).equals("0000")){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;sb1.append("0");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}else if(str.substring(i,i+4).equals("0001")){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;sb1.append("1");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}else if(str.substring(i,i+4).equals("0010")){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;sb1.append("2");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}else&nbsp; if(str.substring(i,i+4).equals("0011")){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;sb1.append("3");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}else if(str.substring(i,i+4).equals("0100")){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;sb1.append("4");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}else if(str.substring(i,i+4).equals("0101")){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;sb1.append("5");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}else if(str.substring(i,i+4).equals("0110")){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;sb1.append("6");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}else if(str.substring(i,i+4).equals("0111")){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;sb1.append("7");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}else if(str.substring(i,i+4).equals("1000")){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;sb1.append("8");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}else if(str.substring(i,i+4).equals("1001")){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;sb1.append("9");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}else if(str.substring(i,i+4).equals("1010")){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;sb1.append("A");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}else if(str.substring(i,i+4).equals("1011")){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;sb1.append("B");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}else if(str.substring(i,i+4).equals("1100")){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;sb1.append("C");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}else if(str.substring(i,i+4).equals("1101")){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;sb1.append("D");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}else if(str.substring(i,i+4).equals("1110")){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;sb1.append("E");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}else if(str.substring(i,i+4).equals("1111")){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;sb1.append("F");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;sb1.append("L");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;return sb1.toString();<br />
&nbsp;&nbsp; &nbsp;}<br />
<br />
&nbsp;&nbsp; &nbsp;public static void main(String[] args) throws Exception {<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;//生成指定目标位的掩码<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;//System.out.println(createMask(54, 55, 56, 57, 58, 59, 60, 61, 62, 63));<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;//创建id示例<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;long id = createId(0, 0, 1, 3, 16, 33, 777);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;System.out.println(id);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;//将ID生成短可见ID<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;String strid = LongTransfer.getStrFrom(id);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;System.out.println(strid);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;//从短可见ID生成long<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;long id_ = LongTransfer.getLongFrom(strid);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;System.out.println(id_);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;//对ID进行反向解析<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;System.out.println("开始反向解析");<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;for(long l : parseId(id_)){<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;System.out.println(l);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;}<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;//pl64(1);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;//pl(1,63);<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;//System.out.println(createId(0,1,1,1,1,1,1,111));<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;//System.out.print(<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;//&nbsp;&nbsp; &nbsp;pl64(<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;//&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;MASK_TIME | MASK_COUNTRY | MASK_CITY | MASK_CLUSTER | MASK_MACHINE | MASK_RANDOM | MASK_USER<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;//&nbsp;&nbsp; &nbsp;)<br />
&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;//);<br />
&nbsp;&nbsp; &nbsp;}<br />
<br />
<br />
}
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
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
</p>
<p>
	-------------------------------------------------------------------------------LongTransfer------------------------------------------------------------------------------------------------------
</p>
<p>
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
}
</p>
<p>
	-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
	<br />
</p>