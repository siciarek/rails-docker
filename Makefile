.PHONY: reset kill up down cons irb

all: pre build

pre:
	rm -rvf Gemfile*
	echo "source 'https://rubygems.org'" > Gemfile
	echo "gem 'rails', '~>5'" >> Gemfile
	touch Gemfile.lock

build:
	$(MAKE) pre
	docker-compose run web rails new . --force --no-deps --database=postgresql
	sudo chown -R ${USER}:$(shell id -gn ${USER}) .
	[ -d tmp/db ] || mkdir tmp/db
	sudo chmod -R 777 tmp/db/
	cp database.yml config/
	docker-compose build
	docker-compose up -d
	docker-compose run web rake db:create
	docker-compose down

reset:
	git clean -f -d -x

kill:
	docker system prune --force
	docker image prune -a --force

up:
	docker-compose up --build --remove-orphans

down:
	docker-compose down

cons:
	docker-compose run web bin/rails console

irb:
	docker-compose run web irb
