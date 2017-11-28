defmodule ExOwm do
  alias ExOwm.Feature.Coordinator
  require Logger
  use Application
  @moduledoc """
  Documentation for ExOwm, OpenWeatherMap API Elixir client.
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
  Gets weather data of the given location with specified options.

  ## Examples

      iex> ExOwm.current_weather_data(["Warsaw,PL",23212,3332674,"London",5], units: :metric, lang: :pl)
      %{}

  """
  @spec get_current_weather_data(list, list) :: map
  def get_current_weather_data(locations, opts \\ []) when is_list(locations) do
    Coordinator.start_workers(locations, opts)
    Coordinator.get_state()
  end

end
