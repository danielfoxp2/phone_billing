defmodule BillingGatewayWeb.TaxesController do
  use BillingGatewayWeb, :controller

  alias BillingGateway.Taxes

  action_fallback BillingGatewayWeb.FallbackController

  @moduledoc """
    Represent the entry point of taxes insertion API
  """

  @doc """
    Represent the entry point of taxes insertion API
  """

  def create(conn, %{"taxes_params" => taxes_params}) do
    with {:ok, response_message} <- Taxes.create(taxes_params) do
      conn
      |> render("show.json", response_message: response_message)
    end
  end
end