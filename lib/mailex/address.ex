defmodule Mailex.Address do
  defstruct name: nil, address: nil


  def rfc_822_format(emails) when is_list(emails), do:
    emails |> Enum.map(&rfc_822_format(&1))


  def rfc_822_format(email) when is_map(email) do
    email_address = Map.get(email, "address", Map.get(email, :address))
    email_name = Map.get(email, "name", Map.get(email, :name))

    if email_name do
      "#{email_name} <#{email_address}>"
    else
      name = email_address |>
        String.split("@") |>
        List.first |>
        String.split(~r/([^\w\s]|_)/) |>
        Enum.map(&String.capitalize/1) |>
        Enum.join(" ")
      "#{name} <#{email_address}>"
    end
  end


  def envelope_format(emails) when is_list(emails), do:
    emails |> Enum.map(&envelope_format(&1))


  def envelope_format(email) when is_map(email) do
    email_address = Map.get(email, "address", Map.get(email, :address))
    "<#{email_address}>"
  end


end