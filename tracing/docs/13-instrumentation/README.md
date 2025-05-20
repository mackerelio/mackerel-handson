# トレースを用いてWebアプリケーションを改善してみよう 〜OpenTelemetryによる計装

Rubyライブラリを用いた計装をしていきましょう。OpenTelemetryによって、テレメトリーデータの計装、収集、エクスポートなどの仕様や概念については標準化されていますが、実装ライブラリに関しては各言語の特性や流儀に合わせた実装になっており、様々な違いがあります。

> [!NOTE]
> OpenTelemetryは日々開発が進んでおり、言語によって各テレメトリーシグナルへの対応状況も異なります。
> - [Language APIs & SDKs | OpenTelemetry](https://opentelemetry.io/docs/languages/)

Rubyでは、よく用いられるフレームワークやライブラリにあわせて計装用のライブラリが用意されており、またそれらをまとめて有効にできる工夫がなされています。

以下がOpenTelemetryによるシグナルの計装や送信の準備をする部分です。このコードを[Railsのイニシャライザファイル](https://railsguides.jp/configuring.html#%E3%82%A4%E3%83%8B%E3%82%B7%E3%83%A3%E3%83%A9%E3%82%A4%E3%82%B6%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%82%92%E4%BD%BF%E3%81%86)として配置し読み込むだけで、計装ライブラリが用意されている処理に関しては計装が完了してしまいます。中身を見ていきましょう。

- [計装の設定ファイル: `config/initializers/opentelemetry.rb`](../../demo/sample-app/ruby/config/initializers/opentelemetry.rb)

```ruby
require 'opentelemetry/sdk'
require 'opentelemetry/exporter/otlp'
require 'opentelemetry/instrumentation/all'

if defined?(Rails::Server)
  OpenTelemetry::SDK.configure do |c|
    c.service_name = 'sample-app'
    c.use_all({
      'OpenTelemetry::Instrumentation::Mysql2' => { obfuscation_limit: 10000 },
    })
  end
end
```

## SDKとして用意されているライブラリによる自動計装

`OpenTelemetry::SDK.configure`では計装や送信のための処理が初期化されます。OpenTelemetryの標準で定められたデフォルト設定が用意されているため、この部分はとても簡潔になっています。内部ではトレースやスパンを生成するためのトレーサープロバイダーとトレーサー、シグナルを送信するためのクライアントやエクスポーターなどが初期化されています。

- [Using instrumentation libraries | OpenTelemetry](https://opentelemetry.io/docs/languages/ruby/libraries/)

> [!NOTE]
> SDKやCollectorのデフォルト値、設定用の環境変数などは以下のページにまとまっています。
> - [General SDK Configuration | OpenTelemetry](https://opentelemetry.io/docs/languages/sdk-configuration/general/)
> - [OTLP Exporter Configuration | OpenTelemetry](https://opentelemetry.io/docs/languages/sdk-configuration/otlp-exporter/)

opentelemetry-exporter-otlpを読み込むことでotlpというプロトコルでシグナルを送信します。送信先もまた、OpenTelemetryの標準で定められたデフォルト値が設定されています。

opentelemetry-instrumentation-allを読み込み、コード内で`c.use_all`と設定することで、RubyのSDKで用意されている計装ライブラリが全て読み込まれます。有効となる計装対象は以下に列挙されています。

- [opentelemetry-instrumentation-all | RubyGems.org | コミュニティのgemホスティングサービス](https://rubygems.org/gems/opentelemetry-instrumentation-all)

`service_name`はテレメトリデータを生成したアプリケーションやサービスを一意に特定するためにつけられる名前です。実際には`service.name`という属性名が用いられ、OpenTelemetryではこのように操作やデータの共通の名前が
[セマンティック規約](https://opentelemetry.io/ja/docs/concepts/semantic-conventions/)として定められています。

## スパンを作るコードを書くことによる手動計装

アプリケーションを開発していると、ライブラリが用意されている部分以外の計装もしたくなるでしょう。その場合はSDKを用いてスパンを作り計装することができます。

以下はあるメソッドの処理を計装する例です。`in_span`メソッドのブロックの中身が1つのスパンとして記録されます。`set_attribute`メソッドによってスパンに属性を設定しています。また、`in_span`メソッドの内部で例外を発生させることにより、スパンにエラーと例外が設定されます。

- [手動計装の例: `app/controllers/product_controller.rb`](../../demo/sample-app/ruby/app/controllers/product_controller.rb)

```ruby
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
```

これらのコードによって実際にどのようにトレースやスパンが可視化されるかを見ていきましょう。

[→「トレースを用いてWebアプリケーションを改善してみよう 〜Mackerelでトレースを確認しよう」へ進む](../14-mackerel-tracing/README.md)
