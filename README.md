
*This project has been created as part of the 42 curriculum by ferafano*

## Description
this project is about learning how to setup a small infrastructure composed of different services under specific rules.
At the end we will be able to setup a small infrastructure using : 
- Nginx: Serving as the entry point and web server.
- MariaDB: Acting as the relational database management system for persistent storage.
- WordPress: Functioning as the content management system and application layer.

## Instructions

#### Environment & Secrets
- Environment variables are loaded from `srcs/.env`.
- Secrets are mounted from files in `secrets/` as defined in `docker-compose.yml`.
	- `secrets/credentials.txt`      → WordPress editor user password
	- `secrets/credentials2.txt`     → WordPress admin password
	- `secrets/db_password.txt`      → MariaDB app user password
	- `secrets/db_root_password.txt` → MariaDB root password

#### Compilation & installation
- To run specifique cmd to setup the project , you can use :
	- `make` to build & run the project
	- `make clean` stop & remove every container
	- `make fclean` will execute `make clean` & remove every image
	- `make reset` will execute `make fclean` & remove the volume
	- `make re` will execute `make fclean` & `make` without removing the volume 

#### Usage
- After `make`, Nginx serves WordPress over HTTPS on `PORT` specified inside `.env`.
    - Use the `URL` you specified from `.env` to access the site.

## Resources
- Docker docs    : https://kodekloud.com/
- Nginx docs     : https://nginx.org/en/docs/
- MariaDB docs   : https://mariadb.com/kb/en/documentation/
- WordPress docs : https://developer.wordpress.org/cli/commands/
- How AI Was Used :
	- AI assisted by providing more detailed explanation, help debugging container error log, identifying hell configuration mismatches , and suggesting safer and good practice to avoid possible vulnerability.

## Project Description
- How to use docker:
  - Infrastructure Management
    - `docker-compose up -d` → Build and start the infrastructure in the background.
    - `docker-compose down` → Stop and remove all containers and networks.
    - `docker-compose stop` → Halt running containers without removing them.
    - `docker-compose restart` → Restart services (apply configuration changes).
  - Monitoring & Inspection
    - `docker ps` → List all currently running containers.
    - `docker ps -a` → List all containers (including stopped ones).
    - `docker-compose logs -f` → View live output logs for debugging service errors.
    - `docker network ls` → List all networks to verify the isolated bridge.
    - `docker volume ls` → List all persistent volumes (where DB data lives).
    - `docker inspect <name>` → View detailed configuration/IP of a specific container.
  - Interacting with Services
    - `docker exec -it <container_name> sh` → Open a shell inside a running container.
    - `docker-compose exec <service_name> sh` → Access a service defined in your YAML.
    - `docker cp <src> <container>:<dest>` → Copy files between the host VM and container.
  - Cleanup & Maintenance
    - `docker-compose down -v` → Stop containers and delete all attached volumes.
    - `docker system prune -a` → Wipe all unused data (containers, networks, and images).
    - `docker top <container_name>` → Display the running processes of a container.
  
- The main design choice :
    - 1. Isolation and Fault Tolerance
		- If one service crashes, others continue running Can restart/update individual services without full system downtime
	      Failures are contained and easier to diagnose
    - 2. Independent Scaling
        - Scale services based on their specific load patterns Database under heavy load.
    - 3. Security Through Segmentation
    	- Network isolation: database isn't directly accessible from the public-facing web server
		Nginx acts as a hardened entry point, filtering malicious requests before they reach WordPress.


- comparaison:
  - Virtual Machines vs Docker: Docker shares the host kernel and isolates processes with namespaces/cgroups, making it faster to start and lighter than full VMs; ideal for microservices.
  - Secrets vs Environment Variables: Secrets are mounted from files and avoid storing sensitive values in images or commits. Envs configure non-sensitive runtime parameters.
  - Docker Network vs Host Network: Internal bridge networks isolate services; only Nginx exposes a public DB_PORT, reducing attack surface.
  - Docker Volumes vs Bind Mounts: Bind mounts ensure developer-visible persistence at known paths; volumes abstract storage.


