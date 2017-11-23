defmodule ExOwm do
  require Logger
  use Application
  @moduledoc """
  Documentation for ExOwm, OpenWeatherMap API Elixir library.
  """

  def start(_type, _args) do
    import Supervisor.Spec
    Logger.info "Starting supervision tree for #{inspect(__MODULE__)}"

    children = [
      supervisor(ExOwm.Feature.Supervisor, [])
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  @doc """
  Gets temperature of the given city by calling api.openweathermap.org

  ## Examples

      iex> ExOwm.get_weather("Warsaw")
      %{}

  """
  def get_weather_by_id(locations) when is_list(locations) do
    # Enum.each(locations, fn(location) -> 
      # IO.inspect location
      # ExOwm.Feature.Supervisor.start_workers(%{id: location}) 
    ExOwm.Feature.Coordinator.start_workers(locations)
    # end)
    ExOwm.Feature.Coordinator.get_state()
  end

end
