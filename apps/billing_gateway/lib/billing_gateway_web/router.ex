defmodule BillingGatewayWeb.Router do
  use BillingGatewayWeb, :router
  
  @moduledoc false
  
  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BillingGatewayWeb do
    pipe_through :api

    post "/call_records", CallRecordController, :create
    get "/bill", BillController, :calculate
    post "/taxes", TaxesController, :create
  end
end
