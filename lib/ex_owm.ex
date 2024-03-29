defmodule ExOwm do
  require Logger

  @moduledoc """
  ExOwm, OpenWeatherMap API Elixir client.
  This module contains main public interface of the application.
  """

  @typedoc """
  Current weather data API request.
  """
  @type request ::
          %{city: String.t()}
          | %{city: String.t(), country_code: String.t()}
          | %{id: integer()}
          | %{lat: float(), lon: float()}
          | %{lat: float(), lon: float(), dt: integer()}
          | %{zip: String.t(), country_code: String.t()}

  @typedoc """
  Current weather data API requests.
  """
  @type requests :: [request]

  @typedoc """
  Current weather data API call options corresponding to OWM APIs described in
  official docs: http://openweathermap.org/api

  The output of the request can be specified according to below options.
  """
  @type option :: :format | :units | :lang | :cnt | :like | :accurate | :mode | :cnt

  @typedoc """
  Keyword list of options.
  """
  @type options :: [option: term]

  @doc """
  Gets weather data of the given location with specified options.

  ## Examples

      iex> ExOwm.get_current_weather([%{city: "Warsaw"}, %{city: "London", country_code: "uk"}], units: :metric, lang: :pl)

  """
  @spec get_current_weather(requests, options) :: map
  def get_current_weather(loc, opts \\ [])

  def get_current_weather(locations, opts) when is_list(locations),
    do: ExOwm.CurrentWeather.Coordinator.get_weather(locations, opts)

  def get_current_weather(location, opts) when is_map(location),
    do: get_current_weather([location], opts)

  @doc """
  Gets weather data of the given location with specified options.

  ## Examples

      iex> ExOwm.get_weather([%{lat: 52.374031, lon: 4.88969}], units: :metric, lang: :pl)

  """
  @spec get_weather(requests, options) :: map
  def get_weather(loc, opts \\ [])

  def get_weather(locations, opts) when is_list(locations),
    do: ExOwm.Weather.Coordinator.get_weather(locations, opts)

  def get_weather(location, opts) when is_map(location),
    do: get_weather([location], opts)

  @doc """
  Gets 5 day forecast data of the given location with specified options.

  ## Examples

      iex> ExOwm.get_five_day_forecast([%{city: "Warsaw"}, %{city: "London", country_code: "uk"}], units: :metric, lang: :pl)

  """
  @spec get_five_day_forecast(requests, options) :: map
  def get_five_day_forecast(locations, opts \\ [])

  def get_five_day_forecast(locations, opts) when is_list(locations),
    do: ExOwm.FiveDayForecast.Coordinator.get_weather(locations, opts)

  def get_five_day_forecast(location, opts) when is_map(location),
    do: get_five_day_forecast([location], opts)

  @doc """
  Gets 4 day hourly forecast data of the given location with specified options.

  ## Examples

      iex> ExOwm.get_hourly_forecast([%{city: "Warsaw"}, %{city: "London", country_code: "uk"}], units: :metric, lang: :pl)
  """
  @spec get_hourly_forecast(requests, options) :: map
  def get_hourly_forecast(locations, opts \\ [])

  def get_hourly_forecast(locations, opts) when is_list(locations),
    do: ExOwm.HourlyForecast.Coordinator.get_weather(locations, opts)

  def get_hourly_forecast(location, opts) when is_map(location),
    do: get_hourly_forecast([location], opts)

  @doc """
  Gets 1 to 16 days forecast data of the given location with specified options.

  ## Examples

      iex> ExOwm.get_sixteen_day_forecast([%{city: "Warsaw"}, %{city: "London", country_code: "uk"}], units: :metric, lang: :pl, cnt: 16)

  """
  @spec get_sixteen_day_forecast(requests, options) :: map
  def get_sixteen_day_forecast(locations, opts \\ [])

  def get_sixteen_day_forecast(locations, opts) when is_list(locations),
    do: ExOwm.SixteenDayForecast.Coordinator.get_weather(locations, opts)

  def get_sixteen_day_forecast(location, opts) when is_map(location),
    do: get_sixteen_day_forecast([location], opts)

  @doc """
  Gets historical weather data of the given location with specified options.
  dt should be within the last 5 days.

  ## Examples

      iex> ExOwm.get_historical_weather([%{lat: 52.374031, lon: 4.88969, dt: 1615546800}], units: :metric, lang: :pl)

  """
  @spec get_historical_weather(requests, options) :: map
  def get_historical_weather(loc, opts \\ [])

  def get_historical_weather(locations, opts) when is_list(locations),
    do: ExOwm.HistoricalWeather.Coordinator.get_weather(locations, opts)

  def get_historical_weather(location, opts) when is_map(location),
    do: get_historical_weather([location], opts)
end
