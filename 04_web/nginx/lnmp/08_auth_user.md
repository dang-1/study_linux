nginx用户认证

首先需要安装 apache，可以使用 yum install httpd 安装。然后生成密码文件：

    htpasswd -c -m /usr/local/nginx/conf/htpasswd dang
这样就添加了 dang 用户，第一次添加时需要加-c 参数，第二次添加时不需要-c 参数。  
在 nginx 的虚拟主机配置文件中添加

    location /uc_server/ {
    auth_basic "Auth";
    auth_basic_user_file /usr/local/nginx/conf/htpasswd;
    }
这样就会把请求/uc_server/的访问给限制了，只有输入用户名和密码才可以继续访问，基本上和 apache 的配置类似。


配置文件为：

    server
    {
        listen 80;
        server_name www.test.com;
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
    
    
验证：

    curl -x127.0.0.1 -udang:123456 www.test.com/admin.php
