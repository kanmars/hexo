---
layout: post
title:  "[KANMARS原创]-SpringMVC源码解析(4) - 视图处理器"
desc: "[KANMARS原创]-SpringMVC源码解析(4) - 视图处理器"
date: 2016-11-18 16:51:00
tags: [server,java]
---
# 三、SpringMVC的视图处理器 #

从上一篇文章我们已经看到了在获取到一个ModelAndView之后，会调用DispatcherServlet.processDispatchResult(processedRequest, response, mappedHandler, mv, dispatchException);对用户进行响应

	processDispatchResult(processedRequest, response, mappedHandler, mv, dispatchException);	
		├render(mv, request, response);
		│	├View view = viewResolver.resolveViewName(mv.getViewName(), locale);//此处viewResolover常用的是FreeMarkerViewResolver，返回FreeMarkerView
		│	└view.render(mv.getModelInternal(), request, response);
		│		├Map<String, Object> mergedModel = createMergedOutputModel(model, request, response);
		│		├prepareResponse(request, response);
		│		└renderMergedOutputModel(mergedModel, request, response);
		│			└FreeMarkerView.doRender(model, request, response);
		│				└template.process(model, response.getWriter());//给用户输出内容
		│	
		└mappedHandler.triggerAfterCompletion(request, response, null);
			├HandlerInterceptor[] interceptors = getInterceptors()
			└for(HandlerInterceptor h : interceptors)h.afterCompletion(request, response, ex)

我们上一节已经大致描述了这个过程。

此处仅强调一下：

在视图解析器的解析过程中，采用的是如下代码：

	for (ViewResolver viewResolver : this.viewResolvers) {
		View view = viewResolver.resolveViewName(viewName, locale);
		if (view != null) {
			return view;
		}
	}

即：在系统中按照viewResolvers对view进行解析，如果解析成功，则直接返回，跳过其他viewResolvers

然后调用view.render(mv.getModelInternal(), request, response);

最终调用template.process(model, response.getWriter());把结果输出到用户

-----------------------------------------------------------------------------------

PS：依稀记得当年和九扬搞车险时，九扬整了一个同时支持ftl和jsp的解析器，我找找代码去...........

Spring配置如下：

	<bean id="viewResolver" class="com.spring.action.MultiViewResover">  
        <property name="resolvers">  
            <map>  
                <entry key="jsp">  
                    <bean  
                     class="org.springframework.web.servlet.view.InternalResourceViewResolver">  
                        <property name="viewClass"  
                         value="org.springframework.web.servlet.view.JstlView"/>  
                        <property name="prefix" value="/WEB-INF/jsp/"/>  
                        <property name="suffix" value=".jsp"/>  
                    </bean>  
                </entry>  
                <entry key="ftl">  
                    <bean  
                     class="org.springframework.web.servlet.view.freemarker.FreeMarkerViewResolver">  
                        <property name="cache" value="true"/>  
                        <property name="prefix" value="/"/>  
                        <property name="suffix" value=".ftl"/>    
                    </bean>  
                </entry>  
                <entry key="vm">  
                    <bean  
                     class="org.springframework.web.servlet.view.velocity.VelocityViewResolver">  
                        <property name="cache" value="true"/>  
                        <property name="prefix" value="/"/>  
                        <property name="suffix" value=".vm"/>  
                    </bean>  
                </entry>  
            </map>  
        </property>  
    </bean>  

JAVA类如下：

	package com.spring.action;  
	  
	import java.util.Locale;  
	import java.util.Map;  
	import org.springframework.web.servlet.View;  
	import org.springframework.web.servlet.ViewResolver;  
	  
	/** 
	 * @author Jeson 
	 * @blog:http://www.gbsou.com 
	 * @date:Oct 20, 2009 8:39:27 AM 
	 * @version :1.0 
	 *  
	 */  
	public class MultiViewResover implements ViewResolver {  
	  
	    private Map<String, ViewResolver> resolvers;  
	  
	    @Override  
	    public View resolveViewName(String viewName, Locale locale)  
	            throws Exception {  
	        int n = viewName.lastIndexOf("_"); // 获取  
	                                            // viewName(modelAndView中的名字)看其有没有下划线  
	        if (n == (-1))  
	            return null; // 没有则直接返回空  
	        // 有的话截取下划线后面的字符串 这里一般是jsp,ftl,vm与配置文件中的<entry key="ftl">的key匹配  
	        String suffix = viewName.substring(n + 1);  
	        // 根据下划线后面的字符串去获取托管的视图解析类对象  
	        ViewResolver resolver = resolvers.get(suffix);  
	  
	        // 取下划线前面的部分 那时真正的资源名.比如我们要使用hello.jsp 那viewName就应该是hello_jsp  
	        viewName = viewName.substring(0, n);  
	        if (resolver != null)  
	            return resolver.resolveViewName(viewName, locale);  
	        return null;  
	    }  
	  
	    public Map<String, ViewResolver> getResolvers() {  
	        return resolvers;  
	    }  
	  
	    public void setResolvers(Map<String, ViewResolver> resolvers) {  
	        this.resolvers = resolvers;  
	    }  
	}  

Controller如下

	package com.spring.action;  
	  
	import java.util.HashMap;  
	import java.util.Map;  
	  
	import org.springframework.stereotype.Controller;  
	import org.springframework.web.bind.annotation.RequestMapping;  
	import org.springframework.web.servlet.ModelAndView;  
	  
	@Controller  
	public class HelloWorldAction {  
	  
	    @RequestMapping(value = "/helloworld.do")  
	    public ModelAndView hello() {  
	        ModelAndView modelAndView = new ModelAndView();  
	        modelAndView.setViewName("hello_jsp");  
	        modelAndView.addObject("message", "Hello,SpringMvc");  
	        return modelAndView;  
	    }  
	  
	    @RequestMapping(value = "/welcome.do")  
	    public ModelAndView helloVm() {  
	        // ModelAndView modelAndView=new ModelAndView();  
	        // modelAndView.setViewName("freemarker_ftl");  
	        // modelAndView.addObject("message", "Hello,Velocity");  
	        // return modelAndView;  
	        Map map = new HashMap();  
	        return new ModelAndView("freemarker_ftl",  map); // 根据之前的解释这里就是去寻找  
	                                                         // user.ftl资源  
	  
	    }  
	  
	    @RequestMapping(value = "/free.do")  
	    public ModelAndView helloFreeMarker() {  
	        ModelAndView modelAndView = new ModelAndView();  
	        modelAndView.setViewName("welcome");  
	        modelAndView.addObject("message", "Hello,Freemarker");  
	        return modelAndView;  
	    }  
	  
	} 


----------------------------------------------------------------------------------

这是大概四年前的代码了，而我今天才看懂其内部是怎么走的，惭愧惭愧。

更惭愧的是：因为一直没时间，我本来不计划看SpringMVC的。但是最近在看服务化，有同事推荐SpringCloud，然后SpringCloud的基础是SpringBoot，而SpringBoot的第一组件是SpringMVC，我在看完SpringBoot后发现自己对SpringMVC用了很多年但还是无知的概念，因此我决定沉下心来看一下SpringMVC的源码。

到今天终于看完了，终于可以回头看SpringCloud了。 