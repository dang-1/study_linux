登录方式：tcp/ip或socket方式

mysql 服务启动时，不仅会监听 IP\:\Port，还会监听一个 socket，我们安装的 mysql 是监听在/tmp/mysql.sock。  
如果 php 是在本地，那么 php 和 mysql 通信可以通过 socket 通信，如果是远程，就需要通过 tcp/ip 来通信。  
在 Linux 命令行下，我们可以通过如下的方法来连接 mysql 服务器。

## （1 ）tcp/ip  的方式

    /usr/local/mysql/bin/mysql -uroot -h127.0.0.1 #无密码登录
    /usr/local/mysql/bin/mysqladmin -uroot password 'password' #无密码的时候修改密码
    /usr/local/mysql/bin/mysqladmin -uroot -paminglinux.com password 'password2' #有密码的时候修改密码

    避免输入较长的绝对路径：第一设置 alias，第二设置 PATH。

    alias mysql=/usr/local/mysql/bin/mysql
    alias mysqladmin=/usr/local/mysql/bin/mysqladmin
如果想永久生效，记得把这两个 alias 放到/etc/bashrc 里面即可。  
另外就是设置 PATH 了，如下。  

    vim /etc/profile.d/path.sh
加入一行

    export PATH=$PATH:/usr/local/mysql/bin
保存后，执行

    source /etc/profile.d/path.sh
当给 mysql 设置密码后再去连接，就需要加上-p 选项了。  

    mysql -uroot -pAmingLInux -h127.0.0.1
其中-h 指定 ip，那如果是远程机器，则-h 后面跟远程服务器 ip，默认 port 是 3306，如果是其他端口，需要用-P 来定义。

    mysql -uroot -pAmingLinux -h127.0.0.1 -P3306
## （2 ）socket  方式
这种只适合连接本机的 mysql，命令为：  

    mysql -uroot -S /tmp/mysql.sock -pAmingLinux
这里的-S 可以省略掉。
