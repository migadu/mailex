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
    from    = email.from |> Mailex.Address.envelope_format
    to      = email.to |> Mailex.Address.envelope_format

    if Keyword.get(config, :relay) do
      envelope = { from, to, message }
      case :gen_smtp_client.send_blocking(envelope, config) do
        { :error, msg } -> { :error, msg }
                    msg -> { :ok, msg }
      end
    else
      IO.puts "\n\n[[[ Mailex ]]]\n\nFROM: #{from}\nTO: #{to}\n\nRAW START -------------\n#{message}\nRAW END -------------\n\n"
      {:ok, "message dumped to console"}
    end
  end

end