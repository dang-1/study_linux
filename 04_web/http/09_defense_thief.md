凡是在第三方站点上，严禁访问你站点的图片、MP3、rar、zip等文件

    SetEnvIfNoCase Referer "^http://.*\.aaa\.com" local_ref
    SetEnvIfNoCase Referer ".*\.test\.com" local_ref
    SetEnvIfNoCase Referer "^$" local_ref
    <filesmatch "\.(txt|doc|mp3|zip|rar|jpg|gif)">
        Order Allow,Deny
        Allow from env=local_ref
    </filesmatch>



比如：在A网站上面做了防盗链处理，那么在B网站上面插入A的图片，在访问B网站的时候，A网站的图片将会不会显示。  
说明：在这段配置中涉及到一个名词 referer，它其实就是上次访问的网站链接。   




配置中的referer，根据来源链接做限制的，如果源链接并不是我们想要的，就直接拒绝，这就是防盗链的原理。 
