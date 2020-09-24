defmodule YoutubeScraper.VideosFast do
  use Crawly.Spider

  @impl Crawly.Spider
  def base_url(), do: "https://www.youtube.com"

  @impl Crawly.Spider
  def init(),
    do: [start_urls: ["https://www.youtube.com/channel/UCYogOW28QIQdfvfY5KyzDsw/videos?pbj=1"]]

  @impl Crawly.Spider
  def parse_item(response) do
    body = Jason.decode!(response.body)
    items = get_items(body)
    requests = get_requests(response.request.url, body)
    %Crawly.ParsedItem{:items => items, :requests => requests}
  end

  @impl Crawly.Spider
  def override_settings() do
    [
      concurrent_requests_per_domain: 16,
      closespider_itemcount: 1000,
      closespider_timeout: 50,
      middlewares: [
        {Crawly.Middlewares.UserAgent,
         user_agents: ["Gordon Freeman", "Duke Nukem", "Link", "Max Payne", "Master Chief"]},
        YoutubeScraper.Middleware.YoutubeHeaders
      ]
    ]
  end

  defp get_items(body) do
    {:ok, video_ids} = Elixpath.query(body, "..gridVideoRenderer.videoId")
    {:ok, durations} = Elixpath.query(body, "..gridVideoRenderer..thumbnailOverlays..simpleText")
    {:ok, titles} = Elixpath.query(body, "..gridVideoRenderer..title..text")

    for {id, duration, title} <- Enum.zip([video_ids, durations, titles]),
        do: %{
          id: id,
          title: title,
          duration: duration
        }
  end

  defp get_requests(_url, body) do
    {:ok, continuation} = Elixpath.query(body, "..continuation")

    Enum.map(continuation, fn cont ->
      Crawly.Utils.build_absolute_url(
        "/browse_ajax?continuation=#{cont}&pbj=1",
        "https://www.youtube.com"
      )
      |> Crawly.Utils.request_from_url()
    end)
  end
end
