---
layout: post
title:  "[KANMARS原创]-基于隐层的前馈式神经网络之brain.js"
desc: "这是一个基于隐层的前馈式神经网络的js实现"
date: 2016-05-07 03:16:00
tags: [server,neuralnetwork]
---
睡不着，翻译点资料......

好久之前帮同学写过一篇论文，大致是基于ELM（Extreme Learning Machine极限学习机）的前馈式神经网络.

因此对神经网络的一些概念还算了解。

凑巧最近对人工智能感兴趣，所以百度了一下成型的产品，比如brain.js，然后翻译以及阅读一下。

brain.js是一个javascript的神经网络，（最近javascript越来越万能了，大家一定要摒弃javascript就是在浏览器上专用的这个概念，随着时代的发展，随着掌握编译技术的IT工程师的泛滥，随手写个虚拟机已经不是什么难事，随手创造一门语言也并非太难--这也是为什么IT语言有近两千种之多的原因。javascript由于v8引擎的大肆扩展，已经成为了一门扩展性和方便性极强的语言，将来会是大热）

关于brain.js的官网如下地址：
>http://www.open-open.com/lib/view/open1436520926911.html

其使用说明很简单：

	var net = new brain.NeuralNetwork();

	net.train([

		{input: { r: 0.03, g: 0.7, b: 0.5 }, output: { black: 1 }},

		{input: { r: 0.16, g: 0.09, b: 0.2 }, output: { white: 1 }},

		{input: { r: 0.5, g: 0.5, b: 1.0 }, output: { white: 1 }}
    
		]);

	var output = net.run({ r: 1, g: 0.4, b: 0 });  // { white: 0.99, black: 0.002 }

这个例子很简单，但是其原理就需要你好好的学习一下机器学习和人工智能类的资料了。

**知识点铺垫**

1、在“学习”领域，一般先要选择学习策略，机器的学习策略有如下几种：机械学习、示教学习、演绎学习、类比学习、基于解释的学习、归纳学习

2、而学习的结果，即所获取的知识的表示形式:代数表达式参数、决策树、形式文法、产生式规则、形式逻辑表达式、图和网络、框架和模式、计算机程序和其它的过程编码、神经网络、多种表示形式的组合

3、机器学习方法有这么几类：经验性归纳学习、分析学习、类比学习、遗传算法、联接学习、增强学习

4、学习形式分类：监督学习、非监督学习

**前馈式神经网络**

1、前馈神经网络（feedforward neural network），简称前馈网络，是人工神经网络的一种。在此种神经网络中，各神经元从输入层开始，接收前一级输入，并输入到下一级，直至输出层。整个网络中无反馈，可用一个有向无环图表示。

2、感知器网络是最简单的前馈网络，它主要用于模式分类，也可用在基于模式分类的学习控制和多模态控制中。感知器网络可分为单层感知器网络和多层感知器网络。

3、**BP网络**指连接权调整采用了反向传播（Back Propagation）学习算法的前馈网络。与感知器不同之处在于，BP网络的神经元变换函数采用了S形函数（Sigmoid函数），因此输出量是0~1之间的连续量，**可实现从输入到输出的任意的非线性映射**。

4、RBF网络是指隐含层神经元由RBF神经元组成的前馈网络。RBF神经元是指神经元的变换函数为RBF（Radial Basis Function，径向基函数）的神经元。典型的RBF网络由三层组成：一个输入层，一个或多个由RBF神经元组成的RBF层（隐含层），一个由线性神经元组成的输出层。


5、隐藏层是特别有趣的。 通过通用逼近定理 ,一个带有有限数量的神经元单隐层网络可以被训练来近似一个任意随机函数。 换句话说,一个隐藏层是强大到足以学习 任何 函数。 也就是说,我们在实践中使用多层会学习得更好(即隐藏层。 深网)

----------------------------------

或许看完这些大家还不理解什么是神经网络，那就看一张图吧，是神经网络的模型结构

![](http://www.jdon.com/simgs/bigdata/mla13.png)


在这个结构中，黄色的Input模拟的是输入层，经整理后的信号从此处输入

灰色的Output模拟的是输出层，经处理后的信号从此处输出

中间橘黄色的为隐层，负责模拟神经元的链接和权重值

还可以看到一些灰色的线，代表了信号的传输方向，可以看到，每个信号传给了所有的神经元，每个神经元处理后又输出为真实信号。

那么从数学模型上，这个模型含有如下内容：

1、输入信号的数量n  Number of Input

2、输入信号传输给各隐层节点的权重W

3、隐层节点内部的非线性激活函数f(x)

4、隐层节点内部的参数

在学习过程中，整理后的数据被分为两部分，一部分为训练集，一部分为测试集。神经网络从训练集开始训练，训练完成之后，就可以对测试集进行测试。

那么怎么评价一个神经网络的好坏呢？

评价标准很多，但我“个人认为”比较重要的标准有如下两个：

1、学习速度（之前帮同学写的那篇论文，就是在学习速度上有所优化）

2、学习效率（耗费更少的学习效率）

--------------------------------------

如果你看懂了上面这些简单的铺垫，那么我们就可以来阅读brain.js了

代码可以从下面地址获取到

>https://github.com/harthur/brain/blob/master/lib/neuralnetwork.js

代码很简单，570行。刚看到时，我的第一反应是：做算法的人往往没有工程思维，而做工程的往往对算法又忽略不计，所以算法+工程这个行业还大有发展前途。

这个js文件中，首先要看神经网络的结构：

//设置默认值

	var NeuralNetwork = function(options) {

		options = options || {};

		this.learningRate = options.learningRate || 0.3;

		this.momentum = options.momentum || 0.1;

		this.hiddenSizes = options.hiddenLayers;	//隐层数量

		this.binaryThresh = options.binaryThresh || 0.5;
	}

//在原型上创建诸多函数

NeuralNetwork.prototype={

	initialize://初始化

	train://训练方法

	trainPattern : //真·训练方法

	calculateDeltas://计算误差方法

	adjustWeights://权重判断方法
	
	run://测试集方法

	runInput://真·测试集方法

	formatData: //一些这样的或者那样的方法

	test : //一些这样的或者那样的方法

	toJSON://一些这样的或者那样的方法

	fromJSON://一些这样的或者那样的方法

	createTrainStream：//一些这样的或者那样的方法

}

//创建一些全局函数

randomWeight

zeros

randos

mse

......//一些这样的或者那样的方法

那么我们看这个brain.js的方法，就需要按照我上面列的“在原型上创建诸多函数”的顺序去读（该顺序也是调用顺序）

1.initialize://初始化

在初始化时，代码如下：

	this.biases = []; // weights for bias nodes

	this.weights = []; 

	this.outputs = [];

	this.deltas = [];
 
	this.changes = []; // for momentum

	this.errors = [];

这个操作最主要的是创建了：biases，weights，outputs这三个数组，分别代表了 **biases偏差**，权重，输出

2.train训练方法

核心代码为：

	data = this.formatData(data);

		。。。。。。

	for (var i = 0; i < iterations && error > errorThresh; i++) {
      var sum = 0;
      for (var j = 0; j < data.length; j++) {
        var err = this.trainPattern(data[j].input, data[j].output, learningRate);
        sum += err;
      }
      error = sum / data.length;

      if (log && (i % logPeriod == 0)) {
        log("iterations:", i, "training error:", error);
      }
      if (callback && (i % callbackPeriod == 0)) {
        callback({ error: error, iterations: i });
      }
    }
可以看到，在训练方法里，根据iterations参数（默认20000），反复对data[]数据集进行训练

data[]数据集为训练集


3.trainPattern真·训练方法

	learningRate = learningRate || this.learningRate;//学习的权重

    // forward propogate
    this.runInput(input);//运行真测试方法，在机器学习领域，运行和测试对机器来说是一样的，仅是对人类的“观察该学习是否有效”而言有区别

    // back propogate
    this.calculateDeltas(target);//计算误差
    this.adjustWeights(learningRate);//决定权重

    var error = mse(this.errors[this.outputLayer]);
    return error;
4.runInput真·测试方法
	this.outputs[0] = input;  // set output state of input layer

    for (var layer = 1; layer <= this.outputLayer; layer++) {
      for (var node = 0; node < this.sizes[layer]; node++) {
        var weights = this.weights[layer][node];

        var sum = this.biases[layer][node];
        for (var k = 0; k < weights.length; k++) {
          sum += weights[k] * input[k];
        }
        this.outputs[layer][node] = 1 / (1 + Math.exp(-sum));
      }
      var output = input = this.outputs[layer];
    }
    return output;
该方法先根据biases数组获取的当前神经元的biases偏差，赋值给sum

然后根据weight从各个输入层获取输入信号，然后乘以weight，最终叠加到sum上

然后根据输出函数this.outputs[layer][node] = 1 / (1 + Math.exp(-sum));计算出当前神经元的输出，放入到outputs中

这样就完成了一个神经元的：接收各个上层神经元突触传递的信号，并且传递给下层神经元的功能。

据高级专家研究，layer层数越多，越能学习到足够复杂的知识，但绝大多数人类遇到的问题，一层layer已经足够了

5、calculateDeltas计算误差

在每一次学习或者测试一个数据之后，需要对神经网络模型进行“学习后的修正”，第一步需要计算误差，第二步需要根据误差调整权重

此处的calculateDeltas计算误差即为第一步计算误差

	for (var layer = this.outputLayer; layer >= 0; layer--) {
      for (var node = 0; node < this.sizes[layer]; node++) {
        var output = this.outputs[layer][node];

        var error = 0;
        if (layer == this.outputLayer) {
          error = target[node] - output;
        }
        else {
          var deltas = this.deltas[layer + 1];
          for (var k = 0; k < deltas.length; k++) {
            error += deltas[k] * this.weights[layer + 1][k][node];
          }
        }
        this.errors[layer][node] = error;
        this.deltas[layer][node] = error * output * (1 - output);
      }
    }
代码很简单，计算error错误的根据weight的加权值，然后根据公式this.deltas[layer][node] = error * output * (1 - output);计算出真正的deltas

6、adjustWeights重新分配权重

	for (var layer = 1; layer <= this.outputLayer; layer++) {
      var incoming = this.outputs[layer - 1];

      for (var node = 0; node < this.sizes[layer]; node++) {
        var delta = this.deltas[layer][node];

        for (var k = 0; k < incoming.length; k++) {
          var change = this.changes[layer][node][k];

          change = (learningRate * delta * incoming[k])
                   + (this.momentum * change);

          this.changes[layer][node][k] = change;
          this.weights[layer][node][k] += change;
        }
        this.biases[layer][node] += learningRate * delta;
      }
    }
代码很简单，根据delta和change和learningRate修改当前神经元的权重weights

7、run 测试方法
	if (this.inputLookup) {
      input = lookup.toArray(this.inputLookup, input);
    }

    var output = this.runInput(input);

    if (this.outputLookup) {
      output = lookup.toHash(this.outputLookup, output);
    }
    return output;

run方法为通过调用runInput真·测试方法来完成了运行，并且将output输出。

------------------------------------------------------
以上即为brain.js的代码分析

根据这个js，我们就可以做出这样的一个简单的功能：

1、准备一些训练数据，

2、对这个神经网络进行训练，

3、将训练结果固化为JSON对象，

4、使用训练结果对测试数据进行测试。

这样我们就可以实现从抽象规范数据到抽线规范结果的处理了。

例如文章最前面的例子

	var net = new brain.NeuralNetwork();

	net.train([

		{input: { r: 0.03, g: 0.7, b: 0.5 }, output: { black: 1 }},

		{input: { r: 0.16, g: 0.09, b: 0.2 }, output: { white: 1 }},

		{input: { r: 0.5, g: 0.5, b: 1.0 }, output: { white: 1 }}
    
		]);

	var output = net.run({ r: 1, g: 0.4, b: 0 });  // { white: 0.99, black: 0.002 }

进行解读的话，我们准备了三个训练数据，数据为：

{input: { r: 0.03, g: 0.7, b: 0.5 }, output: { black: 1 }}

{input: { r: 0.16, g: 0.09, b: 0.2 }, output: { white: 1 }}

{input: { r: 0.5, g: 0.5, b: 1.0 }, output: { white: 1 }}

通过调用net.train方法，我们对神经网络进行了训练，通过训练修正了内部的biases和weight，即修改了神经元节点的偏差和连接权重

之后训练成功

最后调用

var output = net.run({ r: 1, g: 0.4, b: 0 });  // { white: 0.99, black: 0.002 }

我们将这个神经网络输入了一个测试值，然后我们的神经网络告诉我们，这个颜色是白色的

这是个很神奇的例子。Isn't it ?

-------------------------------------------------------------

神经网络能实现规范数据  到 规范结果的模拟处理

那么我们还有个重要问题是：如何把数据规范化

例如：图片数据、声音数据、指纹数据、围棋...


以我之前搜索的一些资料：

1、图片数据是通过如下步骤处理的：先分解为4等分，求其每等分的平均颜色，生成一个color[4]数组，再分解为16等分，生成一个color[16]数组，再分解为64等分，生成一个color[64]数组......

最终将color[4],color[16],color[64],color[256]....组合成一定的格式，作为标准数据。

例如谷歌之前做过一个神经网络，试图在互联网上认识一张图片是猫，似乎采用的就是这种数据处理方法

2、声音处理：这是一个复杂的领域，我仅知道采用了傅立叶变化，将声波分解为不同的频率值，最终生成了一个频率的序列，之后进行的标准化处理，但是具体步骤未知，概率论和三角函数都不甚了解

3、指纹数据：未知

4、围棋：阿尔法狗的神作，是由两层神经网络构成，价值网络和策略网络，目前已经击败了人类围棋选手。我的评价是：这个真的是人类击败了人类，因为神经网络内部储存的数据其实是训练集的映象，阿尔法狗的训练集是全人类的围棋棋谱。

-------------------------------------------------------------------
如我所说的：做算法的工程知识一般很欠缺，而做工程的一般非常鄙视算法。

因此在算法+工程领域是大有可为的，比如：在工程学上构建可初始化的人工智能大脑，可以提供基础训练和映象备份功能，可以提供任意时间点回退功能，可以提供模块化扩展功能...............

这个领域没有人做过，是一片空白。
