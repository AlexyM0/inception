# ----------- COMMANDES PRINCIPALES -----------
all:
	docker compose -f ./srcs/docker-compose.yml up -d --build

config:
	docker compose -f ./srcs/docker-compose.yml config

clean:
	docker compose -f ./srcs/docker-compose.yml down -v
	@sudo rm -rf /home/alexy/data/mariadb/* /home/alexy/data/mariadb/.* 2>/dev/null || true
	@sudo rm -rf /home/alexy/data/wordpress/* /home/alexy/data/wordpress/.* 2>/dev/null || true
fclean: clean
	@docker ps -qa | xargs -r docker stop || true
	@docker ps -qa | xargs -r docker rm || true
	@docker images -qa | xargs -r docker rmi -f || true
	@docker volume ls -q | xargs -r docker volume rm || true
	@docker network ls -q | grep -v "bridge\|host\|none" | xargs -r docker network rm || true
	@docker system prune -a -f

re: fclean all

# ----------- POUR ÉVITER LES ERREURS MAKE -----------

.PHONY: all config clean fclean prune re status logs