defmodule BillingProcessor.ErrorMessage do

  def for_wrong_type(field, value) do
    "Call record has a wrong #{field}: '#{value}'. Only 'start' and 'end' types are allowed."
  end

  def for_wrong_timestamp(field, value) do
    "Call record has a wrong #{field}: '#{value}'. The timestamp must have this format: YYYY-MM-DDThh:mm:ssZ"
  end

  def for_wrong_call_id(field, value) do
    "Call record has a wrong #{field}: '#{value}'. The call id must be integer"
  end

  def for_wrong_phone_number(field, value) do
    """
    Call record has a wrong #{field}: '#{value}'. 
    The phone number format is AAXXXXXXXXX, where AA is the area code and XXXXXXXXX is the phone number.
    The area code is always composed of two digits while the phone number can be composed of 8 or 9 digits.
    """
  end

end