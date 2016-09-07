---
layout: post
title:  "[KANMARS原创]-DUBBO源码解析(1)SPI机制"
desc: "DUBBO源码解析(1)SPI机制"
date: 2016-09-07 20:20:00
tags: [server,java]
---
PS:恰逢暴雨、回不了家，写点文章......

DUBBO源码解析(1)-SPI机制

# 一、SPI机制 #

SPI机制的全称是Service Provider Interface，单从字面可以理解为Service提供者接口，正如从SPI的名字去理解SPI就是Service提供者接口；

JAVA自带的SPI机制是这么实现的：

	1、新建一个接口类com.kanmars.IOperation
		代码如下：
		public interface IOperation {
    		public int operation(int numberA, int numberB);
		}

	2、在/META-INF/services文件夹中创建空白文件，文件名为"com.kanmars.IOperation"
	3、文件内容为
		com.kanmars.impl.OperationImpl
	4、创建实现类com.kanmars.impl.OperationImpl
		代码如下：
		public class DivisionOperationImpl implements IOperation {
			@Override
			public int operation(int numberA, int numberB) {
				return numberA / numberB;
			}
		}
	5、创建Main方法
		public static void main(String[] args){
			ServiceLoader<IOperation> operations = ServiceLoader.load(IOperation.class);
			Iterator<IOperation> operationIterator = operations.iterator();
			System.out.println("classPath:"+System.getProperty("java.class.path"));
			while (operationIterator.hasNext()) {
				IOperation operation = operationIterator.next();
				System.out.println(operation.operation(6, 3));
			}
		}
	6、运行Main方法，则可以输出:9

以上内容即为JAVA自带的SPI机制，在/META-INF/service寻找要加载的接口的文件，从该文件中获取到真正的实现类，根据实现类实例化对象，然后对实例化的对象进行调用。

可以看到JAVA自带SPI的目的在于查找一个接口的实现类并初始化后调用。

# 二、DUBBO的SPI机制 #

由于JAVA原生的SPI仅有“简单的根据配置文件获取实现类”的功能，因此DUBBO用自己的方式实现了一遍SPI机制。

核心类是com.alibaba.dubbo.common.extension.ExtensionLoader

核心方法如下：
	
	/**根据type创建一个ExtensionLoader*/
	public static <T> ExtensionLoader<T> getExtensionLoader(Class<T> type)
	/**根据name返回当前ExtensionLoader的type的对象的实例*/
	public T getExtension(String name)
	/**获取一个可以根据传入的URL.protocol或者Parameter或者MethodParameter选择Extension并调用方法的代理类*/
	public T getAdaptiveExtension()
	/**获取符合指定group，
	 * 并且name在values数组中，
	 * 并且url的parameter的keys在目标的Activate注解的values中存在实现类*/
	public List<T> getActivateExtension(URL url, String[] values, String group)

以上三个方法我们需要一个一个来看，才能知道Dubbo是如何加载一个对象的。

## 2.1一个简单示例 ##

我们先举两个很具有代表性的例子

	例一、在com.alibaba.dubbo.config.ServiceConfig类中有如下代码:

	public class ServiceConfig<T> extends AbstractServiceConfig {
		... ...
		final int defaultPort = ExtensionLoader.getExtensionLoader(Protocol.class).getExtension(name).getDefaultPort();
		... ...
	}

	例二、在com.alibaba.dubbo.config.ServiceConfig类中有如下代码：
	
	public class ServiceConfig<T> extends AbstractServiceConfig {
		... ...
		private static final Protocol protocol = ExtensionLoader.getExtensionLoader(Protocol.class).getAdaptiveExtension();
		... ...
	｝
	
我们可以看到：在我们启动一个<dubbo:service ....../>标签时，会分别调用如下三个方法：

1、getExtensionLoader(Protocol.class);根据type创建一个ExtensionLoader

2、getExtension(name);根据name返回当前ExtensionLoader的type的对象的实例

3、getAdaptiveExtension();获取一个可以根据传入的URL.protocol或者Parameter或者MethodParameter选择Extension并调用方法的代理类

我们就按照这个顺序来看ExtensionLoader是如何实现Dubbo的SPI机制的

## 2.2ExtensionLoader的实例化(getExtensionLoader) ##

ExtensionLoader.getExtensionLoader(Protocol.class)这个静态方法的代码如下（为帮助理解，我删除了不重要代码）：
	
	private final Class<?> type;

    private final ExtensionFactory objectFactory;
	
	private ExtensionLoader(Class<?> type) {
        this.type = type;
        objectFactory = (type == ExtensionFactory.class ? null : ExtensionLoader.getExtensionLoader(ExtensionFactory.class).getAdaptiveExtension());
    }
	
    public static <T> ExtensionLoader<T> getExtensionLoader(Class<T> type) {
        ExtensionLoader<T> loader = (ExtensionLoader<T>) EXTENSION_LOADERS.get(type);
        if (loader == null) {
            EXTENSION_LOADERS.putIfAbsent(type, new ExtensionLoader<T>(type));
            loader = (ExtensionLoader<T>) EXTENSION_LOADERS.get(type);
        }
        return loader;
    }

这是四个最重要的部分：

	type：代表了当前这个ExtensionLoader的类型

	objectFactory：是一个对象工厂，在初始化extension对象的依赖关系时会用这个工厂来创建extension依赖

	ExtensionLoader：私有构造方法

	getExtensionLoader：根据指定类型获取目标的extensionLoader

可以看到ExtensionLoader的实例化过程就是：创建一个ExtensionLoader，通过构造方法制定内部的type，并且设置objectFactory，并且以type作为主键把ExtensionLoader缓存起来

## 2.3根据name返回当前ExtensionLoader的type的对象的实例(getExtension) ##

为了帮助理解，我把不重要的代码删除了

	public T getExtension(String name) {
		Holder<Object> holder = cachedInstances.get(name);
		if (holder == null) {
		    cachedInstances.putIfAbsent(name, new Holder<Object>());
		    holder = cachedInstances.get(name);
		}
		Object instance = holder.get();
		if (instance == null) {
	        instance = holder.get();
	        if (instance == null) {
	            instance = createExtension(name);
	            holder.set(instance);
	        }
		}
		return (T) instance;
	}
	
	private T createExtension(String name) {
        Class<?> clazz = getExtensionClasses().get(name);
        
        T instance = (T) EXTENSION_INSTANCES.get(clazz);
        if (instance == null) {
            EXTENSION_INSTANCES.putIfAbsent(clazz, (T) clazz.newInstance());
            instance = (T) EXTENSION_INSTANCES.get(clazz);
        }
        injectExtension(instance);
        Set<Class<?>> wrapperClasses = cachedWrapperClasses;
        if (wrapperClasses != null && wrapperClasses.size() > 0) {
            for (Class<?> wrapperClass : wrapperClasses) {
                instance = injectExtension((T) wrapperClass.getConstructor(type).newInstance(instance));
            }
        }
        return instance;
    }

	private Map<String, Class<?>> getExtensionClasses() {
        Map<String, Class<?>> classes = loadExtensionClasses();
        return classes;
	}
	
	private Map<String, Class<?>> loadExtensionClasses() {
        Map<String, Class<?>> extensionClasses = new HashMap<String, Class<?>>();
        loadFile(extensionClasses, DUBBO_INTERNAL_DIRECTORY);
        loadFile(extensionClasses, DUBBO_DIRECTORY);
        loadFile(extensionClasses, SERVICES_DIRECTORY);
        return extensionClasses;
    }

	private void loadFile(Map<String, Class<?>> extensionClasses, String dir) {
		... ...
		从参数dir代表的文件夹，即/META-INF/dubbo/internal/等文件夹中加载KeyValue键值对并初始化Value代表的Class，将结果放到extensionClasses这个map中
		举例说明：/META-INF/dubbo/internal/com.alibaba.dubbo.common.extension.ExtensionFactory文件的内容如下：
		spring=com.alibaba.dubbo.config.spring.extension.SpringExtensionFactory
		adaptive=com.alibaba.dubbo.common.extension.factory.AdaptiveExtensionFactory
		spi=com.alibaba.dubbo.common.extension.factory.SpiExtensionFactory
		则初始化这三个class，并且分别以"spring","adaptive","spi"作为key存放到extensionClasses中

		同时，对当前ExtensionLoader实例的cachedAdaptiveClass、cachedWrapperClasses、cachedActivates等变量进行缓存
		... ...
	}

以上代码就是按顺序调用的，可以看到:getExtension(name)的作用就是：

	1、根据/META-INF/dubbo/internal/com.alibaba.dubbo.common.extension.ExtensionFactory文件的内容
		spring=com.alibaba.dubbo.config.spring.extension.SpringExtensionFactory
		adaptive=com.alibaba.dubbo.common.extension.factory.AdaptiveExtensionFactory
		spi=com.alibaba.dubbo.common.extension.factory.SpiExtensionFactory
	2、根据name加载对应的类并实例化
	
	3、在对应的类实例化后，会在createExtension方法中调用injectExtension(instance)，将该实例内部的所有的含set方法的实例变量所代表的对象，尝试用当前ExtensionLoader的objectFactory作为对象工厂创建对象并设置
		objectFactory在当前ExtensionLoader初始化时注入
		objectFactory = (type == ExtensionFactory.class ? null : ExtensionLoader.getExtensionLoader(ExtensionFactory.class).getAdaptiveExtension());
	
	4、在所有的文件中，判断有没有构造方法为对应的type，如果有，则封装为一个wrapperClass(见createExtension倒数四行，在DubboProtocol协议的链式引用中会用到这个功能，较重要)

## 2.4获取一个可以根据传入的URL.protocol或者Parameter或者MethodParameter选择Extension并调用方法的代理类(getAdaptiveExtension) ##
	
这个标题很复杂，但关键在于Adaptive如何理解。

Adaptive含义为自适应，那么什么叫做自适应？如何实现的自适应呢？

2.4.1 自适应的概念

在Dubbo中Adaptive的概念是针对于方法的：

1、如果一个Interface的某个方法含有Adaptive标签，则该类可以生成一个动态代理类

2、代理类的该含Adaptive标签的方法可以正常调用，而不含Adaptive标签的方法调用会报错

3、该含有Adaptive的方法必须有类型为com.alibaba.dubbo.common.URL的参数，或者某参数内部必须有get开头并且返回值为com.alibaba.dubbo.common.URL的无参方法

4、代理类会根据以下三个value从当前ExtensionLoader中获取对象，然后调用当前方法
	
	4.1  URL中的protocpl
	4.2  parameter中的AdaptiveAnnotation的value作为key代表的值
	4.3  methodParameter中的以当前被调用的方法名作为参数的值

举例：

	package com.alibaba.dubbo.rpc;
	@SPI("dubbo")
	public interface Protocol {
	    int getDefaultPort();
	    @Adaptive
	    <T> Exporter<T> export(Invoker<T> invoker) throws RpcException;
	    @Adaptive
	    <T> Invoker<T> refer(Class<T> type, URL url) throws RpcException;
	    void destroy();
	
	}

则getAdaptiveExtension会生成如下代理类，为方便理解，我也删掉一些不重要代码

	package com.alibaba.dubbo.rpc;
	
	public class Protocol$Adpative implements Protocol {
	  public void destroy() {
	    throw new UnsupportedOperationException("method public abstract void com.alibaba.dubbo.rpc.Protocol.destroy() of interface com.alibaba.dubbo.rpc.Protocol is not adaptive method!");
	  }
	
	  public int getDefaultPort() {
	    ... ...
	  }
	
	  public Exporter export(Invoker paramInvoker) throws RpcException {
	    URL localURL = paramInvoker.getUrl();
	    String str = localURL.getProtocol() == null ? "dubbo" : localURL.getProtocol();
	    Protocol localProtocol = (Protocol)ExtensionLoader.getExtensionLoader(Protocol.class).getExtension(str);
	    return localProtocol.export(paramInvoker);
	  }
	
	  public Invoker refer(Class paramClass, URL paramURL) throws RpcException {
	    URL localURL = paramURL;
	    String str = localURL.getProtocol() == null ? "dubbo" : localURL.getProtocol();
	    Protocol localProtocol = (Protocol)ExtensionLoader.getExtensionLoader(Protocol.class).getExtension(str);
	    return localProtocol.refer(paramClass, paramURL);
	  }
	}

由这个接口的Adaptive，以及生成的代理类，即可看到getAdaptiveExtension的作用：生成一个代理类，该代理类内部的含有@Adaptive标签的方法是可以使用的，内部会根据参数来动态获取真正的实例，最终调用实例的方法完成代理


2.4.2如何实现的自适应

可以参考getAdaptiveExtension()方法，同上，我删掉了一些不重要的代码

	public T getAdaptiveExtension() {
        Object instance = cachedAdaptiveInstance.get();
        if (instance == null) {
            instance = cachedAdaptiveInstance.get();
            if (instance == null) {
                try {
                    instance = createAdaptiveExtension();
                    cachedAdaptiveInstance.set(instance);
                } catch (Throwable t) {
                    throw new IllegalStateException("fail");
                }
            }
            
        }
        return (T) instance;
    }

	private T createAdaptiveExtension() {
        return injectExtension((T) getAdaptiveExtensionClass().newInstance());
    }
	
	private Class<?> getAdaptiveExtensionClass() {
        getExtensionClasses();
        if (cachedAdaptiveClass != null) {
            return cachedAdaptiveClass;
        }
        return cachedAdaptiveClass = createAdaptiveExtensionClass();
    }

	private Class<?> createAdaptiveExtensionClass() {
        String code = createAdaptiveExtensionClassCode();
        ClassLoader classLoader = findClassLoader();
        com.alibaba.dubbo.common.compiler.Compiler compiler = ExtensionLoader.getExtensionLoader(com.alibaba.dubbo.common.compiler.Compiler.class).getAdaptiveExtension();
        return compiler.compile(code, classLoader);
    }

	private String createAdaptiveExtensionClassCode() {
		... ...
		在此方法内部动态生成了代理类的代码
		可参考2.4.1章节最后生成的Protocol$Adpative类的实现
		... ...
	}

于是：根据上文我们就清晰了ExtensionLoader.getExtensionLoader(Protocol.class).getAdaptiveExtension()的作用：获取一个Protocol.class的代理类，该代理类会根据参数自动选择真正的实现类是哪一个。

## 2.5获取符合指定group，并且name在values数组中，并且url的parameter的keys在目标的Activate注解的values中存在实现类(getActivateExtension) ##

这个的代码比较简单，大家随便看看就好了，其用途可看public List<T> getActivateExtension(URL url, String[] values, String group)方法，传入一个group和names数组，以及url
根据三个条件，从Extension中筛选符合条件的extension对象

代码如下：

	public List<T> getActivateExtension(URL url, String[] values, String group) {
        List<T> exts = new ArrayList<T>();
        List<String> names = values == null ? new ArrayList<String>(0) : Arrays.asList(values);
        if (! names.contains(Constants.REMOVE_VALUE_PREFIX + Constants.DEFAULT_KEY)) {
            getExtensionClasses();
            for (Map.Entry<String, Activate> entry : cachedActivates.entrySet()) {
                String name = entry.getKey();
                Activate activate = entry.getValue();
                if (isMatchGroup(group, activate.group())) {
                    T ext = getExtension(name);
                    if (! names.contains(name)
                            && ! names.contains(Constants.REMOVE_VALUE_PREFIX + name) 
                            && isActive(activate, url)) {
                        exts.add(ext);
                    }
                }
            }
            Collections.sort(exts, ActivateComparator.COMPARATOR);
        }
        List<T> usrs = new ArrayList<T>();
        for (int i = 0; i < names.size(); i ++) {
        	String name = names.get(i);
            if (! name.startsWith(Constants.REMOVE_VALUE_PREFIX)
            		&& ! names.contains(Constants.REMOVE_VALUE_PREFIX + name)) {
            	if (Constants.DEFAULT_KEY.equals(name)) {
            		if (usrs.size() > 0) {
	            		exts.addAll(0, usrs);
	            		usrs.clear();
            		}
            	} else {
	            	T ext = getExtension(name);
	            	usrs.add(ext);
            	}
            }
        }
        if (usrs.size() > 0) {
        	exts.addAll(usrs);
        }
        return exts;
    }

很简单

# 三、DUBBO-SPI机制迷思 #

DUBBO-SPI机制是个很神奇的机制：我第一次看的时候，觉得这个东西非常没用；第二次看的时候发现坑好多，莫名其妙就会冒出一个未知的内容;第三次看的时候发现有点意思;

但同时我们需要注意到：还有没有其他的实现方式？xml？json?环境变量？或者远程注册中心?可以多尝试一下。