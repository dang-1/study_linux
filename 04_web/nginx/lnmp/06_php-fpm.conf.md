php-fpm.conf

    [global]
    pid = /usr/local/php/var/run/php-fpm.pid
    error_log = /usr/local/php/var/log/php-fpm.log
    [www]
    listen = /tmp/php-fcgi.sock
    user = php-fpm
    group = php-fpm
    listen.owner = nobody #和后面的 nginx 的一致
    listen.group = nobody #同上 是nginx的访问相关
    pm = dynamic
    pm.max_children = 50
    pm.start_servers = 20
    pm.min_spare_servers = 5
    pm.max_spare_servers = 35
    pm.max_requests = 500
    rlimit_files = 10240
    slow_log = /tmp/www_slow.log #指定记录位置
    request_slowlog_timeout = 1 #慢日志超市时长
    php_admin_value[open_basedir]=/data/www/:/tmp/
## 配置说明：
global 部分是全局配置，指定 pid 文件路径以及 error_log 路径。  

### 多个pool的方法
[www]是一个 pool，我们其实还可以再写第二个 pool，第二个 pool 和第一个不一样的地方。

首先 pool 的 name，比如叫做[www2]。  
然后 listen 肯定就不能一样了，比如可以 listen= /tmp/php-fcgi2.sock。  
而 user，group 也可以和[www]中定义的不一样。  
isten.owner 这个是定义/tmp/php-fcgi.sock 这个文件的所有者是谁，在 php5.4 版本之后监听的 socket 文件权限默认编程了 rw-------， 如果不定义 listen.owner 那么 nginx 调用这个 socket 的时候就没有权限了，故在这里我们定义 listen.owner 为 nginx 的子进程监听用户。  

pm = dynamic 表示以动态的形式启动，在 php5.3 版本以后它可以支持动态和静态了，如果是静态，即 pm=static 时，下面的配置只有 pm.max_children 管用。  
pm.max_children 表示启动几个 php-fpm 的子进程。 如果是 dynamic， 下面的配置会生效，pm.max_children 表示最大可以启动几个子进程。  
pm.start_servers 表示一开始启动几个子进程。  
pm.min_spare_servers 表示当 php-fpm 空闲时最少要有几个子进程，即如果空闲进程小于此值， 则创建新的子进程。 pm.max_spare_server 表示当 php-fpm 空闲时最多有几个子进程，即如果空闲进程大于此值，则会进行清理。    
pm.max_requests 表示一个子进程最多可以接受多少个请求，比如设置为 500 那么一个子进程受理 500 个请求后自动销毁。    
rlimit_files 表示每个子进程打开的多少个文件句柄。 
