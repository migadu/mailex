defmodule Mailex.Address do
  defstruct name: nil, address: nil


  def rfc_822_format(emails) when is_list(emails), do:
    emails |> Enum.map(&rfc_822_format(&1))


  def rfc_822_format(email) when is_map(email) do
    if email.name do
      "#{email.name} <#{email.address}>"
    else
      name = email.address |>
        String.split("@") |>
        List.first |>
        String.split(~r/([^\w\s]|_)/) |>
        Enum.map(&String.capitalize/1) |>
        Enum.join " "
      "#{name} <#{email.address}>"
    end
  end


  def envelope_format(emails) when is_list(emails), do:
    emails |> Enum.map(&envelope_format(&1))


  def envelope_format(email) when is_map(email), do:
    "<#{email.address}>"


end