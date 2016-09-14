查找php.ini的路径：

    /usr/local/php/bin/php -i |head
    Loaded Configuration File => /usr/local/php/etc/php.ini
如果此行为None，那么说明没有加载到具体的php.ini。  
在配置文件中，‘;’开头的行为注释符号。  
常用配置：   
（1）配置 disable_function

    disable_functions =eval,assert,popen,passthru,escapeshellarg,escapeshellcmd,passthru,exec,system,chroot,scandir,chgrp,chown,escapeshellcmd,escapeshellarg,shell_exec,proc_get_status,ini_alter,ini_restore,dl,pfsockopen,openlog,syslog,readlink,symlink,leak,popepassthru,stream_socket_server,popen,proc_open,proc_close
    
说明，在 php 中有非常多的函数，在这些函数中有一些是不太安全的，所以有必要把它们禁掉、。 像 exec，shell_exec 都是在 php 代码中执行 linux shell 命令， 很危险，要禁掉。

（2 ）配置 error_log  
1.遇到错误的时候，访问网站限制白页，状态码是500.  
配置：  

    display_error=on
重启Apache可以把错误信息放在浏览器，出现的是具体错误。

2.将错误信息输出到日志文件  
配置：

    vim /usr/local/php/etc/php.ini
    display_error=off
    log_errors=on
    error_log=/usr/local/php/logs/error.log

说明：该文件一开始是不存在的，为了避免权限问题不能自动生成该文件，我们可以先创建该文件，并且修改权限为 777

    error_reporting = E_ALL | E_STRICT
说明： 首先要把错误不再浏览器显示，第二打开错误日志开关，然后指定错误日志的路径，最后是定义错误日志的级别。配置完成后记得要重启 apache 服务，才会生效。
