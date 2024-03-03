defmodule ExOwm.CurrentWeather.Worker do
  @moduledoc """
  Current Weather Worker task implementation.
  """
  alias ExOwm.Api
  alias ExOwm.Cache

  @doc """
  Returns current weather for a specific location and given options.
  Checks whether request has been already cached, if not it sends the request to
  OWM API and caches it with specific TTL.
  """
  @spec get_current_weather(map, key: atom) :: map
  def get_current_weather(location, opts) do
    ExOwm.WorkerHelper.get_from_cache_or_call("current_weather: #{inspect(location)}", fn ->
      Api.send_and_parse_request(:get_current_weather, location, opts)
    end)
  end
end
