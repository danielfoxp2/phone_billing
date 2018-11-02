defmodule BillingProcessor.ErrorMessage do

  def for_wrong("type" = field, value) do
    "Call record has a wrong #{field}: '#{value}'. Only 'start' and 'end' types are allowed."
  end

  def for_wrong("timestamp" = field, value) do
    "Call record has a wrong #{field}: '#{value}'. The timestamp must have this format: YYYY-MM-DDThh:mm:ssZ"
  end

  def for_wrong("call_id" = field, value) do
    "Call record has a wrong #{field}: '#{value}'. The call id must be integer"
  end

  def for_wrong(phone_number_field, value) do
    """
    Call record has a wrong #{phone_number_field}: '#{value}'. 
    The phone number format is AAXXXXXXXXX, where AA is the area code and XXXXXXXXX is the phone number.
    The area code is always composed of two digits while the phone number can be composed of 8 or 9 digits.
    """
  end

end