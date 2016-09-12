lsof(list open files)是一个列出当前系统打开文件的工具。在linux环境下，任何事物都以文件的形式存在，通过文件不仅仅可以访问常规数据，还可以访问网络连接和硬件。所以如传输控制协议 (TCP) 和用户数据报协议 (UDP) 套接字等，系统在后台都为该应用程序分配了一个文件描述符，无论这个文件的本质如何，该文件描述符为应用程序与基础操作系统之间的交互提供了通用接口。因为应用程序打开文件的描述符列表提供了大量关于这个应用程序本身的信息，因此通过lsof工具能够查看这个列表对系统监测以及排错将是很有帮助的。 

安装：

    yum install -y lsof

# 1.命令格式
    lsof ［options］ filename
# 2.命令功能
用于查看你进程开打的文件，打开文件的进程，进程打开的端口(TCP、UDP)。找回/
恢复删除的文件。是十分方便的系统监视工具，因为 lsof 需要访问核心内存和各
种文件，所以需要root用户执行。  
lsof打开的文件可以是：

    1.普通文件
    2.目录
    3.网络文件系统的文件
    4.字符或设备文件
    5.(函数)共享库
    6.管道，命名管道
    7.符号链接
    8.网络文件（例如：NFS file、网络socket，unix域名socket）
    9.还有其它类型的文件，等等
# 3.命令参数
lsof 常见的用法是查找应用程序打开的文件的名称和数目。可用于查找出某个特定应用程序将日志数据记录到何处，
或者正在跟踪某个问题。  
例如，linux限制了进程能够打开文件的数目。通常这个数值很大，所以不会产生问题，并且在需要时，应用程序可以
请求更大的值（直到某个上限）。如果你怀疑应用程序耗尽了文件描述符，那么可以使用 lsof 统计打开的文件数
目，以进行验证。

    lsof  filename #显示打开指定文件的所有进程
    lsof -a #表示两个参数都必须满足时才显示结果
    lsof -c string   显示COMMAND列中包含指定字符的进程所有打开的文件
    lsof -u username  显示所属user进程打开的文件
    lsof -g gid 显示归属gid的进程情况
    lsof +d /DIR/ 显示目录下被进程打开的文件
    lsof +D /DIR/ 递归列出目录下被打开的文件，时间相对较长
    lsof -d FD 显示指定文件描述符的进程
    lsof -n 不将IP转换为hostname，缺省是不加上-n参数
    lsof -i 用以显示符合条件的进程情况
    lsof -i[46] [protocol][@hostname|hostaddr][:service|port]
        46 --> IPv4 or IPv6
        protocol --> TCP or UDP
        hostname --> Internet host name
        hostaddr --> IPv4地址
        service --> /etc/service中的 service name (可以不只一个)
        port --> 端口号 (可以不只一个)
# 4.使用实例

### 4.1lsof输出信息含义
在终端下输入lsof即可显示系统打开的文件，因为 lsof 需要访问核心内存和各种文件，所以必须以 root 
用户的身份运行它才能够充分地发挥其功能。   

    COMMAND    PID      USER   FD      TYPE     DEVICE     SIZE       NODE      NAME
    init       1         root  cwd      DIR       3,3       1024       2         /
    init       1         root  rtd      DIR       3,3       1024       2         /
    init       1         root  txt      REG       3,3       38432      1763452  /sbin/init
    init       1         root  mem      REG       3,3       106114     1091620  /lib/libdl-2.6.so
    init       1         root  mem      REG       3,3       7560696    1091614  /lib/libc-2.6.so
    init       1         root  mem      REG       3,3       79460      1091669  /lib/libselinux.so.1
    init       1         root  mem      REG       3,3       223280     1091668  /lib/libsepol.so.1
    init       1         root  mem      REG       3,3       564136     1091607  /lib/ld-2.6.so
    init       1         root  10u      FIFO      0,15                  1309     /dev/initctl
#### 每行显示一个打开的文件，若不指定条件默认将显示所有进程打开的所有文件。lsof输出各列信息的意义如下：   

    COMMAND：进程的名称
    PID：进程标识符
    PPID：父进程标识符（需要指定-R参数）
    USER：进程所有者
    FD：文件描述符，应用程序通过文件描述符识别该文件。如cwd、txt等
    TYPE：文件类型，如DIR、REG等
    DEVICE：指定磁盘的名称
    SIZE：文件的大小
    NODE：索引节点（文件在磁盘上的标识）
    NAME：打开文件的确切名称
#### FD：文件描述符，应用程序通过文件描述符识别该文件。如cwd、txt等。  
    
    （1）cwd：表示current work dirctory，即：应用程序的当前工作目录，这是该应用程序启动的目录，除非它本身对这个目录进行更改
    （2）txt ：该类型的文件是程序代码，如应用程序二进制文件本身或共享库，如上列表中显示的 /sbin/init 程序
    （3）lnn：library references (AIX);
    （4）er：FD information error (see NAME column);
    （5）jld：jail directory (FreeBSD);
    （6）ltx：shared library text (code and data);
    （7）mxx ：hex memory-mapped type number xx.
    （8）m86：DOS Merge mapped file;
    （9）mem：memory-mapped file;
    （10）mmap：memory-mapped device;
    （11）pd：parent directory;
    （12）rtd：root directory;
    （13）tr：kernel trace file (OpenBSD);
    （14）v86  VP/ix mapped file;
    （15）0：表示标准输出
    （16）1：表示标准输入
    （17）2：表示标准错误
        一般在标准输出、标准错误、标准输入后还跟着文件状态模式：r、w、u等
        （1）u：表示该文件被打开并处于读取/写入模式
        （2）r：表示该文件被打开并处于只读模式
        （3）w：表示该文件被打开并处于
        （4）空格：表示该文件的状态模式为unknow，且没有锁定
        （5）-：表示该文件的状态模式为unknow，且被锁定
        同时在文件状态模式后面，还跟着相关的锁
        （1）N：for a Solaris NFS lock of unknown type;
        （2）r：for read lock on part of the file;
        （3）R：for a read lock on the entire file;
        （4）w：for a write lock on part of the file;（文件的部分写锁）
        （5）W：for a write lock on the entire file;（整个文件的写锁）
        （6）u：for a read and write lock of any length;
        （7）U：for a lock of unknown type;
        （8）x：for an SCO OpenServer Xenix lock on part      of the file;
        （9）X：for an SCO OpenServer Xenix lock on the      entire file;
        （10）space：if there is no lock.
 
txt 类型的文件是程序代码，如应用程序二进制文件本身或共享库，如上列表中显示的 /sbin/init 程序。其次数值
表示应用程序的文件描述符，这是打开该文件时返回的一个整数。如上的最后一行文件/dev/initctl，其文件描述符
为 10。u 表示该文件被打开并处于读取/写入模式，而不是只读 ® 或只写 (w) 模式。同时还有大写 的W 表示该
应用程序具有对整个文件的写锁。该文件描述符用于确保每次只能打开一个应用程序实例。初始打开每个应用程序
时，都具有三个文件描述符，从 0 到 2，分别表示标准输入、输出和错误流。所以大多数应用程序所打开的文件
的 FD 都是从 3 开始。     

#### TYPE
TYPE：文件类型，如DIR、REG等，常见的文件类型

    （1）DIR：表示目录
    （2）CHR：表示字符类型
    （3）BLK：块设备类型
    （4）UNIX： UNIX 域套接字
    （5）FIFO：先进先出 (FIFO) 队列
    （6）IPv4：网际协议 (IP) 套接字

与 FD 列相比，Type 列则比较直观。文件和目录分别称为 REG 和 DIR。而CHR 和 BLK，分别表示字符和块设备；
或者 UNIX、FIFO 和 IPv4，分别表示 UNIX 域套接字、先进先出 (FIFO) 队列和网际协议 (IP) 套接字。 


### 4.2查找谁在使用文件系统
在卸载文件系统时，如果该文件系统中有任何打开的文件，操作通常将会失败。那么通过lsof可以找出那些进程在使用当前要卸载的文件系统，如下：   

    lsof  /GTES11/  
    COMMAND  PID USER   FD   TYPE DEVICE SIZE NODE NAME  
    bash    4208 root  cwd    DIR    3,1 4096    2 /GTES11/  
    vim     4230 root  cwd    DIR    3,1 4096    2 /GTES11/  
在这个示例中，用户root正在其/GTES11目录中进行一些操作。一个 bash是实例正在运行，并且它当前的目录为/GTES11，
另一个则显示的是vim正在编辑/GTES11下的文件。要成功地卸载/GTES11，应该在通知用户以确保情况正常之后，中止这些
进程。 这个示例说明了应用程序的当前工作目录非常重要，因为它仍保持着文件资源，并且可以防止文件系统被卸载。这
就是为什么大部分守护进程（后台进程）将它们的目录更改为根目录、或服务特定的目录（如 sendmail 示例中的
/var/spool/mqueue）的原因，以避免该守护进程阻止卸载不相关的文件系统。 
### 4.3恢复删除的文件
当Linux计算机受到入侵时，常见的情况是日志文件被删除，以掩盖攻击者的踪迹。管理错误也可能导致意外删除重要的文
件，比如在清理旧日志时，意外地删除了数据库的活动事务日志。有时可以通过lsof来恢复这些文件。  
当进程打开了某个文件时，只要该进程保持打开该文件，即使将其删除，它依然存在于磁盘中。这意味着，进程并不知道
文件已经被删除，它仍然可以向打开该文件时提供给它的文件描述符进行读取和写入。除了该进程之外，这个文件是不可见
的，因为已经删除了其相应的目录索引节点。   
在/proc 目录下，其中包含了反映内核和进程树的各种文件。/proc目录挂载的是在内存中所映射的一块区域，所以这些文
件和目录并不存在于磁盘中，因此当我们对这些文件进行读取和写入时，实际上是在从内存中获取相关信息。大多数与 lsof
相关的信息都存储于以进程的 PID 命名的目录中，即 /proc/1234 中包含的是 PID 为 1234 的进程的信息。每个进程目
录中存在着各种文件，它们可以使得应用程序简单地了解进程的内存空间、文件描述符列表、指向磁盘上的文件的符号链
接和其他系统信息。lsof 程序使用该信息和其他关于内核内部状态的信息来产生其输出。所以lsof 可以显示进程的文
件描述符和相关的文件名等信息。也就是我们通过访问进程的文件描述符可以找到该文件的相关信息。   
当系统中的某个文件被意外地删除了，只要这个时候系统中还有进程正在访问该文件，那么我们就可以通过lsof从/proc目
录下恢复该文件的内容。 假如由于误操作将/var/log/messages文件删除掉了，那么这时要将/var/log/messages文件恢复
的方法如下：   
首先使用lsof来查看当前是否有进程打开/var/logmessages文件，如下：   

    lsof |grep /var/log/messages
    syslogd   1283      root    2w      REG        3,3  5381017    1773647 /var/log/messages (deleted)
从上面的信息可以看到 PID 1283（syslogd）打开文件的文件描述符为 2。同时还可以看到/var/log/messages
已经标记被删除了。因此我们可以在 /proc/1283/fd/2 （fd下的每个以数字命名的文件表示进程对应的文件描述符）中
查看相应的信息，如下：   

    head -n 10 /proc/1283/fd/2
    Aug  4 13:50:15 holmes86 syslogd 1.4.1: restart.
    Aug  4 13:50:15 holmes86 kernel: klogd 1.4.1, log source = /proc/kmsg started.
    Aug  4 13:50:15 holmes86 kernel: Linux version 2.6.22.1-8 (root@everestbuilder.linux-ren.org) (gcc version 4.2.0) #1 SMP Wed Jul 18 11:18:32 EDT 2007
    Aug  4 13:50:15 holmes86 kernel: BIOS-provided physical RAM map:
    Aug  4 13:50:15 holmes86 kernel:  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
    Aug  4 13:50:15 holmes86 kernel:  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
    Aug  4 13:50:15 holmes86 kernel:  BIOS-e820: 0000000000100000 - 000000001f7d3800 (usable)
    Aug  4 13:50:15 holmes86 kernel:  BIOS-e820: 000000001f7d3800 - 0000000020000000 (reserved)
    Aug  4 13:50:15 holmes86 kernel:  BIOS-e820: 00000000e0000000 - 00000000f0007000 (reserved)
    Aug  4 13:50:15 holmes86 kernel:  BIOS-e820: 00000000f0008000 - 00000000f000c000 (reserved)
从上面的信息可以看出，查看 /proc/8663/fd/15 就可以得到所要恢复的数据。如果可以通过文件描述符查看相应的数据，那么就可以使用 I/O 重定向将其复制到文件中，如:   

    cat /proc/1283/fd/2 > /var/log/messages 
对于许多应用程序，尤其是日志文件和数据库，这种恢复删除文件的方法非常有用。 


### 4.4 查看22端口现在运行的情况 
    lsof -i :22
    COMMAND  PID USER   FD   TYPE DEVICE SIZE NODE NAME
    sshd    1409 root    3u  IPv6   5678       TCP *:ssh (LISTEN)
### 4.5 查看所属root用户进程所打开的文件类型为txt的文件: 
    lsof -a -u root -d txt
    COMMAND    PID USER  FD      TYPE DEVICE    SIZE    NODE NAME
    init      1    root txt       REG    3,3   38432 1763452 /sbin/init
    mingetty  1632 root txt       REG    3,3   14366 1763337 /sbin/mingetty
    mingetty  1633 root txt       REG    3,3   14366 1763337 /sbin/mingetty
    mingetty  1634 root txt       REG    3,3   14366 1763337 /sbin/mingetty
    mingetty  1635 root txt       REG    3,3   14366 1763337 /sbin/mingetty
    mingetty  1636 root txt       REG    3,3   14366 1763337 /sbin/mingetty
    mingetty  1637 root txt       REG    3,3   14366 1763337 /sbin/mingetty
    kdm       1638 root txt       REG    3,3  132548 1428194 /usr/bin/kdm
    X         1670 root txt       REG    3,3 1716396 1428336 /usr/bin/Xorg
    kdm       1671 root txt       REG    3,3  132548 1428194 /usr/bin/kdm
    startkde  2427 root txt       REG    3,3  645408 1544195 /bin/bash

### 4.6 查看谁正在使用某个文件，也就是说查找某个文件相关的进程

    lsof /bin/bash
    COMMAND  PID USER  FD   TYPE DEVICE SIZE/OFF    NODE NAME
    bash    5635 root txt    REG  252,1   940416 1053516 /bin/bash


### 4.7 列出某个用户打开的文件信息

    lsof -u username
说明:   
-u 选项，u其实是user的缩写  

### 4.8列出某个程序进程所打开的文件信息

    lsof -c mysql
说明:
-c 选项将会列出所有以mysql这个进程开头的程序的文件，其实你也可以写成 lsof | grep mysql, 但是第一种方法明显比第二种方法要少打几个字符了
 
### 4.9列出多个进程多个打开的文件信息

    lsof -c mysql -c apache
### 4.10 列出某个用户以及某个进程所打开的文件信息

    lsof  -u test -c mysql 
说明：
用户与进程可相关，也可以不相关

### 4.11 列出除了某个用户外的被打开的文件信息
    lsof -u ^root
说明：
^这个符号在用户名之前，将会把是root用户打开的进程不让显示

### 4.12 通过某个进程号显示该进行打开的文件
    lsof -p 1
    
### 4.13 列出多个进程号对应的文件信息
    lsof -p 1,2,3
### 4.14 列出除了某个进程号，其他进程号所打开的文件信息
    lsof -p ^1
### 4.15 列出所有的网络连接
    lsof -i
### 4.16 列出所有tcp 网络连接信息
    lsof -i tcp
### 4.17 列出所有udp网络连接信息
    lsof -i udp
### 4.18 列出谁在使用某个端口
    lsof -i :3306
### 4.19 列出谁在使用某个特定的udp端口
    lsof -i udp:55
    #或者：特定的tcp端口
    lsof -i tcp:80
    
### 4.20 列出某个用户的所有活跃的网络端口
    lsof -a -u test -i
### 4.21 列出所有网络文件系统
    lsof -N

### 4.22 某个用户组所打开的文件信息
    lsof -g 5555
### 4.23 根据文件描述列出对应的文件信息

    lsof -d description(like 2)
        lsof  -d  txt
        lsof  -d  1
        lsof  -d  2
0表示标准输入，1表示标准输出，2表示标准错误，从而可知：所以大多数应用程序所打开的文件的 FD 都是从 3 开始
### 4.24 根据文件描述范围列出文件信息
    lsof -d 2-3
### 4.25 列出COMMAND列中包含字符串" sshd"，且文件描符的类型为txt的文件信息
    lsof -c sshd -a -d txt
    #输出：
    [root@localhost soft]# lsof -c sshd -a -d txt
    COMMAND   PID USER  FD   TYPE DEVICE   SIZE    NODE NAME
    sshd     2756 root txt    REG    8,2 409488 1027867 /usr/sbin/sshd
    sshd    24155 root txt    REG    8,2 409488 1027867 /usr/sbin/sshd
    sshd    24905 root txt    REG    8,2 409488 1027867 /usr/sbin/sshd
    sshd    24937 root txt    REG    8,2 409488 1027867 /usr/sbin/sshd

 
### 4.26 列出被进程号为1234的进程所打开的所有IPV4 network files 
    lsof -i 4 -a -p 1234
### 4.27 列出目前连接主机上端口为：20，21，22，25，53，80相关的所有文件信息，且每隔3秒不断的执行lsof指令
    lsof -i :20,21,22,25,53,80  -r  3
