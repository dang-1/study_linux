
allow 和 deny 的规则。
首先举个例子

    Order deny,allow
    deny from all
    allow from 127.0.0.1

我们判断的依据是这样的：  
1. 看 Order 后面的，哪个在前，哪个在后  
2. 如果 deny 在前，那么就需要看 deny from 这句，然后看 allow from 这一句  
3. 规则是一条一条的匹配的，不管是 deny 在前还是 allow   在前，都是会生效的。比如例子中，先 deny 了所有，然后又 allow 了 127.0.0.1，所以 127.0.0.1 是通过的。  

不妨再多举几个例子：

    Order allow,deny  
    deny from all  
    allow from 127.0.0.1  
这个就会 deny 所有了，127.0.0.1 也会被 deny。因为顺序是先 allow 然后 deny，虽然一开始 allow 了 127.0.0.1，但是后面又拒绝了它。

    Order allow,deny
    deny from all
上面的规则就表示，全部都不能通

    Order deny,allow
    deny from all
上面的规则表示，全部都不能通行

    Order deny,allow
只有顺序，没有具体的规则，表示，全部都可以通行（默认的），因为 allow 在最后了。

    Order allow,deny
这个表示，全部都不能通行（默认的），因为 deny 在最后了。

### 具体应用：  
（1）某个目录做限制，比如该目录很重要，只允许我们公司的 ip 访问，当然这个目录可以是网站根目录，也就是整个站点都要做限制了。  

    <Directory /data/www/>
        Order deny,allow
        Deny from all
        Allow from 127.0.0.1
    </Directory>
说明：只允许 127.0.0.1 访问，其他 IP 全部拒绝掉。

（2）针对请求的 uri 去限制，前面安装的 discuz 论坛，访问后台是 admin.php，那我们就可以针对这个 admin.php 做限制。

    <filesmatch "(.*)admin(.*)">
        Order deny,allow
        Deny from all
        Allow from 127.0.0.1
    </filesmatch>
说明：这里用到了 filesmatch 语法，表示匹配的意思。


上面是使用allow 和 deny 去现在网站根目录下的某个子目录，也可以使用rewrite 实现，配置如下：

    <IfModule mod_rewrite.c>
        RewriteEngine on
        RewriteCond %{REQUEST_URI} ^.*/tmp/* [NC]
        RewriteRule .* - [F]
    </IfModule>
这段配置，会把只要是包含/tmp/字样的请求都限制了，比如下面的请求，在这里我们假定网站域名为 bbs.1.com。  
bbs.1.com/1/tmp/123.html  
bbs.1.com/2/tmp/123.html  
bbs.1.com/3/1/2/tmp/123.html
