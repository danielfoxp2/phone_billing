defmodule BillingGatewayWeb do
  
  @moduledoc false

  def controller do
    quote do
      use Phoenix.Controller, namespace: BillingGatewayWeb
      import Plug.Conn
      import BillingGatewayWeb.Router.Helpers
      import BillingGatewayWeb.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/billing_gateway_web/templates",
                        namespace: BillingGatewayWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 2, view_module: 1]

      import BillingGatewayWeb.Router.Helpers
      import BillingGatewayWeb.ErrorHelpers
      import BillingGatewayWeb.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import BillingGatewayWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
