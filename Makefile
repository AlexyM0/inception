all:
		docker compose -f ./srcs/docker-compose.yml up -d --build

config:
		docker compose -f ./srcs/docker-compose.yml config

clean:
		docker compose -f ./srcs/docker-compose.yml down -v

fclean:
		make clean
		docker stop $(docker ps -qa); docker rm $(docker ps -qa); docker rmi -f $(docker images -qa); docker volume rm $(docker volume ls -q); docker network rm $(docker network ls -q) 2>/dev/null

prune:
		make clean
		docker system prune

re:
		make fclean
		make all

.PHONY: all config clean fclean prune re