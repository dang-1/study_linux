first,we should get rpm file:
http://repo.mongodb.org/yum/redhat/6/mongodb-org/3.0/x86_64/RPMS/mongodb-org-server-3.0.12-1.el6.x86_64.rpm
http://repo.mongodb.org/yum/redhat/6/mongodb-org/3.0/x86_64/RPMS/mongodb-org-shell-3.0.12-1.el6.x86_64.rpm
http://repo.mongodb.org/yum/redhat/6/mongodb-org/3.0/x86_64/RPMS/mongodb-org-tools-3.0.12-1.el6.x86_64.rpm
http://repo.mongodb.org/yum/redhat/6/mongodb-org/3.0/x86_64/RPMS/mongodb-org-mongos-3.0.12-1.el6.x86_64.rpm
http://repo.mongodb.org/yum/redhat/6/mongodb-org/3.0/x86_64/RPMS/mongodb-org-3.0.12-1.el6.x86_64.rpm
2.
# rpm -ivh *
3.start
delete /tec/mongo.conf the "#" after the
'''fork:true
pidFilePath:/var/run/mongodb/mongod.conf
'''
# echo never > /sys/kernel/mm/transparent_hugepage/enabled
# echo never > /sys/kernel/mm/transparent_hugepage/defrag
# vim /etc/security/limits.conf // 加入
mongod soft nofile 64000
mongod hard mofile 64000
mongod soft nproc 32000
mongod hard nproc 32000
启动：service mongod start
if start filed and no log
could use  "mongod -f /etc/mongod.conf" 会显示报错

