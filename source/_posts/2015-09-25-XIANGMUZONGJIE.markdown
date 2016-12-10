---
layout: post
title:  "[KANMARS原创] - 近期项目经验总结"
desc: "最近总结了一下前段时间做过的项目，包括项目管理的和技术方案两部分的内容"
date: 2015-09-25 15:57:22
tags: [server]
---
<br />
<p>
	项目经验总结
</p>
<p>
	总结方面：项目管理方面，技术方案方面
</p>
<h3>
	<strong>项目管理方面</strong> 
</h3>
<p>
	1、需求的确定
</p>
<p>
	&nbsp;&nbsp;&nbsp; 项目最忌讳需求不确定，如果需求不确定，会导致项目变动频繁，进而开发人员丧失信心，进而消极怠工，进而遥遥无期。
</p>
<p>
	&nbsp;&nbsp;&nbsp; 因此需求尽量要在最开始就确定。确定方式为：（1）确定系统建设目的（大需求）；（2）分模块确认需求；（3）分析需求和需求之间的关系；（4）确认业务流程。
</p>
<p>
	&nbsp;&nbsp;&nbsp; （1）确定系统建设目的：
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 在项目中经常遇到这样的情况：主次不分。
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;比如：某团队要建设一个**项目，项目如何开展？开发负责人一接手就开始建设各子系统：基础模块、监控模块、权限模块、数据分析模块......。三个月后，一堆基础的东西出来了，但是项目仍然不可使用，甚至连demo都没有，于是被无情开除。
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 分析其问题，就是开发负责人主次不分。<span style="color:#E53333;background-color:#000000;"></span> 
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;任何系统都有主要系统，也有次要系统。主要系统就好比是一个数字之前的1，而次要系统就是这个数字后面的0。如果主要系统都没弄好，次要系统再多也没有意义。
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 因此，让主要系统可以运行显得无比重要。而指出哪些需求是主要系统，哪些需求是次要系统，是开发负责人不可推卸的责任。
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 如何判断一个系统是主要的、还是次要的？
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 必须要深入了解系统建设目的，然后按照如下几步来筛选：
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; a、如果缺少它无法完成建设目的，则该系统是主要系统，剩下的是次要系统。
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; b、如果增加该系统可以大大提高建设目的的成功率，则该系统是主要系统。
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; c、如果增加该系统在近期内无法体现出足够有效的效果，则该系统是次要系统。
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 经过如此筛选，则一个项目中能列入主需求的，估计只剩原需求的20%，成功率提升80%。
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;总结其经验：<span style="color:#E53333;background-color:#000000;">先让程序能用，接着让程序好用，再让程序员轻松，最后再让项目脱离了任何人都能稳定运行。</span> 
</p>
<p>
	&nbsp;&nbsp;&nbsp; （2）分模块确认需求
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 在对系统的主次进行区分后，然后才是对分模块进行细致的确认
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 在这个方面，需要根据业务流程进行分析，正确的业务流程是模块流程的基础。
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 这个阶段的要点是：让必须业务人员参与的工作减至最少。
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 因为从稳定性上说，系统内部流程远远大于人工操作。
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 于是我们得到一个推论：<span style="background-color:#000000;color:#E53333;">为了系统稳定，必须尽可能的让系统自动化实现一切功能，避免人工参与。所以，必须了解子模块在一个标准业务流程中的具体功能和详细步骤。</span> 
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 如果一个模块特别复杂，则把模块进行切分，切成两个、三个独立的异步的小模块。
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 模块的失败，源于模块的复杂；模块的复杂，源于模块切分的不合理；模块切分的不合理，源于开发负责人对系统需求的把握不足。
</p>
<p>
	&nbsp;&nbsp;&nbsp; （3）分析需求和需求之间的关系
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 在模块划分好之后，最害怕的是关联模块的影响。
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 比如我们在第二步，把某个大的模块，切割成了A，B，C三个模块，那么这三个模块就是关联的，如果对某模块进行修改，则可能会影响一大片的需求。
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 如果想避免对模块的修改导致整个系统的大改，则开发负责人必须对需求和需求之间的关系理清，条件反射程度的明白改一个小模块会对其他模块造成什么毁灭性的影响。
</p>
<p>
	&nbsp;&nbsp;&nbsp; （4）确认业务流程
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 在系统建设目的，分模块确认需求，分析需求和需求之间的关系后。我们得到了一堆合理合法的积木。
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 接下来需要做的就是要把这堆积木合理的组装起来，这就是业务流程的重要性，<span style="background-color:#000000;color:#E53333;">业务流程是锁链，正确的业务流程才能把需求联合起来</span>。
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; PS：曾经有同事和我争论面向过程和面向对象的优劣，进而讨论我们的系统是应该以对象架构出现，还是以业务流程模型出现。
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 我保留个人意见，因为类似思想的争论没有意义，如果有人争论面向过程、面对对象哪个好，我特别想告诉他，地球上还有面向函数、对称多处理、管道流、面向构件的架构、中间件技术、仓库风格......
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 跳出“面向过程”和“面向对象”这狭小的两个点来看，争论这个是毫无意义的。
</p>
<p>
	<br />
</p>
<p>
	2、项目开发模型的选型：
</p>
<p>
	&nbsp;&nbsp;&nbsp; 有不同的项目开发模型，常用的是瀑布模型，和近两年很火的敏捷开发。此外还有很多其他的模型，例如极限编程、统一过程等。
</p>
<p>
	&nbsp;&nbsp;&nbsp; 我之前是瀑布模型和统一过程的信众，内心中深深的鄙视敏捷开发，直到今天早上才想开，原来我错了，大家都错了......
</p>
<p>
	&nbsp;&nbsp;&nbsp; <span style="background-color:#000000;color:#E53333;">没有最好的开发模型：项目的大小与复杂度，决定了项目适合用的开发模型。</span> 
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;<span style="background-color:#000000;color:#E53333;">大而复杂的项目，必须使用瀑布模型</span>：严格从需求分析、概要设计、详细设计、测试、试运行、正式上线；
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;<span style="background-color:#000000;color:#E53333;">中等规模的项目适合于统一过程</span>：用例驱动、以基本架构为中心、迭代和增量。UP是一个不停迭代的过程。初始、细化、构建、交付。
</p>
<p>
	&nbsp;&nbsp;&nbsp; <span style="background-color:#000000;color:#E53333;">小规模的项目适合于敏捷开发</span>：开发人员和业务专家紧密协作、面对面沟通、频繁交付新的软件版本、紧凑和自我组织型团队。
</p>
<p>
	<br />
</p>
<p>
	&nbsp;&nbsp;&nbsp; 人是活着的人，最忌讳的是死板，没有任何一个项目是按照开发模型一步一步走就可以成功的。否则世界上不会有这么多失败的项目。
</p>
<p>
	&nbsp;&nbsp;&nbsp; 根据项目规模、难度来选择瀑布模型，还是统一过程、或者敏捷开发。（合格项目经理的水准）
</p>
<p>
	&nbsp;&nbsp;&nbsp; 然后再灵活一点，以统一过程为基准，根据项目的困难度选择自己更像瀑布模型一些，还是更像敏捷开发一些。（高级项目经理水准）
</p>
<p>
	&nbsp;&nbsp;&nbsp; 根据项目的进度，随时调整项目规模，调整开发模型，同时保持团队的稳定性和凝聚力，保持项目的目标统一。（顶级项目经理水准）
</p>
<p>
	&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp; 同时一定要避免陷入如下境地：“为灵活而灵活”、“为了灵活而放弃了一切、乃至癫狂甚至猖狂”、“为了灵活甚至放弃了自己的底线”
</p>
<p>
	<br />
</p>
<p>
	3、项目的优先度问题
</p>
<p>
	&nbsp;&nbsp;&nbsp; 项目是有优先度的。每个人都有每个人的认识和见解。
</p>
<p>
	&nbsp;&nbsp;&nbsp; 我的理解如下：优先度是可以变化的，随着时期或者环境的变化、优先度可以随时调整。
</p>
<p>
	&nbsp;&nbsp;&nbsp; 在今年早些时候，我的优先度是：项目进度&gt;程序员开心度&gt;项目的完整度&gt;项目的合理性
</p>
<p>
	&nbsp;&nbsp;&nbsp; 而现在这个时间，我的优先度是：项目的稳定性&gt;项目的合理性&gt;程序员开心度&gt;项目的完整度&gt;项目进度 &nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp;
</p>
<p>
	&nbsp;&nbsp;&nbsp; 可以看到，早期我把项目的稳定性彻底抛弃了，这是环境、人员、条件限制下不得不做出的牺牲。因此没少和测试部门打仗---各种环境不稳定、各种随时重启、各种404和500。
</p>
<p>
	&nbsp;&nbsp;&nbsp; 而在后期，随着各个环境、人员、资源问题的解决，对项目的优先度进行了重新排序，把我们可以顾及到的东西都排到了优先度里。
</p>
<p>
	<br />
</p>
<p>
	&nbsp;&nbsp;&nbsp; 优先度的调整、是受整体环境影响的，需要根据环境的变化而变化。
</p>
<p>
	&nbsp;&nbsp;&nbsp; <span style="background-color:#000000;color:#E53333;">我们必须有一个信念，在有机会做的更好的时候，我们一定要追求极致。体现在优先度上，就是资源充足的情况下，排在项目进度之前的内容会逐步增加。</span> 
</p>
<p>
	<br />
</p>
<p>
	4、人员开心问题
</p>
<p>
	&nbsp;&nbsp;&nbsp; 俗话说：有钱难买爷高兴。
</p>
<p>
	&nbsp;&nbsp;&nbsp; 人员的开心度、最终会成为团队稳定性的关键指标。
</p>
<p>
	&nbsp;&nbsp;&nbsp; 如何保持团队的开心度，莫过于“团队源源不断的成功”+“己所不欲勿施于人”
</p>
<p>
	<br />
</p>
<p>
	<br />
</p>
<h3>
	<strong>技术方案方面</strong> 
</h3>
<p>
	<br />
</p>
<p>
	我必须承认：早期我们是走了弯路的，因此我们有一堆BUG要修改。其根本原因在于早期我们的无知和短视。 &nbsp;&nbsp;
</p>
<p>
	同时我也必须声明：与过去相比，我们确实走在直线上；但与未来比较，我们一定是从一条弯路走进了另一条稍直的弯路。
</p>
<p>
	上周六我看到一句话：“未来不能靠空想出来，而是只能通过对过去不停的批判，总结经验与教训，一步一步走向未来”
</p>
<p>
	我深以为然。
</p>
<p>
	程序架构是不能空想的，我们必须批判自己的过去，多多阅读同行的尝试，从同行的尝试中吸取经验与教训，改进我们自身，然后才能逐步进化。
</p>
<p>
	显然，我们已经进化了一次，从CP模型进化到了伪AP模型---&gt;<span style="background-color:#000000;color:#E53333;">意味着我们还需要一次进化，从伪AP进化到真AP模型</span>。
</p>
<p>
	<br />
</p>
<p>
	<span style="background-color:#000000;color:#E53333;">CAP理论</span> 
</p>
<p>
	参考http://blog.csdn.net/chen77716/article/details/30635543
</p>
<p>
	参考http://blog.csdn.net/cutesource/article/details/5621725
</p>
<p>
	在系统设计中有一个CAP理论，即在大型系统中，一致性C，可用性A，分区兼容性P，这三个属性只能同时满足其中的两个。
</p>
<p>
	<br />
</p>
<p>
	所谓一致性Consistency，即是数据库理论ACID中的C，所有的数据都是一致的，没有冲突的。
</p>
<p>
	所谓可用性Availability，即是系统整体是高可用的。
</p>
<p>
	所谓分区容错性Partition Tolerance，就是一旦开始将数据和逻辑分布在不同的节点上，就有形成partition的风险。假定网线被切断，partition就形成了，节点A无法和节点B通讯。由
于Web提供的这种分布式能力，临时的partition是一个常见的情况，如之前说所的，在全球化的有多个数据中心的公司中这并不罕见。
</p>
<p>
	<br />
</p>
<p>
	由于分区容错性P在系统建设中是必选的，那么我们的系统建设就只有两种选择：
</p>
<p>
	CP模型：放弃系统的可用性，而选择了一致性+分区容错性。
</p>
<p>
	AP模型：放弃了系统的搞一致性，而选择了高可用+分区容错性。
</p>
<p>
	<br />
</p>
<p>
	<span style="background-color:#000000;color:#E53333;">业内目前的大型分布式系统多使用的是AP模型，即临时性的“放松”对系统一致性的要求，但是提升了系统的可用性和无限扩展性。</span> 
</p>
<br />
<br />
<p>
	<span style="background-color:#000000;color:#E53333;">金融部门早期技术方案</span> 
</p>
<p>
	早期由于各种限制，例如经验不足等原因。我们的系统结构是CP的，就是系统一致+分区容错。
</p>
<p>
	体现在代码结构上，就是：
</p>
<p>
	&nbsp;&nbsp;&nbsp; 1、web层直接对数据库进行操作。
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2、数据库作为中央的逻辑处理，例如事务控制，任务锁定
</p>
<p>
	&nbsp;&nbsp;&nbsp; 3、用负载均衡提升应用层的可用性，用RAC提升数据库的可用性
</p>
<p>
	&nbsp;&nbsp;&nbsp; 4、使用分布式事务来处理多数据库问题
</p>
<p>
	对代码进行反思，其缺陷如下：
</p>
<p>
	&nbsp;&nbsp;&nbsp; 1、web层直接对数据库进行操作，可能导致数据库链接数成为web层的瓶颈，导致web层无法进行大规模横向扩展
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2、数据库作为中央的逻辑处理，例如事务控制，金额控制，任务锁定等，会导致数据库的压力过大，在业务猛增时可能导致数据库瘫痪
</p>
<p>
	&nbsp;&nbsp;&nbsp; 3、分布式事务的二段提交，会导致<span style="background-color:#000000;color:#E53333;">可用性直线下降</span>，导致<span style="background-color:#000000;color:#E53333;">可扩展性指数级下降</span>。
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;当系统需要横向扩展时，分布式事务会使每个数据库的不稳定性增加，进而形成<span style="background-color:#000000;color:#E53333;">指数级</span>下降可扩展性的惨剧。
</p>
<p>
	<span style="background-color:#000000;color:#E53333;">金融部门目前的技术方案</span> 
</p>
<p>
	金融部门目前的总体架构是：面向服务化、状态控制的异步任务处理的系统架构。
</p>
<p>
	与早期技术方案相比，最大的进化点在于，在架构中引入了面向服务化的内容。
</p>
<p>
	<br />
</p>
<p>
	在代码结构上：
</p>
<p>
	&nbsp;&nbsp;&nbsp; 1、通过DUBBO服务化，将系统的前端和服务进行解耦，使得前端获得了近似无限的扩展能力。如果遇到大流量的业务扩展，通过增加前端服务器即可初步满足。
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2、服务外观层的提出，使得系统结构可以将业务逻辑进行封装和组合，便于系统针对单独的服务进行横向扩展。
</p>
<p>
	&nbsp;&nbsp;&nbsp; 3、解决了历史遗留问题，代码趋于合理有序。
</p>
<p>
	但我们必须认识到还有如下问题没有解决：
</p>
<p>
	&nbsp;&nbsp;&nbsp; 1、数据库作为中央的逻辑处理，例如事务控制，金额控制，任务锁定等，会导致数据库的压力过大，在业务猛增时可能导致数据库瘫痪
</p>
<p>
	&nbsp;&nbsp;&nbsp; 2、数据库数据关联比较严重，有可能在将来拆分时会遇到较大问题。
</p>
<p>
	这些问题是我们需要在半年或者一年内解决的问题。
</p>
<p>
	<br />
</p>
<p>
	如上文所说：一味的空想解决不了问题，我们必须从同行中寻找解决方案。
</p>
<p>
	<br />
</p>
<p>
	<br />
</p>
<p>
	我们需要学习一下ebay、taobao的解决方式，进而对我们的问题加以解决。
</p>
<p>
	<span style="background-color:#000000;color:#E53333;">ebay的可伸缩性实践</span> 
</p>
<p>
	&nbsp;&nbsp;&nbsp; 参见《可伸缩性最佳实践：来自ebay的经验》http://kb.cnblogs.com/page/157745/
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;在一个可伸缩的架构中，资源的消耗应该随负载线性（或更佳）上升，负载可由用户流量、数据量等测量。如果说性能衡量的是每一工作单元所需的资源消耗，可伸缩性则是衡量当工作单元的数量或尺寸增加时，资源消耗的变化情况。换句话说，可伸缩性是整个价格-性能曲线的形状，而不是曲线上某一点的取值。
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;可伸缩性有很多侧面——事务的方面、运营的方面、还有开发的方面。我们在改善一个Web系统的事务吞吐量的过程中学到了很多经验，本文总结了其中若 
干关键的最佳实践。可能很多最佳实践你会觉得似曾相识，也可能有素未谋面的。这些都是开发和运营eBay网站的众人的集体经验结晶。
</p>
<p>
	&nbsp;&nbsp;&nbsp; <strong>最佳实践 #1：按功能分割：在编码层次，将代码分割为不同的jar、不同的包<strong>、</strong>不同的Bundle；在应用层次，将应用切割为不同的类型、如销售功能应用池、投标功能应用池，方便根据复杂独立对应用进行扩展；在数据库层次，将不同的数据放到不同的数据库中。</strong> 
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;<strong>最佳实践 #2：水平切分：在应用层次，务必使每个应用都是无状态的，就可以轻而易举的使应用进行水平切分；在数据库层次略有难度，可以根据用户ID的mod，根据订单mod进行水平切分，把相同的数据，根据访问路径散列到不同的数据库中。<br />
</strong> 
</p>
<p>
	<strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 水平切分方案很多，例如：主键取模；区间分割；查找表；比较复杂的“全局唯一ID”+“一致性hash”；</strong> 
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;<strong>最佳实践 #3：避免分布式事务：ebay是通过采用一些技术来帮助系统达到最终的一致性（eventual consistency）：周密调整数据库操作的次序、异步恢复事件，以及数据核对（reconciliation）或者集中决算（settlement batches）</strong> 
</p>
<p>
	<strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; taobao的方案是软事务，通过程序来实现了分布式事务。</strong> 
</p>
<p>
	<strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 通过放松系统的临时一致性，要求系统的最终一致性，就可以有效的提升系统的可伸缩性<br />
</strong> 
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;<strong>最佳实践 #4：用异步策略解耦程序：把过程分解为阶段（stages or phases），然后将它们异步地连接起来，这是伸缩的关键。</strong> 
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;<strong>最佳实践 #5：将过程转变为异步的流：任何可以晚点再做的事情都应该晚点再做。异步性可以从根本上降低基础设施的成本。将昂贵的处理过程转变为异步的流，基础设施就不需要按照峰值来配备，只需要满足平均负载。</strong> 
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;<strong>最佳实践 #6：虚拟化所有层次：虚拟化和抽象化无所不在，计算机科学里有一句老话：所有问题都可以通过增加一个间接层次来解决。操作系统是对硬件的抽象，而许多现代语言所用的虚拟机又是对操作系统的抽象。</strong> 
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;<strong>最佳实践 #7：适当地使用缓存：最适合缓存的是很少改变、以读为主的数据。</strong> 
</p>
<p>
	<strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;当你开始依赖于缓存，那么主要系统就只需要满足缓存未命中时的处理要求，自然而然你就会想到可以削减主要系统。</strong> 
</p>
<p>
	<strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;但当你这样做之后，系统就完全离不开缓存了。现在主要系统没办法直接应付全部流量，也就是说网站的可用性取决于缓存能否100%正常运行——潜在的危局。<br />
</strong> 
</p>
<p>
	&nbsp;&nbsp;&nbsp;&nbsp;<strong>《可伸缩性最佳实践：来自ebay的经验》的作者:</strong>Randy 
Shoup&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 是eBay的杰出架构师。从2004年起担任eBay搜索基础设施的主要架构师。在加入eBay之前，他是Tumbleweed 
Communications公司的总架构师，也曾在Oracle和Informatica担任多个软件开发和架构的职位。
</p>
<p>
	<br />
</p>
<p>
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
</p>
<p>
	以上就是我对最近项目的总结。
</p>
<p>
	<br />
</p>