---
layout: post
title: "几种方法调用思路的比较"
date: 2016-12-02 09:00:00
description: "按位与,按位或,方法调用思路"
keywords: "function invoke, function calling"
permalink: /2016/12/02/funny-function-invoking-logic/
categories:
- 编程语言
tags:
- 方法调用
- 按位与
- 按位或
---

编码过程中，每天都在实现的事情，不是对象就是方法。那么如何去封装一个方法的入参呢？如果入参很多，是否有比较不一样的思路可以提高代码的复用性和可读性呢？下面谈谈在这一方面，近期学习到的一点知识。

#### 一、参数逐个罗列

假设有这么一个方法，方法参数很多，但都类似，我们可能需要把所有参数逐个逐个传入方法体内，就像这样：

```java
/**
 * A common style of implementing a function.
 *
 * @param type1
 * @param type2
 * @param type3
 */
public static void doSomething(Byte type1, Byte type2, Byte type3) {
    if (type1 == 1) {
        //
        // do some conditional processes.
        //
    }
    if (type2 == 1) {
        //
        // do some conditional processes.
        //
    }
    if (type3 == 1) {
        //
        // do some conditional processes.
        //
    }
}
```

```java
/**
 * Test cases for explaining how to invoke a function.
 *
 * @author chenjinlong 20161202
 */
public static void invokerMethod() {
    /**
     * Initial parameters
     */
    final Byte type1 = 1, type2 = 1, type3 = 1;

    /**
     * Call with separated parameters
     */
    doSomething(type1, type2, type3);
}
```

#### 二、列表形式批量传入

可能有的工程师觉得上面这种办法，会使得方法参数过多，不便于阅读和归类，列表的办法可能会更好，所以上面的逻辑也可以写成这样：

```java
/**
 * Another common style of implementing a function.
 *
 * @param typeList
 */
public static void doSomething(List<Byte> typeList) {
    for (Byte type : typeList) {
        switch (type) {
            case 1:
                //
                // do some conditional processes.
                //
                break;
            case 2:
                //
                // do some conditional processes.
                //
                break;
            default:
                break;
        }
    }
}
```

```java
/**
 * Test cases for explaining how to invoke a function.
 *
 * @author chenjinlong 20161202
 */
public static void invokerMethod() {
    /**
     * Initial parameters
     */
    final Byte type1 = 1, type2 = 1, type3 = 1;
    
    /**
     * Call with parameter list
     */
    List<Byte> typeList = new ArrayList<Byte>(){{
        add(type1);
        add(type2);
        add(type3);
    }};
    doSomething(typeList);
}
```

#### 三、对象VO的形式传入参数

可能还有的工程师觉得，塞个列表进来，其实也并不能将释义阐述清楚，每个列表值虽说都是byte，但是每个byte的含义都代表着不通的分支不通的含义。所以，对象的办法就引入进来了：

```java
/**
 * An POJO-bean style of implementing a function.
 *
 * @param typeList
 */
public static void doSomething(TypeExplains typeExplains) {
    if (typeExplains.getTypeOne() == 1) {
        //
        // do some conditional processes.
        //
    }
    if (typeExplains.getTypeTwo() == 1) {
        //
        // do some conditional processes.
        //
    }
    if (typeExplains.getTypeThree() == 1) {
        //
        // do some conditional processes.
        //
    }
}
```

```java
/**
 * Test cases for explaining how to invoke a function.
 *
 * @author chenjinlong 20161202
 */
public static void invokerMethod() {
    /**
     * Initial parameters
     */
    final Byte type1 = 1, type2 = 1, type3 = 1;
    
    /**
     * Call with parameter bean
     */
    TypeExplains typeExplains = new TypeExplains();
    typeExplains.setTypeOne(type1);
    typeExplains.setTypeTwo(type2);
    typeExplains.setTypeThree(type3);
    doSomething(typeExplains);
}
```

#### 四、按位与&按位或 的方式传入参数

以上方式其实都可以达到相同的函数想要实现的目标，但是是否考虑过其他更为便捷的办法呢？最近就遇到这么一种比较创新的、特殊的、异类、不一样的、充分展现计算机知识学以致用的调用的模式：

```java
/**
 * Each of Keys must be strictly defined.
 */
public enum TypeEnum {
    TYPE_1(1), // equals to "0001"
    TYPE_2(2), // equals to "0010"
    TYPE_3(4)  // equals to "0100"
    ;

    private Integer key;

    TypeEnum(Integer key) {
        this.key = key;
    }

    public Integer getKey() {
        return key;
    }

    public void setKey(Integer key) {
        this.key = key;
    }
}
```

```java
/**
 * Using & and | features.
 *
 * @param type
 */
public static void doSomething(Byte type) {
    if ((type & TypeEnum.TYPE_1.getKey()) == 1) {
        //
        // do some conditional processes.
        //
    }
    if ((type & TypeEnum.TYPE_2.getKey()) == 1) {
        //
        // do some conditional processes.
        //
    }
    if ((type & TypeEnum.TYPE_3.getKey()) == 1) {
        //
        // do some conditional processes.
        //
    }
}
```

```java
/**
 * Test cases for explaining how to invoke a function.
 *
 * @author chenjinlong 20161202
 */
public static void invokerMethod() {
    /**
     * Initial parameters
     */
    final Byte type1 = 1, type2 = 1, type3 = 1;

    /**
     * Call with & and |
     */
    doSomething((byte)(type1 | type2 | type3));
}
```

这种按位或传入，按位与判断获取的办法，着实为传入参数提供了截然不同的参考。当然，这种办法也不是适用于所有场景的。
按位与按位或的办法，使用于需要传入参数很多的，方法体内针对每个参数会包含着不一样分支逻辑的场景。该方式简化了方法体外“或关系”判断的逻辑，但另一方面也确实降低了代码的易读性。

#### 五、总结

其实以上谈到的四种模式中，没有哪一种是最好的。符合实践场景的、符合团队技术水平现实的、具备高内聚低耦合特点的，那就一定是最适合的。    
后续日子里，会就代码内部模式的实践上，发散开来谈谈如何编写可读性强的代码，然后再多po几篇文章分享出来。



