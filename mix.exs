defmodule ExOwm.Mixfile do
  use Mix.Project
  @github_url "https://github.com/Kociamber/ex_owm"

  def project do
    [
      app: :ex_owm,
      name: "ExOwm",
      version: "1.2.3",
      description: "OpenWeatherMap API Elixir client.",
      source_url: @github_url,
      homepage_url: @github_url,
      package: [
        maintainers: ["Rafał Kociszewski", "Joe Eifert"],
        licenses: ["MIT"],
        links: %{"GitHub" => @github_url}
      ],
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [
        main: "readme",
        extras: ["README.md"]
      ]
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
      {:httpoison, "~> 1.7"},
      {:jason, "~> 1.2"},
      {:nebulex, "~> 2.0"},
      {:shards, "~> 1.0"},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:credo, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end
end
