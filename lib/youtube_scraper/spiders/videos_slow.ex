defmodule YoutubeScraper.VideosSlow do
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
    {:ok, video_details} = Elixpath.query(body, "..videoDetails")
    {:ok, video_microformat} = Elixpath.query(body, "..playerMicroformatRenderer")

    if length(video_details) > 0 do
      [details] = video_details
      [more_details] = video_microformat

      [
        %{
          id: details["videoId"],
          title: details["title"],
          description: details["shortDescription"],
          duration: details["lengthSeconds"],
          keywords: details["keywords"],
          is_crawlable: details["isCrawlable"],
          use_cipher: details["useCipher"],
          average_rating: details["averageRating"],
          view_count: details["viewCount"],
          is_private: details["isPrivate"],
          is_unplugged_corpus: details["isUnpluggedCorpus"],
          is_live_content: details["isLiveContent"],
          upload_date: more_details["uploadDate"],
          publish_date: more_details["publishDate"],
          is_family_safe: more_details["isFamilySafe"],
          is_unlisted: more_details["isUnlisted"],
          category: more_details["category"]
        }
      ]
    else
      []
    end
  end

  defp get_requests(url, body) do
    {:ok, video_ids} = Elixpath.query(body, "..gridVideoRenderer.videoId")

    {:ok, continuation} =
      unless String.match?(url, ~r/watch/) do
        Elixpath.query(body, "..continuation")
      else
        {:ok, []}
      end

    Enum.map(video_ids, fn id ->
      Crawly.Utils.build_absolute_url(
        "/watch?v=#{id}&pbj=1",
        "https://www.youtube.com"
      )
      |> Crawly.Utils.request_from_url()
    end) ++
      Enum.map(continuation, fn cont ->
        Crawly.Utils.build_absolute_url(
          "/browse_ajax?continuation=#{cont}&pbj=1",
          "https://www.youtube.com"
        )
        |> Crawly.Utils.request_from_url()
      end)
  end
end
