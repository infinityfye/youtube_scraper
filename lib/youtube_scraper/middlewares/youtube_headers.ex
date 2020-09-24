defmodule YoutubeScraper.Middleware.YoutubeHeaders do
  @behaviour Crawly.Pipeline

  @impl Crawly.Pipeline
  def run(request, state, opts \\ []) do
    headers =
      opts ++ [{"X-YouTube-Client-Name", "1"}, {"X-YouTube-Client-Version", "2.20200912.06.00"}]

    {Map.put(request, :headers, request.headers ++ headers), state}
  end
end
