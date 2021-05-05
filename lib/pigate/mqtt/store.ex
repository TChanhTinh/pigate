defmodule Pigate.Mqtt.Store do
  @moduledoc """
  This store and dispatch MQTT message
  """

  use GenServer

  def start_link(_opt) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def push_message(topic, payload) do
    GenServer.cast(__MODULE__, {:push, topic, payload})
  end

  def get_message(topic) do
    GenServer.call(__MODULE__, {:get, topic})
  end

  def get_message() do
    GenServer.call(__MODULE__, :get)
  end

  def init(_init_arg) do
    keyword = Keyword.new()
    {:ok, keyword}
  end

  def handle_cast({:push, topic, payload}, state) do
    keyword = state
    |> Keyword.put(String.to_atom(topic), payload)

    {:noreply,
    keyword}
    #device_state ++ state}
  end

  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:get, topic}, _from, state) do
    device_state = state
    |> Keyword.get(String.to_atom(topic))

    {:reply, device_state, state}
  end
end
