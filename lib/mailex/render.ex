defmodule Mailex.Render do

  alias Mailex.Address

  def render(email) do
    mimemail_args = []
    if email.text, do:
      mimemail_args = [ { :plain, email.text } | mimemail_args]
    if email.html, do:
      mimemail_args = [ { :html, email.html } | mimemail_args]
    if email.attachments, do:
      mimemail_args = [ Enum.map(email.attachments, fn(a) -> { :attachment, a.data, a } end) | mimemail_args ]

    mimemail_args |> List.flatten |> to_tuple(email) |> :mimemail.encode
  end


  def to_tuple(part, _email) when is_tuple(part) do
    {
      mime_type_for(part),
      mime_subtype_for(part),
      [],
      parameters_for(part),
      elem(part, 1)
    }
  end


  def to_tuple(parts, email) when is_list(parts) do
    {
      mime_type_for(parts),
      mime_subtype_for(parts),
      headers_for(email),
      [],
      Enum.map(parts, &to_tuple(&1, email))
    }
  end


  def parameters_for({:attachment, _body, attachment}) do
    [
      { "transfer-encoding", "base64" },
      content_type_params_for(attachment),
      disposition_for(attachment),
      disposition_params_for(attachment)
    ]
  end


  def parameters_for(_part) do
    [
      { "transfer-encoding", "quoted-printable" },
      { "content-type-params", [] },
      { "disposition", "inline" },
      { "disposition-params", [] }
    ]
  end


  def content_type_params_for(attachment) do
    { "content-type-params", [{ "name", attachment.filename }] }
  end


  def disposition_for(_attachment) do
    { "disposition", "attachment" }
  end


  def disposition_params_for(attachment) do
    { "disposition-params", [{ "filename", attachment.filename }] }
  end


  def mime_type_for(parts) when is_list(parts) do
    "multipart"
  end


  def mime_type_for({_type, _}) do
    "text"
  end


  def mime_type_for({_, _, attachment}) do
    elem(attachment.type, 0)
  end


  def mime_subtype_for(parts) when is_list(parts) do
    if Enum.find parts, fn(part) -> elem(part, 0) == :attachment end do
      "mixed"
    else
      "alternative"
    end
  end


  def mime_subtype_for({type, _}) do
    type
  end


  def mime_subtype_for({_, _, attachment}) do
    elem(attachment.type, 1)
  end


  def headers_for(email) do
    headers = []

    if email.reply_to && (length(email.reply_to) > 0), do:
      headers = [ { "Reply-To", email.reply_to |> stringify_addresses } ]

    if email.bcc && (length(email.bcc) > 0), do:
      headers = [ { "Bcc", email.bcc |> stringify_addresses } | headers ]

    if email.cc && (length(email.cc) > 0), do:
      headers = [ { "Cc", email.cc |> stringify_addresses } | headers ]

    if email.to && (length(email.to) > 0), do:
      headers = [ { "To", email.to |> stringify_addresses } | headers ]

    if email.headers && (length(email.headers) > 0), do:
      headers = headers ++ email.headers

    [ { "From",    email.from |> stringify_addresses },
      { "Subject", email.subject || "" }  | headers ]
  end


  def stringify_addresses(nil), do: ""
  def stringify_addresses([]),  do: ""

  def stringify_addresses(addresses) do
    addresses = addresses |> Address.rfc_822_format
    if is_list(addresses) do
      Enum.join(addresses, ", ")
    else
      addresses
    end
  end


end