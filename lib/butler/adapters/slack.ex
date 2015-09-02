defmodule Butler.Adapters.Slack do
  @behaviour Butler.Adapter

  @behaviour :websocket_client_handler

  def start_link(opts \\ []) do
    {:ok, json} = Butler.Adapters.Slack.Rtm.start
    url = String.to_char_list(json.url)
    :websocket_client.start_link(url, __MODULE__, opts)
  end

  def init(json, socket) do
    slack = %{
      socket: socket,
      me: json.self,
      team: json.team,
      channels: json.channels,
      groups: json.groups,
      users: json.users
    }

    {:ok, %{slack: slack}}
  end

  def websocket_info(:start, _connection, state) do
    Butler.Logger.debug "Starting"
    {:ok, state}
  end

  def websocket_terminate(reason, _connection, state) do
    Butler.Logger.error "Terminated", reason
    {:error, state}
  end

  def websocket_handle({:ping, msg}, _connection, state) do
    Butler.Logger.debug "Ping"
    {:reply, {:pong, msg}, state}
  end

  def websocket_handle({:text, msg}, _connection, state) do
    message = Poison.Parser.parse!(msg, keys: :atoms)
    handle_message(message, state)
  end

  defp handle_message(message = %{type: "message", text: text}, state) do
    Butler.Logger.debug "Recieved text: #{text}"
    {:ok, state}
  end

  defp handle_message(_message, state), do: {:ok, state}

  defp encode(text, channel) do
    Poison.encode!(%{ type: "message", text: text, channel: channel })
  end

  def send_message(text, channel, socket, client \\ :websocket_client) do
    msg = Poison.encode!(%{ type: "message", text: text, channel: channel })
    client.send({:text, msg}, socket)
  end

  def send(text, channel, socket) do
    msg = Poison.encode!(%{ type: "message", text: text, channel: channel })
    :websocket_client.send({:text, msg}, socket)
  end
end
