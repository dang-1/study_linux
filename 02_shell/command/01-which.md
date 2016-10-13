### 常用搜索命令：
    which  查看可执行文件的位置。
    whereis 查看文件的位置。 
    locate   配合数据库查看文件位置。
    find   实际搜寻硬盘查询文件名称。

作用：在PATH变量指定的路径中，搜索某个系统命令的位置，并返回第一个搜索结果。  
可以看到某个系统命令是否存在，以及执行的到底是哪一个位置的命令。  
Write the full path of COMMAND(s) to standard output.
### 1.命令格式
    /usr/bin/which [options] [--] COMMAND [...]
### 2.命令功能
which指令会在PATH变量指定的路径中，搜索某个系统命令的位置，并且返回第一个搜索结果。
### 3.命令参数

    --version, -[vV] Print version and exit successfully.
    --help,          Print this help and exit successfully.
    --skip-dot       Skip directories in PATH that start with a dot.
    --skip-tilde     Skip directories in PATH that start with a tilde.
    --show-dot       Don''t expand a dot to current directory in output.
    --show-tilde     Output a tilde for HOME directory for non-root.
    --tty-only       Stop processing options on the right if not on tty.
    --all, -a        Print all matches in PATH, not just the first
    --read-alias, -i Read list of aliases from stdin.
    --skip-alias     Ignore option --read-alias; don''t read stdin.
    --read-functions Read shell functions from stdin.
    --skip-functions Ignore option --read-functions; don''t read stdin.
    -n 　指定文件名长度，指定的长度必须大于或等于所有文件中最长的文件名。
    -p 　与-n参数相同，但此处的包括了文件的路径。
    -w 　指定输出时栏位的宽度。

Recommended use is to write the output of (alias; declare -f) to standard
input, so that which can show aliases and shell functions. See which(1) for
examples.

If the options --read-alias and/or --read-functions are specified then the
output can be a full alias or function definition, optionally followed by
the full path of each command used inside of those.

### 4.使用实例

###### 1. 查找文件、显示命令路径

    which lsmod
    /usr/sbin/lsmod

which是根据使用者的环境变量内的目录去搜寻可运行命令的。

###### 2. 使用which查找which

    which which 
    alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'
    	/usr/bin/alias
    	/usr/bin/which
    	
前面是一个命令别名。

###### 3. 普通用户无法查找cd命令

    which cd
    /usr/bin/which: no cd in (/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/yw_tangjianming/bin)
