DO = docker
CM = compose
CO = container

PATH_FILE = ./srcs/docker-compose.yml

all:
	$(DO) $(CM) -f $(PATH_FILE) up -d --build

clean:
	$(DO) $(CM) -f $(PATH_FILE) down -v
	$(DO) $(CO) prune -f

fclean: clean
	$(DO) rmi -f nginx:ng wordpress:wp mariadb:mb
	$(DO) rmi -f alpine:3.22

reset: fclean
	rm -rf /home/ferafano/data
	mkdir -p /home/ferafano/data/mariadb/
	mkdir -p /home/ferafano/data/wordpress

reload: reset all

re: fclean all
