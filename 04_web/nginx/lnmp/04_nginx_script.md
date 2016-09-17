编写 Nginx  启动脚本，并加入系统服务

    # vim /etc/init.d/nginx //写入如下内容:
    #!/bin/bash
    # chkconfig: - 30 21
    # description: http service.
    # Source Function Library
    . /etc/init.d/functions
    # Nginx Settings
    NGINX_SBIN="/usr/local/nginx/sbin/nginx"
    NGINX_CONF="/usr/local/nginx/conf/nginx.conf"
    NGINX_PID="/usr/local/nginx/logs/nginx.pid"
    RETVAL=0
    prog="Nginx"
    start() {
    echo -n $"Starting $prog: "
    mkdir -p /dev/shm/nginx_temp
    daemon $NGINX_SBIN -c $NGINX_CONF
    RETVAL=$?
    echo
    return $RETVAL
    }
    stop() {
    echo -n $"Stopping $prog: "
    killproc -p $NGINX_PID $NGINX_SBIN -TERM
    rm -rf /dev/shm/nginx_temp
    RETVAL=$?
    echo
    return $RETVAL
    }
    reload(){
    echo -n $"Reloading $prog: "
    killproc -p $NGINX_PID $NGINX_SBIN -HUP
    RETVAL=$?
    echo
    return $RETVAL
    }
    restart(){
    stop
    start
    }
    configtest(){
    $NGINX_SBIN -c $NGINX_CONF -t
    return 0
    }
    case "$1" in
    start)
    start
    ;;
    stop)
    stop
    ;;
    reload)
    reload
    ;;
    restart)
    restart
    ;;
    configtest)
    configtest
    ;;
    *)
    echo $"Usage: $0 {start|stop|reload|restart|configtest}"
    RETVAL=1
    esac
    exit $RETVAL
    
说明：该启动脚本并非我编写，来自互联网，所以不需要大家死记硬背，如果对 shell感兴趣可以研究一下。脚本下载地址 http://study.lishiming.net/.nginx_init  
保存后，更改权限:  

    # chmod 755 /etc/init.d/nginx
    # chkconfig --add nginx
    如果想开机启动，请执行:
    # chkconfig nginx on
