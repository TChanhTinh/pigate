defmodule Pigate.Mqtt.Connection do
  @moduledoc """
  This contain MQTT logic relate
  """
  use GenServer

  def config(), do: Application.fetch_env!(:pigate, __MODULE__)

  def start_link({hostname}) do
    GenServer.start_link(__MODULE__, {hostname}, name: __MODULE__)
  end

  def subscribe(topic, qos) do
    GenServer.cast(__MODULE__, {:subscribe, topic, qos})
  end

  def publish(topic, message) do
    GenServer.cast(__MODULE__, {:publish, topic, message})
  end

  def get_message(topic) do
    GenServer.call(__MODULE__, {:get_message, topic})
  end

  def init({hostname}) do
    Tortoise.Connection.start_link(
      client_id: hostname,
      server: {Tortoise.Transport.Tcp, host: config()[:host], port: config()[:port]},
      handler: {Pigate.MQTT.Handler, []},
      subscriptions: [{"#", 0}]
    )

    {:ok, {hostname, []}}
  end

  def handle_cast({:subscribe, topic, qos}, {hostname, subscribed}) do
    Tortoise.Connection.subscribe(hostname, {topic, qos})

    {:noreply, {hostname, subscribed}}
  end

  def handle_cast({:publish, topic, message}, {hostname, subscribed}) do
    Tortoise.publish(hostname, topic, message)
    {:noreply, {hostname, subscribed}}
  end
end
