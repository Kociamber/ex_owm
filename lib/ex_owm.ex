defmodule ExOwm do
  alias ExOwm.Coordinator
  require Logger
  @moduledoc """
  Documentation for ExOwm, OpenWeatherMap API Elixir client.
  """

  @typedoc """
  Current weather data API request.
  """
  @type request ::
    %{city: String.t} | %{city: String.t, country_code: String.t} |
    %{id: integer()} |
    %{lat: float(), lon: float()} |
    %{zip: String.t, country_code: String.t}

  @typedoc """
  Current weather data API requests.
  """
  @type requests :: [request]

  @typedoc """
  Current weather data API call available options.
  """
  @type option :: :format | :units | :lang

  @typedoc """
  Keyword list of options
  """
  @type options :: [option: term]

  @doc """
  Gets weather data of the given location with specified options.

  ## Examples

      iex> is_list ExOwm.get_current_weather([%{city: "Warsaw"}, %{city: "London", country_code: "uk"}], units: :metric, lang: :pl)
      true
      iex> is_list ExOwm.get_current_weather([%{id: 2759794}], units: :metric, lang: :nl)
      true

  """
  @spec get_current_weather(requests, options) :: map
  def get_current_weather(locations, opts \\ []) when is_list(locations) do
    Coordinator.start_workers(:get_current_weather, locations, opts)
    Coordinator.get_state()
  end

  @doc """
  Gets 5 day forecast data of the given location with specified options.

  ## Examples

      iex> is_list ExOwm.get_five_day_forecast([%{city: "Warsaw"}, %{city: "London", country_code: "uk"}], units: :metric, lang: :pl)
      true
      iex> is_list ExOwm.get_five_day_forecast([%{id: 2759794}], units: :metric, lang: :nl)
      true


  """
  @spec get_five_day_forecast(requests, options) :: map
  def get_five_day_forecast(locations, opts \\ []) when is_list(locations) do
    Coordinator.start_workers(:get_five_day_forecast, locations, opts)
    Coordinator.get_state()
  end
end
