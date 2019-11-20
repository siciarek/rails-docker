include Makefile

build:
	$(MAKE) pre
	docker-compose run app rails new . --api --skip-active-record --force --no-deps
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
