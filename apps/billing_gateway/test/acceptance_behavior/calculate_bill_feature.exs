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

    test "Should create the bill for closed period" , %{conn: conn} do
      params = %{"phone_number" => "62984680648", "reference_period" => "11/2018"}

      conn = get(conn, bill_path(conn, :calculate), bill_params: params)
      expected_result = mount_bill()
      
      assert json_response(conn, 200)["bill"] == expected_result
    end
    
  end

  defp mount_bill() do
    %{
      "phone_number" => "62984680648", 
      "reference_period" => "11/2018",
      "bill" => %{
			    "bill_total" => "R$ 3,24",
          "bill_details" => [
            %{
              "destination" => 6298457834,
					    "call_start_date" => "23-11-2018",
					    "call_start_time" => "21:57:13",
					    "call_duration" => "0h20m40s",
					    "call_price" => "R$ 0,54"
            },
            %{
              "destination" => 6298457877,
					    "call_start_date" => "25-11-2018",
					    "call_start_time" => "15:45:23",
					    "call_duration" => "0h22m42s",
					    "call_price" => "R$ 2,34"
            },
            %{
              "destination" => 6298457877,
              "call_start_date" => "31-10-2018",
              "call_start_time" => "23:50:00",
              "call_duration" => "0h18m05s",
              "call_price" => "R$ 0,36"
            }
          ]
      }
    }
  end
end