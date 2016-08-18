### 集合简介
类似于数学中的集合，对集合的操作有添加删除元素，有对多个集合求交并差等操作。    
操作中key理解为集合的名字。比如在微博应用中，可以将一个用户所有的关注人存在一个集合中，将其所有粉丝存在一个集合。因为redis非常人性化的为集合提供了求交集、并集、差积等操作，那么久可以非常方便的实现如同关注、共同喜好、二度好友等功能，对上面的所有集合操作，你还可以使用不同的命令选择将结果返回给客户端还是存集到一个新的集合中。  
qq有一个社交功能叫做“好友标签”，大家可以给你的好友贴标签，比如“大美女”、“土豪”、“欧巴”等等，这时就可以使用redis的集合来实现，把每一个客户的标签都存储在一个集合之中。  

### 常用命令
#### 插入元素
127.0.0.1:6379> sadd set1 dang  #向set1中放入元素
(integer) 1
127.0.0.1:6379> sadd set1 linux  
(integer) 1
127.0.0.1:6379> sadd set1 python
(integer) 1
127.0.0.1:6379> sadd set1 nosql
(integer) 1
#### 删除元素
srem set1 aaaa //删除元素
spop set1 //随机取出一个元素，删除
#### 获取元素
127.0.0.1:6379> smembers set1 #获取集合中的所有元素
1) "linux"
2) "nosql"
3) "python"
4) "dang"
sismember seta aaa //判断一个元素是否属于一个集合
srandmember seta //随机取出一个元素，但不删除
#### 交并差
sdiff seta setb //求差集，以seta为标准
sdiffstore seta setb setc //求差集并存储，存储到了seta里
sinter seta setb //求交集
sinterstore seta setb setc //求交集并存储，存储到seta
sunion seta setb //求并集
sunionstore sete seta setb //求并集并将结果存储在sete
