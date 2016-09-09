## 问题现象

    userdel dang
    userdel: user dang is currently used by process 27880
    
## 解决方法

    mv /var/run/utmp /var/run/utmp_old #移动文件
    touch  /var/run/utmp #重新创建一个新的文件
    userdel dang #执行删除操作
        userdel: user dang is currently used by process 27880 #提示用户使用进程
    kill 27880 #kill无效
    userdel dang #删除无效
    kill -9 27880 #强制kill
    userdel dang #成功删除

## 扩展

关于：/var/run/utmp

utmp是一个文件，除了utmp程序你不能编辑这个文件，删掉他的话，当前登陆信息都会
丢失。这个文件在每次机器reboot起来后都会重新创建。

更多关于utmp文件介绍请参考下面说明：  
/var/run/utmp   
该日志文件记录有关当前登录的每个用户的信息。因此这个文件会随着用户登录和注
销系统而不断变化，它只保留当时联机的用户记录，不会为用户保留永久的记录。系
统中需要查询当前用户状态的程序，如 who、w、users、finger等就需要访问这个文
件。该日志文件并不能包括所有精确的信息，因为某些突发错误会终止用户登录会
话，而系统没有及时更新 utmp记录，因此该日志文件的记录不是百分之百值得
信赖的。  
　(/var/log/wtmp、/var/log/utmp、/var/log/lastlog)是日志子系统的关键文件，
都记录了用户登录的情况。这些文件的所有记录都包含了时间戳。这些文件是按二进
制保存的，故不能用less、cat之类的命令直接查看这些文件，而是需要使用相关命
令通过这些文件而查看。其中，utmp和wtmp文件的数据结构是一样的，而lastlog文
件则使用另外的数据结构，关于它们的具体的数据结构可以使用man命令查询。  
    每次有一个用户登录时，login程序在文件lastlog中查看用户的UID。如果存
在，则把用户上次登录、注销时间和主机名写到标准输出中，然后 login程序在
lastlog中记录新的登录时间，打开utmp文件并插入用户的utmp记录。该记录一直用
到用户登录退出时删除。utmp文件被各种 命令使用，包括who、w、users和finger。  
　　下一步，login程序打开文件wtmp附加用户的utmp记录。当用户登录退出时，具
有更新时间戳的同一utmp记录附加到文件中。wtmp文件被程序last使用。
