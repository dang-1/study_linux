#### 介绍
string类型是redis最基本的数据类型，一个key对应一个value，一个键最大能存512Mb。
string是二进制安全的。

#### 常用命令：

    > set mykey "dang"
    OK
    > get mykey
    "dang"
    > set mykey "nihao" #多次赋值会覆盖原来的值
    OK
    > get mykey
    "nihao"
    > mset key1 1 key2 2 key3 e #多次赋值
    OK
    > mget key1 key2 key3 #取多个值
    1) "1"
    2) "2"
    3) "e"
    
    > setnx mykey 111 #返回0
    (integer) 0
    > setnx mykey2 111 #返回1
    (integer) 1
    > get mykey2
    "111"
    #setnx如果key存在，则返回0，并不会覆盖存在的值，不存在会直接创建这个key
    
    > setex key6 30 yes #设定过期时间，前面为有效期，后面为值
    OK
    > ttl key6 #获取过期时间，若没有过期时间，则返回-1
    (integer) 25
    > ttl mykey2
    (integer) -1
