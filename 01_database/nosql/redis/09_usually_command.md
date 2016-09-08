### 服务相关操作

    dbsize #返回当前数据库中key的数目
    info #返回redis数据库状态信息，获取redis服务器的统计信息
    flushdb #清空当前数据库中所有的键
    flushall #清空所有数据库中的所有的key
    bgrewriteaof #异步执行一个aof文件写操作
    config get * #查看所有的配置项
    config get timeout #获取数据过期时间
    config set timeout 0 #重设timeout

### 键值相关操作

    kyes * //取出所有key
    keys my* // 模糊匹配
    exists name // 有name键，返回1，否则返回0
    del key1 // 删除一个key //成功返回1，否则返回0
    EXPIRE key1 100 //设置key1 在100s后过期
    ttl key //查看键还有多长时间过期，单位是s，当key不存在时，返回-2，当key存在但没有设置剩余生存时间时，返回-1，否则，返回key的剩余生存时间。
    select 0 //代表选择当前数据库，默认进入0数据库
    move age 1 //把age移动到1数据库
    persist key1 //取消key1的过期时间
    randomkey //随机返回一个key
    rename oldname newname //重命名key
    type key1 //返回键的类型
