defmodule ExOwm.Api do
  @moduledoc """
  This module contains functions for interacting with the OpenWeatherMap API.
  It builds request URLs, makes API calls using Req, and parses responses.
  """
  alias ExOwm.{RequestURL, Location}

  @doc """
  Builds a request URL based on the given parameters, calls the OWM API,
  and parses the JSON response.

  ## Parameters

    - `api_call_type` (atom): The type of API call (e.g., `:get_weather`, `:get_current_weather`).
    - `location` (%ExOwm.Location{}): The location struct.
    - `opts` (keyword): Optional parameters for the API call (e.g., type, mode, units, cnt, lang).

  ## Returns

    - `{:ok, map}`: The parsed JSON response.
    - `{:error, term}`: An error atom.
    - `{:error, term, term}`: An error tuple containing the error type and the response.
  """
  @spec send_and_parse_request(atom, Location.t(), keyword) ::
          {:ok, map} | {:error, term} | {:error, term, term}
  def send_and_parse_request(api_call_type, %Location{} = location, opts) do
    api_call_type
    |> RequestURL.build_url(location, opts)
    |> call_api()
  end

  @spec call_api(String.t()) :: {:ok, map} | {:error, term} | {:error, term, term}
  defp call_api(url) do
    case Req.get(url) do
      {:ok, %Req.Response{status: 200} = response} ->
        handle_success_response(response)

      {:ok, %Req.Response{status: status, body: body}} when status in [400, 401, 404] ->
        handle_error_response(status, body)

      {:ok, %Req.Response{status: status} = response} ->
        {:error, :unknown_api_response, %{status: status, response: response}}

      {:error, exception} ->
        {:error, exception}
    end
  end

  defp handle_success_response(%Req.Response{body: body}) when is_map(body), do: {:ok, body}

  defp handle_success_response(%Req.Response{body: body}) when is_binary(body) do
    case Jason.decode(body) do
      {:ok, decoded} -> {:ok, decoded}
      {:error, reason} -> {:error, {:json_decode_error, reason}}
    end
  end

  defp handle_error_response(404, body), do: {:error, :not_found, parse_error_body(body)}
  defp handle_error_response(400, body), do: {:error, :bad_request, parse_error_body(body)}
  defp handle_error_response(401, body), do: {:error, :api_key_invalid, parse_error_body(body)}

  defp parse_error_body(body) when is_map(body), do: body

  defp parse_error_body(body) when is_binary(body) do
    case Jason.decode(body) do
      {:ok, decoded} -> decoded
      {:error, _} -> %{"error" => body}
    end
  end
end
