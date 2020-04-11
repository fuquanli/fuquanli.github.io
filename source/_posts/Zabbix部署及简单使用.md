---
title: Zabbix部署和简单使用
date: 2020-04-11 20:20:00
tags: 运维
categories: 技术
---

**Zabbix部署和简单使用**

  使用Docker容器部署Zabbix，并添加Windows和Linux服务器监测节点。

<!-- more -->

##  Zabbix是什么

Zabbix是一种网络监视、管理系统，基于Server-Client架构。可用于监视各种网络服务、服务器和网络机器等状态。

可以监控如下资源

![](https://s1.ax1x.com/2020/04/11/GbhL4J.png)

## 为什么要监控？

1. 在需要的时刻，提前提醒我们服务器出问题了
2. 当出问题之后，可以找到问题根源
3. 实时观测网站/服务器的可用性

## 工作模式

分为主动模式和被动模式

1. 主动模式：客户端主动把自己监测到的数据上报给服务端，服务端不需要向客户端发起请求

![](https://s1.ax1x.com/2020/04/11/Gbh7HU.png)

2. 被动模式：服务端向客户端发起请求，告诉客户端我需要哪些数据，然后客户端执行相关操作，把执行结果返回给服务端

   ![](https://s1.ax1x.com/2020/04/11/GbhTBT.png)



## 自动发现与自动注册

1. 自动发现：zabbix主动发现所有客户端，扫描设定的IP段。缺点是压力大，时间长

2. 自动注册：zabbix agent主动到zabbix Server上报到，登记；缺点agent有可能找不到Server（配置出错）

   自动注册配置：

   ![](https://s1.ax1x.com/2020/04/11/GbLdZn.png)

   ![](https://s1.ax1x.com/2020/04/11/GbLNrj.png)

   ![](https://s1.ax1x.com/2020/04/11/GbLtMQ.png)

   ![](https://s1.ax1x.com/2020/04/11/GbLUqs.png)

   ![](https://s1.ax1x.com/2020/04/11/GbLwaq.png)

## 使用Docker安装Zabbix服务端

安装必须组件 mysql5.7、zabbix-server-mysql和zabbix-web-nginx-mysql

```
# 启动mysql5.7实例
docker run --name mysql-server -t -v /etc/timezone:/etc/timezone -v /etc/localtime:/etc/localtime  -v /data/mysql5.7/data:/var/lib/mysql -v /data/mysql/etc:/etc/mysql/conf.d   -e MYSQL_DATABASE="zabbix"       -e MYSQL_USER="zabbix"       -e MYSQL_PASSWORD="zabbix"       -e MYSQL_ROOT_PASSWORD="zabbix"       -d mysql:5.7  --character-set-server=utf8 --collation-server=utf8_bin

# 启动Zabbix server实例，并关联这个实例到已创建的MySQL服务器实例
docker run --name zabbix-server-mysql -t  -e PHP_TZ="Asia/Shanghai" -v /etc/timezone:/etc/timezone  -v /etc/localtime:/etc/localtime   -e DB_SERVER_HOST="mysql-server"       -e MYSQL_DATABASE="zabbix"       -e MYSQL_USER="zabbix"       -e MYSQL_PASSWORD="zabbix"       -e MYSQL_ROOT_PASSWORD="zabbix"       --link mysql-server:mysql       -p 10051:10051       -d zabbix/zabbix-server-mysql:latest

# 启动Zabbix web 接口，并将它与MySQL服务器实例和Zabbix server实例关联
docker run --name zabbix-web-nginx-mysql -t -e PHP_TZ="Asia/Shanghai" -v /etc/timezone:/etc/timezone  -v /etc/localtime:/etc/localtime     -e DB_SERVER_HOST="mysql-server"       -e MYSQL_DATABASE="zabbix"       -e MYSQL_USER="zabbix"       -e MYSQL_PASSWORD="zabbix"       -e MYSQL_ROOT_PASSWORD="zabbix"       --link mysql-server:mysql       --link zabbix-server-mysql:zabbix-server       -p 80:80       -d zabbix/zabbix-web-nginx-mysql:latest
```

修改每个容器时区

```
docker cp /usr/share/zoneinfo/Asia/Shanghai containerId:/etc/localtime
```

解决中文乱码问题

```
#找到字体所位置
find -name DejaVuSans.ttf
拷贝Windows下的C:\Windows\Fonts 宋体字体 到docker里
随后备份DejaVuSans.ttf字体，并更名宋体为DejaVuSans.ttf，刷新页面可看到效果
```

## 添加服务器

**添加一台Windows服务器**

客户端操作：

[下载Zabbix Agent客户端](https://www.zabbix.com/cn/download_agents)，并安装到被监测的主机上

Server和ServerActive均设置为监控服务器的IP

若Zabbix服务器在内网，被监控对象在外网，则需要拿到监控服务端的外网IP。

如何获取外网IP？

先在zabbix服务器使用telnet命令连客户端的10050端口，然后在客户端使用netstat -an | grep 10050查看被那个IP访问了。

Web操作：

1. 进入页面：【配置】->【主机】->【创建主机】

   ![](https://s1.ax1x.com/2020/04/11/GbTKQs.png)

2. 必填主机名、群组选择Templates/Operating systems，agent代理程序的ip地址填被监控主机ip，端口不变为10050。

   ![](https://s1.ax1x.com/2020/04/11/GbTmWQ.png)

3. 选择Tab【模板】，选中Template OS Windows By zabbix agent

   ![](https://s1.ax1x.com/2020/04/11/GbTnzj.png)

4. 点击底部添加按钮，回到主机列表页

   ![](https://s1.ax1x.com/2020/04/11/GbTeJg.png)

**添加一台Linux服务器**

客户端操作：

```
#关闭SELinux (如果有)
sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config
setenforce 0
#防火墙设置，允许zabbix-agent的10050端口通过
firewall-cmd --permanent --add-port=10050/tcp
firewall-cmd --reload
#下载安装包并安装(Centos)
rpm -Uvh https://repo.zabbix.com/zabbix/4.4/rhel/7/x86_64/zabbix-release-4.4-1.el7.noarch.rpm
yum install zabbix-agent
#下载安装包并安装(Ubuntu)
wget http://repo.zabbix.com/zabbix/4.4/ubuntu/pool/main/z/zabbix-release/zabbix-release_4.4-1+bionic_all.deb
dpkg -i zabbix-release_4.4-1+bionic_all.deb
apt update
apt install zabbix-agent
#安装完以后找到配置文件
find -name 'zabbix*'
#修改内容：
Server=<zbx-server的ip>
ServerActive=<zbx-server的ip>
Hostname=<本机名字>
#启动agent
systemctl start zabbix-agent.service
systemctl status zabbix-agent.service
```

Web操作同添加Windows

## 添加MYSQL

客户端操作：

```
#创建一个mysql用户
GRANT ALL ON . TO 'zbx_monitor'@'%' IDENTIFIED BY 'zbx_monitor';
FLUSH PRIVILEGES;
#在zabbix_agentd服务目录下创建my.cnf
目前我使用的是windows系统，zabbix_agentd安装在C盘，故而在C盘顶层创建，内容为：
[client]
user=zbx_monitor
password=zbx_monitor

#Zabbix_agentd目录下的zabbix_agentd.conf.d增加一个配置文件,内容为：

#template_db_mysql.conf created by Zabbix for "Template DB MySQL" and Zabbix 4.2
#For OS Linux: You need create .my.cnf in zabbix-agent home directory (/etc/zabbix by default)
#For OS Windows: You need add PATH to mysql and mysqladmin and create my.cnf in %WINDIR%\my.cnf,C:\my.cnf,BASEDIR\my.cnf https://dev.mysql.com/doc/refman/5.7/en/option-files.html
#The file must have three strings:
#[client]
#user=zbx_monitor
#password=<password>
UserParameter=mysql.ping[*], mysqladmi
UserParameter=mysql.get_status_variables[*], mysql -h"$1" -P"$2" -sNX -e "show global status"
UserParameter=mysql.version[*], mysqladmin -s -h"$1" -P"$2" version
UserParameter=mysql.db.discovery[*], mysql -h"$1" -P"$2" -sN -e "show databases"
UserParameter=mysql.dbsize[*], mysql -h"$1" -P"$2" -sN -e "SELECT SUM(DATA_LENGTH + INDEX_LENGTH) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='$3'"
UserParameter=mysql.replication.discovery[*], mysql -h"$1" -P"$2" -sNX -e "show slave status"
UserParameter=mysql.slave_status[*], mysql -h"$1" -P"$2" -sNX -e "show slave status"

修改zabbix_agentd.conf,添加内容：
Include=C:\Program Files\Zabbix Agent\zabbix_agentd.conf.d\*.conf

重启zabbix_agent服务

#到zabbix_mysql_server 监控主机测试mysql命令
zabbix_get -s ip -p 10050 -k mysql.ping
```

Web操作：

选择MYSQL所在主机

![](https://s1.ax1x.com/2020/04/11/GbbalQ.png)

![](https://s1.ax1x.com/2020/04/11/Gbbdyj.png)

## 添加网站

![](https://s1.ax1x.com/2020/04/11/GbqBge.png)

![](https://s1.ax1x.com/2020/04/11/GbqDjH.png)

![](https://s1.ax1x.com/2020/04/11/Gbqsud.png)