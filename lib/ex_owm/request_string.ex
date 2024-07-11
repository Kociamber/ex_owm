defmodule ExOwm.RequestString do
  @moduledoc """
  Module responsible for creating request strings for OpenWeatherMap API calls.
  It supports various API endpoints and allows for dynamic construction
  of query strings based on provided parameters.
  """

  @api_endpoints %{
    get_weather: "api.openweathermap.org/data/2.5/onecall",
    get_current_weather: "api.openweathermap.org/data/2.5/weather",
    get_five_day_forecast: "api.openweathermap.org/data/2.5/forecast",
    get_hourly_forecast: "pro.openweathermap.org/data/2.5/forecast/hourly",
    get_sixteen_day_forecast: "api.openweathermap.org/data/2.5/forecast/daily",
    get_historical_weather: "api.openweathermap.org/data/2.5/onecall/timemachine"
  }

  @doc """
  Builds request string based on provided params.

  ## Parameters

    - `api_call_type` (atom): The type of API call (e.g., `:get_weather`, `:get_current_weather`).
    - `location` (map): The location parameters (e.g., city, coordinates, zip code).
    - `opts` (keyword list): Optional parameters (e.g., type, mode, units, cnt, lang).

  ## Returns

    - (String.t()): The constructed request string.
  """
  @spec build(atom, map, keyword) :: String.t()
  def build(api_call_type, location, opts) do
    api_call_type
    |> add_prefix_substring()
    |> add_location_substring(location)
    |> add_search_accuracy_substring(opts)
    |> add_format_substring(opts)
    |> add_units_substring(opts)
    |> add_day_count(opts)
    |> add_language_substring(opts)
    |> add_api_key_substring()
  end

  defp add_prefix_substring(api_call_type) do
    @api_endpoints[api_call_type]
  end

  defp add_location_substring(base_url, %{city: city, country_code: country_code}),
    do: "#{base_url}?q=#{city},#{country_code}"

  defp add_location_substring(base_url, %{city: city}),
    do: "#{base_url}?q=#{city}"

  defp add_location_substring(base_url, %{id: id}),
    do: "#{base_url}?id=#{id}"

  defp add_location_substring(base_url, %{lat: lat, lon: lon, dt: dt}),
    do: "#{base_url}?lat=#{lat}&lon=#{lon}&dt=#{dt}"

  defp add_location_substring(base_url, %{lat: lat, lon: lon}),
    do: "#{base_url}?lat=#{lat}&lon=#{lon}"

  defp add_location_substring(base_url, %{zip: zip, country_code: country_code}),
    do: "#{base_url}?zip=#{zip},#{country_code}"

  defp add_search_accuracy_substring(url, opts) do
    case Keyword.get(opts, :type) do
      :like -> "#{url}&type=like"
      :accurate -> "#{url}&type=accurate"
      _ -> url
    end
  end

  defp add_format_substring(url, opts) do
    case Keyword.get(opts, :mode) do
      :xml -> "#{url}&mode=xml"
      _ -> url
    end
  end

  defp add_units_substring(url, opts) do
    case Keyword.get(opts, :units) do
      :metric -> "#{url}&units=metric"
      :imperial -> "#{url}&units=imperial"
      _ -> url
    end
  end

  defp add_day_count(url, opts) do
    case Keyword.get(opts, :cnt) do
      nil -> url
      cnt -> "#{url}&cnt=#{cnt}"
    end
  end

  defp add_language_substring(url, opts) do
    case Keyword.get(opts, :lang) do
      nil -> url
      lang -> "#{url}&lang=#{Atom.to_string(lang)}"
    end
  end

  defp add_api_key_substring(url),
    do: "#{url}&APPID=#{Application.get_env(:ex_owm, :api_key)}"
end
