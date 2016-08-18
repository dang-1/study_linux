#### 1.安装：
    yum install vim gcc -y
    wget  https://github.com/antirez/redis/archive/2.8.21.tar.gz
    wget https://redis.googlecode.com/files/redis-2.6.12.tar.gz
    tar xf 
    make
    make PREFIX=/usr/local/redis  install
    mkdir /usr/local/redis/etc
    mkdir /usr/local/redis/log
    mkdir /usr/local/redis/redis
    echo "PATH=/usr/local/redis/bin/:$PATH" >> /etc/profile
    echo "export PATH" >> /etc/profile
    source /etc/profile

#### 2.配置文件为/usr/local/redis/etc/redis.conf
    daemonize yes
    pidfile /var/run/redis.pid
    port 6379
    tcp-backlog 511
    timeout 0
    tcp-keepalive 0
    loglevel notice
    logfile "/usr/local/redis/log/redis.log"
    databases 16
    save 900 1
    save 300 1000
    save 60 10000
    stop-writes-on-bgsave-error yes
    rdbcompression yes
    rdbchecksum yes
    dbfilename dump.rdb
    dir /usr/local/redis/redis
    slave-serve-stale-data yes
    slave-read-only yes
    repl-diskless-sync no
    repl-diskless-sync-delay 5
    repl-disable-tcp-nodelay no
    slave-priority 100
    maxclients 300000
    maxmemory 8589934592
    appendonly no
    appendfilename "appendonly.aof"
    appendfsync everysec
    no-appendfsync-on-rewrite no
    auto-aof-rewrite-percentage 100
    auto-aof-rewrite-min-size 64mb
    aof-load-truncated yes
    lua-time-limit 5000
    slowlog-log-slower-than 10000
    slowlog-max-len 128
    latency-monitor-threshold 0
    notify-keyspace-events ""
    hash-max-ziplist-entries 512
    hash-max-ziplist-value 64
    list-max-ziplist-entries 512
    list-max-ziplist-value 64
    set-max-intset-entries 512
    zset-max-ziplist-entries 128
    zset-max-ziplist-value 64
    hll-sparse-max-bytes 3000
    activerehashing yes
    client-output-buffer-limit normal 0 0 0
    client-output-buffer-limit slave 256mb 64mb 60
    client-output-buffer-limit pubsub 32mb 8mb 60
    hz 10
    aof-rewrite-incremental-fsync yes


### 3./usr/local/redis/bin目录
    redis-server //redis服务器的daemon启动程序
    redis-cli //redis命令行操作工具。也可以用telnet根据其纯文本协议来操作。
    redis-benchmark //redis性能测试工具，检测redis在系统以及配置下的读写性能
    redis-stat //redis状态检测工具，可以检测redis当前状态参数以及延迟状况


#### 4.启动：
    /usr/local/redis/bin/redis-server /usr/local/redis/etc/redis.conf
#### 5.检测：
    ps -ef | grep redis
    redis-cli ping 

#### 6.关闭：
手动持久化内存数据至磁盘（注意，持久化时，可能需要额外的maxmemory，即：若配置了8G，则再需要8G内存才能完成数据的持久化）
    redis-cli -h 127.0.0.1 -p 6379   bgsave //默认保存到配置文件中的‘dir’下。
    /usr/local/redis/bin/redis-cli shutdown //默认关闭6379端口的redis进程,关闭时，会使用bgsave持久化数据到磁盘中。
关闭指定端口的redis-server
    redis-cli -p 6379 shutdown
#### 7.保存/备份
数据备份可以通过定期备份该文件实现。  
因为redis是异步写入磁盘的，如果要让内存中的数据马上写入硬盘可以执行如下命令：  
redis-cli save 或者 redis-cli -p 6380 save（指定端口）  
注意，以上部署操作需要具备一定的权限，比如复制和设定内核参数等。  
执行redis-benchmark命令时也会将内存数据写入硬盘。   

#### 8.连接
    redis-cli -a passwd

