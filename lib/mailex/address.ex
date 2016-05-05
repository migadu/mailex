defmodule Mailex.Address do
  defstruct name: nil, address: nil


  def rfc_822_format(emails) when is_list(emails), do:
    emails |> Enum.map(&rfc_822_format(&1))


  def rfc_822_format(email) when is_map(email) do
    email_address = Map.get(email, "address", Map.get(email, :address))
    email_name = email
      |> Map.get("name", Map.get(email, :name))
      |> prepare_name(email_address)
    "#{email_name} <#{email_address}>"
  end


  defp prepare_name(email_name, address) do
    if email_name do
      email_name = String.strip(email_name)
    else
      email_name = address |>
        String.split("@") |>
        List.first |>
        String.split(~r/([^\w\s]|_)/) |>
        Enum.map(&String.capitalize/1) |>
        Enum.join(" ")
    end
    if String.match?(email_name, ~r/[\(\)\<\>\@\,\;\:\"\.\[\]\\]/) do
      "\"\\\"" <> String.replace(email_name, "\"", "\\\"") <> "\\\"\""
    else
      email_name
    end
  end


  def envelope_format(emails) when is_list(emails), do:
    emails |> Enum.map(&envelope_format(&1))


  def envelope_format(email) when is_map(email) do
    email_address = Map.get(email, "address", Map.get(email, :address))
    "<#{email_address}>"
  end


end
