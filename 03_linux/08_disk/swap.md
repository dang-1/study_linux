
## 用途
增加或者添加swap交换分区，在系统内存不足的时候，系统将一些不常用的数据放入swap中。

有两种方法：  
1.直接将一个磁盘分区，然后格式化，修改为82，然后添加。  
2.在某个格式化后的磁盘分区中，使用dd创建一个文件，然后制作成swap，然后添加。

## 一、分区方法

##### 1.查看swap，以及硬盘容量
    free -m #查看内存
    df -h #查看硬盘容量
    fdisk -l #查看所有磁盘
    swapon -s #查看挂载的swap
##### 2.分区格式化
    fdisk /dev/sdb
        n
        1
        w
    mkfs.ext4 /dev/sdb1
    fdisk /dev/sdb1
        t
        1
        82
        w
##### 3.创建swap文件
    mkswap /dev/sdb1
##### 4.添加
    swapon -a /dev/sdb1
##### 5.查看
    swapon -s
    free -m
##### 6.永久生效
    blkid #获取所有的uuid，并选择/dev/sdb1的uuid
    vim /etc/fstab
    UUID="ecab9142-bb16-47d9-a231-d32ae2285c77" swap swap defaults 0 0

## 二、创建文件方法
##### 1.查看swap，以及硬盘容量
    free -m 
    df -h
    fdisk -l
    swapon -s
##### 2.挂载硬盘
    fdisk /dev/sdb
        n
        p
        2
    mkfs.ext4 /dev/sdb2
    blkid /dev/sdb2
    mkdir /data/
    vim /etc/fstab
    UUID="3ee384ec-596e-40d5-ad92-0cbc77483e33" /data/ ext4 defaults 0 0
    mount /dev/sdb2 /data/ #挂载
    mount #查看挂载
##### 3.创建文件
    dd if=/dev/zero of=/data/swap_file bs=1024 count=8192000 #创建8000M的文件
##### 4.制作swap文件
    mkswap /data/swap_file
##### 5.启动swap
将文件添加到系统swap中

    swapon /data/swap_file 
##### 5.查看系统swap
    swapon -s
##### 6.添加到自动挂载
    vim /etc/fstab
    #添加
    /data/swap_file swap swap defaults 0 0
    
新得：  
    其实比较简单，只是两种适用场景，第一种适合于系统自带一个未分区硬盘，可以添加一个分区。第二种适合于所有的硬盘已经都挂载在相应的目录，无法重新格式化，然后找一个空闲的硬盘，创建一个文件，制作swap。



