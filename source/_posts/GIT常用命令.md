---
title: GIT常用命令
date: 2018-04-12 11:12:57
tags: Git
categories: 工具
---

**GIT中常用的一些命令(持续更新中...)**

下载项目: 
```
git clone https://***
```

查看远程仓库:
```
git remote -v
```

查看分支本地文件： 
```
git status
```

本地分支关联远程主版本：获取代码使用pull 
否则使用 git pull origin 远程主分支名：本地分支名

提交修改文件:
```
git add ****
```

提交本地仓库 
```
git commit -m '注释'
```

推送代码 
```
git push origin master
```

错误： fatal: refusing to merge unrelated histories   
  *拒绝合并不相关的项目*
```
git pull origin master --allow-unrelated-histories //强制合并
```