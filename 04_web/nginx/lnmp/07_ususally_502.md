配置完环境后，访问网站直接提示“502 Bad Gateway”。出现 502 的原因大致分为这么两种。  

### （1 ）配置错误
我们在 nginx 中有配置这么一段

    location ~ \.php$ {
    include fastcgi_params;
    fastcgi_pass unix:/tmp/php-fcgi.sock;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME /usr/local/nginx/html$fastcgi_script_name;
    }
如果我把 fastcgi_pass 后面指定的路径配置错了，那么就会出现 502 的错误，因为 nginx找不到 php-fpm 了。fastcgi_pass 后面可以跟 socket 也可以跟 ip:port，默认监听地址为127.0.0.1:9000。
### （2 ）资源耗尽
LNMP 架构处理 php 时，是 nginx 直接调取后端的 php-fpm 服务，如果 nginx 的请求量偏高，而我们又没有给 php-fpm 配置足够的子进程，那么总有 php-fpm 资源耗尽的时候，一旦耗尽 nginx 则找不到 php-fpm，此时就会导致 502 出现。那这时候的解决方案就是去调整php-fpm.conf 中的 pm.max_children 数值，使其增加。但也不能无限设置，毕竟服务器的资源有限， 根据经验， 4G内存机器如果只跑php-fpm和nginx， 不跑mysql服务， pm.max_children可以设置为 150，尽量不要超过该数值，8G 内存可用设置为 300，以此类推。  

当然，除了这两种情况外，也会有其他情况导致 502 发生，但很少很少。那我们如何去判定到底是什么原因导致 502 呢？其实， 我们有一个办法可以去排查此类问题。 就是要借助nginx 的错误日志啦。在 nginx.conf 中有一个参数叫做 error_log，它可以指定错误日志的路径，而错误日志其实还能定义级别。默认是 crit，该级别为最严谨的，记录日志也是最少的，有可能一些小问题我们不能发现，所以有必要把日志级别调整一下，比如“error_log/usr/local/nginx/logs/nginx_error.log debug;”，这样显示的日志就会有很多，不要忘记当调试完后要把级别改为 crit，否则 error_log 会把磁盘撑爆！
