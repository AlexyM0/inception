# ----------- COMMANDES PRINCIPALES -----------

all:
	docker compose -f ./srcs/docker-compose.yml up -d --build

config:
	docker compose -f ./srcs/docker-compose.yml config

clean:
	docker compose -f ./srcs/docker-compose.yml down -v

fclean: clean
	@docker ps -qa | xargs -r docker stop || true
	@docker ps -qa | xargs -r docker rm || true
	@docker images -qa | xargs -r docker rmi -f || true
	@docker volume ls -q | xargs -r docker volume rm || true
	@docker network ls -q | grep -v "bridge\|host\|none" | xargs -r docker network rm || true


prune: clean
	docker system prune -f

re: fclean all

# ----------- COMMANDES BONUS UTILES -----------

status:
	docker ps -a

logs:
	docker compose -f ./srcs/docker-compose.yml logs -f

# ----------- POUR ÉVITER LES ERREURS MAKE -----------

.PHONY: all config clean fclean prune re status logs
