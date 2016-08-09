### images manage

    docker pull centos //get a image of "centos"
    docker images //list locate images
    docker tag centos dang #set a 'dang' tag from "centos" image
    docker search [image_name] #search "image_name" from docker repository
    docker rmi [image_name/"IMAGE ID"]#可以跟镜像名字，如果还有其他tag，不会删除镜
    #像，如果删除“IMAGE ID”将会删除所有的"IMAGE ID"的镜像
    
### 基于本地模板创建镜像

    http://openvz.org/Download/templates/precreated
    cat centos-6-x86_64-minimal.tar.gz | docker import - centos-6-x86_64-minimal 
    # import local images
    docker save -o centos-6-x86_64-minimal.tar.gz "REPOSITORY/IMAGE ID" 
    #将现有的镜像导出一个文件，后面可以跟"REPOSITORY"或"IMAGE ID"
    docker load --input centos-6-x86_64-minimal.tar.gz  #恢复本地镜像
     docker load < centos-6-x86_64-minimal.tar.gz ##恢复本地镜像
    docker tag "IMAGE ID" dang:last #恢复后没有名字可以修改
    docker export container_id  > file_name.tar
    #导出容器，可以迁移到其他机器上，需要先导入为镜像

### continer manage

    docker create  -it  centos #创建一个容器，不启动
    docker start "CONTAINER ID" #启动容器后，可以使用 dockerps  查看到CONTAINER ID
    docker run -i -t centos  bash #使用虚拟中断进入容器，使用命令exit
    #或者ctrl d 退出该bash，当退出后这个容器也会停止。
    docker run -i -t centos /bin/bash #用下载的镜像开启容器
        # -i 让容器的标准输入打开
        # -t 分配一个伪终端
    docker run -d  #可以让容器在后台运行 
    eg:docker run -d centos  bash -c "for i in `seq 1 100`; do echo "123"; sleep 1; done "
    docker run --name web -itd centos bash # --name 给容器自定义名字
    docker run --rm -it centos bash -c "sleep 30"  
    #--rm可以让容器退出后直接删除，在这里命令执行完容器就会退出，不能和-d一起使用
    docker ps #查看运行的容器，加上-a 可以查看所有的容器

### start container

    docker start "CONTAINER ID"

    docker exec -it container_id /bin/bash #重新进入容器
