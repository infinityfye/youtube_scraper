use Mix.Config

config :crawly,
  middlewares: [
    {Crawly.Middlewares.UserAgent, user_agents: ["VSCode - Rest Client extension"]},
    YoutubeScraper.Middleware.YoutubeHeaders
  ],
  pipelines: [
    Crawly.Pipelines.JSONEncoder,
    {Crawly.Pipelines.WriteToFile, folder: "./", extension: "jl"}
  ]
