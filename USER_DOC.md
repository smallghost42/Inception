## USER DOC

###  Nginx (Web Server)
- Serves your website securely over HTTPS
- Acts as the "front door" for all visitors
- Protects traffic with SSL encryption

### WordPress (Website & Blog)
- Your website content management system
- Create pages, posts, and manage content
- Admin dashboard for site management
- User accounts with different permission levels

###  MariaDB (Database)
- Stores all your website data
- Saves posts, pages, user accounts, settings
- Runs quietly in the background

### start & stop the project
```bash
    make #start the project
    make clean # stop project and keep data
    make fclean # stop project and delete all image
    make reset #require privilege delete all data
    
    docker ps -a # check if a container is running
```
### access the website and the admin panel
  - open you browser and go to :
    - `https://login.42.fr`
  - login to admin panel
    - https://login.42.fr/wp-admin/
### locate and manage credentials
  -  passwords are saved in secrets folder you can modify it s content to modify it:
  -  secrets/
  -  ├── credentials.txt          → Editor user password
  -  ├── credentials2.txt         → Admin user password
  -  ├── db_password.txt          → Database app user password
  -  └── db_root_password.txt     → Database root password
### check that service are running
  - `docker ps` all three container should show `UP`
  - `docker logs <service-name>` to see error log 