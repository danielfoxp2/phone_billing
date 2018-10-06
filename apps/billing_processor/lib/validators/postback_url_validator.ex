defmodule BillingProcessor.PostbackUrlValidator do

  def is_valid?(nil), do: {:error, "The processing was not executed because postback url was not informed"}
  def is_valid?(""), do: {:error, "The processing was not executed because postback url was not informed"}
  def is_valid?(postback_url), do: {:ok, postback_url}

end