defmodule YoutubeScraper.MixProject do
  use Mix.Project

  def project do
    [
      app: :youtube_scraper,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {YoutubeScraper.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:crawly, "~> 0.10.0"},
      {:jason, "~> 1.2"},
      {:elixpath, "~> 0.1.0"}
    ]
  end
end
