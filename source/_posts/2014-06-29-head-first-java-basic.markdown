---
layout: post
author: jeromechan
comments: true
date: 2014-06-29 00:55:29
slug: head-first-java-basic
title: 入门JAVA，你需要知道的一些简单的不能再简单了的知识点
wordpress_id: 14
permalink: /2014/06/29/head-first-java-basic/
categories:
- 编程语言
tags:
- Java
---


	
#### 编程离不开参考物，Java的强大正在于它的海纳百川

	
#### 一、Java的参考文档形式：
1. 原生HTML形式
2. 排版CHM形式
3. 其它…

	
#### 二、从Java doc里看ooad世界
1. 包-接口-类-异常-错误的阐述，应有尽有
2. 类的方法和属性的说明和使用说明，让你一如既往都感觉是在书写hello world

	
#### 三、package的分类
1. java.*：基础语言包
2. javax.*：jdk扩展包
3. org.*：第三方功能包
4. com.sun.*：sun公司提供的功能包，因其不具备兼容性，变更大，并不在std-api-doc内公开<!-- more -->

	
#### 四、java.lang包
1. 默认自动引入
2. 包含了Java语言所需要的基本功能类和接口的信息，是进行Java编程的基础
3. Object类  

	<1> Object类是Java语言的灵魂，所有的Java类（除了Object类）都是Object类的儿子，它的所有方法将出现在所有类的内部，这就是Java继承树的唯一根，这就是独具Java语言特色的单根继承体系
	
	<2> equals方法  
	判断两个对象内容是否相同。Object.equals()实现如下：
	
	![clip_image002](/images/2014-06-29-head-first-java-basic/clip_image0024_thumb.jpg)  
	
	<3> finalize方法
	概念与构造函数相反，如同C++中的析构函数一般，该方法会被JVM自动调用执行垃圾回收。
	
	<4> hashcode方法
	获取一个散列码数值，使用这个散列码可以快速判断对象是否**不相同**。
	两个内容相同的对象，hashcode返回值必须相同，而对于两个不相同的对象，返回的hashcode也有可能相同。
	
	<5> toString方法  
	显示对象内容时会被系统自动调用的方法
	
	![clip_image004](/images/2014-06-29-head-first-java-basic/clip_image0044_thumb.jpg)

4. Math类
	<1> 放置常用的数学常数和方法
	<2> 类的常数和方法皆是静态类型的

5. String和StringBuffer
	都是代表任意多个字符串组成的序列，两者实现的区别，一般把String看成固定的字符串，而StringBuffer看成可变的字符串。并不是说前者不能变更，而是因为前者变更如同品牌笔记本维修主板一般，直接取新替换，浪费机器资源；而后者则是维修自身。
	String类的声明
	
	![clip_image005](/images/2014-06-29-head-first-java-basic/clip_image0054_thumb.png)
	
	其实String类还有好多方法，例如charAt()，compareTo()，compareToIgnoreCase()，concat()，equals()，length()等等
	StringBuffer类的声明
	
	![clip_image006](/images/2014-06-29-head-first-java-basic/clip_image0064_thumb.png)
	
	String与StringBuffer间的转换关系
	
	![clip_image008](/images/2014-06-29-head-first-java-basic/clip_image0084_thumb.jpg)
	
	诸如此类的方法多如绵绵春雨，还是等待大家慢慢深入研究吧:D

#### 五、java.util包
1. 时间日期类
	- Date类（deprecated）

	![clip_image009](/images/2014-06-29-head-first-java-basic/clip_image0094_thumb.png)
	
	以下是绝对时间与相对时间的互转
	绝对时间->相对时间：
	
	`getTime()`
	
	相对时间->绝对时间：

	![clip_image010](/images/2014-06-29-head-first-java-basic/clip_image0104_thumb.png)

	- Calendar类（recommend）

	![clip_image012](/images/2014-06-29-head-first-java-basic/clip_image0124_thumb.jpg)
	
	要提一下的是，它家的add(Calendar.YEAR, 1)方法可以实现计算某字段之后添加或减少一定的数值

	
2. 集成框架（CF）
	- List系列类：按索引值操作数据，允许存放重复元素
	- Set系列类：按索引值操作数据，不允许存放重复数据
	- Map系列类：按照名称操作数据，名称不允许重复，值可以重复，一个名称对应唯一的值
	简而言之，CF类的复杂性在于它们使用了数据结构类型进行存储和实现，具备了该种数据结构的特点。
	示例1：LIST
	
	![clip_image013](/images/2014-06-29-head-first-java-basic/clip_image0134_thumb.png)
	
	示例2：SET
	
	![clip_image014](/images/2014-06-29-head-first-java-basic/clip_image0144_thumb.png)
	
	示例3：MAP
	
	![clip_image015](/images/2014-06-29-head-first-java-basic/clip_image0154_thumb.png)

其实大家也都会发现，以上谈到的都只是些边边角角的JAVA最基本的知识。
所谓学海无涯苦作舟，大家就乘着风，扬起帆，继续前进吧。


