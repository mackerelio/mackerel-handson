class ProductController < ApplicationController
  def index
    products = Product.all.sample(100)

    # 改善1: product を 1 つオブジェクトにするたびに category を取得している N+1 問題を解決
    # https://railsguides.jp/active_record_querying.html#%E9%96%A2%E9%80%A3%E4%BB%98%E3%81%91%E3%82%92eager-loading%E3%81%99%E3%82%8B
    # products = Product.includes(:category).all.sample(100)

    # 改善2: product を取得した後に 100 件に絞っているが、これを SQL で一発で取得するようにする
    # https://railsguides.jp/active_record_querying.html#limit%E3%81%A8offset
    # products = Product.includes(:category).limit(100).order('RANDOM()')

    results = products.map do |product|
      {
        product: product.name,
        price: product.price,
        description: product.description,
        category: product.category.name,
      }
    end

    # 改善ポイント: 重い処理を行うメソッドが呼び出されている
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

        # 改善ポイント: エラーが発生する
        if n > 2
          raise "Sleep time is too long: #{n}"
        end
      end
    end
end
