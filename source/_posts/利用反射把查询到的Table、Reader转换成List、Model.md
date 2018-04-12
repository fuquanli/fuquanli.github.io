---
title: 利用反射把查询到的Table、Reader转换成List、Model
date: 2018-04-12 11:58:49
tags: 
- C#
- 反射 
categories: 技术
---

纯粹写着玩，在不使用ORM工具的情况下通过反正转换类型。

<!-- more -->

通常我们从数据库查询到一个  DataReader  或者是  一个 Table , 想要转换成 一个 list 或者是 
一个model 的话 , 一般情况下是使用foreach 循环reader或是table的rows，然后在循环内创建个对象，通过reader[“列名”]来赋值对象的属性。如果表的字段少的话，用这种方式还可以，速度也快一点。但是如果后续还会增加字段的话，那就非常麻烦了，要改很多地方。工作量太大，而且还很容易出错。所以这个时候使用反射来转换的话就非常便捷了。我们只管增加字段，改一下数据表对应的model，调用这个工具类的方法，传入相对应的参数就能得到想要的结果。

```
public static List<T> ConvertToList<T>(DataTable dt)
{
    List<T> list = new List<T>(); // 定义集合
    Type type = typeof(T); // 获得此模型的类型
    string tempName = "";
    PropertyInfo[] propertys = type.GetProperties();// 获得此模型的公共属性
    foreach (DataRow dr in dt.Rows)
    {
        //新建一个模型
        object obj = type.Assembly.CreateInstance(type.FullName);
        foreach (PropertyInfo pi in propertys)
        {
            tempName = pi.Name;
            if (dt.Columns.Contains(tempName))
            {
                if (!pi.CanWrite) continue;
                object value = dr[tempName];
                if (value != DBNull.Value)
                    pi.SetValue(obj, value, null);
            }
        }
        list.Add((T)obj);
    }
    return list;
}

public static List<T> ConvertToList<T>(IDataReader reader)
{
    List<T> list = new List<T>(); // 定义集合
    Type type = typeof(T); // 获得此模型的类型
    string tempName = "";
    PropertyInfo[] propertys = type.GetProperties();// 获得此模型的公共属性
    while (reader.Read())
    {
        //新建一个模型
        object obj = type.Assembly.CreateInstance(type.FullName);
        foreach (PropertyInfo pi in propertys)
        {
            tempName = pi.Name;
            if (ReaderExists(reader, tempName))
            {
                if (!pi.CanWrite) continue;
                object value = reader[tempName];
                if (value != DBNull.Value)
                    pi.SetValue(obj, value, null);
            }
        }
        list.Add((T)obj);
    }
    return list;
}

public static T ConvertToModel<T>(IDataReader reader)
{
    Type type = typeof(T);
    PropertyInfo[] proList = type.GetProperties();
    //新建一个模型
    object obj = type.Assembly.CreateInstance(type.FullName);
    string tempName = "";
    if (reader.Read())
    {
        foreach (PropertyInfo pi in proList)
        {
            tempName = pi.Name;
            if (ReaderExists(reader, pi.Name))
            {
                if (!pi.CanWrite) continue;
                object value = reader[tempName];
                if (value != DBNull.Value)
                    pi.SetValue(obj, value, null);
            }
        }
    }
    return (T)obj;
}

public static T ConvertToModel<T>(DataRow row)
{
    Type type = typeof(T);
    PropertyInfo[] proList = type.GetProperties();
    //新建一个模型
    object obj = type.Assembly.CreateInstance(type.FullName);
    string tempName = "";
    foreach (PropertyInfo pi in proList)
    {
        tempName = pi.Name;
        if (!string.IsNullOrEmpty(row[tempName].ToString()))
        {
            if (!pi.CanWrite) continue;
            object value = row[tempName];
            if (value != DBNull.Value)
                pi.SetValue(obj, value, null);
        }
    }
    return (T)obj;
}

/// <summary>
/// 验证reader是否存在某列
/// </summary>
/// <param name="reader"></param>
/// <param name="columnName"></param>
/// <returns></returns>
private static bool ReaderExists(IDataReader reader, string columnName)
{
    int count = reader.FieldCount;
    for (int i = 0; i < count; i++)
    {
        if (reader.GetName(i).Equals(columnName))
        {
            return true;
        }
    }
    return false;
}
```
