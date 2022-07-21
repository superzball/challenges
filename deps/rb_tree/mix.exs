defmodule RedBlackTree.MixProject do
  use Mix.Project

  def project do
    [
      app: :rb_tree,
      version: "1.0.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "RedBlackTree",
      description: "Module for creating and managing red-black trees",
      # Docs
      source_url: "https://github.com/herbstrith/rb_tree",
      homepage_url: "https://github.com/herbstrith/rb_tree",
      package: [
        maintainers: ["Vinicius Herbstrith"],
        licenses: ["MIT"],
        links: %{
          "GitHub" => "https://github.com/herbstrith/rb_tree",
        },
        files: ~w(mix.exs lib LICENSE.md README.md CHANGELOG.md)
      ],
      docs: [
        main: "RedBlackTree", # The main page in the docs
        extras: ["README.md", "CHANGELOG.md"]
      ],
      test_coverage: [tool: ExCoveralls]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:credo, "~> 0.8", only: [:dev, :test]},
      {:excoveralls, "~> 0.10", only: :test},
    ]
  end
end
