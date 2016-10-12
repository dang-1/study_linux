vmstat: virtual memory statistics 虚拟内存统计  
可对操作系统的虚拟内存、进程、cpu活动进行监控。  
是对系统的整体情况进行统计，无法对某个进程进行深入分析。  
该工具开销低。  

**物理内存/虚拟内存的区别**  
直接从物理内存读写数据要比硬盘读写数据要块的多，内存的资源有限，所以引出物理内存与虚拟内存。  
**物理内存**就是系统硬件提供的内存大小，是真正的内存。  
**虚拟内存**是为了满足物理内存不足而提出的策略，利用磁盘空间虚拟出一块逻辑内存，用作虚拟内存的磁盘空间被称为交换空间(swap space)。  
作为物理内存的扩展，linux会在物理内存不足时，使用减缓分区的虚拟内存，即内核会将暂时不用的内存快信息写到交换空间，这样以来，物理内存得到了释放，这块内存可以用于其他目前，当需要原始的内容时，这些信息会被从新从交换空间读入物理内存。  
**linux的内存管理**采取的是分页存取机制，为了保证物理内存能得到充分的利用，，内核会在适当的时候将物理内存中不经常使用的数据块自动交换到虚拟内存中，而将经常使用的信息保留到物理内存。  

**linux内存运行机制**   
1. **linux系统会不时的进行页面交换操作，以保持尽可能多的空闲物理内存，即使并没有什么事情需要内存，linux也会交换出暂时不用的内存页面。可以避免等待交换所需的时间。**  
2. linux进行页面交换是有条件的，不是所有页面在不用时都交换到虚拟内存，linux内核根据“最近最进场使用”算法，仅仅将一些不经常使用的页面文件交换到虚拟内存。有时候可以看到：linux物理内存还有很多，但是交换空间也使用了很多。不用担心，这个也可能是正常的，例如：一个占用很大内存的进程运行时，需要耗费很多内存资源，此时就会有一些不常用页面文件被交换到虚拟内存中，但该进程结束并适当了很多内存时，被交换出去的页面文件并不会自动的交换进物理内存，除非有必要，那么此时系统物理内存就会空闲很多，同时交换空间也被使用。  
3. 交换空间的页面在使用时会首先备交换到物理内存，如果此时没有足够的物理内存来容纳这些页面，它们又会被马上交换出去，如此以来，虚拟内存中可能没有足够的空间来存储这些交换页面，最终会导致linux出现假死机、服务异常等问题，linux虽然可以在一段时间内自行恢复，但是恢复后的系统已经基本不可用了。  

**虚拟内存原理**  
在系统中运行的每个进程都需要使用到内存，但不是每个进程都需要每时每刻使用系统分配的内存空间。当系统运行所需内存超过实际的物理内存，内核会释放某些进程所占用但未使用的部分或所有物理内存，将这部分资料存储在磁盘上直到进程下一次调用，并将释放出的内存提供给有需要的进程使用。  
在linux内存管理中，主要是通过“调页Paging”和“交换Swapping”来完成上述的内存调度。调页算法是将内存中最近不常使用的页面换到磁盘上，把活动页面保留在内存中供进程使用。交换技术是将整个进程，而不是部分页面，全部交换到磁盘上。  
分页(Page)写入磁盘的过程被称作Page-Out，分页(Page)从磁盘重新回到内存的过程被称作Page-In。当内核需要一个分页时，但发现此分页不在物理内存中(因为已经被Page-Out了)，此时就发生了分页错误（Page Fault）。  
当 系统内核发现可运行内存变少时，就会通过Page-Out来释放一部分物理内存。经管Page-Out不是经常发生，但是如果Page-out频繁不断的 发生，直到当内核管理分页的时间超过运行程式的时间时，系统效能会急剧下降。这时的系统已经运行非常慢或进入暂停状态，这种状态亦被称作 thrashing(颠簸)。  


### 1.命令格式
    vmstat [options] [delay [count]]
### 2.命令功能
用来显示虚拟内存的信息
### 3.命令参数

    delay：刷新时间间隔。如果不指定，只显示一条结果。
    count：刷新次数。如果不指定刷新次数，但指定了刷新时间间隔，这时刷新次数为无穷。
    -a, --active           active/inactive memory 显示活跃和非活跃内存
    -f, --forks            number of forks since boot 显示从系统启动至今的fork数量
    -m, --slabs            slabinfo 显示slabinfo
    -n, --one-header       do not redisplay header 只在开始时显示一次各字段名称
    -s, --stats            event counter statistics 显示内存相关统计信息及多种系统活动数量
    -d, --disk             disk statistics 显示磁盘相关统计信息
    -D, --disk-sum         summarize disk statistics
    -p, --partition <dev>  partition specific statistics 显示指定磁盘分区统计信息
    -S, --unit <char>      define display unit 使用指定单位显示。参数有 k 、K 、m 、M ，分别代表1000、1024、1000000、1048576字节（byte）。默认单位为K（1024 bytes） 
    -w, --wide             wide output
    -t, --timestamp        show timestamp
    -h, --help     display this help and exit
     -V, --version  output version information and exit
### 4.使用实例

###### 1. 显示虚拟内存使用情况

    vmstat 1 3
    procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
     r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
     2  0      0 576616    948 273608    0    0    73    15   42   86  0  0 99  1  0
     0  0      0 576600    948 273608    0    0     0     0   49   86  0  0 100  0  0
     0  0      0 576600    948 273608    0    0     0     0   43   71  0  0 100  0  0
字段说明：

    Procs（进程）：  
        r: 运行队列中进程数量  
        b: 等待IO的进程数量  
    Memory（内存）：
        swpd: 使用虚拟内存大小
        free: 可用内存大小
        buff: 用作缓冲的内存大小
        cache: 用作缓存的内存大小
    Swap：
        si: 每秒从交换区写到内存的大小
        so: 每秒写入交换区的内存大小
    IO：（现在的Linux版本块的大小为1024bytes）
        bi: 每秒读取的块数
        bo: 每秒写入的块数
    system：
        in: 每秒中断数，包括时钟中断。
        cs: 每秒上下文切换数。
    CPU（以百分比表示）：
        us: 用户进程执行时间(user time)
        sy: 系统进程执行时间(system time)
        id: 空闲时间(包括IO等待时间),中央处理器的空闲时间 。以百分比表示。
        wa: 等待IO时间
备注： 如 果 r经常大于 4 ，且id经常少于40，表示cpu的负荷很重。如果pi，po 长期不等于0，表示内存不足。如果disk 经常不等于0， 且 在 b中的队列 大于3， 表示 io性能不好。Linux在具有高稳定性、可靠性的同时，具有很好的可伸缩性和扩展性，能够针对不同的应用和硬件环境调 整，优化出满足当前应用需要的最佳性能。因此企业在维护Linux系统、进行系统调优时，了解系统性能分析工具是至关重要的。

vmstat 1 3
表示在3秒内进行3次采样。将得到一个数据汇总他能够反映真正的系统情况。

###### 2. 显示活跃和非活跃内存

    vmstat -a 1 3
    procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
     r  b   swpd   free  inact active   si   so    bi    bo   in   cs us sy id wa st
     2  0      0 574448  67320 106860    0    0    61    13   39   78  0  0 99  1  0
     0  0      0 574448  67320 106856    0    0     0    16   44   71  0  0 100  0  0
     0  0      0 574448  67320 106872    0    0     0     0   43   69  0  0 100  0  0
使用-a选项显示活跃和非活跃内存时，所显示的内容除增加inact和active外，其他显示内容与例子1相同。  
字段说明：  

    Memory（内存）：
    inact: 非活跃内存大小（当使用-a选项时显示）
    active: 活跃的内存大小（当使用-a选项时显示）

###### 3. 查看系统已经fork了多少次

    vmstat -f
             2750 forks
这个数据是从/proc/stat中的processes字段里取得的

###### 4. 查看内存使用的详细信息

    vmstat -s
          1009276 K total memory
           153476 K used memory
           102712 K active memory
            67320 K inactive memory
           579628 K free memory
              948 K buffer memory
           275224 K swap cache
          2097148 K total swap
                0 K used swap
          2097148 K free swap
              264 non-nice user cpu ticks
                2 nice user cpu ticks
              829 system cpu ticks
           212886 idle cpu ticks
             1060 IO-wait cpu ticks
                0 IRQ cpu ticks
                6 softirq cpu ticks
                0 stolen cpu ticks
           122947 pages paged in
            26553 pages paged out
                0 pages swapped in
                0 pages swapped out
            81713 interrupts
           160895 CPU context switches
       1476168473 boot time
             2753 forks
这些信息的分别来自于/proc/meminfo,/proc/stat和/proc/vmstat。

###### 5. 查看磁盘的读/写

    vmstat -d
    disk- ------------reads------------ ------------writes----------- -----IO------
           total merged sectors      ms  total merged sectors      ms    cur    sec
    fd0        0      0       0       0      0      0       0       0      0      0
    sda     8666     15  245806   28737   2945    972   53136  993192      0     28
    sr0       11      0      88     253      0      0       0       0      0      0
    dm-0    7311      0  232037   27619   2883      0   48966 1836536      0     28
    dm-1     126      0    2136     239      0      0       0       0      0      0
这些信息主要来自于/proc/diskstats.  
merged:表示一次来自于合并的写/读请求,一般系统会把多个连接/邻近的读/写请求合并到一起来操作.

###### 6. 查看/dev/vdb2磁盘的读/写

    df 
    Filesystem     1K-blocks    Used Available Use% Mounted on
    /dev/vda1       20510332 2599384  16862424  14% /
    tmpfs             510172      12    510160   1% /dev/shm
    /dev/vdb2       16382320   45312  15498176   1% /data
    [root@vm10-100-0-8 ~]# vmstat -p /dev/vdb2
    vdb2          reads   read sectors  writes    requested writes
                     498       4066       3193      51176
这些信息主要来自于/proc/diskstats。  
reads:来自于这个分区的读的次数。  
read sectors:来自于这个分区的读扇区的次数。  
writes:来自于这个分区的写的次数。  
requested writes:来自于这个分区的写请求次数。  

###### 7. 查看系统的slab信息

    vmstat -m | head
    Cache                       Num  Total   Size  Pages
    bridge_fdb_cache              0      0     64     59
    dm_thin_endio_hook            0      0     64     59
    dm_thin_new_mapping           0      0     88     44
    dm_bio_prison_cell            0      0     88     44
    nf_conntrack_expect           0      0    240     16
    nf_conntrack_ffffffff81b1b780      4     12    312     12
    fib6_nodes                   24     59     64     59
    ip6_dst_cache                16     20    384     10
    ndisc_cache                   8     15    256     15
这组信息来自于/proc/slabinfo。  
slab:由于内核会有许多小对象，这些对象构造销毁十分频繁，比如i-node，dentry，这些对象如果每次构建的时候就向内存要一个页(4kb)，而其实只有几个字节，这样就会非常浪费，为了解决这个问题，就引入了一种新的机制来处理在同一个页框中如何分配小存储区，而slab可以对小对象进行分配,这样就不用为每一个对象分配页框，从而节省了空间，内核对一些小对象创建析构很频繁，slab对这些小对象进行缓冲,可以重复利用,减少内存分配次数。
