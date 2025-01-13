defmodule Sb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SbWeb.Telemetry,
      Sb.Repo,
      {DNSCluster, query: Application.get_env(:sb, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Sb.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Sb.Finch},
      # Start a worker by calling: Sb.Worker.start_link(arg)
      # {Sb.Worker, arg},
      # Start to serve requests, typically the last entry
      SbWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SbWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
