include Makefile.mk

build:
	docker-compose run app rails new . --api --force --no-deps --database=mysql
	echo "gem 'mongoid', '~> 6.0'" >> Gemfile
	echo "gem 'bson_ext'" >> Gemfile
	sudo chown -R ${USER}:$(shell id -gn ${USER}) .
	mv database.yml mongoid.yml config/
	docker-compose up --build --remove-orphans -d
	docker-compose down
	docker-compose run app bin/rails g scaffold author first_name:string last_name:string
	docker-compose run app bin/rails g scaffold article name:string content:text
	@echo 'YOUR MongoDB PROJECT TEMPLATE HAS BEEN CREATED SUCCESSFULLY.'
