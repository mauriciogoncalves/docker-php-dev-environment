# Docker PHP development environment  
  
## Description  
The purpose here is to setup a environment for development of some PHP web.  
 After start the containers we should have:  
 - **PHP Apache** machine with many PHP extensions already instaled and some applications, like a **sample web page** for database connection tests, **PGAdmin** for postgre management and **PhpMyAdmin** for mysql management .  
 - **Redis** machine  
 - **PostgreSQL** machine  
 - **Mysql** machine with MariaDB as service  
   
##  Setup 
Assuming we have what is necessary already installed (Like git, docker, ssh and so on), just run the following commands:
  ```
git clone https://github.com/mauriciogoncalves/docker-php-dev-environment.git
cd docker-php-dev-environment
docker-compose -f ./php7-docker-compose.yaml up
```   

After this we should have four docker virtual machines container  running our services.
  
##   Services
|Container|  Service  | Remote Access | Local Access|Username|Password|Database|  
|    -   |      -     |        -      |        -    |     -  |    -   | - |    
|redis   |**Redis** |127.0.0.1:66790|redis:3369   |        |password|     
|postgres|**Postgres**|127.0.0.1:54320|postgres:5432|postgres|password|dev   
|mariadb |**MariaDB** |127.0.0.1:33060|redis:3369   | admin  |password|dev    
|dev-php |**Apache** |127.0.0.1:800  |localhost:80 |     
|dev-php |**Apache** |127.0.0.1:4430 |localhost:443|     
|dev-php |**SSH** |127.0.0.1:220  |localhost:22 | root   |password   
   
##   Web Tools
|Application| Link                          | Username    |Password| Info |  
|      -    |             -                 |      -      |    -   |   -  |
|PhpMyAdmin |http://localhost:800/phpMyAdmin|admin        |password|   
|PGAdmin4   |http://localhost:800/pgadmin4  |admin@dev.dev|password|  
|Test Page  |http://localhost:800/index.html|             |        | /var/www/web  
 ---
 
 
##  Test Page
A sample web page is already added at /var/www/web folder.
This page use Javascript Workers to trigger parallel requests to PHP file that test databases.
    
 - **index.html** `Sample Page`
 - **style.css**  &hairsp;  &hairsp; `Page styles` 
 - **main.js**  &hairsp;  &hairsp;  &hairsp;  &hairsp; `Page Javascript to trigger and handle response from workers`
 - **workers.js** `Workers to fire "multi-thread" requests` 
 - **test.php**  &hairsp;  &hairsp;  &hairsp;  `Backend function to test connection with Redis, Mysql and Postgres`
 
 ![test page](https://raw.githubusercontent.com/mauriciogoncalves/docker-php-dev-environment/main/web/images/page.gif)
 ----
  ## Development tools 
  PHP docker machine will create 3 log files in our local folder. We can tail PHP errors and access logs. 
 - docker-php-dev-environment/**xdebug_remote.log**  
 - docker-php-dev-environment/**php_error.log**  
 - docker-php-dev-environment/**error_log.log**
 - docker-php-dev-environment/**acess_log.log**

When you save a file in local folder, for example docker-php-dev-environment/index.html, it automatically change in docker machine at /var/www/web/index.html

## Debug
In PhpStorm you need to configure ;

 - Deployment
 - Servers
 - PHP Debug port
 - Open SSH tunnel

#### PhpStorm Deployment
![PhpStorm Deployment](https://raw.githubusercontent.com/mauriciogoncalves/docker-php-dev-environment/main/web/images/phpsotm-deployment.jpg)
#### PhpStorm Servers
![PhpStorm Servers](https://raw.githubusercontent.com/mauriciogoncalves/docker-php-dev-environment/main/web/images/phpsotm-servers.jpg)
#### PhpStorm Debug Port
![PhpStorm Debug](https://raw.githubusercontent.com/mauriciogoncalves/docker-php-dev-environment/main/web/images/phpsotm-debug.jpg)

#### Open SSH Tunnel
Open the SSH tunnel, default password is defined as "password"
 ```
ssh -R 9000:127.0.0.1:9001 -p220 root@127.0.0.1
```   

Now when you use the GET parameet XDEBUG_SESSION_START=phpstorm debug will be enables (or Cookie XDEBUG_SESSION). 
Like:
http://localhost:800/test.php?XDEBUG_SESSION_START=phpstorm
![PhpStorm Debug](https://raw.githubusercontent.com/mauriciogoncalves/docker-php-dev-environment/main/web/images/debug.jpg)

That's it! Just git clone, docker compose up, and we can deugging our PHP files.

---
 