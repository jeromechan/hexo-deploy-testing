---
layout: post
title: "读写分离的原则"
date: 2016-09-20 01:00:00
description: "How to use Master-Slave pattern for database."
keywords: “Read Write Separation,Master Slave Pattern”
permalink: /2016/09/06/db-master-slave-pattern-rules/
categories:
- 编程语言
tags:
- Database
---

![](/images/2016-09-20-db-master-slave-pattern-rules/14743556033765.jpg)


#### 一、读写分离是什么？

简单了说，就是数据库一主一从/一主多从/多主多从的部署方式。先简单介绍下mysql的原生同步机制，其是将master的binlog期间的执行日志根据顺序，拷贝至slave的relaylog中，然后逐一解析和执行。

读写分离的好处在于：

* 硬件处理能力得到了横向的扩增，拿机器和带宽换性能
* 降低了主库服务器的压力，提高并发性能
* 缓解读锁（S锁，共享锁，Shared Lock）和写锁（X锁，排他锁，Exclusive Lock）的竞争
* 系统运行性能得到间接的提升

#### 二、如何判别是否需要读写分离？

谈及读写分离，必定要先了解怎样的应用层场景才需要使用到读写分离模式。以下是几点比较共性的场景特点：

* 以读操作为主的应用或者服务
* 可接受时间上短暂的信息延迟
* 单一线程内同时涵盖读写操作的，使用主库

#### 三、常见的读写分离的方式有哪些？

1. 中间件，例如java-amoeba
2. 框架特性，例如spring-aop
3. 自定义组件，例如在dal层的prepare过程，增加拦截代码，以执行数据源的路由逻辑。

#### 四、读写分离简单原则

![](/images/2016-09-20-db-master-slave-pattern-rules/14787121481232.jpg)


#### 五、参考文章

* [为什么数据库读写分离可以提高性能](https://my.oschina.net/candiesyangyang/blog/203425)

