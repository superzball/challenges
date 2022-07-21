defmodule Challenges.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Challenges.MatchingEngine,
    ]

    opts = [strategy: :one_for_one, name: Challenges.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
