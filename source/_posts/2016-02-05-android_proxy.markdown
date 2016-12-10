---
layout: post
title:  "安卓代理-感谢腾讯"
desc: "之前一直以为只能架上代理去国外搞，今天才发现，腾讯的同仁们开了一个代理服务器"
date: 2016-02-05 17:31:11
tags: [server,android]
---
<p>
	说明地址http://android-mirror.bugly.qq.com:8080/include/usage.html
</p>
<p>
	1、 Config User Defined Sites <br>
	Add this url to "User Defined Sites": http://android-mirror.bugly.qq.com:8080/android/repository/addon.xml 
</p>
<p>
	2、Config Proxy <br>
	Http Proxy Server : android-mirror.bugly.qq.com<br>
	HttpProxy Port：8080<br>
	Make sue to select: Force https://... sources to be fetched using http://... 

</p>