defmodule BillingGatewayWeb.TaxesView do
  use BillingGatewayWeb, :view

  def render("show.json", %{response_message: response_message}) do
    %{response_message: response_message}
  end

end