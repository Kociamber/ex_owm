defmodule ExOwm.Application do
  require Logger
  use Application
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications

  def start(_type, _args) do
    import Supervisor.Spec
    Logger.info "Starting supervision tree for #{inspect(__MODULE__)}"

    children = [
      supervisor(ExOwm.Supervisor, []),
      supervisor(ExOwm.Cache.CurrentWeather, []),
      supervisor(ExOwm.Cache.FiveDayForecast, []),
      supervisor(ExOwm.Cache.SixteenDayForecast, [])
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
