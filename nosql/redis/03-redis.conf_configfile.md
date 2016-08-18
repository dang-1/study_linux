#### 通用配置 

    daemonize no #是否作为守护进程运行，默认为否，改成yes会生成一个pid文件。
    pidfile /var/lib/redis.pid  #如果以后台进程运行，则需要指定一个pid，默认为/var/run/redis.pid。
    bind 127.0.0.1 #绑定主机IP，默认值为127.0.0.1，可以有多个
    port 6379 #redis默认监听端口
    unixsocket /tmp/redis.sock # 也可以监听socket
    unixsocketperm 755 #当监听socket时可以指定权限为755
    timeout 300 #客户端闲置多少秒后，断开链接，默认300秒，如果为0表示关闭该功能,永不关闭
    tcp-keepalive 0 #TCP连接保活策略，可以通过tcp-keepalive配置项来进行设置，单位为秒，假如设置为60秒，则server端会每60秒向连接空闲的客户端发起一次ACK请求，以检查客户端是否已经挂掉，对于无响应的客户端则会关闭其连接，如果设置为0，则不会进行保活检测。
    loglevel verbose #日志记录等级，有4个可选值，debug，verbose（默认值），notice，warning。
    logfile stdout #指定日志输出的文件名，默认为标准输出stdout，也可以设置为/dev/null屏蔽日志
    syslog-ident redis #如果希望日志打印到syslog中，通过syslog-enabled来控制。另外，syslog-ident还可以让你指定syslog里的日志标志。
    syslog-facility local0 #指定syslog的设备，可以是USER或者local0-local7
    database 16 #可用数据库，默认值为16，默认数据库为0,select n 选择数据库，0-15
    maxclients 128 #设置同一时间最大客户端连接数，默认无限制，Redis可以同时打开的客户端连接数
    #为Redis进程可以打开的最大文件描述符数，如果设置 maxclients 0，表示不作限制。当客户端连接数
    #到达限制时，Redis会关闭新的连接并向客户端返回max number of clients reached错误信息。
    maxmemory <bytes> #指定Redis最大内存限制，Redis在启动时会把数据加载到内存中，达到最大内存
    #后，Redis会先尝试清除已到期或即将到期的Key，当此方法处理 后，仍然到达最大内存设置，将无法再
    #进行写入操作，但仍然可以进行读取操作。Redis新的vm机制，会把Key存放内存，Value会存放在swap区
    slowlog-log-slower-than 10000 #单位：微秒(microsecond，1秒 = 1,000,000 微秒)
    client-output-buffer-limit slave 256mb 64mb 60 #向slave发送rdb 时的时间、buffer限制。
    client-output-buffer-limit pubsub 32mb 8mb 60 #向订阅者发送数据时的时间、buffer限制。
    
    
#### 持久化-RDB

    save 900 1 #表示每900秒且至少有一个key改变，就触发一次持久化
    save 300 10 #表示每300秒且至少有10个key改变，就触发一次持久化
    save 60 10000 #表示每60秒且至少有10000个key改变，就触发一次持久化
    save "" #这样可以禁用rdb持久化
    stop-writes-on-bgsave-error yes #rdb持久化写入磁盘避免不了会出现失败的情况，默认 一出现失败，redis会马上停止写操作。如果你觉得无所谓，那就可以使用该选项关闭这个功能。
    rdbcompression yes #指定存储至本地数据库时是否压缩数据，默认为yes，redis采用LZF压缩，如果
    #为了节省CPU时间可以关闭改选项，但会导致数据库文件变得巨大。
    rdbchecksum yes #是否要进行数据校验
    dbfilename dump.rdb #指定本地数据库文件名，默认值是dump.rdb，最好添加绝对路径，若不添加，
    #则在启动用户的home目录下。
    dir /var/lib/redis/  #本地数据库存放路径，默认值为 ./

#### 持久化-AOF

    appendonly no #指定是否在每次更新操作后进行日志记录，Redis在默认情况下是异步的把数据写入
    #磁盘，如果不开启，可能会在断电时导致一段时间内的数据丢失。因为 redis本身同步数据文件是按
    #上面save条件来同步的，所以有的数据会在一段时间内只存在于内存中。默认为no。
    appendfilename "appendonly.aof" #指定aof更新日志文件名，保存在dir参数指定的目录
    appendfsync everysec #指定更新日志条件(no：表示等操作系统进行数据缓存同步到磁盘（快）,
    #always：表示每次更新操作后手动调用fsync()将数据写到磁盘（慢，安全）,
    #everysec：表示每秒同步一次（折衷，默认值）)。
    no-appendfsync-on-rewrite no #使用no可避免当写入量非常大时的磁盘io阻塞
    auto-aof-rewrite-percentage 10 #规定什么情况下回触发aof重写。该值为一个比例，10表示当aof文件增幅达到10%时则会触发重写机制
    auto-aof-rewrite-min-size 64mb #重写会有一个条件，就是不能低于64Mb

#### replication -redis的复制配置

    slave of <masterip> <masterport> #设置主从服务器的主服务器的IP及端口
    masterauth <master-password> #当本机为从服务时，设置主服务器的链接密码
    #AUTH命令提供密码，默认关闭
    slave-read-only yes //让从只读
    repl-ping-slave-period 10 //设置slave向master发起ping的频率，每10秒发起一次
    repl-timeout 60 //设置slave ping不通master多少s后就超时
    repl-disable-tcp-nodelay no //是否开启tcp_nodelay,开启后将会使用更少的带宽，但会有延迟，所以建议关闭
    repl-backlog-size 1mb //同步队列的长度，backlog是master的一个缓冲区，主从断开后，master会先把数据写到缓冲区，salve再次连接会从缓冲区中同步数据
    repl-backlog-ttl 3600 //主从断开后，缓冲区的有效期，默认1小时
    slave-priority 100 //多个slave是可以设置优先级的，数值越小优先级越高，应用于集群中，支持salve切换为master，优先级最高的才会切换
    min-slaves-to-write 3 //和下面的一起使用，它的意思是master发现有超过3个slave的延迟高于10s，那么master就会暂时停止写操作。这两个数值任何一个为0，则关闭该功能，默认第一数值是0
    min-slaves-max-lag 10

#### redis 安全配置
    requirepass foobared #设置redis连接密码，如果配置了连接密码，客户端在连接redis时需要  
    maxmemory-policy volatile-lru #指定内存移除规则
    maxmemory-samples 3 #LRU算法和最小TTL算法并非是精确的算法，而是估算值。所以你可以设置样本的大小。假如redis默认会检查三个key并选择其中LRU的那个，那么你可以改变这个key样本的数量。

#### virtual memory 虚拟内存

    vm-enabled no #指定是否启用虚拟内存机制，默认值为no，VM机制将数据分页存放，由Redis将访问量
    #较少的页即冷数据swap到磁盘上，访问多的页面由磁盘自动换出到内存中（在后面的文章我会仔细分析
    #Redis的VM机制）
    vm-swap-file /tmp/redis.swap #虚拟内存文件路径，默认值为/tmp/redis.swap，不可多个Redis实例共享
    vm-max-memory 0 #将所有大于vm-max-memory的数据存入虚拟内存,无论vm-max-memory设置多小,所有
    #索引数据都是内存存储的(Redis的索引数据 就是keys),也就是说,当vm-max-memory设置为0的时候,其实是
    #所有value都存在于磁盘。默认值为0。
    vm-page-size 32 #Redis swap文件分成了很多的page，一个对象可以保存在多个page上面，但一个page上
    #不能被多个对象共享，vm-page-size是要根据存储的 数据大小来设定的，作者建议如果存储很多小对象，
    #page大小最好设置为32或者64bytes；如果存储很大大对象，则可以使用更大的page，如果不 确定，
    #就使用默认值。
    vm-pages 134217728 #设置swap文件中的page数量，由于页表（一种表示页面空闲或使用的bitmap）
    #是在放在内存中的，，在磁盘上每8个pages将消耗1byte的内存
    vm-max-threads 4 #设置访问swap文件的线程数,最好不要超过机器的核数,如果设置为0,那么所有
    #对swap文件的操作都是串行的，可能会造成比较长时间的延迟。默认值为4

注意：Redis官方文档对VM的使用提出了一些建议:
当你的key很小而value很大时,使用VM的效果会比较好.因为这样节约的内存比较大.
当你的key不小时,可以考虑使用一些非常方法将很大的key变成很大的value,比如你可以考虑将key,value组合成一个新的value.
最好使用linux ext3 等对稀疏文件支持比较好的文件系统保存你的swap文件.
vm-max-threads这个参数,可以设置访问swap文件的线程数,设置最好不要超过机器的核数.如果设置为0,那么所有对swap文件的操作都是串行的.可能会造成比较长时间的延迟,但是对数据完整性有很好的保证.

#### 慢日志
针对慢日志，你可以设置两个参数，一个是执行时长，单位是微妙，另一个是慢日志的长度。当一个新的命令被写入日志时，最老的一条会从命令日志队列中被移除。  

    slowlog-log-slower-than 10000 #慢于10000ms则记录日志  
    slowlog-max-len 128 #日志长度
    
#### 主从配置

#### advanced config

    glueoutbuf yes #设置在向客户端应答时，是否把较小的包合并为一个包发送，默认为开启
    hash-max-zipmap-entries 64 #指定在超过一定的数量时，采用一种特殊的哈希算法
    hash-max-zipmap-value 512 #指定在者最大的元素超过某一临界值时，采用一种特殊的哈希算法
    activerehashing yes #是否重置Hash表，指定是否激活重置哈希，默认为开启（后面在介绍Redis
    #的哈希算法时具体介绍）

    include /path/to/local.conf #指定包含其它的配置文件，可以在同一主机上多个Redis实例之间使
    #用同一份配置文件，而同时各个实例又拥有自己的特定配置文件
