
# 主文件
    user www www;
    worker_processes 8;
    error_log /var/log/nginx/error.log info;
    pid /var/run/nginx.pid;
    worker_rlimit_nofile 65535;
    
    events
    {
        use epoll;
        worker_connections 65535;
    }
    
    
    http
        {
        include mime.types;
        default_type application/octet-stream;
        #charset utf-8;
        server_names_hash_bucket_size 3526;
        server_names_hash_max_size 4096;
        log_format combined_realip '$remote_addr $http_x_forwarded_for [$time_local]'
            '$host "$request_uri" $status'
            '"$http_referer" "$http_user_agent"';
        sendfile on;
        #autoindex on;
        tcp_nopush on;
        tcp_nodelay on;
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
        
        #fastcgi_connect_timeout 300;
        #fastcgi_send_timeout 300;
        #fastcgi_read_timeout 300;
        #fastcgi_buffer_size 64k;
        #fastcgi_buffers 4 64k;
        #fastcgi_busy_buffers_size 128k;
        #fastcgi_temp_file_write_size 128k;
        
        gzip on;
        gzip_min_length 1k;
        gzip_buffers 4 8k;
        gzip_comp_level 5;
        gzip_http_version 1.1;
        gzip_types text/plain application/x-javascript text/css text/htm application/xml;
        #gzip_vary on;
        
        #limit_zone crawler $binary_remote_addr 10m;
        
        include /usr/local/nginx/conf/vhosts/*.conf;
    }


## 虚拟主机

    server
        {
        listen 80;
        server_name www.test.com test.com;
        index index.html index.htm index.php;
        root /data/www/www.test.com;
        
        location ~ .*\.(php|php5)?$
            {
            fastcgi_pass 127.0.0.1:9000;
            fastcgi_index index.php;
            include fastcgi.conf;
            }

        location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
            {
            expires 10d;
            }
        
        location ~ .*\.(js|css)?$
            {
            expires 1h;
            }
        
        log_format access '$remote_addr - $remote_user [$time_local] "$request" '
        '$status $body_bytes_sent "$http_referer" '
        '"$http_user_agent" $http_x_forwarded_for';
        
        }
