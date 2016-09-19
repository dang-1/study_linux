配置如下：

    if ($host != 'www.a.com' ) {
    rewrite ^/(.*)$ http://www.a.com/$1 permanent;
    }
和 apache 的相关配置很像。

    server
    {
        listen 80;
        server_name www.test.com www.aaa.com;
        if ($host != 'www.test.com' ) {
            rewrite ^/(.*)$ http://www.test.com/$1 permanent;
        }
        index index.html index.htm index.php;
        root /data/www.test.com;
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
