### sort set(有序集合)简介
它比set多了一个权重参数score，使得集合中的元素能够按score进行有序排列，比如一个存储全班同学成绩的sorted set，其集合value可以是同学的学号，而score就可以是其考试得分，这样在数据插入集合的时候，就已经进行了天然的排序。
### 常用命令
#### 创建有序集合
    > zadd set2 12 "aaa" #12是分值
    (integer) 1
    > zadd set2 30 "linux"
    (integer) 1
    > zadd set2 7 "python"
    (integer) 1
    > zadd set2 13 "nosql"
    (integer) 1
#### 删除元素
    zrem zseta 222 //删除指定元素
    zremrangebyrank zseta 0 2 //删除索引范围0-2的元素，按score正向排序
    zremrangebyscore zseta 1 10 //删除分值范围1-10的元素
#### 显示元素
    zrank zseta 222 // 返回元素的索引值，索引值从0开始，按score正向排序
    zrevrank zseta 222 //同上，不同的是，按score反序排序
    > zrange set2 0 -1  #显示所有元素，按顺序显示
    1) "python"
    2) "aaa"
    3) "nosql"
    4) "linux"
    > zrevrange set2 0 -1 #逆序
    1) "linux"
    2) "nosql"
    3) "aaa"
    4) "python"
    zrange zseta 0 -1 withscores #可以带上分值
    zcard zseta //返回集合中所有元素的个数
    zcount zseta 1 10 //返回分值范围1-10的元素的个数
    zrangebyscore zseta 1 10 //返回分值范围1-10的元素

