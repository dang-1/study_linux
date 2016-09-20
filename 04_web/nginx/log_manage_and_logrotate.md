
## 一、日志分类

访问日志  
错误日志  
可以在http和server模块中配置，nginx有一个非常灵活的日志记录模式。每个级别的配置可以有各自独立的访问日志。日志格式通过log_format命令来定义
### 1.访问日志

#### 1.1功能 
主要记录客户端访问Nginx的每一个请求  


#### 1.2格式：
    log_format用来设置日志格式，只能在http模块下设置
    log_format name   name(格式名称)   type(格式样式)
#### 1.3示例：
默认配置
    
    log_format  main  '$remote_addr - $remote_user [$time_local]"$request" '
        '$status $body_bytes_sent"$http_referer" '
        '"$http_user_agent" "$http_x_forwarded_for"';   

下面的示例会记录代理的 ip 和真实客户端真实 ip，建议大家平时用这个配置。  

    log_format combined_realip '$proxy_add_x_forwarded_for - $remote_user [$time_local] '
        '"$request" $status $body_bytes_sent '
        '"$http_referer" "$http_user_agent"';
生产环境示例

    log_format  main  '$http_host-$http_x_forwarded_for  ${request_time}s- [$time_local] "$request"'
        '$status $body_bytes_sent"$http_referer" "$http_user_agent" $remote_addr ' ;
字段含义：

    $remote_addr #远程客户端的IP地址。
    $remote_user #远程客户端用户名称，如果网站设置了用户验证的话就会有，否则空白
    [$time_local] #访问的时间与时区比如18/Jul/2012:17:00:01+0800时间信息最后的"+0800"表示服务器所处时区位于UTC之后的8小时。
    $request #记录请求的url和http协议
    $status #记录请求返回的http状态码.
    $body_bytes_sent #记录发送给客户端的文件主体内容的大小
    $http_referer #记录 记录从哪个页面链接访问过来的。
    $http_user_agent #记录客户端浏览器信息
    $http_x_forwarded_for #客户端的真实ip。当nginx前面有代理服务器时，$remote_addr获取到的只能是nginx上一级的IP，
    #而反向代理服务器在转发请求的http头信息中可以增加x_forwarded_for信息用以记录原有客户端的IP地址和原来客户端的
    #请求的服务器地址，$http_x_forwarded_for参数就是承接上一级传递的客户端IP参数。从而就获取到了客户端的真实IP。

#### 1.4定义文件
access_log 指令用来指定日志文件的存放路径，可以在http、server、location中设置    
举例说明如下  

    access_log  logs/access.log  main;
    #如果想关闭日志可以如下
    access_log off;

### 2.错误日志
错误日志主要记录客户端访问Nginx出错时的日志格式，不支持自定义。  
如果不指定路径的话默认是在logs下。  
由指令error_log来指定具体格式如下  
    
    error_log  path(存放路径)  level(日志等级)[debug | info | notice | warn | error |crit]

### 3.配置

    cat www.test.com.conf 
    server
    {
        listen 80;
        server_name www.test.com www.aaa.com;
        if ($host != 'www.test.com' ) {
            rewrite ^/(.*)$ http://www.test.com/$1 permanent;
        }
        index index.html index.htm index.php;
        root /data/www.test.com;
        access_log /data/logs/nginx/test.com_access.log combined_realip;
        location ~ .*\.(gif|jpg|jpeg|png|bmp|swf|js|css)$
        {
            access_log off;
        }
    
        location ~ .*admin\.php$ {
            auth_basic "discuz auth";
            auth_basic_user_file /usr/local/nginx/conf/.htpasswd;
            include fastcgi_params;
            fastcgi_pass 127.0.0.1:9000;
            fastcgi_index index.php;
            fastcgi_param SCRIPT_FILENAME /data/www.test.com/$fastcgi_script_name;
        }
        location ~ \.php$ {
            include fastcgi_params;
            fastcgi_pass 127.0.0.1:9000;
            fastcgi_index index.php;
            fastcgi_param SCRIPT_FILENAME /data/www.test.com/$fastcgi_script_name;
        }
    }

## 二、日志管理（切割日志）
### 1.实现方法
脚本切割或者使用centos自带工具logrotate  
### 2.脚本切割

实现：每天定时把日志移动到备份目录，然后重新reload或者restart。这样会在原来的logs下生成新的日志文件。(提示：当日志文件被移动到备份目录后，在没有restart的之前，nginx依然会向原来的日志文件中记录访问请求，只有等restart的之后生成了新文件，才重新记录到新的日志文件中)

定义日志路径，定义nginx的pid文件。

    # vim /usr/local/sbin/nginx_logrotate.sh
    #加入如下内容
    #! /bin/bash
    d=`date -d "-1 day" +%Y%m%d`
    backup_dir=/data/log/nginx/back/
    log_dir=/data/log/nginx/
    [ -d ${backup_dir} ] || mkdir -p ${backup_dir}
    [ -d ${log_dir} ] || mkdir -p ${log_dir}
    /bin/mv ${log_dir}test.com_access.log ${backup_dir}$d_test.com_access.log
    /bin/kill -HUP `cat /usr/local/nginx/logs/nginx.pid`
对该脚本写cront计划任务，每天0点执行
    
### 3.系统工具logrotate
    # vim /etc/logrotate.d/nginx
    #加入如下内容：
    /data/log/nginx/*.log {
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
