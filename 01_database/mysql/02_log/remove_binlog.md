## 语法
    PURGE {MASTER | BINARY} LOGS TO 'log_name'
    PURGE {MASTER | BINARY} LOGS BEFORE 'date'
用于删除列于在指定的日志或日期之前的日志索引中的所有二进制日志。这些日志也会从记录在日志索引文件中的清单中被删除，这样被给定的日志成为第一个。  
BEFORE变量的date自变量可以为'YYYY-MM-DD hh:mm\:\ss'格式。MASTER和BINARY是同义词。

##  安全清除binlog
binlog过多的时候，先使用purge命令

    purge binary logs to 'log-bin.000056'; #将log-bin.000056之前的binary logs清理
    purge binary logs before '2016-06-28 12:16:56' #将指定时间之前的binary logs清掉


注意，不要轻易手动去删除binlog，会导致binlog.index和真实存在的binlog不匹配，而导致expire_logs_day失效  
如果从服务器停止，如果清除未读取的binlog日志，则会造成主从不同步。主从同步的时候，则可以安全清除。  




## 查看设置的binlog的过期时间
    show variables like '%expire%';  
在线设置binlog的过期时间  

    set global expire_logs_days=10;  
为了使之生效，需要flush logs。

##   RESET MASTER
  删除之前所有的binlog，并重新生成新的binlog，后缀从000001开始。

**注意**：  
如果有从服务器正在读取日志，则该操作将会失败，并返回一个错误。  
如果从服务器正在等待读取日志，则可以操作。  
但是从服务器关闭时，如果清除了未读取的日志，则会导致主从不一致。
