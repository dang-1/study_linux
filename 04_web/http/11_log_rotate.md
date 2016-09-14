apache 有相关的配置，使日志按照需求进行归档，比如每天一个新日志，或者每小时一个新日志。  

编辑配置文件打开日志

    vim /usr/local/apache/conf/extra/httpd-vhosts.conf
    #在对应的虚拟主机配置文件中加入
    ErrorLog "|/usr/local/apache/bin/rotatelogs -l /usr/local/apache/logs/aaa-error_%Y%m%d.log 86400"
    CustomLog "|/usr/local/apache/bin/rotatelogs -l /usr/local/apache/logs/aaa-access_%Y%m%d.log 86400" combined
说明：上面是两行，注意不要写成多于两行。ErrorLog 是错误日志，CustomLog
是访问日志。最前面的那个竖线其实就是管道符，意思是把产生的日志交给
rotatelogs 这个工具，而这个工具就是 apache 自带的切割日志的工具。-l
的作用是校准时区为 UTC，也就是北京时间。最后面的 86400，单位是
秒，所以正好是一天，那么日志会每天切割一次。  
而最后面的combined为日志格式，关于日志格式在/usr/local/apcahe/conf/httpd.conf 里面定义。

    # grep LogFormat /usr/local/apache/conf/httpd.conf
    LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
    LogFormat "%h %l %u %t \"%r\" %>s %b" common
    LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %I %O"
    combinedio
