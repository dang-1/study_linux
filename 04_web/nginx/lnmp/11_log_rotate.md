nginx 没有 apache 自动切割的工具，但是我们可以自己写脚本，也可以借助 CentOS 自带的日志归档工具 logrotate。  
## （1 ）使用脚本切割
首先确定访问日志路径， 假定为/data/logs/nginx/test.com_access.log， 还要确定 nginx 的 pid 文件所在路径，假定为/usr/local/nginx/logs/nginx.pid。

    # vim /usr/local/sbin/nginx_logrotate.sh
    #加入如下内容
    #! /bin/bash
    d=`date -d "-1 day" +%Y%m%d`
    [ -d /data/logs/nginx/ ] || mkdir /data/logs/nginx/
    /bin/mv /data/logs/nginx/test.com_access.log /data/logs/nginx/$d_test.com_access.log
    /bin/kill -HUP `cat /usr/local/nginx/logs/nginx.pid`
然后写一个计划任务，每天 0 点 0 分执行该脚本。还可以做压缩，判断是否会覆盖别的文件
## （2 ）借助系统的 logrotate  工具实现

    # vim /etc/logrotate.d/nginx
    #加入如下内容：
    /home/logs/*.log {
    Daily
    Missingok
    rotate 52
    compress
    delaycompress
    notifempty
    create 644 nobody nobody
    sharedscripts
    postrotate
    [ -f /usr/local/nginx/var/nginx.pid ] && kill -USR1 `cat /usr/local/nginx/var/nginx.pid`
    Endscript
    }
说明：
第一行就要定义日志的路径，可以是多个日志。  
daily 表示日志按天归档。  
missingok 表示忽略所有错误，比如日志文件不存在的情况下。  
rotate 52 表示存放的日志个数，最多就 52 个，最老的会被删除。  
compress 表示日志要压缩。  
delaycompress 表示压缩除了当前和最近之外的所有其他版本。  
notifempty 表示如果日志为空，则不归档。  
create 644 nobody nobody 定义归档日志的权限以及属主和属组。  
sharedscripts 表示所有的日志共享该脚本，因为我们在这里指定的日志文件为多个，用来*.log。  
postrotate 后面跟轮换过日志之后要运行的命令。  
endscript 表示结束了。
