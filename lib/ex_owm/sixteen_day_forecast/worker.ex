defmodule ExOwm.SixteenDayForecast.Worker do
  @moduledoc """
  Sixteen Day Forecast Worker task implementation.
  """
  alias ExOwm.{Api, WorkerHelper}

  @doc """
  Returns sixteen day weather forecast for a specific location and given options.
  Checks whether request has been already cached, if not it sends the request to
  OWM API and caches it with specific TTL.
  """
  @spec get_sixteen_day_forecast(map, key: atom) ::
          {:ok, map()} | {:error, map()} | {:error, map(), map()}
  def get_sixteen_day_forecast(location, opts) do
    WorkerHelper.get_from_cache_or_call("sixteen_day_forecast: #{inspect(location)}", fn ->
      Api.send_and_parse_request(:get_sixteen_day_forecast, location, opts)
    end)
  end
end
