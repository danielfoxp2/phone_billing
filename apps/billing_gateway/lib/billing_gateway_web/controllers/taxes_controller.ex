defmodule BillingGatewayWeb.TaxesController do
  use BillingGatewayWeb, :controller

  alias BillingGateway.Taxes

  action_fallback BillingGatewayWeb.FallbackController

  def create(conn, %{"taxes_params" => taxes_params}) do
    with {:ok, response_message} <- Taxes.create(taxes_params) do
      conn
      |> render("show.json", response_message: response_message)
    end
  end
end