defmodule ExOwm.Application do
  require Logger
  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    Logger.info("Starting supervision tree for #{inspect(__MODULE__)}")

    children = [
      supervisor(ExOwm.Supervisor, []),
      supervisor(ExOwm.Cache, []),
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
