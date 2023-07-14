---
title: JS设置localStorage有效期
id: 422886F81BCA6B29305410027114C835
date: 2018-09-03 08:54:00
tags: js
categories: Technology
---

  localStorage是一个没有时间限制的数据存储，如果没有手动删除它，它将永久保存。但是有些时候我们又需要它在一段时间后自动删除，这里我们可以对它进行扩展。

<!-- more -->

``` js

var date = new Date().getTime();
//设置localStorage的值
foowwLocalStorage.set("test", "你好", date + 10000);
//获取localStorage的值
var data = foowwLocalStorage.get("test");


const foowwLocalStorage = {
    set: function (key, value, ttl_ms) {
        var data = { value: value, expirse: new Date(ttl_ms).getTime() };
        localStorage.setItem(key, JSON.stringify(data));
    },
    get: function (key) {
        var data = JSON.parse(localStorage.getItem(key));
        if (data !== null) {
            debugger
            if (data.expirse != null && data.expirse < new Date().getTime()) {
                localStorage.removeItem(key);
            } else {
                return data.value;
            }
        }
        return null;
    }
}
```
  