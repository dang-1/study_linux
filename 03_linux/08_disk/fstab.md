系统启动时会挂载分区通过/etc/fstab文件进行配置。

# 1.文件解读

    [root@localhost ~]# cat /etc/fstab
    #
    # /etc/fstab
    # Created by anaconda on Tue May 7     17:51:27 2013
    #
    # Accessible filesystems, by reference, are maintained under '/dev/disk'
    # See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
    #
    UUID=95297b81-538d-4d96-870a-de90255b74f5 /     ext4 defaults 1 1
    UUID=a593ff68-2db7-4371-8d8c-d936898e9ac9 /boot ext4 defaults 1 2
    UUID=ff042a91-b68f-4d64-9759-050c51dc9e8b swap  swap defaults 0 0
    tmpfs  /dev/shm tmpfs  defaults          0 0
    devpts /dev/pts devpts gid=5,mode=620    0 0
    sysfs  /sys     sysfs  defaults          0 0
    proc   /proc    proc   defaults          0 0

## 1.1内容解读：  
第一列就是分区的标识， 可以写分区的 LABEL， 也可以写分区的 UUID，当然也可以写分区名(/dev/sda1)；  
第二列是挂载点；  
第三列是分区的格式；  
第四列则是 mount 的一些挂载参数，一般情况下，直接写 defaults 即可；  
第五列的数字表示是否被 dump 备份，是的话这里就是 1，否则就是 0；  
第六列是开机时是否自检磁盘。1，2 都表示检测，0 表示不检测。在 Redhat/CentOS 中，这个 1，2还有个说
法，/ 分区必须设为 1，而且整个 fstab 中只允许出现一个 1，这里有一个优先级的说法。1 比 2 优先级高，
所以先检测 1，然后再检测 2，如果有多个分区需要开机检测那么都设置成 2,1 检测完了后会同时去检测 2。

## 1.2第四列常用选项： 
async/sync: async 表示和磁盘和内存不同步，系统每隔一段时间把内存数据写入磁盘中，而 sync 则会时时
同步内存和磁盘中数据；  
auto/noauto: 开机自动挂载/不自动挂载；  
default: 按照大多数永久文件系统的缺省值设置挂载定义， 它包含了 rw， suid， dev， exec， auto， nouser，async
ro: 按只读权限挂载 ；   
rw: 按可读可写权限挂载 ；  
exec/noexec: 允许/不允许可执行文件执行， 但千万不要把根分区挂载为 noexec， 那就无法使用系统了，连 mount
命令都无法使用了，这时只有重新做系统了；  
user/nouser: 允许/不允许 root 外的其他用户挂载分区，为了安全考虑，请用 nouser；  
suid/nosuid: 允许/不允许分区有 suid 属性，一般设置 nosuid ；  
usrquota: 启动使用者磁盘配额模式，磁盘配额会针对用户限定他们使用的磁盘额度；  
grquota: 启动群组磁盘配额模式； 
