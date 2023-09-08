defmodule ExOwm.Api do
  @moduledoc """
  This module contains OpenWeatherMap API related functions.
  """
  alias ExOwm.RequestString

  @doc """
  Prepares request string basing on given params, calls OWM API, parses and
  decodes the answers.
  """
  @spec send_and_parse_request(atom, map, term) :: map | {:error, term, term}
  def send_and_parse_request(api_call_type, location, opts) do
    RequestString.build(api_call_type, location, opts)
    |> call_api()
    |> parse_json()
  end

  defp call_api(string) do
    case HTTPoison.get(string) do
      {:ok, %HTTPoison.Response{status_code: 200, body: json_body}} ->
        {:ok, json_body}

      {:ok, %HTTPoison.Response{status_code: 404, body: json_body}} ->
        {:error, :not_found, json_body}

      {:ok, %HTTPoison.Response{status_code: 400, body: json_body}} ->
        {:error, :not_found, json_body}

      {:ok, %HTTPoison.Response{status_code: 401, body: json_body}} ->
        {:error, :api_key_invalid, json_body}

      {:ok, response} ->
        {:error, :unknown_api_response, response}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp parse_json({:ok, json}), do: Jason.decode(json)

  defp parse_json({:error, :unknown_api_response, response}),
    do: {:error, :unknown_api_response, response}

  defp parse_json({:error, reason, json_body}), do: {:error, reason, Jason.decode!(json_body)}
  defp parse_json({:error, %HTTPoison.Error{} = reason}), do: {:error, reason}
end
