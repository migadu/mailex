defmodule Mailex do

  @config_defaults [
    relay:    nil,
    username: "",
    password: "",
    port:     25,
    ssl:      false,
    tls:      :never,
    auth:     :always
  ]

  def deliver(email, config \\ []) do
    config = Keyword.merge(@config_defaults, config || [])

    message = email |> Mailex.Render.render
    envelope_from = email.from |> Mailex.Address.envelope_format
    envelope_to = (email.to ++ (email.cc || []) ++ (email.bcc || [])) |> Mailex.Address.envelope_format

    if Keyword.get(config, :relay) do
      envelope = { envelope_from, envelope_to, message }
      IO.puts "\n[[ Mailex ]] ${inspect(envelope)}"
      case :gen_smtp_client.send_blocking(envelope, config) do
        { :error, msg } -> IO.puts "\n\nERROR sending message"; IO.inspect(envelope); { :error, msg }
                    msg -> { :ok, msg }
      end
    else
      IO.puts "\n\n[[[ Mailex ]]]\n\nFROM: #{envelope_from}\nTO: #{envelope_to}\n\nRAW START -------------\n#{message}\nRAW END -------------\n\n"
      {:ok, "message dumped to console"}
    end
  end

end
