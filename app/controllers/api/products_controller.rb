class Api::ProductsController < ApplicationController
  before_action :authenticate_admin, only: [:create, :update, :destroy]

  def index

    search_term = params[:search]
    discount = params[:discount]
    sort_attribute = params[:sort]
    sort_order = params[:sort_order]
    category_name = params[:category]

    @products = Product.all

    if category_name
      category = Category.find_by(name: category_name)
      @products = category.products
    end

    if search_term
      @products = @products.where("name iLIKE ?", "%#{search_term}%")
    end

    if discount == "true"
      @products = @products.where("price < ?", 60)
    end
    


    if sort_attribute == "price"
      @products = @products.order(:price)
    end


    render 'index.json.jbuilder'
  end

  def create
    if current_user && current_user.admin?
      @product = Product.new(
                            name: params[:name],
                            price: params[:price],
                            description: params[:description],
                            in_stock: params[:in_stock],
                            supplier_id: params[:supplier_id]
                            )
      if @product.save
        render 'show.json.jbuilder'
      else
        render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: {}, status: :unauthorized
    end
  end

  def show
    @product = Product.find(params[:id])
    render 'show.json.jbuilder'
  end

  def update
    @product = Product.find(params[:id])

    @product.name = params[:name] || @product.name
    @product.price = params[:price] || @product.price
    @product.image_url = params[:image_url] || @product.image_url
    @product.description = params[:description] || @product.description
    @product.in_stock = params[:in_stock] || @product.in_stock


    if @product.save
      render 'show.json.jbuilder'
    else
      render json: { message: @product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    render json: {message: "Successfully destroyed product #{@product.name} with id #{@product.id}"} 
  end
end
