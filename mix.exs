defmodule Bf.MixProject do
  use Mix.Project

  @app :bf
  @version "0.1.0"

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      preferred_cli_env: ["quality.ci": :ci],
      consolidate_protocols: not (Mix.env() in [:dev, :test]),
      compilers: compilers(Mix.env()),
      elixirc_paths: elixirc_paths(Mix.env()),
      xref: [exclude: []],
      description: description(),
      package: package(),
      deps: deps(),
      aliases: aliases(),
      docs: docs(),
      releases: [
        {@app,
         [
           include_executables_for: [:unix],
           applications: [logger: :permanent]
         ]}
      ],
      dialyzer: [
        plt_file: {:no_warn, ".dialyzer/dialyzer.plt"},
        plt_add_deps: :transitive,
        plt_add_apps: [:mix],
        list_unused_filters: true,
        ignore_warnings: ".dialyzer/ignore.exs"
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Bf.App, []}
    ]
  end

  defp deps do
    [
      {:tarearbol, "~> 1.2"},
      # dev/test/ci
      {:boundary, "~> 0.4", runtime: false},
      {:credo, "~> 1.0", only: [:dev, :ci], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :ci], runtime: false},
      {:ex_doc, "~> 0.11", only: [:dev], runtime: false}
    ]
  end

  defp aliases do
    [
      "quality.ci": [
        "format --check-formatted",
        "credo --strict",
        "dialyzer"
      ]
    ]
  end

  defp description do
    """
    Brainfuck implementation in Elixir on Processes.

    This is a fun project.
    """
  end

  defp package do
    [
      name: @app,
      files: ~w|lib .formatter.exs .dialyzer/ignore.exs mix.exs README* LICENSE|,
      maintainers: ["Aleksei Matiushkin"],
      licenses: ["Kantox LTD"],
      links: %{
        "GitHub" => "https://github.com/am-kantox/#{@app}",
        "Docs" => "https://hexdocs.pm/#{@app}"
      }
    ]
  end

  defp docs do
    [
      main: "getting-started",
      source_ref: "v#{@version}",
      canonical: "http://hexdocs.pm/#{@app}",
      logo: "stuff/#{@app}-48x48.png",
      source_url: "https://github.com/am-kantox/#{@app}",
      assets: "stuff/images",
      extras: ~w[stuff/getting-started.md],
      groups_for_modules: []
    ]
  end

  defp elixirc_paths(:dev), do: ["lib", "test/support"]
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp compilers(:prod), do: Mix.compilers()
  defp compilers(_), do: [:boundary | Mix.compilers()]
end
