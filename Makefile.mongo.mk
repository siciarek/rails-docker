include Makefile.mk

build:
	docker-compose run app rails new . --api --skip-active-record --force --no-deps
	echo "gem 'mongoid', '~> 6.0'" >> Gemfile
	echo "gem 'bson_ext'" >> Gemfile
	sudo chown -R ${USER}:$(shell id -gn ${USER}) .
	mv mongoid.yml config/
	rm database.yml
	docker-compose up --build --remove-orphans -d
	docker-compose down
	docker-compose run app bin/rails g scaffold article name:string content:text
	@echo 'YOUR MongoDB PROJECT TEMPLATE HAS BEEN CREATED SUCCESSFULLY.'
