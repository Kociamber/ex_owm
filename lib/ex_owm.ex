defmodule ExOwm do
  @moduledoc """
  Documentation for ExOwm.
  """

  @doc """
  Gets temperature of the given city by calling api.openweathermap.org

  ## Example API calls by city name
  api.openweathermap.org/data/2.5/weather?q={city name}&APPID={APIKEY}
  api.openweathermap.org/data/2.5/weather?q={city name},{country code}&units=metric&APPID={APIKEY}

  ## Example API calls by city ID
  api.openweathermap.org/data/2.5/weather?id=2172797&APPID={APIKEY}

  ## Full parameter list: http://openweathermap.org/current#format

  ## Examples

      iex> ExOwm.get_weather("Warsaw")
      %{}

  """
  def get_weather(locations) do
    locations
    |> send_request()
    |> parse_request()
  end

  defp send_request(location) do
    api_url = "api.openweathermap.org/data/2.5/weather?q=#{location}&units=metric&APPID=#{Application.get_env(:ex_owm, :api_key)}"
    case HTTPoison.get(api_url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: json_body}} ->
        {:ok, json_body}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:ok, :not_found}
      {:ok, %HTTPoison.Response{status_code: 400}} ->
        {:ok, :empty_location}  
    end
  end

  defp parse_request(location) do
    case location do
      {:ok, json_body} ->
        {:ok, weather_map} = Poison.decode(json_body)
        weather_map
    end
  end
end
