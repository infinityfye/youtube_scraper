defmodule YoutubeScraperTest do
  use ExUnit.Case
  doctest YoutubeScraper

  test "greets the world" do
    assert YoutubeScraper.hello() == :world
  end
end
