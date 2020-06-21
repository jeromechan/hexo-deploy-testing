---
layout: post
title: "关于PhpStorm+MAMP+xdebug集成失败的处理办法"
date: 2016-09-01 09:00:00
description: "PhpStorm+MAMP+xdebug集成失败,"
keywords: "xdebug,MAMP,phpstorm,PHP_IDE_CONFIG"
permalink: /2016/09/01/integrate-phpstorm-mamp-xdebug/
categories:
- 编程语言
tags:
- php
- xdebug
---

首先，阐述一下我的开发环境配置：  

* MacOS v10.11.6
* MAMP PRO v3.5
* PHP v5.3.29
* Xdebug v2.2.7
* PhpStorm 2016.1

近期对mamp作了次重装升级，之后遇到了xdebug无法正常启用的问题，在phpstorm中反馈的Event Log信息如下：  

```
Cannot accept external Xdebug connection: Cannot evaluate expression 'isset($_SERVER['PHP_IDE_CONFIG'])'
```

看以上描述可以知道，是因为在建立Xdebug connection之时，无法找到变量`PHP_IDE_CONFIG`的定义。  
谈到这里，大家来看看php.ini中Xdebug的参数配置先：  

```
[xdebug]
extension=xdebug.so

[xdebug]
MAMP_Xdebug_MAMP
 xdebug.remote_enable=1
 xdebug.remote_host=localhost
 xdebug.remote_port=9000
 xdebug.remote_autostart=1
 ;xdebug.profiler_enable=0
 ;xdebug.profiler_output_dir="/Applications/MAMP/tmp"
```

#### 一、核实xdebug与phpstorm已建立关联关系

打开phpinfo()信息页面，xdebug扩展部分如下：

![](/images/2016-09-01-integrate-phpstorm-mamp-xdebug/14727184774765.jpg)

也可以正常进行加载。但是问题来了，为什么phpstorm不能使用其进行debug过程呢？  
不难发现，`IDE Key`上显示的是`no value`，这一方面说明了xdebug并没有正确地与phpstorm建立关联，即phpstorm即时发起xdebug connections，也无法正常连接并使用xdebug扩展。  

修正这个问题比较简单，增加xdebug扩展参数配置即可：  

```
xdebug.idekey="PHPSTORM"
```

#### 二、确认xdebug使用的是zend_extension引入方式

php的扩展库有很多，主要分为两大类：php extension和zend extension。

有的基于php module开发而成，有的基于zend engine开发而成（xdebug基于的就是zend引擎进行开发的），当然，也有的可以兼容两种引擎（memcache就是一个很好的兼容两种引擎的例子）。而这里要提到一个概念，php内核是基于zend engine的，zend engine从php3开始就在服务php内核的最后一道岗了。

> 通常我们称php extension为“modules”，称zend extension为“extensions”。

以下为大家扩展一下，php extension和zend extension的基本数据结构上的区别：

* php extension(modules)

```c
// php extension structures
typedef struct _zend_module_entry zend_module_entry;
typedef struct _zend_module_dep zend_module_dep;
 
struct _zend_module_entry {
	unsigned short size;
	unsigned int zend_api;
	unsigned char zend_debug;
	unsigned char zts;
	const struct _zend_ini_entry *ini_entry;
	const struct _zend_module_dep *deps;
	const char *name;
	const struct _zend_function_entry *functions;
	int (*module_startup_func)(INIT_FUNC_ARGS);
	int (*module_shutdown_func)(SHUTDOWN_FUNC_ARGS);
	int (*request_startup_func)(INIT_FUNC_ARGS);
	int (*request_shutdown_func)(SHUTDOWN_FUNC_ARGS);
	void (*info_func)(ZEND_MODULE_INFO_FUNC_ARGS);
	const char *version;
	size_t globals_size;
#ifdef ZTS
	ts_rsrc_id* globals_id_ptr;
#else
	void* globals_ptr;
#endif
	void (*globals_ctor)(void *global TSRMLS_DC);
	void (*globals_dtor)(void *global TSRMLS_DC);
	int (*post_deactivate_func)(void);
	int module_started;
	unsigned char type;
	void *handle;
	int module_number;
	const char *build_id;
};
 
struct _zend_module_dep {
	const char *name;		/* module name */
	const char *rel;		/* version relationship: NULL (exists), lt|le|eq|ge|gt (to given version) */
	const char *version;	/* version */
	unsigned char type;		/* dependency type */
};
```

* zend extension(extensions)

```c
// zend extension structures
typedef void (*message_handler_func_t)(int message, void *arg);
 
typedef void (*op_array_handler_func_t)(zend_op_array *op_array);
 
typedef void (*statement_handler_func_t)(zend_op_array *op_array);
typedef void (*fcall_begin_handler_func_t)(zend_op_array *op_array);
typedef void (*fcall_end_handler_func_t)(zend_op_array *op_array);
 
typedef void (*op_array_ctor_func_t)(zend_op_array *op_array);
typedef void (*op_array_dtor_func_t)(zend_op_array *op_array);
 
typedef struct _zend_extension {
	char *name;
	char *version;
	char *author;
	char *URL;
	char *copyright;
 
	startup_func_t startup;
	shutdown_func_t shutdown;
	activate_func_t activate;
	deactivate_func_t deactivate;
 
	message_handler_func_t message_handler;
 
	op_array_handler_func_t op_array_handler;
 
	statement_handler_func_t statement_handler;
	fcall_begin_handler_func_t fcall_begin_handler;
	fcall_end_handler_func_t fcall_end_handler;
 
	op_array_ctor_func_t op_array_ctor;
	op_array_dtor_func_t op_array_dtor;
 
	int (*api_no_check)(int api_no);
	int (*build_id_check)(const char* build_id);
	void *reserved3;
	void *reserved4;
	void *reserved5;
	void *reserved6;
	void *reserved7;
	void *reserved8;
 
	DL_HANDLE handle;
	int resource_number;
} zend_extension;
 
typedef struct _zend_extension_version_info {
	int zend_extension_api_no;
	char *build_id;
} zend_extension_version_info;
```

从加载顺序上分析，zend extension要早于php extension进行注册(register)，然而在激活(activate)阶段，却是php extension要早于zend extension被激活。  
在两者的激活顺序上，有如下区别可以额外了解一下：  

> **PHP extensions** in an order that make the dependencies be activated in a specific order. But remember that **Zend extensions** are never sorted in any way. You must then declare them in the FIFO order in php.ini. The engine wont touch your declaration order.
  
zend_extension注册是调用的函数`zend_register_extension()`，而php extension注册是调用的函数`zend_register_module_ex(zend_module_entry *module)`进行注册。

以下是两类扩展的生命周期图：  

![](/images/2016-09-01-integrate-phpstorm-mamp-xdebug/14727201625932.jpg)

前面谈及了许多的关于php两类扩展的一些内部实现问题，其实对于这部分仅仅为了让开发者们更加深刻记得一点：“确认xdebug使用的是zend_extension引入方式”。

这个时候，我们需要继续修改php.ini关于xdebug的引入配置：

```
;1.移除默认引入xdebug.so的php extension的方式
[xdebug]
;extension=xdebug.so

;2.更改为zend extension的方式对xdebug.so进行引入
[xdebug]
MAMP_Xdebug_MAMP
 zend_extension="/Applications/MAMP/bin/php/php5.3.29/lib/php/extensions/no-debug-non-zts-20090626/xdebug.so"
```

以上可能你会疑惑，为什么一个写的是绝对路径，而一个写的是相对路径？  
其实原因很简单，php extension约定了在加载之时可以使用相对于php.ini公共配置项目 `extension_dir`的路径作为扩展路径；而zend extension则约定了使用全路径进行引入和加载。  

#### 三、配置PhpStorm项目PHP Web Application

这部分不在赘述，正如title中所提到的，配置好PhpStorm项目PHP Web Application，就可以进行debug调试你的php脚本代码了。以下就简单的附上几张图示吧，供各位参考。

* 配置：Run/Debug Configuration

![](/images/2016-09-01-integrate-phpstorm-mamp-xdebug/14727221950526.jpg)

* 配置：Servers

![](/images/2016-09-01-integrate-phpstorm-mamp-xdebug/14727223290574.jpg)

* 操作：Start Listening Xdebug Connections

![](/images/2016-09-01-integrate-phpstorm-mamp-xdebug/14727235899205.jpg)

* Debug界面一览

![](/images/2016-09-01-integrate-phpstorm-mamp-xdebug/14727237053026.jpg)

*备注：若各位看官有疑问或者建议，可以在文章末端的disqus留言，本人看到后会及时回复。感谢读者们阅读本篇文章。*


