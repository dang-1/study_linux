    
    
    NameVirtualHost *:80
    
    <VirtualHost *:80>
        DocumentRoot "/tmp/123"
        ServerName 111.com
        
    </VirtualHost>
    
    <VirtualHost *:80>
        DocumentRoot "/data/www"
        ServerName www.test.com
        ServerAlias www.aaa.com
        SetEnvIf Request_URI ".*\.gif$" image-request
        SetEnvIf Request_URI ".*\.jpg$" image-request
        SetEnvIf Request_URI ".*\.png$" image-request
        SetEnvIf Request_URI ".*\.bmp$" image-request
        SetEnvIf Request_URI ".*\.swf$" image-request
        SetEnvIf Request_URI ".*\.js$" image-request
        SetEnvIf Request_URI ".*\.css$" image-request
        ErrorLog "|/usr/local/apache/bin/rotatelogs -l /usr/local/apache/logs/aaa-error_%Y%m%d.log 86400"
        CustomLog "|/usr/local/apache/bin/rotatelogs -l /usr/local/apache/logs/aaa-access_%Y%m%d.log 86400" combined env=!image-request
    
        <IfModule mod_rewrite.c>
            RewriteEngine on
            RewriteCond %{HTTP_HOST} ^www.aaa.com$
            RewriteRule ^/(.*)$ http://www.test.com/$1 [R=301,L]
        </IfModule>
        
        <Directory /data/www/admin.php>
            AllowOverride AuthConfig
            AuthName "alksdjflkasjdf"
            AuthType Basic
            AuthUserFile /data/.htpasswd
            require valid-user
        </Directory>
    </VirtualHost>







说明：在原来日志配置的基础上，增加了一些 image-request 的定义，比如把 gif、jpg、bmp、swf、js、css 等结尾的全标记为 image-request，然后在配置日志的时后加一个标记env=!image-request，这里有个叹号，表示取反，这样就可以把这些忽略了。
