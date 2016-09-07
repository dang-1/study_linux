saltstack配置认证
以下操作都是在master上：  

    salt-key -L //列出Unaccepted Keys:的ID
    salt-key -a dang_192.168.0.104  //接受认证
此时salt-key 就能显示  
此时我们在client的 /etc/salt/pki/minion 目录下面会多出一个minion_master.pub 文件  
可以使用 salt-key 命令查看到已经签名的客户端  
salt-key  可以使用-A签名所有主机，也可以使用-d删除指定主机的key  


认证之前，大伙要是想确保认证的准确   性，可以先识别下minion的身份。两边一样的话就靠谱了。这样的做是啥原理呢，minion请求验证的时候，会把公钥发给master，两边都打印一 下这个公钥的指纹，finger这东西是叫指纹吧，一样就OK了。这个可以防止别人冒名顶替，发个错误的公钥过来。
