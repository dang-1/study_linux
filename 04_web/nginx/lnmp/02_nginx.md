




Nginx 官方网站(http://nginx.org),



（1 ）下载、解压 Nginx
    cd /usr/local/src/
    wget http://nginx.org/download/nginx-1.8.0.tar.gz
    tar zxvf nginx-1.8.0.tar.gz
（2 ）配置编译选项

    cd nginx-1.8.0
    yum install -y pcre-devel #正则
    ./configure \
    --prefix=/usr/local/nginx \
    --with-http_realip_module \
    --with-http_sub_module \
    --with-http_gzip_static_module \
    --with-http_stub_status_module \
    --with-pcre
（3 ）编译、安装 Nginx

    make
    make install
（4 ）启动 nginx:

    /usr/local/nginx/sbin/nginx
    #检查 nginx 是否启动:
    ps aux |grep nginx
    #看是否有进程。
