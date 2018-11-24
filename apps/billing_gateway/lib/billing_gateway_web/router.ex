defmodule BillingGatewayWeb.Router do
  use BillingGatewayWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BillingGatewayWeb do
    pipe_through :api

    resources "/call_records", CallRecordController, except: [:new, :edit]
    get "/dummy_postback_url", DummyPostbackUrlController, :show
    post "/dummy_postback_url", DummyPostbackUrlController, :create
  end
end
