---
layout: post
title:  "[KANMARS原创]-SpringMVC源码解析(3) - 请求处理过程"
desc: "[KANMARS原创]-SpringMVC源码解析(3) - 请求处理过程"
date: 2016-11-18 14:44:00
tags: [server,java]
---
# 二、SpringMVC的请求处理过程 #

上一章讲了SpringMVC的启动过程，包括DispatcherServlet的启动与spring的启动。这一章我们在SpringMVC已经启动的基础上，讲一个request是如何接受与处理的。

## 2.1、请求调用顺序 ##

	FrameworkServlet.service()
		└FrameworkServlet.processRequest(request, response);
			└DispatcherServlet.doService(request, response);
				└DispatcherServlet.doDispatch(request, response)；
					├HandlerExecutionChain mappedHandler=getHandler(request, false)
					│	│	//SpringMVC中配置了很多handlerMapping，按顺序逐个调用
					│	│	//如果某handlerMapping找到了Handler，则立刻返回
					│	│	//一般来说，handlerMappings的顺序是：
					│	│	//1、RequestMappingHandlerMapping//负责url到Handler名称映射
					│	│	//2、BeanNameUrlHandlerMapping//负责url到Handler名称映射
					│	│	//3、SimpleUrlHandlerMapping//负责url到Handler名称映射
					│	└HandlerExecutionChain handler = handlerMappings.getHandler(request);
					│		│	//以RequestMappingHandlerMapping为例
					│		└RequestMappingHandlerMapping.getHandler(request)
					│			└AbstractHandlerMapping.getHandler(request)
					│				├Object handler = getHandlerInternal(request);
					│				│	└HandlerMethod hm = AbstractHandlerMethodMapping.getHandlerInternal(request);
					│				│		├String lookupPath = getUrlPathHelper().getLookupPathForRequest(request);
					│				│		└HandlerMethod handlerMethod = lookupHandlerMethod(lookupPath, request);
					│				│				└AbstractHandlerMethodMapping.lookupHandlerMethod(lookupPath, request);
					│				└getHandlerExecutionChain(handler, request);
					│					├for (MappedInterceptor mappedInterceptor : mappedInterceptors) 
					│					└chain.addInterceptor(mappedInterceptor.getInterceptor());
					│					//此步骤给handler增加interceptor
					│					//从此处可知springMVC的每次request请求都会动态组装HandlerExecutionChain
					│
					├HandlerAdapter ha = getHandlerAdapter(mappedHandler.getHandler());
					│	│//此步骤从handlerAdapters获取一个support支持当前handler的Adapters
					│	└for (HandlerAdapter ha : this.handlerAdapters)if (ha.supports(handler))return ha;
					│		│//以RequestMappingHandlerAdapter为例
					│		└RequestMappingHandlerAdapter.supports(handler)
					│			└AbstractHandlerMethodAdapter.supports(handler)
					│				└return return handler instanceof HandlerMethod//根据上文可知handler为HandlerMethod，此处为true
					│
					├mappedHandler.applyPreHandle(processedRequest, response)
					│	├HandlerInterceptor[] interceptors = getInterceptors()
					│	└for(HandlerInterceptor h : interceptors)h.preHandle(request, response, this.handler)
					│
					├ModelAndView mv = ha.handle(request, response, mappedHandler.getHandler());	
					│	└RequestMappingHandlerAdapter.handle(request, response, mappedHandler.getHandler());	
					│		└AbstractHandlerMethodAdapter.handle(request, response, mappedHandler.getHandler());	
					│			└RequestMappingHandlerAdapter.handleInternal(request, response, (HandlerMethod) handler);
					│				├checkAndPrepare前处理：session过期，session检查等
					│				└invokeHandleMethod(request, response, handlerMethod);
					│					├ServletWebRequest webRequest = new ServletWebRequest(request, response);
					│					├ServletInvocableHandlerMethod requestMappingMethod = createRequestMappingMethod(handlerMethod, binderFactory);
					│					├ModelAndViewContainer mavContainer = new ModelAndViewContainer();
					│					├requestMappingMethod.invokeAndHandle(webRequest, mavContainer);
					│					│	└ServletInvocableHandlerMethod.invokeAndHandle(webRequest, mavContainer);
					│					│		├Object returnValue = invokeForRequest(webRequest, mavContainer, providedArgs);
					│					│		│	├Object[] args = getMethodArgumentValues(request, mavContainer, providedArgs);
					│					│		│	└return InvocableHandlerMethod.invoke(args);
					│					│		│		└return getBridgedMethod().invoke(getBean(), args);//调用真正的Controller中的@RequestMapping注解的方法
					│					│		│
					│					│		└returnValueHandlers.handleReturnValue(returnValue, getReturnValueType(returnValue), mavContainer, webRequest);
					│					│			│//是一个数组的包装类new HandlerMethodReturnValueHandlerComposite().addHandlers(getDefaultReturnValueHandlers());
					│					│			│//在getDefaultReturnValueHandlers()中返回的是一个List<HandlerMethodReturnValueHandler>
					│					│			│//例如ModelAndViewMethodReturnValueHandler、ViewNameMethodReturnValueHandler、ModelMethodProcessor、ViewMethodReturnValueHandler
					│					│			│//最常用的是前两个ModeAndView处理器和ViewName处理器，分别对应方法返回ModelAndView和String两种情况。只要命中一个，则不再执行下一个handler
					│					│			│//以下以ModelAndViewMethodReturnValueHandler为例
					│					│			├mavContainer.setViewName(viewName);
					│					│			└mavContainer.setRedirectModelScenario(true);
					│					│
					│					└return getModelAndView(mavContainer, modelFactory, webRequest);
					│						└ModelAndView mav = new ModelAndView(mavContainer.getViewName(), mavContainer.getModel());
					│
					├mappedHandler.applyPostHandle(processedRequest, response, mv);
					│	├HandlerInterceptor[] interceptors = getInterceptors()
					│	└for(HandlerInterceptor h : interceptors)h.postHandle(request, response, mv)
					└processDispatchResult(processedRequest, response, mappedHandler, mv, dispatchException);	
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



## 2.2、请求调用总结 ##

在DispatcherServlet的调用过程中

1、根据系统初始化出的HandlrMapping解析URL，获取到具体的HandlerMethod

2、对HandlerMethod增加interceptor，最终生成HandlerExecutionChain

3、根据handler生成HandlerAdapter，在HandlerAdapter内具有更高级的操作

4、执行interceptors的prehandler

5、通过handlerAdapter处理session处理，请求封装，调用实际方法，返回结果封装，返回结果转换为ModelAndView

6、执行interceptors的posthandler，因为在第五步已经将返回结果封装为ModelAndView，因此postHandle的参数为ModelAndView

7、通过viewResolver获取到view，进而通过view.render把响应结果发送给客户端

8、调用interceptor的afterCompletion方法。

-------------------------------------------------------------------------

以上即是SpringMVC的请求调用过程，其细节上还有很多可追究的地方，不再一一讨论。