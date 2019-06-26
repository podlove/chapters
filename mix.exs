defmodule Chapters.MixProject do
  use Mix.Project

  @version "0.1.1"
  @url "https://github.com/podlove/chapters"

  def project do
    [
      app: :chapters,
      version: @version,
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),

      # Docs
      name: "Chapters",
      source_url: @url,
      docs: [
        # The main page in the docs
        main: "Chapters",
        extras: ["README.md"]
      ]
    ]
  end

  defp description() do
    "Podcast chapter parser and formatter. Supports xml/psc, mp4chaps and json."
  end

  defp package() do
    [
      licenses: ["MIT"],
      maintainers: ["Eric Teubert"],
      links: %{"GitHub" => @url}
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
      {:sweet_xml, "~> 0.6.6"},
      {:xml_builder, "~> 2.1"},
      {:nimble_parsec, "~> 0.5.0"},
      {:jason, "~> 1.1"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end
end
