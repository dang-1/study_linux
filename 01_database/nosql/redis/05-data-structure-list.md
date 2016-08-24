### 简介：
list是一个链表结构。  
*主要功能*是push、pop、获取一个范围的所有值等等。操作中key理解为链表的名字。  
使用 List 结构，我们可以轻松地实现最新消息排行等功能（比如新浪微博的 TimeLine ）。  
List 的另一个应用就是消息队列，可以利用 List 的 *PUSH* 操作，将任务存在 List 中，然后工作线程再用 POP 操作将任务取出进行执行。  
Redis 还提供了操作 List 中某一段元素的 API，你可以直接查询，删除 List 中某一段的元素。
### 常用命令
#### 插入元素：
lpush：从左侧插入值  
rpush：从右侧插入值  
linsert：插入一个值  

    > lpush list3 "aaa"
    (integer) 1
    > lpush list3 "bbb"
    (integer) 2
    > rpush list3 "ccc"
    (integer) 3
    > lrange list3 0 -1
    1) "bbb"
    2) "aaa"
    3) "ccc"
    > linsert list3 before "ccc" "111" 
    (integer) 4
    > lrange list3 0 -1
    1) "bbb"
    2) "aaa"
    3) "111"
    4) "ccc"  
#### 取出元素：
lpop：从左侧取出一个值。  
rpop：从右侧取出一个值。      

    > lpop list1
    "123"
    > lrange list1 0 -1
    1) "dang"
    2) "test"
    > rpush list1 "heih"
    (integer) 3
    > lrange list1 0 -1
    1) "dang"
    2) "test"
    3) "heih"
    > rpop list1
    "heih"
    > lrange list1 0 -1
    1) "dang"
    2) "test"
#### 更改值：
lset：  

    > lrange list3 0 -1
    1) "bbb"
    2) "aaa"
    3) "111"
    4) "ccc"
    > lset list3 3 "333" //list名后面带的参数为索引值，从0开始
    OK
    > lrange list3 0 -1 
    1) "bbb"
    2) "aaa"
    3) "111"
    4) "333"
#### 显示元素：
    lrange：是从左到右显示所有元素，左侧在上，右侧在下。  
>用法：lrange list_name 0 -1 #0表示左侧第一个，-1表示右侧的第一个

    lindex list3 0 //查看list3中的第一个元素  
    lindex list3 3 //查看list3中的第4个元素值  
    llen list3 //查看链表中有几个元素
