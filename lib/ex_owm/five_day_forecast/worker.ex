defmodule ExOwm.FiveDayForecast.Worker do
  @moduledoc """
  Five Day Forecast Worker task implementation.
  """
  alias ExOwm.Api
  alias ExOwm.Cache

  @doc """
  Returns five day weather forecast for a specific location and given options.
  Checks whether request has been already cached, if not it sends the request to
  OWM API and caches it with specific TTL.
  """
  @spec get_five_day_forecast(map, key: atom) :: map
  def get_five_day_forecast(location, opts) do
    ExOwm.WorkerHelper.get_from_cache_or_call("five_day_forecast: #{inspect(location)}", fn ->
      Api.send_and_parse_request(:get_five_day_forecast, location, opts)
    end)
  end
end
