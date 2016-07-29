defmodule Mailex.Address do
  defstruct name: nil, address: nil

  def rfc_822_format(emails) when is_list(emails), do:
     Enum.map(emails, &rfc_822_format(&1))

  def rfc_822_format(email) when is_map(email) do
    email_address = Map.get(email, "address", Map.get(email, :address))
    email_name = email
      |> Map.get("name", Map.get(email, :name))
      |> prepare_name(email_address)
    "#{email_name} <#{email_address}>"
  end

  def envelope_format(emails) when is_list(emails), do:
    Enum.map(emails, &envelope_format(&1))

  def envelope_format(email) when is_map(email), do:
    "<#{Map.get(email, "address", Map.get(email, :address))}>"

  defp prepare_name(email_name, address) do
    email_name = case email_name do
      nil -> address
        |> String.split("@")
        |> List.first
        |> String.split(~r/([^\w\s]|_)/)
        |> Enum.map(&String.capitalize/1)
        |> Enum.join(" ")
      _ -> String.strip(email_name)
    end
    if String.match?(email_name, ~r/[\(\)\<\>\@\,\;\:\"\.\[\]\\]/) do
      "\"\\\"" <> String.replace(email_name, "\"", "\\\"") <> "\\\"\""
    else
      email_name
    end
  end

end
