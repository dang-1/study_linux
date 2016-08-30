iostate是I/O statistics（输入/输出统计）的缩写，iostat工具将对系统的磁盘操作活动进行监视。特点是汇报磁盘活动的统计信息，同时也会汇报CPU的使用情况。但是不能对某个进程进行深入分析，仅对系统的整体情况进行分析。iostat属于sysstat软件包。

    yum install -y sysstat #安装
    
### 1.命令格式

    Usage: iostat [ options ] [ <interval> [ <count> ] ]
### 2.命令功能
通过iostat方便查看CPU、网卡、tty设备、磁盘、CD-ROM等设备的活动情况、负载信息。  
### 3.命令参数
    -C 显示CPU使用情况
    -d 显示磁盘使用情况
    -k 以 KB 为单位显示
    -m 以 M 为单位显示
    -N 显示磁盘阵列(LVM) 信息
    -n 显示NFS 使用情况
    -p[磁盘] 显示磁盘和分区的情况
    -t 显示终端和CPU的信息
    -x 显示详细信息
    -V 显示版本信息
### 4.使用实例

4.1 显示所有设备负载情况

    iostat 
Linux 3.10.0-327.22.2.el7.x86_64 (dang1) 	08/09/2016 	_x86_64_	(1 CPU)  
avg-cpu:  %user   %nice %system %iowait  %steal   %idle  
                   0.08      0.00         0.10       0.06     0.00    99.76  
Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn  
sda                0.47             9.40        20.40     661203    1435027  
scd0              0.00             0.00         0.00         44          0  
dm-0             0.53             9.30        20.37     654379    1432907  
dm-1             0.00             0.02         0.00       1096         60  
dm-2             0.61             0.33         9.63      23252     677447  

