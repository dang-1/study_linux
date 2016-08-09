### mysql 5.5
    yum install -y epel-release
    yum install -y gcc bison bison-devel glibc-devel gcc-c++ make cmake
    yum install -y ncurses ncurses-devel
    tar xf mysql-5.5.50.tar.gz
    cd mysql-5.5.50
    cmake \
    -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
    -DMYSQL_DATADIR=/usr/local/mysql \
    -DMYSQL_UNIX_ADDR=/tmp/mysql.sock \
    -DDEFAULT_CHARSET=utf8 \
    -DDEFAULT_COLLATION=utf8_general_ci \
    -DMYSQL_TCP_PORT=3306 \
    -DWITH_MYISAM_STORAGE_ENGINE=1 \
    -DWITH_INNOBASE_STORAGE_ENGINE=1 \
    -DWITH_READLINE=1 \
    -DENABLED_LOCAL_INFILE=1 \
    -DWITH_MEMORY_STORAGE_ENGINE=1 \
    -DWITH_EXTRA_CHARSETS:STRING=all \
    -DWITH_PARTITION_STORAGE_ENGINE=1 \
    -DWITH_EMBEDDED_SERVER=OFF \
    -DMYSQL_USER=mysql \
    -DFEATURE_SET=community \
    -DWITH_DEBUG=0 
    make
    make install

    








