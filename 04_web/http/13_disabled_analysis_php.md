
对某个目录禁止解析PHP  
场景：某些目录可以上传文件，为了避免上传的文件包含木马，禁止对这个目录下面的访问解析php。

    <Directory /data/www/data>
        php_admin_flag engine off
        <filesmatch "(.*)php">
            Order deny,allow
            Deny from all
            Allow from all
        </filesmatch>
    </Directory>
    
说明：php_admin_flag engine off 这个语句就是禁止解析 php 的控制语句。  
同时为了防止用户对该文件的下载，可以禁止访问。
