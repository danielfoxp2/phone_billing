defmodule BillingGatewayWeb.CalculateBillFeature do
  use BillingGatewayWeb.ConnCase

  describe "Calculate bill" do
    
    test "It does not create the bill if there's no phone number informed", %{conn: conn} do
      params = %{"reference" => "12/2018"}

      conn = get(conn, bill_path(conn, :calculate), bill_params: params)
      expected_message = "The bill calculation was not executed because phone number was not informed"

      assert json_response(conn, 200)["missing_bill_phone_number"] == expected_message
    end
    
  end
end