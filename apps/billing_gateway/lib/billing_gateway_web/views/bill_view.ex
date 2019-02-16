defmodule BillingGatewayWeb.BillView do
  use BillingGatewayWeb, :view
  
  @moduledoc false
  
  def render("show.json", %{bill: bill}) do
    %{bill: bill}
  end

end