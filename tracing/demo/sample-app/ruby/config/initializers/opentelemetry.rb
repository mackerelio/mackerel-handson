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
