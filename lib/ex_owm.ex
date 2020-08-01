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
  def get_current_weather(locations, opts) when is_list(locations) do
    ExOwm.CurentWeather.Coordinator.get_weather(locations, opts)
  end

  def get_current_weather(location, opts) when is_bitstring(location) or is_map(location), do: get_current_weather([location], opts)

  @doc """
  Gets 5 day forecast data of the given location with specified options.

  ## Examples

      iex> ExOwm.get_five_day_forecast([%{city: "Warsaw"}, %{city: "London", country_code: "uk"}], units: :metric, lang: :pl)

  """
  @spec get_five_day_forecast(requests, options) :: map
  def get_five_day_forecast(locations, opts \\ []) when is_list(locations) do
    ExOwm.FiveDayForecast.Coordinator.get_weather(locations, opts)
  end

  @doc """
  Gets 1 to 16 days forecast data of the given location with specified options.

  ## Examples

      iex> ExOwm.get_sixteen_day_forecast([%{city: "Warsaw"}, %{city: "London", country_code: "uk"}], units: :metric, lang: :pl, cnt: 16)

  """
  @spec get_sixteen_day_forecast(requests, options) :: map
  def get_sixteen_day_forecast(locations, opts \\ []) when is_list(locations) do
    ExOwm.SixteenDayForecast.Coordinator.get_weather(locations, opts)
  end
end
