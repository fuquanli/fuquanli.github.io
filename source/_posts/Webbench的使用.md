---
title: Webbench的使用
date: 2018-09-03 08:54:00
tags: Test
categories: Tool
---

  Webbench是一个在linux下使用的非常简单的网站压测工具。它使用fork()模拟多个客户端同时访问我们设定的URL，测试网站在压力下工作的性能，最多可以模拟3万个并发连接去测试网站的负载能力。  

  下载好tar.gz文件，上传到linux。  

<!-- more -->

* 编译安装
``` 
root@ip:/home/ftp/webbench-1.5# make install
cc -Wall -ggdb -W -O  -o webbench webbench.o  
install -s webbench /usr/local/bin    
install -m 644 webbench.1 /usr/local/man/man1    
install -d /usr/local/share/doc/webbench
install -m 644 debian/copyright /usr/local/share/doc/webbench
install -m 644 debian/changelog /usr/local/share/doc/webbench
```
* 使用
```
root@ip:/home/ftp/webbench-1.5# webbench -c 100 http://fedupapi.azurewebsites.net/
Webbench - Simple Web Benchmark 1.5
Copyright (c) Radim Kolar 1997-2004, GPL Open Source Software.

Benchmarking: GET http://fedupapi.azurewebsites.net/
100 clients, running 30 sec.

Speed=10854 pages/min, 76339 bytes/sec.
Requests: 5427 susceed, 0 failed.
```

如果执行 make install 出错
```
xx@xx:~/WebBench$ make install
cc -Wall -ggdb -W -O   -c -o webbench.o webbench.c
webbench.c: In function ‘alarm_handler’:
webbench.c:80:31: warning: unused parameter ‘signal’ [-Wunused-parameter]
static void alarm_handler(int signal)
```

解决方案(WebBench 依赖 ctags)
```
sudo apt-get install ctags 
```
