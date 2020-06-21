---
layout: post
title: "XRebel入门与实践"
date: 2016-08-26 09:00:00
description: "XRebel入门、安装、实践"
keywords: "xrebel tutorial,xrebel install"
permalink: /2016/08/26/xrebel-tutorial/
categories:
- 编程语言
tags:
- xrebel
- performance monitor
---

#### 一、XRebel简介

![](/images/2016-08-26-xrebel-tutorial/14721890028699.jpg)
XRebel是一款轻量级的性能优化器，可以帮助开发者们主动去发现和修复一些通用性的问题。XRebel提供了即时的方式，使得开发者可以针对每一个独立的请求进行分析、定位一些诸如DB查询、session变更细节等。  
XRebel支持当前众多的Java企业开发平台，只需要耗费一点点的时间，便可以非常简洁地集成到开发环境当中去。

为什么开发者需要使用到XRebel呢？其实原因很简单。
许多开发者们都遇到过很多挣扎的事宜，例如为了寻找系统crash或者发现issues问题，不断地去确认编码逻辑，不断地去核实业务实现细节等等，是否有线程间通信安全问题，是否出现了未捕获异常等等。这些都是非常耗费时间精力的，而这些问题我们可以让其在整个软件开发过程中，暴露地更早。在软件开发周期中，问题暴露地越早，所花费的成本就会越低。

> The severity of an issue is higher(obviously) if it is later in the development cycle.

![](/images/2016-08-26-xrebel-tutorial/14721925857856.jpg)


XRebel正是为了让开发者们避免继续低效率地挣扎，遭遇节假日技术支持的困扰而诞生的性能优化工具。  
它可以帮助开发者们在开发过程中，实时地检测所编程代码的效率参数和通信细节，XRebel只输出了开发者们所关心的关键监控参数细节，而一些无关的其他参数，它将智能地识别并且隐藏起来。  
开发者们使用XRebel，并不需要频繁地切换系统程序和XRebel分析窗口，因为两者是分离开的。你可以在浏览器中的不同tab上打开对应的页面。这一点很好地提高了开发者的开发效率，方便了开发者在不同窗口内查看指定的数据。

相对于其他的性能优化器产品，XRebel实现了开发、生产环境在代码监测层面上的零差异。开发环境所监测到的sql、session、exception、code trace log等等，无论是在development环境，或是在product环境，都是一致的。  

![](/images/2016-08-26-xrebel-tutorial/14721931961702.jpg)

而其他的一些产品，诸如JProfiler、APM，所监测到的数据大多基于CPU、Memory、Threads等方面，定位问题需要先找到对应的Thread，然后打开Thread Tree/Stack进行逐一排查，非常繁琐，并不是那么地简易操作。  
恰恰XRebel解决了这个排查的技巧性问题。XRebel可以直接捕获到发生异常的代码行和exception detail，同时还可以查看发生该异常的请求之时，所涉及的sql、cache、queue、session等组件的交互情况，使得开发者更易于快速提高解决问题的效率。

![](/images/2016-08-26-xrebel-tutorial/14721926122030.jpg)


#### 二、XRebel安装使用教程

前面介绍了关于XRebel的一些背景和特点，以下介绍XRebel的安装步骤及其Tips。

> 首先要说明的一点，XRebel是一款收费工具，并非开源免费。
> 该工具值得你去购买，如果这笔款项不会影响你的生活质量。关于破解的方法，这里不做介绍，请自行Google。

##### 下载与安装

1.从官网上下载XRebel压缩包（.zip）[http://zeroturnaround.com/software/xrebel/download/](http://zeroturnaround.com/software/xrebel/download/)。  
如果你提前登陆了zeroturnaround.com，那么你所下载的zip包中就非常便捷地包含了你的帐号信息。

2.解压zip包到指定的目录中，zip包中包含的内容如下：  

![](/images/2016-08-26-xrebel-tutorial/14721938888446.jpg)

3.将`xrebel.jar`添加到应用服务容器的JVM参数中，添加时候确认路径是正确无误的。  

```
-javaagent:[path/to/]xrebel.jar
```

4.启动应用服务容器，XRebel就会自动成功启动。  
启动完成之后，打开浏览器，XRebel toolbar就会显示在你服务页面的左下角。

```
2016-05-20 16:29:42 XRebel: #####################################################
2016-05-20 16:29:42 XRebel:
2016-05-20 16:29:42 XRebel:  XRebel 3.1.1 (201605131009)
2016-05-20 16:29:42 XRebel:  (c) Copyright ZeroTurnaround AS, Estonia, Tallinn.
2016-05-20 16:29:42 XRebel:
2016-05-20 16:29:42 XRebel:  For questions and support,
2016-05-20 16:29:42 XRebel:  contact xrebel@zeroturnaround.com
2016-05-20 16:29:42 XRebel:
2016-05-20 16:29:42 XRebel: #####################################################
```

##### License激活

使用XRebel必须先激活，毕竟是收费工具。当然，在你购买前，你会拥有15天的评估试用期。  
怎么激活呢？其实很简单，在你安装完XRebel之后，首次打开浏览器，以下窗口便会自动弹跳出来，根据提示进行License注册便是。

![](/images/2016-08-26-xrebel-tutorial/14721942799287.jpg)

##### 将XRebel集成到你的Server中

这里会有两个方面可以实践。  

* IDE集成
* Server容器集成

以下逐一介绍。首先第一种：IDE集成。

**1.Eclipse**

> Tips: 插件**[XRebel for Eclipse](http://manuals.zeroturnaround.com/xrebel/install/eclipse.html#xrebel-eclipse-install)**已经在Marketplace提供下载。目前该插件仅支持Eclipse 3.6版本及以上。

（1）打开Eclipse的 Run > Run Configurations...；  
（2）选择Server服务容器，打开Arguments参数设置tab标签；  
（3）将以下参数填写到VM arguments配置项目中；  

```
-javaagent:[path/to/]xrebel.jar
```
![](/images/2016-08-26-xrebel-tutorial/14722183417609.jpg)

（4）点击Apply应用并保存到当前的Run Configuration中。

**2.Intellij IDEA**

（1）打开IDEA的Run > Edit Configurations...；  
（2）选择Server服务容器；  
（3）将以下参数填写到VM arguments配置项目中；  

```
-javaagent:[path/to/]xrebel.jar
```
![](/images/2016-08-26-xrebel-tutorial/14722184711430.jpg)


（4）点击Apply应用并保存到当前的Run Configuration中。

**3.NetBeans**

（1）打开NetBeans的Tools > Servers；  
（2）选择Server服务容器，打开Platform参数设置tab标签；  
（3）将以下参数填写到VM arguments配置项目中；  

```
-javaagent:[path/to/]xrebel.jar
```
![](/images/2016-08-26-xrebel-tutorial/14722186661015.jpg)

（4）点击Close保存并关闭当前窗口。

下面我们介绍第二种：Server容器集成。

由于容器种类繁多，这里仅举例应用最为广泛的Tomcat上的应用，其他的容器配置可参考官方文章[Adding-the-xrebel-parameter-without-an-ide](http://manuals.zeroturnaround.com/xrebel/install/index.html#adding-the-xrebel-parameter-without-an-ide)。

**1.Tomcat on Windows Platform**

（1）找到安装Tomcat的目录（即Tomcat home folder）；  
（2）打开bin文件夹；  
（3）新增一个可执行.bat文件，例如命名为`catalina-xrebel.bat`；  
（4）将以下内容增加到第3步所创建好的.bat文件中；  

```
@echo off
set JAVA_OPTS=-javaagent:[path/to/]xrebel.jar %JAVA_OPTS%
call "%~dp0\catalina.bat" %*
```

（5）执行以上.bat文件，启动Tomcat。

PS: 需要将Tomcat以服务的方式启动着？可以打开tomcat包装器`tomcatXw.exe`，在tomcatXw包装器的设置项目Java > Java Options中，新增如下参数：  

```
-javaagent:[path/to/]xrebel.jar
```

**2.Tomcat on Mac OS and Linux**

（1）找到安装Tomcat的目录（即Tomcat home folder）；  
（2）打开bin文件夹；  
（3）新增一个可执行.sh文件，例如命名为`catalina-xrebel.sh`；  
（4）将以下内容增加到第3步所创建好的.sh文件中；

```
#!/bin/bash
export JAVA_OPTS="-javaagent:[path/to/]xrebel.jar $JAVA_OPTS"
`dirname $0`/catalina.sh $@
```

（5）按照如下命令，执行以上.sh启动脚本，启动Tomcat。

```
./catalina-xrebel.sh run
```

#### 三、XRebel应用

经过前两部分的折腾，你应该已经可以成功启动XRebel了。下面我们来进一步介绍以下，如何去实际使用XRebel？XRebel到底给我们开发者提供了怎样的便捷特性？下面会逐一展开讲道。

以下主界面非常明显地呈现出了Toolbar的位置，也是XRebel主要的操作菜单功能区。

![](/images/2016-08-26-xrebel-tutorial/14722230804350.jpg)


**1.第一大功能：Access application profiling**

![](/images/2016-08-26-xrebel-tutorial/14722233171431.jpg)

*PS：为了书写方便，这里暂且称之为AAP功能。*

AAP功能包含的是系统服务所接收到的请求列表，以及每一个请求的时间消耗细节监测数据。该数据的统计维度是定位到Method级别的。  
请跟随以下图示，对AAP功能有一个现状的概览印象，具体事宜可以在真实实践的时候进一步逐一了解。

![](/images/2016-08-26-xrebel-tutorial/14722236434252.jpg)
![](/images/2016-08-26-xrebel-tutorial/14722237721529.jpg)

> ![](/images/2016-08-26-xrebel-tutorial/14722238537773.jpg)
> 查看AAP功能的栈信息之时，留意符号的含义。该符号标识了一个异步的执行请求。

**2.第二大功能：Review IO query**

*PS：为了书写方便，这里暂且称之为RIQ功能。*

RIQ功能可以支持但不仅限于jdbc的监测。例如RabbitMQ、JMS、Redis等框架的执行数据的监控。  
如第3张图示，清晰地监测到了请求中所包含的执行SQL语句，这一点对于开发、测试过程都是及其有帮助的。

![](/images/2016-08-26-xrebel-tutorial/14722233844623.jpg)

![](/images/2016-08-26-xrebel-tutorial/14722239944661.jpg)
![](/images/2016-08-26-xrebel-tutorial/14722243069603.jpg)


**3.第三大功能：Find exceptions**

*PS：为了书写方便，这里暂且称之为FE功能。*

FE功能简单易懂，即异常日志的捕获。开发者们除了在slf4log、log4j等日志框架下定义好的路径中查看系统日志以外，还可以在系统程序运行时从XRebel中查看到即时的日志详情。

![](/images/2016-08-26-xrebel-tutorial/14722234443155.jpg)

![](/images/2016-08-26-xrebel-tutorial/14722244480081.jpg)

以上介绍完了XRebel最为常用的三大功能点，关于session监控的部分，这里也截图一张说明一下，有需要的开发者可以自行研究，例如应用到CAS等用户登录相关场景之时，相信Session data这项功能是你非常好的监控助手。

> Session data的功能需要从XRebel的Settings中打开配置选项，默认是不勾选的。

![](/images/2016-08-26-xrebel-tutorial/14722252061448.jpg)

此外这里再补充一点，也就是主界面三大功能的右上角`Hidden items`选项。

![](/images/2016-08-26-xrebel-tutorial/14722246072371.jpg)

将该选项打上勾，便可以查看到操作过程中，开发者们标记了hidden的条目，以及XRebel智能隐藏的其他条目。具体看应用场景的需要。

#### 四、高级配置选项

**1.XRebel过滤名单**

XRebel允许配置一项黑名单列表，将不需要监测的class路径添加进去，即达到忽略的目的。  
黑名单配置文件在这里：  

```
~/.xrebel/traces-blacklist.txt
```

XRebel还允许配置一项黑名单，以过滤`static`和`transient`属性的大小，使之不影响所在对象Object的大小计算。

```
~/.xrebel/session-blacklist.txt
```

**2.XRebel启动参数**

* `-Dxrebel.single_app_mode=true|false` (default value: true) – Consider all deployments to be part of a single application. This reports activity from different deployment units to one and the same toolbar.
* `-Dxrebel.injection.log_response=true|false` (default: false) – When true, the content of HTTP servlet responses will be logged to xrebel.log. This is meant to help debug cases when XRebel toolbar is not properly injected into the application’s HTML.
* `-Dxrebel.session.include_transient_fields=true|false` (default value: false) – When true, fields with the transient modifier will be considered when constructing the session graph. By default, all transient fields are ignored and objects reachable only through transient fields are not considered to be part of the session.
* `-Dxrebel.browser.console_log=true|false` (default value: false) – When true, the client side XRebel log will be written into the browser console.
* `-Dxrebel.injection=true|false` (default value: true) – Disables the XRebel toolbar injection into application HTML. Add /xrebel to your application URL to view the toolbar in a separate tab (this opens the alternative UI view).
* `-Dxrebel.traces.filter_resources=true|false` (default value: true) – Prevents displaying resource requests in the Application profiling view.
* `-Dxrebel.include_all_io=true|false` (default value: true) – Enables the display of all detected IO events. Uncategorized IO events are displayed as Unidentified.
* `-Dxrebel.sql.format=true|false` (default value: true) – Enables formatting of SQL queries.
* `-Dxrebel.traces.all=true|false` (default value: false) – Enables tracing for all contexts.
	* `-Dxrebel.traces.jms=true|false` (default value: false) – Enables tracing for JMS.
	* `-Dxrebel.traces.scheduler=true|false` (default value: false) – Enables tracing for ScheduledExecutorService.
	* `-Dxrebel.traces.quartz=true|false` (default value: false) – Enables tracing for Quartz.
	* `-Dxrebel.traces.rabbitmq=true|false` (default value: false) – Enables tracing for RabbitMQ.

**3.XRebel特性Module配置参数**

* `-Dxrebel.module.http.HttpURLConnection=true|false` (default value: true) – Disables collecting IQ queries from java.net.HttpURLConnection usage.
* `-Dxrebel.module.http.HttpCore=true|false` (default value: true) – Disables collecting IO queries from Apache HttpCore 4.x usage.
* `-Dxrebel.module.http.HttpClient3=true|false` (default value: true) – Disables collecting IO queries from Apache HttpClient 3.x usage.
* `-Dxrebel.module.mongodb=true|false` (default value: true) – Disables collecting IO queries from MongoDB driver usage.
* `-Dxrebel.module.hbase=true|false` (default value: true) – Disables collecting IO queries from HBase driver usage.
* `-Dxrebel.module.redis=true|false` (default value: true) – Disables collecting IO queries from Redis driver usage.
* `-Dxrebel.module.cassandra=true|false` (default value: true) – Disables collecting IO queries from Cassandra driver usage.
* `-Dxrebel.module.orm=true|false` (default value: true) – Disables collecting information about ORM queries, including Hibernate JPA queries.
* `-Dxrebel.module.equinox=true|false` (default value: true) – Disables support for Equinox class loaders (boot delegation).
* `-Dxrebel.module.rmi=true|false` (default value: true) – Disables collecting IO queries from RMI (java.rmi) remote object invocations.
* `-Dxrebel.module.traces=true|false` (default value: true) – Disables collecting all method calls during HTTP requests.
* `-Dxrebel.module.session=true|false` (default value: true) – Disables taking session snapshots.
* `-Dxrebel.module.springloaded=true|false` (default value: true) – Disables Spring Loaded agent when detected.
* `-Dxrebel.module.async=true|false` (default value: true) – Disables collecting IO queries from asynchronously executed threads.
* `-Dxrebel.module.quartz=true|false` (default value: true) – Disables collecting IO queries within a Quartz job context.
* `-Dxrebel.module.jms=true|false` (default value: true) – Disables collecting IO queries within JMS MessageListener.onMessage() context.
* `-Dxrebel.module.scheduler=true|false` (default value: true) – Disables collecting IO queries for ScheduledThreadPoolExecutor tasks.
* `-Dxrebel.module.rabbitmq=true|false` (default value: true) – Disables collecting IO events within RabbitMQ consumer.handleDelivery() context and outgoing messages.
* `-Dxrebel.module.remote_events=true|false` (default value: true) – Disables collecting and displaying data from remote XRebel-enabled web services (microservices).
* `-Dxrebel.module.jdbc=true|false` (default value: true) – Disable collecting IO queries from JDBC usage.
	* `-Dxrebel.module.jdbc.sql=true|false` (default value: true) – Disables collecting IO queries from relational database JDBC usage. Requires -Dxrebel.module.jdbc to be true.
	* `-Dxrebel.module.jdbc.neo4j=true|false` (default value: true) – Disables collecting IO queries from Neo4j JDBC usage. Requires -Dxrebel.module.jdbc to be true.
	* `-Dxrebel.module.jdbc.cassandra=true|false` (default value: true) – Disables collecting IO queries from Cassandra JDBC usage. Requires -Dxrebel.module.jdbc to be true.
	* `-Dxrebel.module.jdbc.phoenix=true|false` (default value: true) – Disables collecting IO queries from Apache Phoenix (HBase) usage. Requires -Dxrebel.module.jdbc to be true.

#### 五、参考资料

本篇文章基于个人在近期实践XRebel过程中，所用到的知识归纳成文。  
XRebel实用性极高，对自己在日常的开发中，方便了发现代码缺陷以及存在的性能隐患，所以作此一文推荐一番。

具体官方资料可查阅：[http://manuals.zeroturnaround.com/xrebel/index.html](http://manuals.zeroturnaround.com/xrebel/index.html)

