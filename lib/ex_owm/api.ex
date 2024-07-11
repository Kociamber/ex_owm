defmodule ExOwm.Api do
  @moduledoc """
  This module contains functions for interacting with the OpenWeatherMap API.
  It prepares request strings, makes API calls, and parses the responses.
  """
  alias ExOwm.RequestString
  alias HTTPoison.{Error, Response}

  @doc """
  Prepares a request string based on the given parameters, calls the OWM API,
  and parses the JSON response.

  ## Parameters

    - `api_call_type` (atom): The type of API call (e.g., `:get_weather`, `:get_current_weather`).
    - `location` (map): The location parameters (e.g., city, coordinates, zip code).
    - `opts` (term): Optional parameters for the API call (e.g., type, mode, units, cnt, lang).

  ## Returns

    - (map): The parsed JSON response.
    - `{:error, term, term}`: An error tuple containing the error type and the response.
  """
  @spec send_and_parse_request(atom, map, term) :: map | {:error, term, term}
  def send_and_parse_request(api_call_type, location, opts) do
    api_call_type
    |> RequestString.build(location, opts)
    |> call_api()
    |> parse_response()
  end

  @spec call_api(String.t()) :: {:ok, String.t()} | {:error, atom, term} | {:error, term}
  defp call_api(url) do
    case HTTPoison.get(url) do
      {:ok, %Response{status_code: 200, body: json_body}} ->
        {:ok, json_body}

      {:ok, %Response{status_code: 404, body: json_body}} ->
        {:error, :not_found, json_body}

      {:ok, %Response{status_code: 400, body: json_body}} ->
        {:error, :bad_request, json_body}

      {:ok, %Response{status_code: 401, body: json_body}} ->
        {:error, :api_key_invalid, json_body}

      {:ok, response} ->
        {:error, :unknown_api_response, response}

      {:error, %Error{} = reason} ->
        {:error, reason}
    end
  end

  @spec parse_response({:ok, String.t()} | {:error, atom, String.t()} | {:error, term}) ::
          map | {:error, term, term}
  defp parse_response({:ok, json}), do: Jason.decode(json)

  defp parse_response({:error, :unknown_api_response, response}),
    do: {:error, :unknown_api_response, response}

  defp parse_response({:error, reason, json_body}), do: {:error, reason, Jason.decode(json_body)}

  defp parse_response({:error, %Error{} = reason}), do: {:error, reason}
end
