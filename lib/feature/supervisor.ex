defmodule ExOwm.Feature.Supervisor do
  use Supervisor
  alias ExOwm.Feature.Worker
  alias ExOwm.Feature.Coordinator

  def start_link() do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    Supervisor.init([{Coordinator, [:calling_coordinator]}], strategy: :one_for_one)
  end

  def start_worker(params) do
     Supervisor.start_link([{Worker, [params]}], strategy: :one_for_one)
  end
end