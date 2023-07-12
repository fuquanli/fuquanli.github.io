---
title: SQLServer批量修改和插入
date: 2023-07-12 18:55:15
tags: 
- SQL
- SQL Server
categories: Technology
---
# 场景

今天在工作中遇到这么一个场景，我需要根据条件对表A做批量更新或插入。因为条件比较复杂，所以我使用了临时表B，先把需要更新或插入的数据查询出来放入临时表。然后更新表A的某字段，更新条件是A.id = B.id，更新效果是若记录存在表A中，则更新表A的字段，若不在表A中，则插入一条记录到表A。

<!-- more -->

# 初始方案

首先想到的是写两条SQL：

1. update使用A.id in (select id from B)，这时会更新所有存在的记录的字段，不存在则不更新
2. 接下来再使用insert，条件是A.id not in (select id from B)，把A不存在未更新的数据插入到A

两条SQL执行完，则完成了所有数据的更新和插入。

# 优化方案

后面有朋友提示可以使用SQL Merge语句做这件事情，由于对数据库并不熟悉，所以不知道还有这么一个语法。我查阅了相关资料，发现Merge确实很合适这个场景。参考[SQL Server Merge语句 - SQL Server教程 (yiibai.com)](https://www.yiibai.com/sqlserver/sql-server-merge.html)重构了代码

```sql
select ... into #B 
	from A  where ... 

merge [A] a using #B b  
    on a.id = b.id  
    when matched  
	    then update set a.field = 1 
    when not matched by target  
	    then insert (field)  
		values (b.id);
```
