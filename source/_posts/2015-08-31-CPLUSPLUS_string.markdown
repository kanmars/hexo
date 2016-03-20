---
layout: post
title:  "[KANMARS原创] - C++学习_字符串操作_001"
desc: "初学C++，轻拍......"
date: 2015-08-31 23:59:33
tags: [server,c,c++]
---
<p>
	C++中的string
</p>
<p>
	<span style="background-color:#000000;color:#E53333;">一引入的头文件</span>
</p>
<p>
	&nbsp;&nbsp;&nbsp; #include&lt;string&gt;
</p>
<p>
	<span style="background-color:#000000;color:#E53333;">二初始化</span><span style="background-color:#000000;color:#E53333;">&nbsp;&nbsp;&nbsp;</span>&nbsp;
</p>
<p>
	string(const char *s);&nbsp;&nbsp;&nbsp; //用c字符串s初始化&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 例如string s = new string("cccccccc")<br />
string(int n,char c);&nbsp;&nbsp;&nbsp;&nbsp; //用n个字符c初始化&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 例如string s = new string(2,'c')<br />
此外，string类还支持默认构造函数和复制构造函数，如string s1；string s2="hello"；都是正确的写法。当构造的string太长而无法表达时会抛出length_error异常 ；
</p>
<p>
	#include &lt;iostream&gt;<br />
#include &lt;string&gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;<br />
#include &lt;fstream&gt;<br />
<br />
using namespace std;<br />
<br />
int main(){<br />
&nbsp;&nbsp;&nbsp; string * s1 = new string("这是s1");<br />
&nbsp;&nbsp;&nbsp; string * s2 = new string(10,'c');<br />
&nbsp;&nbsp;&nbsp; string s3 = "abcd";<br />
&nbsp;&nbsp;&nbsp; string s4;<br />
&nbsp;&nbsp;&nbsp; cout &lt;&lt; *s1 &lt;&lt; endl;<br />
&nbsp;&nbsp;&nbsp; cout &lt;&lt; *s2 &lt;&lt; endl;<br />
&nbsp;&nbsp;&nbsp; cout &lt;&lt;&nbsp; s3 &lt;&lt; endl;<br />
&nbsp;&nbsp;&nbsp; cout &lt;&lt;&nbsp; s3.empty() &lt;&lt; endl;<br />
&nbsp;&nbsp;&nbsp; cout &lt;&lt;&nbsp; s4.empty() &lt;&lt; endl;<br />
&nbsp;&nbsp; &nbsp;<br />
}
</p>
<p>
	<span style="background-color:#000000;color:#E53333;">三string的字符操作</span>
</p>
<p>
	#include&lt;iostream&gt;<br />
#include&lt;string&gt;<br />
#include&lt;fstream&gt;<br />
#include &lt;string.h&gt;<br />
<br />
using namespace std;<br />
<br />
int main(){<br />
&nbsp;&nbsp;&nbsp; string s = "abcdefghijklmn";<br />
&nbsp;&nbsp;&nbsp; cout &lt;&lt; s.operator[](2) &lt;&lt; endl;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //获取第二个字符，不检查是否越界<br />
&nbsp;&nbsp;&nbsp; cout &lt;&lt; s.at(2) &lt;&lt; endl;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //获取第二个字符，检查是否越界<br />
&nbsp;&nbsp; &nbsp;<br />
&nbsp;&nbsp;&nbsp; char tmp[100];<br />
&nbsp;&nbsp;&nbsp; memset(tmp,0,100);<br />
<br />
&nbsp;&nbsp;&nbsp; int i = s.copy(tmp,5,0);&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //从s的开始位置0开始，拷贝5个字符到tmp字符数组中，返回实际拷贝数量<br />
<br />
&nbsp;&nbsp;&nbsp; cout &lt;&lt; i &lt;&lt; endl;<br />
&nbsp;&nbsp;&nbsp; cout &lt;&lt; tmp &lt;&lt; endl;
</p>
<p>
	<br />
&nbsp;&nbsp;&nbsp; const char * cc1 = s.data();&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //返回一个非null终止的c字符数组<br />
&nbsp;&nbsp;&nbsp; const char * cc2 = s.c_str();&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //返回一个以null终止的c字符串<br />
<br />
&nbsp;&nbsp;&nbsp; cout &lt;&lt; cc1 &lt;&lt; endl;<br />
&nbsp;&nbsp;&nbsp; cout &lt;&lt; cc2 &lt;&lt; endl;<br />
}
</p>
<p>
	<br />
</p>
<p>
	<span style="background-color:#000000;color:#E53333;">四、string 特性描述</span>
</p>
<p>
	int capacity()const;&nbsp;&nbsp;&nbsp; //返回当前容量（即string中不必增加内存即可存放的元素个数）&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 容量是指数上升的0,1,2,4,8,16,32,64,128......<br />
int max_size()const;&nbsp;&nbsp;&nbsp; //返回string对象中可存放的最大字符串的长度&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 和操作系统有关，64位系统4611686018427387897<br />
int size()const;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //返回当前字符串的大小&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 长度，size和length相同，不包含'\0'<br />
int length()const;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //返回当前字符串的长度&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 长度，size和length相同，不包含'\0'<br />
bool empty()const;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //当前字符串是否为空<br />
void resize(int len,char c);//把字符串当前大小置为len，并用字符c填充不足的部分
</p>
<p>
	<br />
</p>
<p>
	<span style="background-color:#000000;color:#E53333;">五、</span><strong><span style="background-color:#000000;color:#E53333;">string类的输入输出操作</span></strong>
</p>
<p>
	string类重载运算符operator&gt;&gt;用于输入，同样重载运算符operator&lt;&lt;用于输出操作。<br />
函数getline(istream &amp;in,string &amp;s);用于从输入流in中读取字符串到s中，以换行符'\n'分开。
</p>
<p>
	#include &lt;iostream&gt;<br />
#include &lt;fstream&gt;<br />
#include &lt;string&gt;<br />
<br />
using namespace std;<br />
<br />
int main () {<br />
&nbsp;&nbsp;&nbsp; string s ;<br />
&nbsp;&nbsp;&nbsp; while(getline(cin,s)){<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; cout &lt;&lt; "readLine : " &lt;&lt; s &lt;&lt; endl;<br />
&nbsp;&nbsp;&nbsp; }<br />
}
</p>
<p>
	<br />
</p>
<p>
	<span style="background-color:#000000;color:#E53333;">六，string的赋值</span>
</p>
<p>
	string &amp;operator=(const string &amp;s);//把字符串s赋给当前字符串<br />
string &amp;assign(const char *s);//用c类型字符串s赋值<br />
string &amp;assign(const char *s,int n);//用c字符串s开始的n个字符赋值<br />
string &amp;assign(const string &amp;s);//把字符串s赋给当前字符串<br />
string &amp;assign(int n,char c);//用n个字符c赋值给当前字符串<br />
string &amp;assign(const string &amp;s,int start,int n);//把字符串s中从start开始的n个字符赋给当前字符串<br />
string &amp;assign(const_iterator first,const_itertor last);//把first和last迭代器之间的部分赋给字符串
</p>
<p>
	#include &lt;iostream&gt;<br />
#include &lt;fstream&gt;<br />
#include &lt;string&gt;<br />
<br />
using namespace std;<br />
<br />
int main(){<br />
&nbsp;&nbsp;&nbsp; string s;<br />
&nbsp;&nbsp;&nbsp; s.assign(*new string("abc"));&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;//把字符串s赋给当前字符串<br />
&nbsp;&nbsp;&nbsp; cout &lt;&lt; s &lt;&lt;endl;<br />
&nbsp;&nbsp;&nbsp; s.assign(*new string("abcdefghijkl"),3,6);&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;//把字符串s中从start开始的n个字符赋给当前字符串<br />
&nbsp;&nbsp;&nbsp; cout &lt;&lt; s &lt;&lt;endl;<br />
&nbsp;&nbsp;&nbsp; s.assign("abcdefghijkl");&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;//用c类型字符串s赋值<br />
&nbsp;&nbsp;&nbsp; cout &lt;&lt; s &lt;&lt;endl;<br />
&nbsp;&nbsp;&nbsp; s.assign("abcdefghijkl",6);&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //用c字符串s开始的n个字符赋值<br />
&nbsp;&nbsp;&nbsp; cout &lt;&lt; s &lt;&lt;endl;<br />
}&nbsp;&nbsp;
</p>
<p>
	<br />
</p>
<p>
	<span style="background-color:#000000;color:#E53333;">七、</span><strong><span style="background-color:#000000;color:#E53333;">string的连接：</span></strong><br />
string &amp;operator+=(const string &amp;s);//把字符串s连接到当前字符串的结尾 <br />
string &amp;append(const char *s);&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //把c类型字符串s连接到当前字符串结尾<br />
string &amp;append(const char *s,int n);//把c类型字符串s的前n个字符连接到当前字符串结尾<br />
string &amp;append(const string &amp;s);&nbsp;&nbsp;&nbsp; //同operator+=()<br />
string &amp;append(const string &amp;s,int pos,int n);//把字符串s中从pos开始的n个字符连接到当前字符串的结尾<br />
string &amp;append(int n,char c);&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //在当前字符串结尾添加n个字符c<br />
string &amp;append(const_iterator first,const_iterator last);//把迭代器first和last之间的部分连接到当前字符串的结尾
</p>
<p>
	<br />
</p>
<p>
	<strong><span style="background-color:#000000;color:#E53333;">八、string的比较</span></strong>
</p>
<p>
	bool operator==(const string &amp;s1,const string &amp;s2)const;//比较两个字符串是否相等<br />
运算符"&gt;","&lt;","&gt;=","&lt;=","!="均被重载用于字符串的比较；<br />
int compare(const string &amp;s) const;//比较当前字符串和s的大小&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 大于是1,小于是-1<br />
int compare(int pos, int n,const string &amp;s)const;//比较当前字符串从pos开始的n个字符组成的字符串与s的大小<br />
int compare(int pos, int n,const string &amp;s,int pos2,int n2)const;//比较当前字符串从pos开始的n个字符组成的字符串与s中
</p>
<p>
	//pos2开始的n2个字符组成的字符串的大小<br />
int compare(const char *s) const;<br />
int compare(int pos, int n,const char *s) const;<br />
int compare(int pos, int n,const char *s, int pos2) const;
</p>
<p>
	<br />
compare函数在&gt;时返回1，&lt;时返回-1，==时返回0&nbsp;&nbsp;
</p>
&nbsp;
<p>
	<br />
</p>
<p>
	<strong><span style="background-color:#000000;color:#E53333;">九、string的子串</span></strong><br />
string substr(int pos = 0,int n = npos) const;//返回pos开始的n个字符组成的字符串
</p>
<p>
	<br />
</p>
<p>
	<strong><span style="background-color:#000000;color:#E53333;">十、string的交换</span></strong>
</p>
<p>
	void swap(string &amp;s2);&nbsp;&nbsp;&nbsp; //交换当前字符串与s2的值
</p>
<p>
	<br />
</p>
<p>
	#include &lt;iostream&gt;<br />
#include &lt;fstream&gt;<br />
#include &lt;string&gt;<br />
<br />
using namespace std;<br />
<br />
int main(){<br />
&nbsp;&nbsp;&nbsp; string *s1 = new string("abc");<br />
&nbsp;&nbsp;&nbsp; string *s2 = new string("def");<br />
<br />
&nbsp;&nbsp;&nbsp; cout &lt;&lt; *s1 &lt;&lt; endl;<br />
&nbsp;&nbsp;&nbsp; cout &lt;&lt; *s2 &lt;&lt; endl;<br />
&nbsp;&nbsp; &nbsp;<br />
&nbsp;&nbsp;&nbsp; (*s1).swap(*s2);<br />
<br />
&nbsp;&nbsp;&nbsp; cout &lt;&lt; *s1 &lt;&lt; endl;<br />
&nbsp;&nbsp;&nbsp; cout &lt;&lt; *s2 &lt;&lt; endl;<br />
&nbsp;&nbsp;&nbsp; return 0;<br />
}
</p>
<p>
	<span style="color:#E53333;background-color:#000000;">十一、</span><strong><span style="color:#E53333;background-color:#000000;">string类的查找函数</span></strong>
</p>
<p>
	int find(char c, int pos = 0) const;//从pos开始查找字符c在当前字符串的位置<br />
int find(const char *s, int pos = 0) const;//从pos开始查找字符串s在当前串中的位置<br />
int find(const char *s, int pos, int n) const;//从pos开始查找字符串s中前n个字符在当前串中的位置<br />
int find(const string &amp;s, int pos = 0) const;//从pos开始查找字符串s在当前串中的位置<br />
//查找成功时返回所在位置，失败返回string::npos的值&nbsp;
</p>
<p>
	<br />
int rfind(char c, int pos = npos) const;//从pos开始从后向前查找字符c在当前串中的位置<br />
int rfind(const char *s, int pos = npos) const;<br />
int rfind(const char *s, int pos, int n = npos) const;<br />
int rfind(const string &amp;s,int pos = npos) const;<br />
//从pos开始从后向前查找字符串s中前n个字符组成的字符串在当前串中的位置，成功返回所在位置，失败时返回string::npos的值&nbsp;
</p>
<p>
	<br />
int find_first_of(char c, int pos = 0) const;//从pos开始查找字符c第一次出现的位置<br />
int find_first_of(const char *s, int pos = 0) const;<br />
int find_first_of(const char *s, int pos, int n) const;<br />
int find_first_of(const string &amp;s,int pos = 0) const;<br />
//从pos开始查找当前串中第一个在s的前n个字符组成的数组里的字符的位置。查找失败返回string::npos&nbsp;
</p>
<p>
	#include &lt;iostream&gt;<br />
#include &lt;string&gt;<br />
using namespace std;<br />
<br />
int main ()<br />
{<br />
&nbsp; string str ("Replace the vowels in this sentence by asterisks.");<br />
&nbsp; size_t found;<br />
&nbsp; found=str.find_first_of("aeiou");<br />
&nbsp; while (found!=string::npos)<br />
&nbsp; {<br />
&nbsp;&nbsp;&nbsp; str[found]='*';<br />
&nbsp;&nbsp;&nbsp; found=str.find_first_of("aeiou",found+1);<br />
&nbsp; }<br />
&nbsp; cout &lt;&lt; str &lt;&lt; endl;<br />
&nbsp; return 0;<br />
}
</p>
<p>
	<br />
</p>
<p>
	<br />
int find_first_not_of(char c, int pos = 0) const;<br />
int find_first_not_of(const char *s, int pos = 0) const;<br />
int find_first_not_of(const char *s, int pos,int n) const;<br />
int find_first_not_of(const string &amp;s,int pos = 0) const;<br />
//从当前串中查找第一个不在串s中的字符出现的位置，失败返回string::npos&nbsp;
</p>
<p>
	<br />
</p>
<p>
	<br />
int find_last_of(char c, int pos = npos) const;<br />
int find_last_of(const char *s, int pos = npos) const;<br />
int find_last_of(const char *s, int pos, int n = npos) const;<br />
int find_last_of(const string &amp;s,int pos = npos) const; <br />
int find_last_not_of(char c, int pos = npos) const;<br />
int find_last_not_of(const char *s, int pos = npos) const;<br />
int find_last_not_of(const char *s, int pos, int n) const;<br />
int find_last_not_of(const string &amp;s,int pos = npos) const;<br />
//find_last_of和find_last_not_of与find_first_of和find_first_not_of相似，只不过是从后向前查找
</p>
<p>
	<br />
</p>
<p>
	<span style="background-color:#000000;color:#E53333;">十二、</span><strong><span style="background-color:#000000;color:#E53333;">string类的替换函数</span></strong>
</p>
<p>
	string &amp;replace(int p0, int n0,const char *s);//删除从p0开始的n0个字符，然后在p0处插入串s<br />
string &amp;replace(int p0, int n0,const char *s, int n);//删除p0开始的n0个字符，然后在p0处插入字符串s的前n个字符<br />
string &amp;replace(int p0, int n0,const string &amp;s);//删除从p0开始的n0个字符，然后在p0处插入串s<br />
string &amp;replace(int p0, int n0,const string &amp;s, int pos, int n);//删除p0开始的n0个字符，然后在p0处插入串s中从pos开始的n个字符<br />
string &amp;replace(int p0, int n0,int n, char c);//删除p0开始的n0个字符，然后在p0处插入n个字符c<br />
string &amp;replace(iterator first0, iterator last0,const char *s);//把[first0，last0）之间的部分替换为字符串s<br />
string &amp;replace(iterator first0, iterator last0,const char *s, int n);//把[first0，last0）之间的部分替换为s的前n个字符<br />
string &amp;replace(iterator first0, iterator last0,const string &amp;s);//把[first0，last0）之间的部分替换为串s<br />
string &amp;replace(iterator first0, iterator last0,int n, char c);//把[first0，last0）之间的部分替换为n个字符c<br />
string
 &amp;replace(iterator first0, iterator last0,const_iterator first, 
const_iterator last);//把[first0，last0）之间的部分替换成[first，last）之间的字符串
</p>
<p>
	#include &lt;iostream&gt;<br />
#include &lt;fstream&gt;<br />
#include &lt;string&gt;<br />
<br />
using namespace std;<br />
<br />
int main(){<br />
&nbsp;&nbsp;&nbsp; string s1 = "abcdefg";<br />
&nbsp;&nbsp;&nbsp; string s2 = "0123456";<br />
&nbsp;&nbsp;&nbsp; cout &lt;&lt; s2.replace(3,2,s1) &lt;&lt; endl;<br />
&nbsp;&nbsp;&nbsp; cout &lt;&lt; s2 &lt;&lt; endl;<br />
&nbsp;&nbsp;&nbsp; s2 = "0123456";<br />
&nbsp;&nbsp;&nbsp; cout &lt;&lt; s2.replace(3,2,s1,4,3) &lt;&lt; endl;<br />
&nbsp;&nbsp;&nbsp; cout &lt;&lt; s2 &lt;&lt; endl;<br />
&nbsp;&nbsp;&nbsp; return 0;<br />
}
</p>
<p>
	<br />
</p>
<p>
	<span style="background-color:#000000;color:#E53333;">十三、</span><strong><span style="background-color:#000000;color:#E53333;">string类的插入函数</span></strong>
</p>
<p>
	string &amp;insert(int p0, const char *s);<br />
string &amp;insert(int p0, const char *s, int n);<br />
string &amp;insert(int p0,const string &amp;s);<br />
string &amp;insert(int p0,const string &amp;s, int pos, int n);<br />
//前4个函数在p0位置插入字符串s中pos开始的前n个字符<br />
string &amp;insert(int p0, int n, char c);//此函数在p0处插入n个字符c<br />
iterator insert(iterator it, char c);//在it处插入字符c，返回插入后迭代器的位置<br />
void insert(iterator it, const_iterator first, const_iterator last);//在it处插入[first，last）之间的字符<br />
void insert(iterator it, int n, char c);//在it处插入n个字符c
</p>
<p>
	<br />
</p>
<p>
	<span style="background-color:#000000;color:#E53333;">十四、</span><strong><span style="background-color:#000000;color:#E53333;">string类的删除函数</span></strong>
</p>
<p>
	iterator erase(iterator first, iterator last);//删除[first，last）之间的所有字符，返回删除后迭代器的位置<br />
iterator erase(iterator it);//删除it指向的字符，返回删除后迭代器的位置<br />
string &amp;erase(int pos = 0, int n = npos);//删除pos开始的n个字符，返回修改后的字符串
</p>
<p>
	<br />
</p>
<p>
	<span style="background-color:#000000;color:#E53333;">十五、</span><strong><span style="background-color:#000000;color:#E53333;">string类的迭代器处理</span></strong>
</p>
<p>
	string类提供了向前和向后遍历的迭代器iterator，迭代器提供了访问各个字符的语法，类似于指针操作，迭代器不检查范围。<br />
用string::iterator或string::const_iterator声明迭代器变量，const_iterator不允许改变迭代的内容。常用迭代器函数有：<br />
const_iterator begin()const;<br />
iterator begin();&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //返回string的起始位置<br />
const_iterator end()const;<br />
iterator end();&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //返回string的最后一个字符后面的位置<br />
const_iterator rbegin()const;<br />
iterator rbegin();&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //返回string的最后一个字符的位置<br />
const_iterator rend()const;<br />
iterator rend();&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; //返回string第一个字符位置的前面<br />
rbegin和rend用于从后向前的迭代访问，通过设置迭代器string::reverse_iterator,string::const_reverse_iterator实现
</p>
<p>
	<br />
</p>
<p>
	#include &lt;iostream&gt;<br />
#include &lt;fstream&gt;<br />
#include &lt;string&gt;<br />
#include &lt;algorithm&gt;<br />
<br />
using namespace std;<br />
<br />
void doExec(char c){<br />
&nbsp;&nbsp;&nbsp; cout &lt;&lt; c;<br />
}<br />
<br />
int main(){<br />
&nbsp;&nbsp;&nbsp; string s1 = "abcdefg";<br />
&nbsp;&nbsp;&nbsp; string::iterator ite_begin = s1.begin();<br />
&nbsp;&nbsp;&nbsp; string::iterator ite_end = s1.end();<br />
<br />
&nbsp;&nbsp;&nbsp; for_each(ite_begin,ite_end,doExec);<br />
&nbsp;&nbsp;&nbsp; cout &lt;&lt; endl;<br />
&nbsp;&nbsp;&nbsp; return 0;<br />
}
</p>
<p>
	<br />
</p>
<p>
	<strong>十六、字符串流处理</strong> <br />
通过定义ostringstream和istringstream变量实现，#include &lt;sstream&gt;头文件中<br />
例如：<br />
&nbsp;&nbsp;&nbsp; string input("hello,this is a test");<br />
&nbsp;&nbsp;&nbsp; istringstream is(input);<br />
&nbsp;&nbsp;&nbsp; string s1,s2,s3,s4;<br />
&nbsp;&nbsp;&nbsp; is&gt;&gt;s1&gt;&gt;s2&gt;&gt;s3&gt;&gt;s4;//s1="hello,this",s2="is",s3="a",s4="test"<br />
&nbsp;&nbsp;&nbsp; ostringstream os;<br />
&nbsp;&nbsp;&nbsp; os&lt;&lt;s1&lt;&lt;s2&lt;&lt;s3&lt;&lt;s4;<br />
&nbsp;&nbsp;&nbsp; cout&lt;&lt;os.str();
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
<p>
	<br />
</p>
<p>
	<br />
</p>
<p>
	<br />
</p>