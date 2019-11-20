.PHONY: reset kill up down cons irb

all: build

pre:
	rm -rvf Gemfile*
	echo "source 'https://rubygems.org'" > Gemfile
	echo "gem 'rails', '~>5'" >> Gemfile
	touch Gemfile.lock

build:
	docker-compose run app rails new . --api --force --no-deps --database=mysql
	sudo chown -R ${USER}:$(shell id -gn ${USER}) .
	mv database.yml config/
	docker-compose up --build --remove-orphans -d
	docker-compose run app rake db:create
	docker-compose down
	@echo 'YOUR PROJECT TEMPLATE HAS BEEN CREATED SUCCESSFULLY.'

reset:
	git clean -f -d -x

kill:
	docker-compose down --remove-orphans
	docker system prune --force
	docker image prune -a --force

up:
	docker-compose up

down:
	docker-compose down

cons:
	docker-compose run app bin/rails console

irb:
	docker-compose run app irb

shell:
	docker-compose run app bash

x:
	rm -rvf .* *
