defmodule ExOwm.Feature.Worker do
  alias ExOwm.Feature.ApiCaller
  alias ExOwm.Cache

  def run(location, opts) do
    case Cache.get(location) do
      # If location wasn't cached within last 10 minutes, call OWM API
      nil ->
        result = ApiCaller.send_and_parse_request(location, opts)
        Cache.set(location, result, ttl: 10)
      # If location was cached within last 10 minutes, return it
      location ->
        location
    end
  end
end
