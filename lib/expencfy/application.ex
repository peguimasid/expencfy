defmodule Expencfy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ExpencfyWeb.Telemetry,
      Expencfy.Repo,
      {DNSCluster, query: Application.get_env(:expencfy, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Expencfy.PubSub},
      # Start a worker by calling: Expencfy.Worker.start_link(arg)
      # {Expencfy.Worker, arg},
      # Start to serve requests, typically the last entry
      ExpencfyWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Expencfy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ExpencfyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
