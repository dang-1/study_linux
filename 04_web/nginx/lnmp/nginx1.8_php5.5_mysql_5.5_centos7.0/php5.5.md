### install
    yum install -y epel-release
    yum install -y libjpeg-devel libxml2-devel libpng libpng-devel openssl openssl-devel 
    yum install -y cure-devel freetype freetype-devel
    yum install -y libmcrypt-devel
    yum install -y curl-devel

    tar xf 
    cd 
    useradd -s /sbin/nologin php-fpm

    ./configure \
    --prefix=/usr/local/php \
    --with-config-file-path=/usr/local/php/etc \
    --enable-fpm \
    --with-fpm-user=php-fpm \
    --with-fpm-group=php-fpm \
--with-mysql=/usr/local/mysql \
--with-mysql-sock=/tmp/mysql.sock \
--with-libxml-dir \
--with-gd \
--with-jpeg-dir \
--with-png-dir \
--with-freetype-dir \
--with-iconv-dir \
--with-zlib-dir \
--with-mcrypt \
--enable-soap \
--enable-gd-native-ttf \
--enable-ftp \
--enable-mbstring \
--enable-exif \
--enable-zend-multibyte \
--disable-ipv6 \
--with-pear \
--with-curl \
--with-openssl

    cp php.ini-production /usr/local/php/etc/php.ini
    vim /usr/local/php/etc/php-fpm.conf
> [global]
> pid = /usr/local/php/var/run/php-fpm.pid
> error_log = /usr/local/php/var/log/php-fpm.log
[www]
listen = /tmp/php-fcgi.sock
user = php-fpm
group = php-fpm
listen.owner = nobody
listen.group = nobody
pm = dynamic
pm.max_children = 50
pm.start_servers = 20
pm.min_spare_servers = 5
pm.max_spare_servers = 35
pm.max_requests = 500
rlimit_files = 1024
保存配置文件后，检验配置是否正确的方法为:
# /usr/local/php/sbin/php-fpm -t
如果出现诸如 “test is successful” 字样，说明配置没有问题，否则就要根据提示检查配置文件是否有问题。
（7 ）启动 php-fpm
首先要拷贝一个启动脚本到/etc/init.d/下
# cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
给它更改权限为 755
# chmod 755 /etc/init.d/php-fpm
# service php-fpm start
如果想让它开机启动，执行:
# chkconfig php-fpm on
检测是否启动:
# ps aux |grep php-fpm
看看是不是有很多个进程（大概 20 多个）。
