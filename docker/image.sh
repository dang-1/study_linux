# images manage
 docker pull centos #get a image of "centos"
 docker images #list locate images
 docker tag centos dang #set a "dang" tag from "centos" image
 docker search [image_name] #search "image_name" from docker repository
 docker rmi [image_name/]


# continer manage
 docker run -i -t centos /bin/bash #用下载的镜像开启容器
     # -i 让容器的标准输入打开
     # -t 分配一个伪终端
 docker ps #查看运行的容器，加上-a 可以查看所有的容器


