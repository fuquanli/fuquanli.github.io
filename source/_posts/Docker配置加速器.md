---
title: Docker配置加速器
date: 2020-03-15 16:21:30
tags:
- docker
categories: 技术
---

有时使用Docker拉取镜像慢如蜗牛，这个时候就需要配置下加速器，Docker 官方和国内很多云服务商都提供了国内加速器服务。

如Docker官方提供中国镜像库：**https://registry.docker-cn.com**

阿里的加速器：**https://5ch7vat9.mirror.aliyuncs.com**

<!-- more -->

这里我使用的是阿里的加速器，使用了一阶段，感觉还不错，大大的提高了拉取镜像的速度。

如何配置？

首先进入docker目录

```bash
cd /etc/docker
```

创建并编辑文件daemon.json

```bash
vim daemon.json
```

编辑内容为

```bash
{     
    "registry-mirrors": ["https://5ch7vat9.mirror.aliyuncs.com"]  
}
```

重新启动docker

```bash
sudo systemctl daemon-reload 
sudo systemctl restart docker 
```



