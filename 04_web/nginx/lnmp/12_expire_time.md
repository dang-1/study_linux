把指定文件类型不记录日志和该功能一起配置。

    location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
    {
        expires 30d;
        access_log off;
    }
    location ~ .*\.(js|css)$
    {
        expires 12h;
        access_log off;
    }
自己配置

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
        location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$
        {
            expires 30d;
            access_log off;
        }
        location ~ .*\.(js|css)$
        {
            expires 12h;
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
