apache的配置文件：

    ServerRoot "/usr/local/apache"
    Listen 80
    LoadModule deflate_module modules/mod_deflate.so
    LoadModule expires_module modules/mod_expires.so
    LoadModule rewrite_module modules/mod_rewrite.so
    LoadModule php5_module        modules/libphp5.so
    <IfModule !mpm_netware_module>
    <IfModule !mpm_winnt_module>
    User daemon
    Group daemon
    </IfModule>
    </IfModule>
    ServerAdmin you@example.com
    ServerName  localhost:80
    DocumentRoot "/usr/local/apache/htdocs"
    <Directory />
        Options FollowSymLinks
        AllowOverride None
        Order deny,allow
        Allow from all
    </Directory>
    <Directory "/usr/local/apache/htdocs">
        Options Indexes FollowSymLinks
        AllowOverride None
        Order allow,deny
        Allow from all
    </Directory>
    <IfModule dir_module>
        DirectoryIndex index.html index.php
    </IfModule>
    <FilesMatch "^\.ht">
        Order allow,deny
        Deny from all
        Satisfy All
    </FilesMatch>
    ErrorLog "logs/error_log"
    LogLevel warn
    <IfModule log_config_module>
        LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
        LogFormat "%h %l %u %t \"%r\" %>s %b" common
        <IfModule logio_module>
          LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\" %I %O" combinedio
        </IfModule>
        CustomLog "logs/access_log" common
    </IfModule>
    <IfModule alias_module>
        ScriptAlias /cgi-bin/ "/usr/local/apache/cgi-bin/"
    </IfModule>
    <IfModule cgid_module>
    </IfModule>
    <Directory "/usr/local/apache/cgi-bin">
        AllowOverride None
        Options None
        Order allow,deny
        Allow from all
    </Directory>
    DefaultType text/plain
    <IfModule mime_module>
        TypesConfig conf/mime.types
        AddType application/x-compress .Z
        AddType application/x-gzip .gz .tgz
        AddType application/x-httpd-php .php
    </IfModule>
    Include conf/extra/httpd-vhosts.conf
    <IfModule ssl_module>
    SSLRandomSeed startup builtin
    SSLRandomSeed connect builtin
    </IfModule>
    



虚拟机配置文件：

    NameVirtualHost *:80

    <VirtualHost *:80>
        DocumentRoot "/data/www"
        ServerName www.test.com
        ServerAlias www.aaa.com
    </VirtualHost>
    
### 1.下载解压文件

    mkdir /data/www
    cd /data/www
    wget http://download.comsenz.com/DiscuzX/3.2/Discuz_X3.2_SC_UTF8.zip
    unzip Discuz_X3.2_SC_GBK.zip
    mv upload/* .
### 2.配置虚拟主机
    #打开虚拟主机
    Include conf/extra/httpd-vhosts.conf
    #然后编辑该配置文件
    vim /usr/local/apache/conf/extra/httpd-vhosts.conf
    #在最后面，加入如下配置：
    <VirtualHost *:80>
    DocumentRoot "/data/www"
    ServerName www.123.com
    </VirtualHost>
    #重启/加载 apache 服务
    /usr/local/apache/bin/apachectl -t #先检查配置是否正确
    /usr/local/apache/bin/apachectl restart #重启
    
    配置本地host文件，修改
    访问 http://www.test.com/install 根据页面提示修改
    
    
### 3.配置数据库
    > create database discuz;
    > grant all on discuz.* to 'dang'@'127.0.0.1' identified by '123456';
    > flush privileges;
    > quit
### 4.安装
    #因为 www.test.com 这个域名是我们随便定义了一个，所以是不能直接访问
    #的，需要先绑定 hosts， 其中 hosts 在 windows 和 linux 上都是存在的， 
    #可以把一个域名指向到一个 ip 上。  
    #windows 下的hosts文件路径在：C:\Windows\System32\drivers\etc\hosts， 
    #用记事本打开它，然后增加一行，保存：192.168.17.213 www.test.com

    #这里的 192.168.17.213 是我虚拟机的 ip。  
    #在浏览器输入：      
    http://www.123.com/install/
    #根据提示，修改对应目录的权限
    cd /data/www
    chown -R daemon config data uc_client uc_server
    #让这几个目录支持 apache 运行帐号可写，daemon 就是 apache 的运行
    #账号，在/usr/local/apache/conf/httpd.conf 中用 User 和 Group 定义的。
