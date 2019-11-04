---
layout: .netcore
title: IFormFile始终为空的问题
date: 2019-11-04 22:26:45
tags: .Netcore
---

  之前获取上传文件都是使用Request.Form.Files获取，直到这次
  改成定义形参 IFormFile时才遇到这个问题。  

```C#
// POST api/values
[HttpPost]
public void Post([FromForm] IFormFile file)
{
　　var files = Request.Form.Files;
　　//file == null
　　//files != null;
}
```

  不知道这是不是微软的一个BUG？  

  解决方案有两种：

  方案一：去除[ApiController]这个Attribute

  ```C#
  [Route("api/[controller]")]
  //[ApiController]
  public class ValuesController : ControllerBase 
  {
  }
  ```

 方案二：在[FromForm]里添加Name属性:[FromForm(name = "file")]，这个属性需跟file参数保持一致

  ```C#
  // POST api/values
  [HttpPost]
  public void Post([FromForm(Name = "file")] IFormFile file)
  {
  }
  ```

  >方案出自：[IFormFile is always null when receiving file from console app](https://stackoverflow.com/questions/52294830/iformfile-is-always-null-when-receiving-file-from-console-app)