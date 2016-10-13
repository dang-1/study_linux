
whereis命令只能用于程序名的搜索，而且只能搜索二进制文件(-b)、man说明文件(-m)和源代码文件(-s)。省略参数，则返回所有信息。  
whereis相对于find查找的速度很快，因为查找的是一个数据库文件，其中包含了系统内的所有文件，但是该文件默认一周更新一次，所以有时候会找到已经删除的数据或者刚刚建立的文件，却无法找到，是因为数据库文件没有被更新。

### 1.命令格式
    whereis [options] file
### 2.命令功能


whereis命令是定位可执行文件、源代码文件、帮助文件在文件系统中的位置。这些文件的属性应属于原始代码，二进制文件，或是帮助文件。whereis 程序还具有搜索源代码、指定备用搜索路径和搜索不寻常项的能力。
### 3.命令参数

    -b         search only for binaries定位可执行文件
    -B <dirs>  define binaries lookup path 指定搜索可执行文件的路径
    -m         search only for manuals 定位帮助文件
    -M <dirs>  define man lookup path指定搜索帮助文件的路径
    -s         search only for sources 定位源代码文件
    -S <dirs>  define sources lookup path 指定搜索源代码文件的路径
    -f         terminate <dirs> argument list
    -u         search for unusual entries 搜索默认路径下除可执行文件、源代码文件、帮助文件以外的其它文件
    -l         output effective lookup paths

### 4.使用实例

###### 1. 将和**文件相关的文件都查找出来

    whereis nginx
    nginx:
    whereis docker
    docker: /usr/bin/docker /etc/docker /usr/libexec/docker /usr/share/man/man1/docker.1.gz

nginx没安装，找不出来，docker已安装，找出了很多相关文件


###### 2. 只将二进制文件 查找出来 

    whereis -b svn
    svn: /usr/bin/svn
    whereis -m svn
    svn: /usr/share/man/man1/svn.1.gz
    whereis -s svn
    svn:

whereis -m svn 查出说明文档路径，whereis -s svn 找source源文件。
