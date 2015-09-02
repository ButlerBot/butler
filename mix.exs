defmodule Butler.Mixfile do
  use Mix.Project

  def project do
    [app: :butler,
     description: "A simple elixir robot to help you get things done",
     version: "0.0.1",
     elixir: "~> 1.0",
     escript: [main_module: Butler],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
      applications: [ :logger, :httpoison ],
      mod: {Butler, {adapter, plugins}}
    ]
  end

  def adapter do
    Butler.Adapters.Console
  end

  def plugins do
    [
      {Butler.Plugins.Cowsay, []},
      {Butler.Plugins.TestCount, []}
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:poison, "~> 1.4.0"},
      {:httpoison, "~> 0.7"},
      {:websocket_client, git: "http://github.com/jeremyong/websocket_client"}
    ]
  end

  defp package do
    [contributors: ["Chris Keathley"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/butlerbot/butler"}]
  end
end
