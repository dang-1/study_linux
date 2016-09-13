# mysql5.5 httpd 2.2 php 5.4

## 

## 1.安装mysql5.5 参见安装mysql

## 2.安装httpd 2.2

    yum install -y gcc zlib-devel openssl-devel
    tar xf 
    cd 
    ./configure \
    --prefix=/usr/local/apache \
    --with-included-apr \
    --enable-so \
    --enable-deflate=shared \
    --enable-expires=shared \
    --enable-rewrite=shared \
    --with-pcre
    
    make
    make install
    
    vim /usr/local/apache/conf/httpd.conf
    ServerName  localhost:80
    
    /usr/local/apache/bin/apachectl start #启动
    /usr/local/apache/bin/apachectl graceful #重新加载配置文件
    /usr/local/apache/bin/apachectl -M #列出模块
    /usr/local/apache/bin/apachectl -l #列出静态模块
    ls /usr/local/apache/modules/ #动态模块位置
    ls /usr/local/apache/bin/httpd #静态被编译至该文件
    /usr/local/apache/bin/apachectl -t #查看配置文件是否有错
    


## 3.安装php 5.4
在编译 php 的时候，需要指定mysql 以及 apache 的路径，故放最后面。
    
    yum install -y libxml2-devel bzip2 bzip2-devel ibpng reetype
    yum install -y libpng-devel freetype-devel libmcrypt-devel libjpeg-devel
    tar xf
    cd
    ./configure \
    --prefix=/usr/local/php \
    --with-apxs2=/usr/local/apache/bin/apxs \
    --with-config-file-path=/usr/local/php/etc \
    --with-mysql=/usr/local/mysql \
    --with-libxml-dir \
    --with-gd \
    --with-jpeg-dir \
    --with-png-dir \
    --with-freetype-dir \
    --with-iconv-dir \
    --with-zlib-dir \
    --with-bz2 \
    --with-openssl \
    --with-mcrypt \
    --enable-soap \
    --enable-gd-native-ttf \
    --enable-mbstring \
    --enable-sockets \
    --enable-exif \
    --disable-ipv6

    make
    make install
    
    cp php.ini-production /usr/local/php/etc/php.ini
    
    在/usr/local/apache/modules/会有一个libphp5.so
    
    然后找到：
    AddType application/x-gzip .gz .tgz
    在该行下面添加:
    AddType application/x-httpd-php .php

    DirectoryIndex index.html index.htm index.php
    
    service iptables stop
    setenforce 0
    
    测试解析
    /usr/local/apache/htdocs/1.php 
    <?php
    echo "php works."; 
    ?>
    
    cat info.php 
    <?php
    phpinfo();
    ?>







