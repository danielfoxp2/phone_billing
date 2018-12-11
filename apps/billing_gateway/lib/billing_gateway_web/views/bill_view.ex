defmodule BillingGatewayWeb.BillView do
  use BillingGatewayWeb, :view

  def render("show.json", %{bill: bill}) do
    %{bill: bill}
  end

end