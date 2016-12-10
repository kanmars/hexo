---
layout: post
title:  "[KANMARS原创]-DUBBO源码解析(2)-proxyFactory"
desc: "DUBBO源码解析(2)-proxyFactory"
date: 2016-09-18 22:24:00
tags: [server,java]
---
DUBBO源码解析(2)-proxyFactory

在ServiceConfig.java和ReferenceConfig.java中有一个神奇的类变量叫做proxyFactory

# 一、用途 #

proxyFactory的接口如下：
	
	@SPI("javassist")
	public interface ProxyFactory {
    	@Adaptive({Constants.PROXY_KEY})
   		<T> T getProxy(Invoker<T> invoker) throws RpcException;
    	@Adaptive({Constants.PROXY_KEY})
    	<T> Invoker<T> getInvoker(T proxy, Class<T> type, URL url) throws RpcException;
	}

很显然，默认使用javassist作为ProxyFactory的实现类，含有两个方法getProxy和getInvoker。

在Dubbo内部，proxy含义为代理，而Invoker为一个执行。

我们举个例子即可：
	
	如下调用堆栈
	ReferenceConfig.init()
		ref = createProxy(map);
			invokers.add(refprotocol.refer(interfaceClass, url));
			invoker = cluster.join(new StaticDirectory(invokers));
			return (T) proxyFactory.getProxy(invoker);

可以看到，在ReferenceConfig中,proxyFactory的作用是根据invoker生成一个代理对象用于执行invoker

	如下调用堆栈
	ServiceConfig.doExportUrls()
		doExportUrlsFor1Protocol(protocolConfig, registryURLs);
			Invoker<?> invoker = proxyFactory.getInvoker(ref, (Class) interfaceClass, registryURL.addParameterAndEncoded(Constants.EXPORT_KEY, url.toFullString()));
			Exporter<?> exporter = protocol.export(invoker);
			exporters.add(exporter);

可以看到，在ServiceConfig中,proxyFactory的作用是根据ref和interfaceClass生成一个Invoker对象，然后使用protocol将此invoker暴露出去，然后将exporter增加如全局exporters

可以总结：
	
	proxyFactory的作用是对invoker生成一个代理层，其中，在service端是使用getInvoker方法对invoker生成代理，而在Consumer端是使用getProxy方法对invoker生成代理

# 二、ProxyFactory默认实现Javassist #

	public abstract class AbstractProxyFactory implements ProxyFactory {

	    public <T> T getProxy(Invoker<T> invoker) throws RpcException {
	        Class<?>[] interfaces = null;
	        String config = invoker.getUrl().getParameter("interfaces");
	        if (config != null && config.length() > 0) {
	            String[] types = Constants.COMMA_SPLIT_PATTERN.split(config);
	            if (types != null && types.length > 0) {
	                interfaces = new Class<?>[types.length + 2];
	                interfaces[0] = invoker.getInterface();
	                interfaces[1] = EchoService.class;
	                for (int i = 0; i < types.length; i ++) {
	                    interfaces[i + 1] = ReflectUtils.forName(types[i]);
	                }
	            }
	        }
	        if (interfaces == null) {
	            interfaces = new Class<?>[] {invoker.getInterface(), EchoService.class};
	        }
	        return getProxy(invoker, interfaces);
	    }
	    public abstract <T> T getProxy(Invoker<T> invoker, Class<?>[] types);
	}
	public class JavassistProxyFactory extends AbstractProxyFactory {

	    @SuppressWarnings("unchecked")
	    public <T> T getProxy(Invoker<T> invoker, Class<?>[] interfaces) {
	        return (T) Proxy.getProxy(interfaces).newInstance(new InvokerInvocationHandler(invoker));
	    }
	
	    public <T> Invoker<T> getInvoker(T proxy, Class<T> type, URL url) {
	        // TODO Wrapper类不能正确处理带$的类名
	        final Wrapper wrapper = Wrapper.getWrapper(proxy.getClass().getName().indexOf('$') < 0 ? proxy.getClass() : type);
	        return new AbstractProxyInvoker<T>(proxy, type, url) {
	            @Override
	            protected Object doInvoke(T proxy, String methodName, 
	                                      Class<?>[] parameterTypes, 
	                                      Object[] arguments) throws Throwable {
	                return wrapper.invokeMethod(proxy, methodName, parameterTypes, arguments);
	            }
	        };
	    }
	}
	



# 三、服务端getInvoker #

在服务端，代码如示例所示：

	Invoker<?> invoker = proxyFactory.getInvoker(ref, (Class) interfaceClass, registryURL.addParameterAndEncoded(Constants.EXPORT_KEY, url.toFullString()));

getInvoker有三个参数：ref,interfaceClass,url

1. 第一个参数ref为要暴露出去的对象
2. 第二个参数为要暴露出去的对象的接口
3. 第三个参数为要暴露出去的对象的注册的地址（内含被暴露服务的地址）

在默认的javasisst接口中，实现方式如下：

	public <T> Invoker<T> getInvoker(T proxy, Class<T> type, URL url) {
        // TODO Wrapper类不能正确处理带$的类名
        final Wrapper wrapper = Wrapper.getWrapper(proxy.getClass().getName().indexOf('$') < 0 ? proxy.getClass() : type);
        return new AbstractProxyInvoker<T>(proxy, type, url) {
            @Override
            protected Object doInvoke(T proxy, String methodName, 
                                      Class<?>[] parameterTypes, 
                                      Object[] arguments) throws Throwable {
                return wrapper.invokeMethod(proxy, methodName, parameterTypes, arguments);
            }
        };
    }

	在Wrapper内部，使用javasisst的API接口，动态生成了一个代理的Wrapper对象，可以参见:
	Wrapper.getWrapper(Class<?> c)
		Wrapper.makeWrapper(Class<?> c)
最终生成的代理类方法如下
		
	public Object invokeMethod(Object o, String n, Class[] p, Object[] v) throws java.lang.reflect.InvocationTargetException{ 
		cn.com.gome.sn.dubbo.JkBusFacadeService w; 
		try{
			w = ((cn.com.gome.sn.dubbo.JkBusFacadeService)$1); 
		}catch(Throwable e){
			throw new IllegalArgumentException(e);
		} 
		try{
			if( "service".equals( $2 )  &&  $3.length == 1 ){
				return ($w)w.service((cn.com.gome.sn.dubbo.bean.SN_ParametersVo)$4[0]); 
			} 
		} catch(Throwable e) {
			throw new java.lang.reflect.InvocationTargetException(e);
		} throw new com.alibaba.dubbo.common.bytecode.NoSuchMethodException("Not found method \""+$2+"\" in class cn.com.gome.sn.dubbo.JkBusFacadeService."); 
	}


而在new AbstractProxyInvoker抽象类中
	
	public Result invoke(Invocation invocation) throws RpcException {
        try {
            return new RpcResult(doInvoke(proxy, invocation.getMethodName(), invocation.getParameterTypes(), invocation.getArguments()));
        } catch (InvocationTargetException e) {
            return new RpcResult(e.getTargetException());
        } catch (Throwable e) {
            throw new RpcException("Failed to invoke remote proxy method " + invocation.getMethodName() + " to " + getUrl() + ", cause: " + e.getMessage(), e);
        }
    }

从以上关系可以看到，当通讯层获取到Invocation时，会根据Invocation中的值找到对应的Invoker（此步骤后文描述）
	
	调用invoker.invoke(proxy, methodName, parameterTypes, arguments)
	之后调用AbstractProxyInvoker.invoke(Invocation invocation)
	之后调用wrapper.invokeMethod(proxy, methodName, parameterTypes, arguments);
	之后调用invokeMethod(Object o, String n, Class[] p, Object[] v)
	根据方法签名找到真正的方法，然后进行调用
	将结果封装为RpcResult
	最终返回
再在通讯层中把RpcResult封装为序列化对象并返回。

# 三、客户端实现getProxy #

客户端ReferenceConfig调用堆栈如下
	
	ref = createProxy(map);
	invoker = refprotocol.refer(interfaceClass, urls.get(0));
	return (T) proxyFactory.getProxy(invoker);
	
	public <T> T getProxy(Invoker<T> invoker, Class<?>[] interfaces) {
        return (T) Proxy.getProxy(interfaces).newInstance(new InvokerInvocationHandler(invoker));
    }
	
	在Proxy.getProxy内部，使用javassist自动对所有的interfaces方法生成代理类，方法体如下

	Object[] args = new Object[1]; 
	args[0] = ($w)$1; 
	Object ret = handler.invoke(this, methods[0], args); 
	return (cn.com.gome.sn.dubbo.bean.SN_ParametersVo)ret;
	
	再看InvokerInvocationHandler的实现

	public class InvokerInvocationHandler implements InvocationHandler {		
	    private final Invoker<?> invoker;
	    public InvokerInvocationHandler(Invoker<?> handler){
	        this.invoker = handler;
	    }
	    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
	        String methodName = method.getName();
	        Class<?>[] parameterTypes = method.getParameterTypes();
	        if (method.getDeclaringClass() == Object.class) {
	            return method.invoke(invoker, args);
	        }
	        if ("toString".equals(methodName) && parameterTypes.length == 0) {
	            return invoker.toString();
	        }
	        if ("hashCode".equals(methodName) && parameterTypes.length == 0) {
	            return invoker.hashCode();
	        }
	        if ("equals".equals(methodName) && parameterTypes.length == 1) {
	            return invoker.equals(args[0]);
	        }   
	        //将客户端appname传输过去
	        Map<String, String>  attachments = new HashMap<String,String>();
	        //路由key取值
	        String testRoutKey = DynamicGroupUtil.getBetaParam(invoker.getUrl().getParameter("application"));
	        attachments.put(Constants.$PREFIX_IDENTIFY+testRoutKey, testRoutKey);
	        attachments.put(Constants.CONSUMER+Constants.SIDE_KEY, StringUtils.isEmpty(invoker.getUrl().getParameter("application"))?"ConsumerProjectNotYetJoinCat":invoker.getUrl().getParameter("application"));
	        return invoker.invoke(new RpcInvocation(method, args,attachments)).recreate();
	    }
	}
	
也就是说，客户端的调用过程为：

	调用ref.service方法
	调用proxy.invoke
	调用handler.invoke方法
	调用invoker.invoke(new RpcInvocation(method,args,attachments))方法
	此处invoker = refprotocol.refer(interfaceClass, urls.get(0))
最终调用通讯层将RpcInvocation封装为序列化对象发送出去
	
# 四、总结 #
在Dubbo中，代理是较为关键的技术，此技术的入口在proxyFactory中，分为两个方面

1. 服务端，需要看ProxyFactory的getInvoker方法，将真实的对象ref、接口interface、registerURL封装为一个AbstractProxyInvoker代理

	a. 用于protocol.export(invoker);用于RegisterProtocol.export(invoker)

	b. RegisterProtocol.doLocalExport中，protocol.export(new InvokerDelegete<T>(originInvoker, getProviderUrl(originInvoker)))

	c. 在protocol.export中，调用DubboProtocol.export，将invokerDelegete封装为new DubboExporter<T>(invoker, key, exporterMap);此处exporterMap为绑定于Protocol，即IP+Port的全局变量

	d. 在DubboProtocol中开启端口，且传入的handler为DubboProtocol中的requestHandler

	e. ......其他通讯层细节，通过Netty接受到数据，加密解密为Invocation对象，调用requestHandler.reply方法，通过getInvoker，在exporterMap中获取到DubboExporter,获取到invoker对象，调用invoke方法......最终执行到ref的真正方法，之后将返回结果封装为RpcResult，并序列化，最终返回给客户端

2、客户端，需要看proxyFactory的getProxy方法，生成一个代理:

    a. 调用proxy.service方法
    b. 调用handler.invoke方法
    c. 调用invoker.invoke方法
    d. 调用refprotocol.refer(interfaceClass, urls.get(0)).invoke方法
	e. 其他通讯层细节，例如负载均衡，动态选择目标等

从上看到，这个过程是比较简单的，但是其细节较为繁冗，例如：通过SPI机制实现的封装类自动注入，通过invoker参数实现的adaptive自适应的protocol选择

代理机制提供了一种“统一”的入口，使得dubbo可以在某一个环节统一增加一种操作，这是dubbo中比较出色的地方。





