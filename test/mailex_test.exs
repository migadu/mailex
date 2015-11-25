defmodule MailexTest do
  use ExUnit.Case
  doctest Mailex

  defp email_minimal do
    %Mailex.Email{
      from: %Mailex.Address{ address: "test_a@gmail.com" },
      to:   [%Mailex.Address{ address: "test_b@gmail.com" }]
    }
  end

  defp email_with_reply_to do
    %Mailex.Email{
      from:     %Mailex.Address{ address: "test_a@gmail.com" },
      to:       [%Mailex.Address{ address: "test_b@gmail.com" }],
      reply_to: [%Mailex.Address{ address: "test_aa@gmail.com" }, %Mailex.Address{ address: "test_a@gmx.com" }],
      subject:  "You've got mail",
      text:     "Hello World!"
    }
  end

  defp email_without_attachments do
    %Mailex.Email{
      from:    %Mailex.Address{ name: "Yankee", address: "test_a@gmail.com" },
      to:      [%Mailex.Address{ address: "test_c@gmail.com" }],
      subject: "You've got mail",
      text:    "Hello World!"
    }
  end

  defp email_with_attachments do
    %Mailex.Email{
      from:        %Mailex.Address{ name: "Yankee", address: "test_a@gmail.com" },
      to:          [%Mailex.Address{ address: "test_c@gmail.com" }],
      subject:     "You've got mail",
      text:        "Hello World",
      attachments: [Mailex.Attachment.inline!("test/data/logo.gif")]
    }
  end

  test "Messages render" do
    assert email_minimal |> Mailex.Render.render
    assert email_with_reply_to |> Mailex.Render.render
    assert email_without_attachments |> Mailex.Render.render
    assert email_with_attachments |> Mailex.Render.render
  end

end
