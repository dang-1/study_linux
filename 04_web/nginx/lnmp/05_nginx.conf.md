更改 nginx  配置  
首先把原来的配置文件清空:  

    # > /usr/local/nginx/conf/nginx.conf
    “>” 这个符号为重定向的意思。单独用它，可以把一个文本文档快速清空。
    # vim /usr/local/nginx/conf/nginx.conf //写入如下内容:
    user nobody nobody;
    worker_processes 2;
    
    error_log /usr/local/nginx/logs/nginx_error.log crit;
    pid /usr/local/nginx/logs/nginx.pid;
    
    worker_rlimit_nofile 51200;
    events
    {
        use epoll;
        worker_connections 6000;
    }
    
    http
        {
            include mime.types;
            default_type application/octet-stream;
            server_names_hash_bucket_size 3526;
            server_names_hash_max_size 4096;
            log_format combined_realip '$remote_addr $http_x_forwarded_for [$time_local]'
            '$host "$request_uri" $status'
            '"$http_referer" "$http_user_agent"';
            sendfile on;
            tcp_nopush on;
            keepalive_timeout 30;
            client_header_timeout 3m;
            client_body_timeout 3m;
            send_timeout 3m;
            connection_pool_size 256;
            client_header_buffer_size 1k;
            large_client_header_buffers 8 4k;
            request_pool_size 4k;
            output_buffers 4 32k;
            postpone_output 1460;
            client_max_body_size 10m;
            client_body_buffer_size 256k;
            client_body_temp_path /usr/local/nginx/client_body_temp;
            proxy_temp_path /usr/local/nginx/proxy_temp;
            fastcgi_temp_path /usr/local/nginx/fastcgi_temp;
            fastcgi_intercept_errors on;
            tcp_nodelay on;
            gzip on;
            gzip_min_length 1k;
            gzip_buffers 4 8k;
            gzip_comp_level 5;
            gzip_http_version 1.1;
            gzip_types text/plain application/x-javascript text/css text/htm application/xml;
    
            server
                {
                    listen 80;
                    server_name localhost;
                    index index.html index.htm index.php;
                    root /usr/local/nginx/html;
                    location ~ \.php$ {
                    include fastcgi_params;
                    fastcgi_pass unix:/tmp/php-fcgi.sock;
                    fastcgi_index index.php;
                    fastcgi_param SCRIPT_FILENAME /usr/local/nginx/html$fastcgi_script_name;
                    }
                }
            include /usr/local/nginx/conf/vhosts/*.conf;
        }
说明：该配置文件可以作为一个模板，你可以用在你的服务器上，以后工作中也可以从参考。下载地址：http://study.lishiming.net/.nginx_conf  
保存配置后，先检验一下配置文件是否有错误存在:  

    # /usr/local/nginx/sbin/nginx -t
如果显示内容如下，则配置正确，否则需要根据错误提示修改配置文件:  

    nginx: the configuration file /usr/local/nginx/conf/nginx.conf syntax is ok
    nginx: configuration file /usr/local/nginx/conf/nginx.conf test is successful
    重启 nginx 服务
    # service nginx restart
之前我已经讲过 apache 有一个默认的虚拟主机，也就是说无论什么域名只要指向到这台机器都会访问到这个虚拟主机。其实，在 nginx 里面也有一个这样的默认虚拟主机，但它有一个配置可以用来标记哪个虚拟主机是默认的。
    
    # mkdir /usr/local/nginx/conf/vhosts
    # cd !$
    # vim default.conf 加入如下配置
    默认虚拟主机，禁止访问
    server
    {
        listen 80 default_server;
        server_name 123.com;
        index index.html index.htm index.php;
        root /tmp/tmp;
        deny all;
    }
    discuz主机
    server
    {
        listen 80;
        server_name www.test.com;
        index index.html index.htm index.php;
        root /data/www.test.com;
        
        location ~ \.php$ {
            include fastcgi_params;
            fastcgi_pass 127.0.0.1:9000;
            fastcgi_index index.php;
            fastcgi_param SCRIPT_FILENAME /data/www.test.com/$fastcgi_script_name;
        }
    }
    
    
    
说明：我们在之前的 nginx.conf 中就已经定义了 include 语句，意思是它会包含一些配置，在这里它会把/usr/local/nginx/conf/vhosts/目录下的所有*.conf 文件加载。所以，我们在这个目录下定义了一个 default.conf 文件，在这里你会发现 listen 80 后面还有一个关键词叫做“default_server”，这个就是用来标记它是默认虚拟主机的。我们使用 deny all 限制了该虚拟主机禁止被任何人访问。

配置DISCUZ论坛，需要将

    unzip Discuz_X3.2_SC_UTF8.zip
    mv upload/* www.test.com
    cd www.test.com
    chown php-fpm uc_client uc_server data config -R
