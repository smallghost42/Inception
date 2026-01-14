### 1. Environment Initialization

  - Before launching the services, you must configure the environment variables and security credentials.
    Prerequisites
  - Host: Linux Virtual Machine (e.g., Debian or Alpine).
  - Tools: make, docker, docker-compose.

    - Configuration Files

    - Environment: Create srcs/.env. This file defines non-sensitive metadata (e.g., Domain Name, Database Name, Usernames, Ports).

    - Secrets: Place sensitive passwords in the secrets/ directory as plain text files:

       - db_password.txt & db_root_password.txt

       - credentials.txt & credentials2.txt

    - Note: These files are excluded from version control but are mounted as read-only files inside the containers at runtime for maximum security.

### 2. Build and Deployment

  - The project uses a Makefile to abstract complex Docker commands into simple developer actions.

- Environment variables are loaded from `srcs/.env`.
- Secrets are mounted from files in `secrets/` as defined in `docker-compose.yml`.
	- `secrets/credentials.txt`      → WordPress editor user password
	- `secrets/credentials2.txt`     → WordPress admin password
	- `secrets/db_password.txt`      → MariaDB app user password
	- `secrets/db_root_password.txt` → MariaDB root password


- To run specifique cmd to setup the project , you can use :
	- `make` to build & run the project
	- `make clean` stop & remove every container
	- `make fclean` will execute `make clean` & remove every image
	- `make reset` will execute `make fclean` & remove the volume
	- `make re` will execute `make fclean` & `make` without removing the volume 

- After `make`, Nginx serves WordPress over HTTPS on `PORT` specified inside `.env`.
    - Use the `URL` you specified from `.env` to access the site.

### 3. Operations & Management

  - Once the stack is live, use these commands to monitor the health of the infrastructure.

    - Audit logs: docker-compose logs -f [service_name] (Use this first if a service fails to start).

    - Health Check: docker ps (Ensure all status columns show Up).

    - Internal Access: docker-compose exec [wordpress/mariadb] sh (To run CLI tools like wp-cli or mysql directly).
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

### 4. Data Persistence & Storage

   - The infrastructure is designed to be stateless in the container layer but persistent in the storage layer.
Storage Architecture

   - Location: Data is stored in Docker Volumes managed by the engine.

   - Persistence Logic: * docker-compose down does not delete your data.

        - The database state (MariaDB) and site uploads (WordPress) survive container restarts.

    - Inspection: To find the physical path on the host VM, use: docker volume inspect [volume_name]
