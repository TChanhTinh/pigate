defmodule Pigate.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Pigate.Repo,
      # Start the Telemetry supervisor
      PigateWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Pigate.PubSub},
      # Start the Endpoint (http/https)
      PigateWeb.Endpoint,
      # Start a worker by calling: Pigate.Worker.start_link(arg)
      # {Pigate.Worker, arg}
      {Pigate.Mqtt.Connection, {"data_mqtt", "192.168.101.178"}}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pigate.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PigateWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
