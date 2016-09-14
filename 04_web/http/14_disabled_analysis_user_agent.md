user_agent：浏览器标识。  
目前主流的浏览器有：IE、 chrome、 Firefox、 360、 iphone上的 Safari、Android 手机上的、百度搜索引擎、google 搜索引擎等。  
常见user_agent：  
Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; Trident/4.0; .NET4.0C; .NET4.0E; SE2.x)  
Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (KHTML, like Gecko)  
Chrome/31.0.1650.63 Safari/537.36  
Mozilla/5.0 (compatible; Baiduspider/2.0;   +http://www.baidu.com/search/spider.html)  
Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; WOW64; Trident/4.0; SLCC2; .NET  
CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC  
6.0; .NET4.0C; .NET4.0E; InfoPath.3; 360SE)  

对这些 user_agent 来做一些限制。  
配置如下：

    <IfModule mod_rewrite.c>
        RewriteEngine on
        RewriteCond %{HTTP_USER_AGENT} ^*Firefox/4.0* [NC,OR]
        RewriteCond %{HTTP_USER_AGENT} ^*Tomato Bot/1.0* [NC]
        RewriteRule .* - [F]
    </IfModule>
使用rewrite模块来实现限制指定的user_agent。  
在本例中， RewriteRule \.\* - [F] 可以直接禁止访问，rewritecond 用 user_agent 来匹配，\*Firefox/4.0\* 表示，只要 user_agent 中含有 Firefox/4.0 就符合条件，其中\*表示任意字符，NC 表示不区分大小写，OR 表示或者，连接下一个条件。假如我现在要把百度的搜索引擎限制掉，可以加一条这样的规则：  
RewriteCond %{HTTP_USER_AGENT} ^*Baiduspider/2.0* [NC]  
RewriteRule .* - [F]  
在不写 OR 的时候就是并且的意思。  
