1.简介  
Nginx 配置文件主要分为4部分：main（全局设置）、server（主机设置）、
upstream（负载均衡服务器设置）和 location（URL匹配特定位置的设置）。  
main部分设置的指令将影响其他所有设置；server部分的指令主要用于指定主机和端
口；upstream指令主要用于负载均衡，设置一系列的后端服务器；location部分用于
匹配网页位置。这四者之间的关系如下：server继承 main，location继承
server，upstream既不会继承其他设置也不会被继承。

结构：
