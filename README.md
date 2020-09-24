# YoutubeScraper

**TODO: Add description**

## Getting started

Install dependencies

```
mix deps.get
```

open up `iex` and start one of the spiders

```
iex -S mix # OR
iex --werl -S mix # if you are on windows
```

Once it starts you can start either of the engines:

1. Slow: `Crawly.Engine.start_spider YoutubeScraper.VideosSlow`
2. Fast: `Crawly.Engine.start_spider YoutubeScraper.VideosFast`

A JSON formatted `.jl` file will be spewd in the root or the project with the results.
