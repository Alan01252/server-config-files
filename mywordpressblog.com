server {
	listen   8081; ## listen for ipv4; this line is default and implied

	server_name mywordpressblog.com *.mywordpressblog.com;
       
	root /var/www/mywordpressblog.com;
	index index.php index.html index.htm;
	
	location ~* \.(jpg|png|gif|jpeg|css|js)$ {
        	expires 10d;
	}

	location ~ \.php$ {
		fastcgi_pass 127.0.0.1:9000;
		fastcgi_index index.php;
		include fastcgi_params;
	}

	if ($http_host != "mywordpressblog.com") {
                 rewrite ^ http://mywordpressblog.com$request_uri permanent;
       	}
	include global/restrictions.conf;
	include global/wordpress-ms-subdir.conf;
}
