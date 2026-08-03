class ApplicationController < ActionController::API
  before_action :set_customer_id

  private

  def set_customer_id
    current_span = OpenTelemetry::Trace.current_span
    current_span.set_attribute('customer.id', params[:customer_id]) if current_span.recording?
  end
end
