# mysql5.5 httpd 2.2 php 5.4

## 1.安装mysql5.5 参见安装mysql

## 2.安装httpd 2.2

    yum install gcc zlib-devel openssl-devel
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









