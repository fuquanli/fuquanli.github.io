---
title: Ubuntu部署netcore网站无法访问
date: 2020-03-15 16:13:30
tags:
- Ubuntu
- .Netcore
categories: Technology
---

记录一次发布.netcore网站到linux上的问题

<!-- more -->

前几天应工作需要，在阿里云上部署一个测试站点。本以为分分钟的事情，没想到打脸了。

当时直接新建一个webapi项目，publish后直接上传到阿里云，随后设置nginx转发网站端口5000。

接着打开网站测试访问，结果傻眼了，502.....。

于是乎，使用dotnet命令行启动，指定端口8080，更改nginx配置转而监听8080。测试，又打不开。

明明是按照众大神的文章一步一步来的，怎么会出错呢？搞不明白。随后老老实实阅读微软官方文档，

终于发现问题所在。原来是我没有设置Kestrel的监听端口。

论基础的重要性！！！要好好读书o(╥﹏╥)o，夯实基本功。

经历说完了，接下来说说如何配置网站端口。

设置的方式有三种：

**第一种：Program类的CreateHostBuilder方法指定Urls**

```c#
public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseUrls("http://*:8080");
                    webBuilder.UseStartup<Startup>();
                });
```

**第二种：使用配置文件Hosting.json**

```json
{
  "urls": "http://*:8080"
}
```

项目需要添加引用

```C#
"Microsoft.Extensions.Configuration.FileExtensions": "1.0.0",
"Microsoft.Extensions.Configuration.Json": "1.0.0"
```

Program代码

```C#
public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>();
                }).ConfigureHostConfiguration(configHost => { 
                    configHost.SetBasePath(Directory.GetCurrentDirectory());
                    configHost.AddJsonFile("hosting.json", optional: true, reloadOnChange : true);
                });
```

**第三种：使用命令行配置**

```bash
dotnet demo.dll --environment development --urls "http://*:8081"
```

项目需要添加引用

```C#
"Microsoft.Extensions.Configuration.CommandLine": "3.1.2"
```

Program代码

```C#
public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>();
                }).ConfigureHostConfiguration(configHost => { 
                    configHost.AddCommandLine(args);
                });
```

注：三种方式可同时配置，但是具有优先级：UseUrls < 文件配置 < 命令行配置

