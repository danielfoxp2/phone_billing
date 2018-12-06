defmodule BillingGatewayWeb.CalculateBillFeature do
  use BillingGatewayWeb.ConnCase

  describe "Calculate bill" do
    
    test "It does not create the bill if there's no phone number informed", %{conn: conn} do
      params = %{"reference_period" => "12/2018"}

      conn = get(conn, bill_path(conn, :calculate), bill_params: params)
      error_message = "The bill calculation was not executed because phone number is invalid or not informed"
      expected_result = %{"reference_period" => "12/2018", "errors" => [error_message]} 

      assert json_response(conn, 200)["bill_creation_error"] == expected_result
    end

    test "It does not create the bill if the reference period is different of MM/AAAA", %{conn: conn} do
      params = %{"phone_number" => "6234679546", "reference_period" => "1/2018"}

      conn = get(conn, bill_path(conn, :calculate), bill_params: params)
      error_message = "The bill calculation was not executed because reference has not the valid format of MM/AAAA or has invalid month"
      expected_result = %{"phone_number" => "6234679546", "reference_period" => "1/2018", "errors" => [error_message]}

      assert json_response(conn, 200)["bill_creation_error"] == expected_result
    end
    
  end
end