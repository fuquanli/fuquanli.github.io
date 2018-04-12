---
title: linux常用命令
date: 2018-04-12 10:58:20
tags: Linux
categories: 系统
---

**Linux中常用的一些命令，记录下来方便日后查询(持续更新中...)**

<!-- more -->

查看端口使用情况
```
netstat -ntpl
```

删除文件夹
```
rm
rm-rf //删除文件夹所以文件  
```
查看系统版本
```
cat /proc/version
```
查看所有监听端口
```
netstat -Intp
```
重启Nginx
```
service nginx restart
```
重启FTP
```
service vsftpd restart
```
添加账号
```
sudo adduser xxx //home目录下添加一个账号
```
添加用户
```
sudo useradd xxx //添加用户，不在home目录添加账号
```
删除账户
```
userdel -r xxx //加上r删除用户目录
```
查看当前系统用户
```
cat etc/passwd
```
文件/文件夹命令
```
//CP命令
//格式：CP [选项] 源文件或目录 目的文件或目录
//选项说明：-b:同名，备份原来文件  -f 强制覆盖同名文件  -r 按递归方式保留原目录结构复制文件
cp -r /tmp/a /root/a

//MV 移动

//解压tag.gz
tar -zxvf ...

```
