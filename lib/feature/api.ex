defmodule ExOwm.Feature.Api do

  def call_owm_api(params) do
    params
    |> build_request_string()
    |> send_request()
    |> parse_json()
  end

  defp build_request_string(params) do
    id = 
      params
      |> List.first()
      |> Map.get(:id)
    IO.puts "+++++++++"
    IO.inspect params
    "api.openweathermap.org/data/2.5/weather?id=#{id}&units=metric&APPID=#{Application.get_env(:ex_owm, :api_key)}"
  end

  defp send_request(string) do
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