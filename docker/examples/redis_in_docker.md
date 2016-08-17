### redis in docker 
#### version 1.0
date: 2016 08 17
    docker pull centos
    docker run -itd -v /data/:/data/ centos
    docker exec -it def bash
        yum install -y vim gcc make
        cp /data/redis-2.8.21.tar.gz /
        tar xf redis-2.8.21.tar.gz
        cd redis-2.8.21
        make
        make PREFIX=/usr/local/redis  install
        mkdir /usr/local/redis/etc
        mkdir /usr/local/redis/log
        mkdir /usr/local/redis/redis
        vim /usr/local/redis/etc/redis.conf
    docker commit -m "centos_gcc_vim_make_redis" -a "dang" 389b13eab625 centos_gcc_vim_make_redis
    docker images
    docker run -itd -p 6379:6379 centos_gcc_vim_make_redis bash
    docker exec -it ***** bash
        /usr/local/redis/bin/redis-server /usr/local/redis/etc/redis.conf
