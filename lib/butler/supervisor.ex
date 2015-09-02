defmodule Butler.Supervisor do
  use Supervisor

  def start_link(adapter, plugins) do
    Supervisor.start_link(__MODULE__, {:ok, adapter, plugins})
  end

  @manager_name Butler.EventManager

  def init({:ok, adapter, plugins}) do
    children = [
      worker(GenEvent, [[name: @manager_name]]),
      worker(Butler.Bot, [adapter, @manager_name, plugins, []]),
      worker(adapter, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
