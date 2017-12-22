defmodule ExOwm.Worker do
  alias ExOwm.Api
  alias ExOwm.Cache

  def get_current_weather(location, opts) do
    case Cache.get(location) do
      # If location wasn't cached within last 10 minutes, call OWM API
      nil ->
        result = Api.send_and_parse_request(:get_current_weather, location, opts)
        Cache.set(location, result, ttl: 10)
      # If location was cached within last 10 minutes, return it
      location ->
        location
    end
  end
end
