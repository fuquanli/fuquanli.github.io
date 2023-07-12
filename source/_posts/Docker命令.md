---
title: Docker命令
date: 2020-03-15 16:13:30
tags:
- Docker
categories: Tool
---

docker 常用命令

<!-- more -->

```bash
docker images #输出所有镜像
docker rmi image_id #移除某镜像
docker ps #查看正在运行的容器
docker ps -a #查看所有容器

停用全部运行中的容器:docker stop $(docker ps -q)
删除全部容器：docker rm $(docker ps -aq)
一条命令实现停用并删除容器 docker stop $(docker ps -q) & docker rm $(docker ps -aq)

修改时区：docker cp /usr/share/zoneinfo/Asia/Shanghai 容器id:/etc/localtime

管理命令： 
container 管理容器 
image 管理镜像 
network 管理网络 
node 管理Swarm节点 
plugin 管理插件 
secret 管理Docker secrets 
service 管理服务 
stack 管理Docker stacks 
swarm 管理Swarm集群 
system 查看系统信息 
volume 管理卷 
如：docker container ls 显示所有容器 

普通命令： 
Docker exec -it containerId /bin/bash 进入容器
以root角色进入 ddocker exec -it -u root containerId /bin/bash

build 从一个DockerFile构建镜像 
commit 从容器创建一个镜像 
cp 从容器和主机文件系统之间拷贝文件 
create 创建一个容器 
diff 检查容器文件系统上的更改
events 从服务器获取实时事件 
exec 在正在运行的容器中运行命令 
export 将容器的文件系统导出为tar存档 
history 显示镜像的历史记录 
images 查看镜像列表 
import 从归档文件中创建镜像 
info 显示系统范围的信息 
inspect 返回Docker对象的低级信息 
kill kill运行中的容器 
load 从存档或者STDIN加载镜像 
login 登陆docker镜像仓库 
logout 退出docker镜像仓库 
logs 获取一个容器的日志 
pause 暂停一个或多个容器中的所有进程 
port 查看端口映射或容器的特定映射列表 
ps 查看容器列表 
pull 从镜像仓库拉取镜像 
push 将本地的镜像上传到镜像仓库,要先登陆到镜像仓库
rename 重命名容器 
restart 重启容器 
rm 删除容器 
rmi 删除镜像 
run 创建一个新的容器并运行一个命令
save 将指定镜像保存成 
tar 归档文件 
search 从Docker Hub搜索镜像 
start 启动容器 
stats 实时显示容器资源使用情况的统计信息
stop 停止容器 
tag 标记本地镜像，将其归入某一仓库
top 展示一个容器中运行的进程 
unpause 恢复容器中所有的进程 
update 更新容器配置 
version 显示Docker的版本信息 
wait 阻塞直到容器停止，然后打印退出代码 
如：docker images 显示所有镜像
```



