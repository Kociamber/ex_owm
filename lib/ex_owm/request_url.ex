defmodule ExOwm.RequestURL do
  @moduledoc """
  Module responsible for building request URLs for OpenWeatherMap API calls.

  Uses URI structs to construct proper HTTPS URLs with query parameters.
  """

  alias ExOwm.Location

  @api_hosts %{
    regular: "api.openweathermap.org",
    pro: "pro.openweathermap.org"
  }

  @api_paths %{
    get_weather: {:regular, "/data/2.5/onecall"},
    get_current_weather: {:regular, "/data/2.5/weather"},
    get_five_day_forecast: {:regular, "/data/2.5/forecast"},
    get_hourly_forecast: {:pro, "/data/2.5/forecast/hourly"},
    get_sixteen_day_forecast: {:regular, "/data/2.5/forecast/daily"},
    get_historical_weather: {:regular, "/data/2.5/onecall/timemachine"},
    get_air_pollution: {:regular, "/data/2.5/air_pollution"},
    get_air_pollution_forecast: {:regular, "/data/2.5/air_pollution/forecast"},
    get_air_pollution_history: {:regular, "/data/2.5/air_pollution/history"},
    geocode_direct: {:regular, "/geo/1.0/direct"},
    geocode_reverse: {:regular, "/geo/1.0/reverse"}
  }

  @doc """
  Builds a complete HTTPS request URL for the OpenWeatherMap API.

  ## Parameters

    - `api_call_type` (atom): The type of API call (e.g., `:get_weather`, `:get_current_weather`).
    - `location` (%ExOwm.Location{}): The location struct.
    - `opts` (keyword list): Optional parameters (e.g., type, mode, units, cnt, lang).

  ## Returns

    - (String.t()): The constructed HTTPS request URL.

  ## Examples

      iex> location = ExOwm.Location.by_city("Warsaw")
      iex> ExOwm.RequestURL.build_url(:get_current_weather, location, units: :metric)
      "https://api.openweathermap.org/data/2.5/weather?q=Warsaw&units=metric&APPID=..."

  """
  @spec build_url(atom, Location.t(), keyword) :: String.t()
  def build_url(api_call_type, %Location{} = location, opts) do
    {host_type, path} = @api_paths[api_call_type]
    host = @api_hosts[host_type]
    query_params = build_query_params(location, opts)

    %URI{
      scheme: "https",
      host: host,
      path: path,
      query: URI.encode_query(query_params)
    }
    |> URI.to_string()
  end

  defp build_query_params(location, opts) do
    []
    |> add_location_params(location)
    |> add_optional_params(opts)
    |> add_api_key()
  end

  defp add_location_params(params, %Location{type: :city, city: city, country: nil}),
    do: [{"q", city} | params]

  defp add_location_params(params, %Location{type: :city, city: city, country: country}),
    do: [{"q", "#{city},#{country}"} | params]

  defp add_location_params(params, %Location{type: :id, id: id}),
    do: [{"id", id} | params]

  defp add_location_params(params, %Location{type: :coords, lat: lat, lon: lon, dt: nil}),
    do: [{"lat", lat}, {"lon", lon} | params]

  defp add_location_params(params, %Location{type: :coords, lat: lat, lon: lon, dt: dt}),
    do: [{"lat", lat}, {"lon", lon}, {"dt", dt} | params]

  defp add_location_params(params, %Location{type: :zip, zip: zip, country: country}),
    do: [{"zip", "#{zip},#{country}"} | params]

  defp add_location_params(params, %Location{type: :geocode_query}),
    do: params

  defp add_optional_params(params, opts) do
    params
    |> add_optional_param(opts, :type, &map_type/1)
    |> add_optional_param(opts, :mode, &map_mode/1)
    |> add_optional_param(opts, :units, &map_units/1)
    |> add_optional_param(opts, :cnt, &to_string/1)
    |> add_optional_param(opts, :lang, &to_string/1)
    |> add_optional_param(opts, :limit, &to_string/1)
    |> add_optional_param(opts, :q, &to_string/1)
    |> add_optional_param(opts, :start, &to_string/1)
    |> add_optional_param(opts, :end, &to_string/1)
  end

  defp add_optional_param(params, opts, key, mapper) do
    case Keyword.get(opts, key) do
      nil -> params
      value -> [{to_string(key), mapper.(value)} | params]
    end
  end

  defp map_type(:like), do: "like"
  defp map_type(:accurate), do: "accurate"

  defp map_mode(:xml), do: "xml"

  defp map_units(:metric), do: "metric"
  defp map_units(:imperial), do: "imperial"

  defp add_api_key(params) do
    [{"APPID", Application.get_env(:ex_owm, :api_key)} | params]
  end
end
