## 简介


配置文件：/etc/httpd/conf/httpd.conf
    
    配置参数 值
        配置指令不区分字符大小写
        值有可能区分大小写
        有些指令可以重复出现多次
    配置文件格式
        全局配置
        主机配置：用于仅提供一个站点时
        虚拟主机配置：用于提供多个站点时
    配置文件语法测试
        serviice httpd configtest
        httpd -t
绝大多数配置修改后，可以用过service httpd reload 来生效，如果修改了
监听的地址或端口，必须重启服务才能生效

## 配置文件

### 1.监听套接字

    Listen [IP:]port
    #此指令可以出现多次，用于指定监听多个不同的套接字
       Listen 80
       Listen 172.16.100.7：8080
### 2.配置使用Keepalive

    KeepAlive {On|Off}
    KeepAliveTimeout 2 #超时时间
    MaxKeepAliveRequests 50 #最大连接

### 3.MPM

    #多道处理模块
    #httpd -l 查看编译进内核的模块
    #想使用不同的机制，修改配置文件即可 /etc/syconfig/httpd文件
    <IfModule preforck.c>  #判断模块是否存在
        StartServers       8 #默认启动的工作进程数
        MinSpareServers    5 #最少空闲进程数
        MaxSpareServers   20 #最大空闲进程数
        ServerLimit      256 #最大活动进程数
        MaxClients       256 #最大并发连接数，最多允许发起的连接请求的个数
        MaxRequestsPerChild  4000 #每个子进程在生命周期内最大允许服务的最多请求个数
    </IfModule>

    <IfModule worker.c>
        StartServers         4 #启动的子进程的个数
        MaxClients         300 #最大并发连接数，最多允许发起的连接请求的个数
        MinSpareThreads     25 #最少空闲线程数
        MaxSpareThreads     75 #最大空闲线程数
        ThreadsPerChild     25 #每个子进程生成的线程数
        MaxRequestsPerChild  0 #每个子进程在声明周期内最大允许服务的最多请求个数
    </IfModule>

### 4、DSO模块的加载方式
    LoadModule module_name /path/to/module
    #如果使用相对路径，则对于ServerRoot所定义的位置而言
    LoadMoudule php5_module /usr/lib64/httpd/modules/php.so
    #让服务重载配置文件方能生效
    #httpd -m 列出与加载到所有DSO模块与非DOS模块
    #取消 注释掉即可
### 5、配置站点根目录
    DocumentRoot /path/to/somewhere
### 6、页面访问属性
    <Direcotry "/path/to/somewhere">
    Options 选项
    Indexes：缺少指定的默认页面时，允许将目录中的所有文件已列表形式返回给用户：危险：慎用
    FollowsymLinks:允许跟随符号链接所指向的原始文件
        None：所有都不启用
        All：所有的都启用
        ExecCGI：允许使用mod_cgi模块执行CGI脚本
        Includes：允许使用mod_include模块实现服务器端包含(SSI)
        IncludesNOEXEC：允许包含但不允许执行脚本
        MultiViews：允许使用mod_negotiation实现内容协商
        SymLinksIfOwnerMatch:在链接文件属主属组与原始文件的属主属组相同时，允许跟随符号连接所指向的原始文件
    AllowOverride
    </Direcotry>
    #可以使用正则表达式，使用~
### 7.基于主机的访问控制
    <Direcotry "/path/to/somewhere">
    Options 
    AllowOverride 
    None 不禁用下面
    order 次序，写在后面的为默认
        allow,deny: 没有允许的都拒绝
        deny,allow：没有拒绝的都允许
        Allow from
        Deny from
    </Direcotry>
    #如果都匹配或都不匹配时以默认为准
    #否则则以匹配到的为准
    Allow from
        Deny from
            IP,Network Address
            172.16
            172.16.0.0
            172.16.0.0/16
            172.16.0.0/255.255.0.0
    #基于用户做访问控制
### 8.定义默认主页面
    DirectoryIndex 依次查找
### 9.用户目录-了解
    #如果期望让每个用户都可以创建个人站点：http://Server_IP/~Username/
    #userdir disablied:禁止
    #userdir public_html:
        #public_html是用户家目录下的目录名称，所有位于此目录中的文件均可通过前述的访问路径进行访问
        #用户的家目录得赋予进行httpd进程的用户拥有执行权限
        setfacl -m u:apache:x ~Username
### 10、配置日志功能
    /var/log/http/
    access.log：访问日志，其需要记录的内容需要自定义
    error.log
    访问日志：
        CustomLog "/path/to/log_file" LogFormat
        LogFormat定义日志格式
        "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\""
        %h:客户端地址
        %l:远程的登录名，通常为-
        %u:认证时的远程用户名，通常为-
        %t：接收到的请求时的时间，为标准英文格式时间+时区
        \" ：转义，显示"
        %r:请求报文的起始行
        %>s：响应状态码，
        %b：以字节响应报文的长度，不包含http报文
        %{Header_Name}i:记录指定请求报文首部的内容（value）
        %u：请求的URL
    详情请参考：http://httpd.apache.org/docs/2.2/mod/mod_log_config.html#formats
    错误日志：
        ErrorLog
### 11、路径别名

    Alias /alias/ "/path/to/somewhere/"
    #意味着访问http://Server_IP/alias时，其页面文件来自于/path/to/somewhere中



### 12、指定默认的字符集
    AddDefaultCharset 

### 13.脚本路径别名(CGI接口)
    URL-->FileSystem Directory
    CGI：Common Gateway #Interface（通用网关接口）使WEB可以跟一个应用程序进行通信，从通信环境中获得结果。
    CGI是不安全的
        在第一行写入
        echo “Content-Type：text/html：
    mod_alias,mod_cgi
    ScriptAlias /URL/ "/path/to/somewhere" #somewhere下的文件可以被执行也可以在目录中实现

    #格式一般为
    #!/bin/sh
    cat << EOF
    Content-Type:text/html
    <pre>
    The time is : `date`.
    </pre>
    EOF

### 14.基于用户的访问控制
    虚拟用户：不是系统用户，只是为了获取某种资源类型的一种虚拟的用户
       文件/etc/httpd/conf/.htpasswd
       SQL数据库
       dbm：
       ldap:轻量级目录访问协议
    认证类型(auth)：
        basic：基本认证，账号和密码明文发送
        digest：摘要认证，hash编码之后发送
    认证提供者(authentication provider):账号和密码的存放位置
        authn
    授权机制(authorization):根据什么进行授权
    案例：基于文件，做基本认证根据用户和组进行授权
    1、编辑配置文件，为需要认证的目录配置认证机制
    <Directory "/www/htdocs/fin">A
        options None
        AllowOverride AuthConfig 使用认证配置
        AuthType Basic 使用基本认证
        AuthName "Private Area" 质询时标题
        AuthUserFile /etc/http/conf/.htpasswd  密码的存放位置
        Require vaild-user 可访问的用户
    </Directory>
    2、使用htpasswd命令使用生成认证库
      htpasswd 
      -c 创建密码，创建第一个用户时使用
      htpasswd -c -m /etc/http/conf/.htpasswd tom
      -m MD5格式存放
      -b 批量模式
      -D 删除用户
    3、基于组认证
    <Directory "/www/htdocs/fin">
        options None
        AllowOverride AuthConfig 使用认证配置
        AuthType Basic 使用基本认证
        AuthName "Private Area" 质询时标题
        AuthgroupFile /etc/http/conf/.htpasswd  密码的存放位置
        Require group GroupName  可访问的用户

    </Directory>
       先创建用户，在创建组
       组文件：
         组名：用户1 用户2 用户3
