defmodule ExOwm.Application do
  require Logger
  use Application

  def start(_type, _args) do
    Logger.info("Starting supervision tree for #{inspect(__MODULE__)}")

    children = [
      ExOwm.Supervisor,
      ExOwm.Cache
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
