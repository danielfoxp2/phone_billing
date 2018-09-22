defmodule BillingGatewayWeb.Router do
  use BillingGatewayWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BillingGatewayWeb do
    pipe_through :api
  end
end
