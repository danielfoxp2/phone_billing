defmodule BillingProcessor.TaxesReferenceValidatorTest do
  use ExUnit.Case
  alias BillingProcessor.TaxesReferenceValidator

  describe "the validation of new taxes insertion when doesn't exists the same reference persisted" do
    test "should validate the insertion for informed reference" do
      reference_from_database = nil
      taxes_params = %{"reference_period" => "11/2018"}
      validate_response = TaxesReferenceValidator.validate(reference_from_database, taxes_params)
      error_value = Map.get(validate_response, "errors")

      assert error_value == nil
    end
  end

  describe "the validation of new taxes insertion when exists the same reference persisted" do
    test "should validate if the persisted reference is equal then current reference" do
      reference_from_database = get_current_reference_as_db_integer()
      taxes_params = %{"reference_period" => get_current_reference_informed_by_user()}
      validate_response = TaxesReferenceValidator.validate(reference_from_database, taxes_params)
      error_value = Map.get(validate_response, "errors")

      assert error_value == nil
    end

    test "should validate if the persisted reference is greater then current reference" do
      reference_from_database = get_next_reference_based_on_current_month_as_db_integer()
      taxes_params = %{"reference_period" => get_next_reference_based_on_current_month_informed_by_user()}
      validate_response = TaxesReferenceValidator.validate(reference_from_database, taxes_params)
      error_value = Map.get(validate_response, "errors")

      assert error_value == nil
    end

    test "should invalidate if the persisted reference is lower then current reference" do
      reference_from_database = get_previous_reference_based_on_current_month_as_db_integer()
      taxes_params = %{"reference_period" => get_previous_reference_based_on_current_month_informed_by_user()}
      validate_response = TaxesReferenceValidator.validate(reference_from_database, taxes_params)
      error_value = Map.get(validate_response, "errors")

      assert error_value == ["It is not allowed the update of taxes before the current reference"]
    end
  end

  defp get_previous_reference_based_on_current_month_as_db_integer() do
    previous_month = get_previous_reference_based_on_current_month()
    {previous_reference, _} = Integer.parse("#{previous_month.year}#{String.pad_leading("#{previous_month.month}", 2, "0")}")
    previous_reference
  end
  
  defp get_previous_reference_based_on_current_month_informed_by_user() do
    previous_month = get_previous_reference_based_on_current_month()
    "#{previous_month.month}/#{previous_month.year}"
  end

  defp get_previous_reference_based_on_current_month() do
    actual_date = Date.utc_today()
    previous_date = Date.add(actual_date, -31)
    previous_date
  end

  defp get_next_reference_based_on_current_month_as_db_integer() do
    next_month = get_next_reference_based_on_current_month()
    {next_reference, _} = Integer.parse("#{next_month.year}#{String.pad_leading("#{next_month.month}", 2, "0")}")
    next_reference
  end
  
  defp get_next_reference_based_on_current_month_informed_by_user() do
    next_month = get_next_reference_based_on_current_month()
    "#{next_month.month}/#{next_month.year}"
  end

  defp get_current_reference_as_db_integer() do
    today = Date.utc_today()
    {current_reference, _} = Integer.parse("#{today.year}#{String.pad_leading("#{today.month}", 2, "0")}")
    current_reference
  end

  defp get_current_reference_informed_by_user() do
    today = Date.utc_today()
    "#{today.month}/#{today.year}"
  end

  defp get_next_reference_based_on_current_month() do
    actual_date = Date.utc_today()
    next_date = Date.add(actual_date, 31)
  end

end