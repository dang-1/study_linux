
步骤：

    mysql> show variables like '%slow%'; #check status of slow log
    mysql> set global slow_query_log=0; #stop slow log
    mysql> show variables like '%slow%'; #check turn off slow log
    mysql> set global slow_query_log_file='/data/log/slow_queries_3306_new.log'; #reset the new file of slow log
    mysql> set global slow_query_log=1; #start slow log
    mysql> select sleep(10) as a, 1 as b; #check the slow sql in the new slow log file
    
    shell> mv old_slow_log.log old_back_slow_log.log; #back old slow log
