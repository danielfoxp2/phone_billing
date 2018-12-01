defmodule BillingGatewayWeb.ErrorView do
  use BillingGatewayWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  def render("200.json", %{postback_url_error_message: error_message}) do
    %{postback_url_error: error_message}
  end

  def render("200.json", %{missing_bill_phone_number_message: error_message}) do
    %{missing_bill_phone_number: error_message}
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
