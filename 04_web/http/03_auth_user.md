对admin管理页面做用户认证    
用处：给一些特殊的访问设置一个用户认证机制，增加安全。   
修改虚拟主机配置文件

vim /usr/local/apache/conf/extra/httpd-vhosts.conf


    NameVirtualHost *:80
    
    <VirtualHost *:80>
        DocumentRoot "/data/www"
        ServerName www.test.com
        ServerAlias www.aaa.com
        <Directory /data/www/admin.php>
            AllowOverride AuthConfig
            AuthName "tishi information"
            AuthType Basic
            AuthUserFile /data/.htpasswd
            require valid-user
        </Directory>
    </VirtualHost>

说明：首先指定要对哪个目录进行验证，AuthName 自定义，AuthUserFile 指定用户密码文件在哪里。  
添加虚拟用户

    /usr/local/apache/bin/htpasswd -cm /data/.htpasswd user1 #第一次
    #-c是创建/data/.htpasswd文件
    /usr/local/apache/bin/htpasswd -m /data/.htpasswd user2 #第二次
    

重新加载配置文件

    /usr/local/apache/bin/apachectl graceful
