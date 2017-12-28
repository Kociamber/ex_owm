defmodule ExOwm.Api do
  alias ExOwm.RequestString

  def send_and_parse_request(api_call_type, location, opts) do
    RequestString.build(api_call_type, location, opts)
    |> call_api()
    |> parse_json()
  end

  # def send_and_parse_request(:get_five_day_forecast, location, opts) do
  #   RequestString.build(:get_five_day_forecast, location, opts)
  #   |> call_api()
  #   |> parse_json()
  # end

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
