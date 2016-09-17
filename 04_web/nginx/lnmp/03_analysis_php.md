首先配置 nginx 配置文件，使其能够支持 php。

    vim /usr/local/nginx/conf/nginx.conf
    #找到
    #location = /50x.html {
    #root html;
    }
    #在其后面新增如下配置：
    location ~ \.php$ {
    root html;
    fastcgi_pass unix:/tmp/php-fcgi.sock; #将套接字的权限修改
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME /usr/local/nginx/html$fastcgi_script_name;
    include fastcgi_params;
    }
    #重新加载 /usr/local/nginx/sbin/nginx -s reload
    /usr/local/nginx/sbin/nginx -t #测试配置文件
    #创建测试文件:
    # vim /usr/local/nginx/html/2.php
    内容如下:
    <?php
    echo "test php scripts.";
    ?>
    
    <?php
    phpinfo();
    ?>
    测试:
    # curl localhost/2.php
    test php scripts. [root@localhost nginx]#
    显示成这样，才说明 PHP 解析正常。
