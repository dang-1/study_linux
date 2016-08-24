### hash简介
在memcached中，我们经常将一些结构化的信息打包成hashmap，在客户端序列化存储为一个字符串的值（一般是json格式），比如用户的昵称、年龄、性别、积分等。

### 常用命令
    > hset hash1 name dang #建立hash
    (integer) 1
    > hget hash1 name
    "dang"
    > hset hash1 age 30
    (integer) 1
    > hget hash1 age
    "30"
    > HGETALL hash1
    1) "name"
    2) "dang"
    3) "age"
    4) "30"

    > hmset user2 name dang age 30 job it  #批量建立hash键值对
    OK
    > hmget user2 name age job
    1) "dang"
    2) "30"
    3) "it"
    > hdel user2 job #删除指定field
    (integer) 1
    > hkeys user2 #打印所有的key
    1) "name"
    2) "age"
    > hvals user2 #打印所有的values
    1) "dang"
    2) "30"
    > hlen user2 #查看hash的field的个数
    (integer) 2
