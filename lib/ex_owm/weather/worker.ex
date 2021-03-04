defmodule ExOwm.Weather.Worker do
  @moduledoc """
  Current Weather Worker task implementation.
  """
  alias ExOwm.Api
  alias ExOwm.CurrentWeather.Cache

  @doc """
  Returns current weather for a specific location and given options.
  Checks whether request has been already cached, if not it sends the request to
  OWM API and caches it with specific TTL.
  """
  @spec get_weather(map, key: atom) :: map
  def get_weather(location, opts) do
    case Cache.get(location) do
      # If location wasn't cached within last 10 minutes, call OWM API
      nil ->
        result = Api.send_and_parse_request(:get_weather, location, opts)
        Cache.set(location, result, ttl: :infinity)

      # If location was cached, return it
      location ->
        location
    end
  end
end
