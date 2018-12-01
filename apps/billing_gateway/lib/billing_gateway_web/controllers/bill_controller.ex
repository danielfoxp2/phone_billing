defmodule BillingGatewayWeb.BillController do
  use BillingGatewayWeb, :controller

  alias BillingGateway.Bills

  action_fallback BillingGatewayWeb.FallbackController

  def calculate(conn, %{"bill_params" => bill_params}) do
    with {:ok, bill} <- Bills.calculate(bill_params) do
      conn
      |> render("show.json", bill: bill)
    end
  end
end