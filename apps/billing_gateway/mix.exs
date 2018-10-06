defmodule BillingGateway.Mixfile do
  use Mix.Project

  def project do
    [
      app: :billing_gateway,
      version: "0.0.1",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      preferred_cli_env: ["white_bread.run": :test]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {BillingGateway.Application, []},
      extra_applications: [:billing_processor, :billing_repository, :logger, :runtime_tools, :httpoison]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.4"},
      {:phoenix_pubsub, "~> 1.0"},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:earmark, "~> 1.2", only: :dev},
      {:ex_doc, "~> 0.19", only: :dev},
      {:white_bread, "~> 4.1.1", only: [:dev, :test]},
      {:credo, "~> 0.10.0", only: [:dev, :test], runtime: false},
      {:httpoison, "~> 1.0"},
      {:billing_processor, in_umbrella: true},
      {:billing_repository, in_umbrella: true}
    ]
  end
end
