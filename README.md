# Mailex

Simple wrapper around gen_smtp for sending emails.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add mailex to your list of dependencies in `mix.exs`:

        def deps do
          [{:mailex, "~> 0.0.1"}]
        end

  2. Ensure mailex is started before your application:

        def application do
          [applications: [:mailex]]
        end


To create an email:

    email = %Mailex.Email{
      from: %Mailex.Address{name: "Dejan Strbac", address: "me@dejanstrbac.com"},
      to: [%Mailex.Address{name: "Dejo", address: "dejan.strbac@gmail.com"}],
      subject: "Hi there",
      text: "Hello World",
      attachments: [Mailex.Attachment.inline!("test/data/logo.gif")]
     }


To render it:

    Mailex.Render.render(email)


To dump emails to console, just deliver without config:

    Mailex.deliver(email)


To use a smtp server, provide settings:


    Mailex.deliver(email, [
      relay:    "smtp.migadu.com",
      username: "USERNAME",
      password: "PASSWORD",
      port:      587,
      tls:      :always
      ssl:      true,
      auth:     :always
    ])
