功能：禁止ip访问，禁止默认虚拟主机  
此文件中第一个配置虚拟主机的即为默认主机。  

特点：凡是解析到这台机器的域名，不管是什么域名，只要在配置文件中没有配置，那么都会访问到这个主机上来。  

举例，我们直接用 ip 访问，会访问到这个站点上来。为了避免别人乱解析， 所以应该把默认也就是第一个虚拟主机给禁止掉。 用 ip 去访问，发现已经提示：

    Forbidden
    You do not have permission to access / on this server.
    vim /usr/local/apache/conf/extra/httpd-vhosts.conf
    
    NameVirtualHost *:80

    <VirtualHost *:80>
        DocumentRoot "/tmp/123"
        ServerName 111.com
        <Directory /tmp/tmp/>
            Order allow,deny
            Deny from all
        </Directory>
    </VirtualHost>
    
    <VirtualHost *:80>
        DocumentRoot "/data/www"
        ServerName www.test.com
        ServerAlias www.aaa.com
        <Directory /data/www/admin.php>
            AllowOverride AuthConfig
            AuthName "alksdjflkasjdf"
            AuthType Basic
            AuthUserFile /data/.htpasswd
            require valid-user
        </Directory>
    </VirtualHost>

    
    #重新加载
    /usr/local/apache/bin/apachectl graceful
