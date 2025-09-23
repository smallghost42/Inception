DC = docker compose
PATH_FILE = ./srcs/docker-compose.yml

all:
	$(DC) -f $(PATH_FILE) up -d --build

clean:
	$(DC) -f $(PATH_FILE) down

fclean: clean
	$(DC) -f $(PATH_FILE) down --rmi all
remove:
	rm -rf /home/ferafano/data
	mkdir -p /home/ferafano/data/mariadb/
	mkdir -p /home/ferafano/data/wordpress
re: fclean all
