class ProductController < ApplicationController
  def index
    products = Product.includes(:category).order("RANDOM()").limit(100)

    results = products.map do |product|
      {
        product: product.name,
        price: product.price,
        description: product.description,
        category: product.category.name,
      }
    end

    render json: results
  end
end
