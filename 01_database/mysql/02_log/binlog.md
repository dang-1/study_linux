### 基础
1.记录了所有的DDL和DML(除了数据查询语句)语句，以事件形式记录，还包含语句所执行的消耗的时间，MySQL的二进制日
志是事务安全型的。  

#### 二进制日志的使用场景
    1.主从
    2.数据恢复，通过使用mysqlbinlog工具来使恢复数据。
    
    
    
二进制日志包括两类文件：二进制日志索引文件（文件名后缀为.index）用于记录所有的二进制文件，二进制日志文件（文
件名后缀为.00000*）记录数据库所有的DDL和DML(除了数据查询语句)语句事件。 

## 一、开启/关闭以及查看binlog日志
### 1.开启binlog
修改配置文件    
    在/etc/my.cnf文件中，在[mysqld] 区块  
    设置/添加 log-bin=mysql-bin  确认是打开状态(值 mysql-bin 是日志的基本名或前缀名)；  
重启生效：  
### 2.关闭binlog
    mysql> SET SQL_LOG_BIN=0 #停止使用日志文件
    mysql> SET SQL_LOG_BIN=1 #启动binlog
也可以在配置文件中注释log-bin，重启后关闭
    

### 3.查看开启
可登录mysql服务器，通过mysql的变量配置表，查看二进制日志是否已开启   
mysql> show variables like 'log_%';  
查看log-bin那行的值是否为ON

## 三、常用binlog日志操作命令

    mysql> show master logs; #查看所有binlog日志列表
    mysql> show master status; #查看master状态，即最后(最新)一个binlog日志的编号名称，及其
    #最后一个操作事件pos结束点(Position)值
    mysql> flush logs; #刷新log日志，自此刻开始产生一个新编号的binlog日志文件 每当mysqld服务重
    #启时，会自动执行此命令，刷新binlog日志；
    mysql> reset master; #重置(清空)所有binlog日志


## 四、日志更新策略

    a.服务器重启  
    b.服务器被更新 
    c.日志达到了最大日志长度max_binlog_size  
    d.日志被刷新mysql> flush logs;  

## 五、使用binlog恢复数据




## 六、日志格式
### 1.基于SQL语句的复制(statement-based replication,SBR)
仅仅记录执行的语句
### 2.基于行的复制(row-based replication,RBR)
不是所有的修改都会以row level来记录，像遇到表结构变更的时候就会以statement模式来记录，如果sql语句
确实就是update或者delete等修改数据的语句， 那么还是会记录所有行的变更。
### 3.混合模式复制(mixed-based replication,MBR)
会根据执行的每一条具体的sql语句来区分对待 记录的日志形式，也就是在Statement和Row之间选择一种。

### 4.静态设置binlog格式
    vi my.cnf
    log-bin = mysql-bin
    #binlog_format = "STATEMENT"
    #binlog_format = "ROW"
    binlog_format = "MIXED"

### 5.动态修改binlog格式：
    mysql>SET SESSION binlog_format ='STATEMENT';
    mysql>SET SESSION binlog_format ='ROW';
    mysql>SET SESSION binlog_format ='MIXED'; 
    mysql>SET GLOBAL binlog_format ='STATEMENT';
    mysql>SET GLOBAL binlog_format ='ROW';
    mysql>SET GLOBAL binlog_format ='MIXED';

## 七、binary log相关变量和参数
### 1.命令行参数

    --log-bin [=file_name] #设置此参数表示启用binlog功能，并制定路径名称。
    --log-bin-index[=file] #设置此参数是指定二进制索引文件的路径与名称。
    --max_binlog_size #Binlog最大值，最大和默认值是1GB，该设置并不能严格控制
    --#Binlog的大小，尤其是Binlog比较靠近最大值而又遇到一个比较大事务时，
    --#为了保证事务的完整性，不可能做切换日志的动作，只能将该事务的所有
    --#SQL都记录进当前日志，直到事务结束。
    --binlog-do-db=db_name #此参数表示只记录指定数据库的二进制日志
    --binlog-ignore-db=db_name #此参数表示不记录指定的数据库的二进制日志

### 2.配置文件

    log_bin
    binlog_cache_size #此参数表示binlog使用的内存大小，可以通过状态变量binlog_cache_use和binlog_cache_disk_use来帮助测试。
    max_binlog_cache_size #此参数表示binlog使用的内存最大的尺寸
    binlog_cache_use #使用二进制日志缓存的事务数量
    binlog_cache_disk_use #使用二进制日志缓存但超过binlog_cache_size值并使用临时文件来保存事务中的语句的事务数量。
    binlog_do_db #记录binlog的库
    binlog_ignore_db #忽略记录配置的库
    sync_binlog #这个参数直接影响mysql的性能和完整性。
    sync_binlog=0 #当事务提交后，Mysql仅仅是将binlog_cache中的数据写入binlog文件，但不执行fsync之类的磁盘，同步指令通知文件系统将缓存刷新到磁盘，而让Filesystem自行决定什么时候来做同步，这个是性能最好的。
    
  sync_binlog=0，在进行n次事务提交以后，Mysql将执行一次fsync之类的磁盘同步指令，通知文件系统将Binlog文件缓存刷新到磁盘。  
  Mysql中默认的设置是sync_binlog=0，即不做任何强制性的磁盘刷新指令，这时性能是最好的，但风险也是最大的。一旦系统Crash，在文件系统缓存中的所有Binlog信息都会丢失。

   默认情况下，并不是每次写入时都将二进制日志与硬盘同步。因此如果操作系统或机器(不仅仅是MySQL服务器)崩溃，有可能二进制日志中最后的语句丢失。 要想防止这种情况，你可以使用sync_binlog全局变量(1是最安全的值，但也是最慢的)，使二进制日志在每N次二进制日志写入后与硬盘同步。 即使sync_binlog设置为1,出现崩溃时，也有可能表内容和二进制日志内容之间存在不一致性。  
   如果崩溃恢复时MySQL服务器发现二进制日志变短了(即至少缺少一个成功提交的InnoDB事务)， 如果sync_binlog =1并且硬盘/文件系统的确能根据需要进行同步(有些不需要)则不会发生，则输出错误消息 (“二进制日志<名>比期望的要小”)。 在这种情况下，二进制日志不准确，复制应从主服务器的数据快照开始。

