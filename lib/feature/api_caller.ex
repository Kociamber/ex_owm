defmodule ExOwm.Feature.ApiCaller do

  def send_and_parse_request(location, opts) do
    {location, opts}
    |> build_request()
    |> call_api()
    |> parse_json()
  end

  defp build_request({location, opts}) do
    {location, opts}
    |> add_prefix_substring()
    |> add_location_substring()
    |> add_units_substring()
    |> add_language_substring()
    |> add_api_key_substring()
  end

  # defp build_request_string(id) do
  #   "api.openweathermap.org/data/2.5/weather?id=#{id}&units=metric&APPID=#{Application.get_env(:ex_owm, :api_key)}"
  # end

  # Start building querys string.
  defp add_prefix_substring({location, opts}) do
    {"api.openweathermap.org/data/2.5/weather", location, opts}
  end

  # Add location type to query string.
  defp add_location_substring({string, location, opts}) do
    cond do
      is_binary(location)  -> {string <> "?q=#{location}", opts}
      is_integer(location) -> {string <> "?id=#{location}", opts}
    end
  end

  # Add temperature type to query string. Lack of this part make api to return default 
  # temperature in Kelvins.
  defp add_units_substring({string, opts}) do
    case Keyword.get(opts, :units) do
      :metric   -> {string <> "&units=metric", opts}
      :imperial -> {string <> "&units=imperial", opts}
      _         -> {string, opts}
    end
  end

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

  defp add_api_key_substring(string), do: string <> "&APPID=#{Application.get_env(:ex_owm, :api_key)}"

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