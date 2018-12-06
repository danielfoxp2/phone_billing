defmodule BillingGatewayWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use BillingGatewayWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(BillingGatewayWeb.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(BillingGatewayWeb.ErrorView, :"404")
  end

  def call(conn, {:postback_url_error, error_message}) do
    conn
    |> render(BillingGatewayWeb.ErrorView, :"200", postback_url_error_message: error_message)
  end

  def call(conn, {:bill_creation_error, bill_params}) do
    conn
    |> render(BillingGatewayWeb.ErrorView, :"200", bill_creation_error: bill_params)
  end

end
