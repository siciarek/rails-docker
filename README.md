# Rails REST API

## Init

```bash
curl http://siciarek.pl/it/rails-docker/setup.sh | bash
```


## Create sample model `Product`

```bash
docker-compose run -e RAILS_ENV=development app bin/rails g model Product rank:integer name:string description:text
docker-compose run -e RAILS_ENV=development app bin/rails db:migrate
```

## Create Routing

```ruby
# config/routes.rb
Rails.application.routes.draw do
  resources :product
end
```

Check it

```bash
docker-compose run -e RAILS_ENV=development app bin/rails routes
```

Sample output:

```bash
MacBook-Pro-Jacek:rails-rest-api jsiciarek$ docker-compose run -e RAILS_ENV=development app bin/rails routes
Starting rails-rest-api_db_1 ... done
                   Prefix Verb   URI Pattern                                                                              Controller#Action
            product_index GET    /product(.:format)                                                                       product#index
                          POST   /product(.:format)                                                                       product#create
                  product GET    /product/:id(.:format)                                                                   product#show
                          PATCH  /product/:id(.:format)                                                                   product#update
                          PUT    /product/:id(.:format)                                                                   product#update
                          DELETE /product/:id(.:format)                                                                   product#destroy
       rails_service_blob GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
rails_blob_representation GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
       rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
     rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create
```

## Create API Controller

```bash
docker-compose run -e RAILS_ENV=development app bin/rails g controller Product
```

Update abstract controller

```ruby
# app/controllers/application_controller.rb

class ApplicationController < ActionController::API
  before_action :set_list, only: [:index]
  before_action :set_item, only: [:show, :update, :destroy]

  # GET /product
  def index
    render json: @list
  end

  # GET /product/:id
  def show
    render json: @item
  end

  # POST /product
  def create
    render json: create_item
  end

  # PUT /product/:id
  def update
    @item.update(item_params)
    head :no_content
  end

  # DELETE /product/:id
  def destroy
    @item.destroy
    head :no_content
  end

  def item_params
    params.permit(self.definition[:fields])
  end

  private

  def create_item
    self.definition[:model].create!(item_params)
  end

  def set_list
    @list = self.definition[:model].all
  end

  def set_item
    @item = self.definition[:model].find_by!(id: params[:id])
  end
end

```

Update specific controller

```ruby
# app/controllers/product_controller.rb

class ProductController < ApplicationController
  def definition
    {
      :model => Product,
      :fields => [
        :name,
        :rank,
        :description,
      ]
    }.freeze
  end
end

```
