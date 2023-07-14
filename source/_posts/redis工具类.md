---
title: Redis工具类
id: D073ECB6924A39E46720C56440498BDF
date: 2018-04-12 13:06:43
tags: 
- Redis
- C#
categories: Technology
---

redis工具类

<!-- more -->

```
public class RedisConnector
{
    public class RedisParseResult<T>
    {
        public bool success;
        public T value;
    }

    private static string ConnectionString { get; set; }
    private static ConnectionMultiplexer RedisConnection { get; set; }

    public RedisConnector(string redisConnectionString)
    {
        ConnectionString = redisConnectionString;
        try
        {
            RedisConnection = ConnectionMultiplexer.Connect(ConnectionString);
        }
        catch (RedisConnectionException e)
        {
            AILogger.LogError(e.Message, $"Redis server : {redisConnectionString}").Wait();
        }
    }

    public static void Initialize(string redisConnectionString)
    {
        ConnectionString = redisConnectionString;
        try
        {
            RedisConnection = ConnectionMultiplexer.Connect(ConnectionString);
        }
        catch (RedisConnectionException e)
        {
            AILogger.LogError(e.Message, $"Redis server : {redisConnectionString}").Wait();
        }
    }

    public static IDatabase RedisStore => (null != RedisConnection) ? RedisConnection.GetDatabase() : ConnectionMultiplexer.Connect(ConnectionString).GetDatabase();

    public static ConnectionMultiplexer Redis => RedisConnection ?? ConnectionMultiplexer.Connect(ConnectionString);

    public async static Task<bool> Store(string key, string value, int expiry = 120, bool replace = false) => await RedisStore.StringSetAsync(key, value, TimeSpan.FromSeconds(expiry), replace ? When.Always : When.NotExists);

    public async static Task<bool> Store(string key, long value, int expiry = 120, bool replace = false) => await RedisStore.StringSetAsync(key, value.ToString(), TimeSpan.FromSeconds(expiry), replace ? When.Always : When.NotExists);

    public async static Task<bool> Store<T>(string key, T value, int expiry = 120, bool replace = false) => await RedisStore.StringSetAsync(key, JsonConvert.SerializeObject(value), TimeSpan.FromSeconds(expiry), replace ? When.Always : When.NotExists);

    public static string Get(string key) => RedisStore.StringGet(key);

    public static RedisParseResult<T> Get<T>(string key)
    {
        var storedValue = RedisStore.StringGet(key);
        if (string.IsNullOrEmpty(storedValue))
            return new RedisParseResult<T> { success = false };
        else
            return new RedisParseResult<T> { success = true, value = JsonConvert.DeserializeObject<T>(storedValue) };
    }
}
```