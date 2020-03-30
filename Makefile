include .env

all: | up install

up:
	echo "Setting up the containers"
	docker-compose up -d
	
down:
	echo "Stopping containers"
	docker-compose down

install:
	echo "Install Drupal 8 & dependencies"
	docker-compose exec -T php bash -c "composer install"
	sleep 30
	docker-compose exec -T php bash -c "drush si --config-dir=../config/default --db-url=mysql://${PROFILE_NAME}:${PROFILE_NAME}@mariadb/${PROFILE_NAME} --verbose"
	docker-compose exec -T php bash -c "drush user:password admin ${ADMIN_PASS}"
	
remove:
	echo "Removing containers and volumes"
	docker-compose down -v

shell:
	docker-compose exec php bash
	