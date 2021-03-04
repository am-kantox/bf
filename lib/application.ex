defmodule Bf.App do
  @moduledoc false

  use Boundary, deps: [Bf]

  use Application

  @spec start(Application.app(), Application.restart_type()) ::
          {:error, any()} | {:ok, pid()} | {:ok, pid(), any()}
  def start(_type, _args) do
    children = [
      # Tarearbol Dynamic Manager
      Bf.Dyno
    ]

    opts = [strategy: :one_for_one, name: Bf.App]
    Supervisor.start_link(children, opts)
  end
end
