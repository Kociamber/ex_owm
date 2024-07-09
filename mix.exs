defmodule ExOwm.Mixfile do
  use Mix.Project
  @github_url "https://github.com/Kociamber/ex_owm"

  def project do
    [
      app: :ex_owm,
      name: "ExOwm",
      version: "1.3.0",
      description: "OpenWeatherMap API Elixir client.",
      source_url: @github_url,
      homepage_url: @github_url,
      package: [
        maintainers: ["Rafał Kociszewski", "Joe Eifert"],
        licenses: ["MIT"],
        links: %{"GitHub" => @github_url}
      ],
      dialyzer: [
        plt_file: {:no_warn, "priv/plts/project.plt"},
        format: :dialyxir,
        paths: ["_build/dev/lib/ex_owm/ebin"]
      ],
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
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false},
      {:httpoison, "~> 2.0"},
      {:jason, "~> 1.4"},
      {:nebulex, "~> 2.6"},
      {:shards, "~> 1.1"}
    ]
  end
end
