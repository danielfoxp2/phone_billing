defmodule BillingProcessor.ErrorMessage do

  @moduledoc false
  
  def for_wrong({:structure, field}, _value), do: "call record don't have #{field}"
  
  def for_wrong({:duplicated_in_database, field}, value), do:  "call record with #{field}: #{value} already exists in database"
  def for_wrong({:duplicated_in_list_being_inserted, field}, value), do:  "call record with #{field}: #{value} is duplicated in call records being inserted"
  def for_wrong({:pair_is_not_valid, _field}, call_id_value) do
    "Inconsistent call for call_id '#{call_id_value}'. A call is a composition of two record types, 'start' and 'end', with the same call id."
  end

  def for_wrong("type" = field, value) do
    "#{call_record_has_a_wrong(field, value)}. Only 'start' and 'end' types are allowed."
  end

  def for_wrong("timestamp" = field, value) do
    "#{call_record_has_a_wrong(field, value)}. The timestamp must have this format: YYYY-MM-DDThh:mm:ssZ"
  end

  def for_wrong("call_id" = field, value) do
    "#{call_record_has_a_wrong(field, value)}. The call id must be integer."
  end

  def for_wrong(phone_number_field, with_this_value) do
    """
    #{call_record_has_a_wrong(phone_number_field, with_this_value)}. 
    The phone number format is AAXXXXXXXXX, where AA is the area code and XXXXXXXXX is the phone number.
    The area code is always composed of two digits while the phone number can be composed of 8 or 9 digits.
    """
  end

  defp call_record_has_a_wrong(field, with_this_value) do
    "Call record has a wrong #{field}: '#{with_this_value}'"
  end

  

end