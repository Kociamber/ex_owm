defmodule ExOwm do
  use Application
  alias ExOwm.Supervisor, as: MainSupervisor
  alias ExOwm.Feature.Supervisor, as: FeatureSupervisor
  alias ExOwm.Feature.Coordinator
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
  def get_weather_by_id(locations) when is_list(locations) do
    Enum.each(locations, fn(location) -> 
      # IO.inspect location
      FeatureSupervisor.start_worker(%{id: location}) 
    end)
    Coordinator.get_state()
  end

  def start(_type, _args) do
    MainSupervisor.start_link()
  end

end
