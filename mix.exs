defmodule ExOwm.Mixfile do
  use Mix.Project
  @github_url "https://github.com/Kociamber/ex_owm"

  def project do
    [
      app: :ex_owm,
      name: "ExOwm",
      version: "2.0.0",
      elixir: "~> 1.17",
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
        extras: ["README.md", "CHANGELOG.md", "UPGRADE.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :runtime_tools],
      mod: {ExOwm.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:bypass, "~> 2.1", only: :test},
      {:credo, "~> 1.7.15", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false},
      {:jason, "~> 1.4"},
      {:mox, "~> 1.0", only: :test},
      {:nebulex, "~> 2.6"},
      {:req, "~> 0.5"},
      {:shards, "~> 1.1"},
      {:telemetry, "~> 1.0"}
    ]
  end
end
