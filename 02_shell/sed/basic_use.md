可以实现 grep 的大部分功能，而且还可以查找替换

##### 1.打印指定行

    sed '10'p -n 1.txt #打印第 10 行
    sed '1,4'p -n 1.txt #打印 1 到 4 行
    sed '5,$'p -n 1.txt #打印 5 到末行
说明： 这里的 p 是 print 的意思，加上-n 后就可以只打印符合规则的行，如果不加则会把 1.txt 从头到尾打印一遍。  
##### 2.打印包 含某个字符串的行

    sed -n '/root/'p 1.txt #打印包含root的行
    
###### 可以使用 ^ . * $ 等特殊符号

    sed -n '/ro.t/'p 1.txt
    sed -n '/^roo/'p 1.txt


###### sed 跟 grep 一样， 不识别+|{}() 等符号，需要借助脱义符号\或者使用选项-r

    sed -n -r '/ro+/'p 1.txt 
    sed -n '/ro\+/'p 1.txt

##### 3.-e 可以实现同时进行多个任务 等同于;

    sed -e '/root/p' -e '/body/p' -n 1.txt
    sed '/root/p; /body/p' -n 1.txt
##### 4.删除
###### 删除指定行
    sed '/root/d' 1.txt; sed '1d' 1.txt; sed '1,10d' 1.txt
'/root/d' 删除包含 root 的行；'1d'或者'1'd 删除第一行；'1,10'd 删除 1 到 10 行替换功能

###### 删除所有数字
    sed 's/[0-9]//g' 1.txt #其实就是把所有数字替换为空字符
###### 删除所有非数字
    sed 's/[^0-9]//g' 1.txt

##### 5.替换

    sed '1,2s/ot/to/g' 1.txt 
    sed '1,2s@ot@to@g' 1.txt
s 就是替换的意思，g 为全局替换，否则只替换第一次的，/也可以为 # @等

###### 调换两个字符串位置
    head -n2 1.txt |sed -r 's/(root)(.*)(bash)/\3\2\1/'
在 sed 中可以用()去表示一个整体，本例中把 root 和 bash 调换位置，后面的\1\2\3 分别表示第一个小括号里面的，第二个小括号里面的以及第三个小括号里面的内容。


##### -i  选项可 以直接修改文件内容

    sed -i 's/ot/to/g' 1.txt
还有一种用法可以将源文件进行备份
    
    sed -i.back 's/ot/to/g' 1.txt #源文件备份为1.txt.back
