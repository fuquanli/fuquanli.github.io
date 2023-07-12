---
title: 上传本地项目到GitHub
date: 2018-04-12 11:18:25
tags: 
- Git
- GitHub
categories: Tool
---

1. 生成ssh秘钥
```
ssh-keygen -t rsa -C "xxxx@xx.com"
```

<!-- more -->

2. 登录github，打开Account Settings ,选择 SSH Public Keys ，添加 ..\.ssh\id_rsa.pub 的内容

3. 设置用户信息
```
git config --global user.name "fuquanli"    //设置用户名
git config --global user.email "fuquan.li@qq.com"    //设置邮箱
```

4. 测试连接 
```
ssh -T git@github.com
```

5. 建立本地仓库
```
cd d:text
git init
```

6. 将所有文件添加到仓库
```
git add .
```

7. 提交指令
```
git commit -m "提交文件"
```

8. 关联github仓库  
  复制项目地址后执行  
```
git remote add origin [项目地址]
```

9. 上传本地仓库代码
```
git push -u origin master
```