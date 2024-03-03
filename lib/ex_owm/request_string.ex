defmodule ExOwm.RequestString do
  @moduledoc """
  Request string creation.
  """

  # 5 day forecast is available at any location or city.
  # It includes weather data every 3 hours. Forecast is available in JSON or XML format.

  @doc """
  Builds request string basing on provided params.
  """
  @spec build(atom, map, key: :atom) :: String.t()
  def build(api_call_type, location, opts) do
    {api_call_type, location, opts}
    |> add_prefix_substring()
    |> add_location_substring()
    |> add_search_accuracy_substring()
    |> add_format_substring()
    |> add_units_substring()
    |> add_day_count()
    |> add_language_substring()
    |> add_api_key_substring()
  end

  # One call weather call.
  defp add_prefix_substring({:get_weather, location, opts}),
    do: {"api.openweathermap.org/data/2.5/onecall", location, opts}

  # Current weather call.
  defp add_prefix_substring({:get_current_weather, location, opts}),
    do: {"api.openweathermap.org/data/2.5/weather", location, opts}

  # Five day forecast call.
  defp add_prefix_substring({:get_five_day_forecast, location, opts}),
    do: {"api.openweathermap.org/data/2.5/forecast", location, opts}

  # Four day hourly forecast call. https://openweathermap.org/api/hourly-forecast
  defp add_prefix_substring({:get_hourly_forecast, location, opts}),
    do: {"pro.openweathermap.org/data/2.5/forecast/hourly", location, opts}

  # Sixteen day forecast call.
  defp add_prefix_substring({:get_sixteen_day_forecast, location, opts}),
    do: {"api.openweathermap.org/data/2.5/forecast/daily", location, opts}

  # History call.
  defp add_prefix_substring({:get_historical_weather, location, opts}),
    do: {"api.openweathermap.org/data/2.5/onecall/timemachine", location, opts}

  # Call by city name and ISO 3166 country code.
  defp add_location_substring({string, %{city: city, country_code: country_code}, opts}),
    do: {string <> "?q=#{city},#{country_code}", opts}

  # Call by city name.
  defp add_location_substring({string, %{city: city}, opts}),
    do: {string <> "?q=#{city}", opts}

  # Call by city id.
  defp add_location_substring({string, %{id: id}, opts}),
    do: {string <> "?id=#{id}", opts}

  # Call by geo coordinates with datetime string
  defp add_location_substring({string, %{lat: lat, lon: lon, dt: dt}, opts}),
    do: {string <> "?lat=#{lat}&lon=#{lon}&dt=#{dt}", opts}

  # Call by geo coordinates
  defp add_location_substring({string, %{lat: lat, lon: lon}, opts}),
    do: {string <> "?lat=#{lat}&lon=#{lon}", opts}

  # Call by zip and ISO 3166 country code.
  defp add_location_substring({string, %{zip: zip, country_code: country_code}, opts}),
    do: {string <> "?zip=#{zip},#{country_code}", opts}

  defp add_search_accuracy_substring({string, opts}) do
    case Keyword.get(opts, :type) do
      :like -> {string <> "&type=like", opts}
      :accurate -> {string <> "&type=accurate", opts}
      _ -> {string, opts}
    end
  end

  # Add format type to a query string. Lack of this part make api to return default
  # JSON format answer.
  defp add_format_substring({string, opts}) do
    case Keyword.get(opts, :mode) do
      :xml -> {string <> "&mode=xml", opts}
      _ -> {string, opts}
    end
  end

  # Add temperature type to a query string. Lack of this part make api to return default
  # temperature in Kelvins.
  defp add_units_substring({string, opts}) do
    case Keyword.get(opts, :units) do
      :metric -> {string <> "&units=metric", opts}
      :imperial -> {string <> "&units=imperial", opts}
      _ -> {string, opts}
    end
  end

  # Add day count for 1 to 16 day forecast.
  defp add_day_count({string, opts}) do
    case Keyword.get(opts, :cnt) do
      nil -> {string, opts}
      cnt -> {string <> "&cnt=#{cnt}", opts}
    end
  end

  # Add language code parameter. API call will return data with description field
  # in selected language. List of available languages can be found here:
  # http://openweathermap.org/forecast16#multi
  defp add_language_substring({string, opts}) do
    case Keyword.has_key?(opts, :lang) do
      true ->
        lang =
          Keyword.get(opts, :lang)
          |> Atom.to_string()

        string <> "&lang=#{lang}"

      false ->
        string
    end
  end

  # Add API key.
  defp add_api_key_substring(string),
    do: string <> "&APPID=#{Application.get_env(:ex_owm, :api_key)}"
end
