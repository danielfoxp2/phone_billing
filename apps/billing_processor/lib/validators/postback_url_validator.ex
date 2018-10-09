defmodule BillingProcessor.PostbackUrlValidator do

  @postback_url_not_exist_message "The processing was not executed because postback url was not informed"

  def is_valid?(nil), do: {:postback_url_error, @postback_url_not_exist_message}
  def is_valid?(""), do: {:postback_url_error, @postback_url_not_exist_message}
  def is_valid?(postback_url), do: {:ok, postback_url}
end