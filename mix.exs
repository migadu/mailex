defmodule Mailex.Mixfile do
  use Mix.Project

  def project do
    [app: :mailex,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [ applications: [:ssl, :crypto, :eiconv, :gen_smtp]]
  end

  defp deps do
    [
      { :eiconv, github: "zotonic/eiconv" },
      { :gen_smtp, ">= 0.9.0" }
    ]
  end
end
