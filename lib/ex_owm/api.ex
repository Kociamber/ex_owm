defmodule ExOwm.Api do
  alias ExOwm.RequestString.CurrentWeather

  def send_and_parse_request(:get_current_weather, location, opts) do
    CurrentWeather.build_request_string(location, opts)
    |> call_api()
    |> parse_json()
  end

  defp call_api(string) do
    case HTTPoison.get(string) do
      {:ok, %HTTPoison.Response{status_code: 200, body: json_body}} ->
        {:ok, json_body}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, :not_found}
      {:ok, %HTTPoison.Response{status_code: 400}} ->
        {:error, :not_found}
    end
  end

  defp parse_json({:ok, json}) do
    {:ok, map} = Poison.decode(json)
    map
  end
  defp parse_json({:error, reason}) do
    {:error, reason}
  end

end
