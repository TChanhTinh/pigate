defmodule Pigate.Mqtt.Connection do
  @moduledoc """
  This contain MQTT logic relate
  """

  use GenServer

  def start_link({hostname, host}) do
    GenServer.start_link(__MODULE__, {hostname, host}, name: __MODULE__)
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

  def init({hostname, host}) do
    Tortoise.Connection.start_link(
      client_id: hostname,
      server: {Tortoise.Transport.Tcp, host: host, port: 1883},
      handler: {Tortoise.Handler.Logger, []}
    )

    {:ok, {hostname, []}}
  end

  def handle_cast({:subscribe, topic, qos}, {hostname, subscribed}) do
    Tortoise.Connection.subscribe(HelloWorld, {topic, qos})
    #{:ok, topic, {hostname, [subscribed ++ {topic, qos}]}}
    {:noreply, {hostname, subscribed}}
  end

  def handle_cast({:publish, topic, message}, {hostname, subscribed}) do
    Tortoise.publish(hostname, topic, message)
    {:noreply, {hostname, subscribed}}
  end

end
