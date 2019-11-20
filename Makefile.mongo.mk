.PHONY: reset kill up down cons irb

all: build

pre:
	rm -rvf Gemfile*
	echo "source 'https://rubygems.org'" > Gemfile
	echo "gem 'rails', '~>5'" >> Gemfile
	touch Gemfile.lock

build:
	$(MAKE) pre
	docker-compose run app rails new . --api --skip-active-record --force --no-deps --database=mysql
	echo "gem 'mongoid', '~> 6.0'" >> Gemfile
	echo "gem 'bson_ext'" >> Gemfile
	sudo chown -R ${USER}:$(shell id -gn ${USER}) .
	mv database.yml config/
	docker-compose up --build --remove-orphans -d
	docker-compose run app bin/rails db:create
	docker-compose down
	docker-compose run app bin/rails g mongoid:config
	docker-compose run app bin/rails g scaffold article name:string content:text
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
