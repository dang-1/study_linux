## 1.介绍

1. 远程执行命令，比如我看一下所有机器操作系统的version，用这东西就简单多了。
2. 配置，配置apache,mysql等等都可以用它
3. 软件安装
4. 服务启动，重启
5. 信息收集归档

## 2.master
### 2.1安装
    yum intall -y epel-release
    yum install -y salt-master  salt-minion
### 2.2 配置
    vim /etc/salt/minion  #大概16行修改或增加
    master: 192.168.0.103 #本机ip地址 （中间有空格）

### 2.3启动服务
    service salt-master start
    service salt-minion start
### 2.4 作用
1. 存放所有minion的公钥
2. 监听mininon
3. 发送命令给minion
4. 存放一些为minion准备的配置文件，如state
5. 存放一些为minion准备的files和数据，如apache2.cnf，pillar
### 2.5 日志
    /var/log/salt/minion












## 3.minion

### 3.1安装
    yum intall -y epel-release
    yum install -y salt-minion

关闭selinux，清空iptables规则

### 3.2.配置
    vim /etc/salt/minion 
    master: 192.168.0.103  #此处为master的ip
    id: dang_192.168.0.104 #id为主机名+本机ip
### 3.3启动服务
    service salt-minion start
### 3.4 作用
1. 连接master
2. 监听master发送的commands
3. 从master下载state并且执行state
4. 可以执行在minion上执行state，用salt-call，当然这个一般多数用于调试
### 3.5日志
    /var/log/salt/master
