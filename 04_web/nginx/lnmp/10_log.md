
## （1 ）日志格式
在 nginx.conf 中定义日志格式，配置如下：

    log_format main '$remote_addr - $remote_user [$time_local] $request '
    '"$status" $body_bytes_sent "$http_referer" '
    '"$http_user_agent" "$http_x_forwarded_for"';
下面的日志格式，会记录代理的 ip 和真实客户端真实 ip，建议大家平时用这个配置。  

    log_format combined_realip '$proxy_add_x_forwarded_for - $remote_user [$time_local] '
    '"$request" $status $body_bytes_sent '
    '"$http_referer" "$http_user_agent"';
## （2 ）错误日志 error_log  日志级别
error_log 级别分为 debug, info, notice, warn,error, crit 默认为 crit, 该级别在日志名后边定义格式如下：

    error_log /your/path/error.log combined_realip;
crit 记录的日志最少，而 debug 记录的日志最多。
## （3 ）某些类型的文件不记录日志
这个就要比 apache 简单多了。配置如下：

    location ~ .*\.(gif|jpg|jpeg|png|bmp|swf|js|css)$
    {
        access_log off;
    }



## 配置

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
