redis持久化-RDB(redis database)
所具备的持久化是使用文件快照的方式，可以在配置文件中配置快照持久化的策略，可以设置多个，这里要考虑具体的数据变化规律合性能的考虑(对磁盘文件的读写也较为费事)。有一点redis的文件快照持久化非增量持久化，也就是说每次进行快照都是全量数据。对于该种策略文件快照，在断电、宕机的情况下会丢失尚未进行快照的数据，在设置策略的时候需要考虑。
插入速度与每条记录大小关系不大，在进行save 60 10000策略插入1千万条数据与没有持久化策略插入1千万时间分别是 1小时50分钟、1小时20分钟
文件快照设置方式如下：
#save 900 1       在900秒内 如果有1条记录更新经行快照
#save 300 10      在300秒内 如果有10条记录更新经行快照
#save 60 10000    在60秒内 如果有10000条记录更新经行快照

redis持久化-AOF(append only file)