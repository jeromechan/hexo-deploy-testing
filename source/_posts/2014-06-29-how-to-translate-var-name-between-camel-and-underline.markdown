---
layout: post
author: jeromechan
comments: true
date: 2014-06-29 00:51:36
slug: how-to-translate-var-name-between-camel-and-underline
title: 代码规范之驼峰vs下划线风格转换方案
wordpress_id: 6
permalink: /2014/06/29/how-to-translate-var-name-between-camel-and-underline/
categories:
- 编程语言
tags:
- PHP
---

转换书写风格的方案均基于递归深度遍历，对key值重新建构，将value值重新赋值。

让我们一起来看看以下详细代码实现。
	
1. 下划线风格=>驼峰风格

```php
<?php
/**
 * @static 数组键名翻译成驼峰写法
 * @param $in 源数组
 * @return array 输出数组
 */
public static function arrKeysToCamelCase($in)
{
    if(empty($in)||!is_array($in))
        return $in;
    $reCopyRes = array();
    foreach($in as $key=>$val)
    {
        $reKey = self::ucFirstWord($key);
        if(!is_array($val)){
            $reCopyRes[$reKey] = $val;
        }else{
            $reCopyRes[$reKey] = self::arrKeysToCamelCase($val);
        }
    }
    return $reCopyRes;
}

/**
 * @static 将单词的首字母转换成大写(首单词除外)
 * @param $word 源单词字符串
 * @return string 输出单词字符串
 */
public static function ucFirstWord($word)
{
    if(!is_string($word)){
        return $word;
    }else{
        $wordArr = explode('_',$word);
        if(!empty($wordArr)){
            $index = 0;
            foreach($wordArr as &$wd)
            {
                if($index==0){
                    $index++;
                    continue;
                }
                $wd = ucfirst($wd);
            }
            $outStr = implode('',$wordArr);
            return $outStr;
        }else{
            return $word;
        }
    }
}
```

2. 驼峰风格=>下划线风格

```php
<?php
/**
 * @static 数组键名翻译成下划线写法
 * @param $in 源数组
 * @return array 输出数组
 */
public static function arrKeysToUnderlineCase($in)
{
    if(empty($in)||!is_array($in))
        return $in;
    $reCopyRes = array();
    foreach($in as $key=>$val)
    {
        $reKey = self::lcFirstWord($key);
        if(!is_array($val)){
            $reCopyRes[$reKey] = $val;
        }else{
            $reCopyRes[$reKey] = self::arrKeysToUnderlineCase($val);
        }
    }
    return $reCopyRes;
}

/**
 * @static 将单词的首字母转换成小写
 * @param $word 源单词字符串
 * @return string 输出单词字符串
 */
public static function lcFirstWord($word)
{
    if(!is_string($word)){
        return $word;
    }else{
        preg_match_all('/([a-z0-9_]*)([A-Z][a-z0-9_]*)?/',$word,EG_PATTERN_ORDER);
        if(!empty($matches)){
            $strPattern1 = !empty($matches[1][0])?trim($matches[1][0]):'';
            $subMatch = array_filter($matches[2]);
            $strPattern2 = !empty($subMatch)?trim(implode('_',$subMatch)):'';
            $strPattern2 = !empty($strPattern2) && !empty($strPattern1)?'_'.2:$strPattern2;
            $outStr = strtolower($strPattern1.$strPattern2);
        }else{
            $outStr = $word;
        }
        return $outStr;
    }
}
```







