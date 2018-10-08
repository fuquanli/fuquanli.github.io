---
title: Python学习笔记-Python数据类型
date: 2018-03-27 08:54:00
tags: Python
categories: 技术
---

  ### 整数  
  ### 浮点数  
  ### 字符串  

  字符串格式化: 用 % 实现  
  可使用 isinstance(x, str) 判断变量x是否是字符串  

<!-- more -->

  ```
  >>> 'Hello , %s' % 'world'
'Hello , world'
>>> 'Hi , %s , you have $%d.' % ('Michael' , 1000000)
'Hi , Michael , you have $1000000.'
  ```

|  占位符  |  替换内容  |
|----------|------|
| %d | 整数 |
| %f | 浮点数 |
| %s | 字符串 |
| %x | 十六进制整数 |

### List
  有序集合，可随时添加和删除其中的元素。  
  有两个特点：  
  * 查找和插入的时间随着元素的增加而增加
  * 占用空间小，浪费内存少
```
>>> classmates = ['Michael', 'Bob', 'Tracy']
>>> classmates
['Michael', 'Bob', 'Tracy']
```
使用 len() 函数获取长度，最后一位元素是 len(classmates) -1
追加元素使用 append() ，插入元素使用 insert()，删除末尾使用 pop()，删除指定 pop(1)

```
>>> classmates.append('Adam')
>>> classmates
['Michael', 'Bob', 'Tracy', 'Adam']

>>> classmates.insert(1, 'Jack')
>>> classmates
['Michael', 'Jack', 'Bob', 'Tracy', 'Adam']

>>> classmates.pop()
'Adam'
>>> classmates
['Michael', 'Jack', 'Bob', 'Tracy']

>>> classmates.pop()
'Adam'
>>> classmates
['Michael', 'Jack', 'Bob', 'Tracy']
```

### Tuple
有序列表元组，与list类似，但初始化后不能修改
```
>>> classmates = ('Michael', 'Bob', 'Tracy')
```
如果只有一个元素，需要加上一个逗号避免歧义
```
>>> t = (1,)
>>> t
(1,)
```

### Dict
字典，全称dictionary，使用键值对(key , value)存储
```
>>> d = {'Michael': 95, 'Bob': 75, 'Tracy': 85}
>>> d['Michael']
95
```

使用 in 判断 key 是否存在
```
>>> 'Thomas' in d
False
```

使用 get() ，如果 key 不存在，可以返回 None，或者指定的value
```
>>> d.get('Thomas')
>>> d.get('Thomas', -1)
-1
```

删除一个 key ，对应的 value 也会删除，使用 pop(key) 
```
>>> d.pop('Bob')
75
>>> d
{'Michael': 95, 'Tracy': 85}
```
和List相比，有两个特点:
  * 查找和插入速度快，不会随着key的增加而变慢
  * 需要占用大量内存，浪费内存多

### Set
与 dict 类似，但仅存储 key，不存储value，且key不可以重复
```
>>> s = set([1, 2, 3])
>>> s
{1, 2, 3}
```
通过 add(key) 添加元素
```
>>> s.add(4)
>>> s
{1, 2, 3, 4}
>>> s.add(4)
>>> s
{1, 2, 3, 4}
```
通过 remove(key) 删除元素


