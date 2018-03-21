defmodule ExOwm.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ex_owm,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ExOwm.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.0"},
      {:poison, "~> 3.1"},
      {:nebulex, "~> 1.0.0-rc.3"},
      {:ex_doc, "~> 0.18", only: :dev, runtime: false}
    ]
  end
end
