class ProductController < ApplicationController
  def index
    products = Product.includes(:category).all.sample(100)

    results = products.map do |product|
      {
        product: product.name,
        price: product.price,
        description: product.description,
        category: product.category.name,
      }
    end

    (1..3).each do |n|
      method_sample(n)
    end

    render json: results
  end

  private
    def method_sample(n = 10)
      OpenTelemetry.tracer_provider.tracer('product_controller').in_span(
        'method_sample',
        kind: :server
      ) do |span|
        sleep(n)
        span.set_attribute(OpenTelemetry::SemanticConventions::Trace::CODE_FUNCTION, __method__.to_s)
        span.set_attribute('sleep.time', n)
      end
    end
end
