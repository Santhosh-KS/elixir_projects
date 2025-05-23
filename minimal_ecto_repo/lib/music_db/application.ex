defmodule MusicDb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: MusicDb.Worker.start_link(arg)
      # {MusicDb.Worker, arg}
      MusicDb.Repo
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MusicDb.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
