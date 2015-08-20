defmodule Butler.Bot do
  @behaviour :websocket_client_handler

  def start_link(opts \\ []) do
    Agent.start_link(fn -> HashSet.new end, name: __MODULE__)
    {:ok, json} = Butler.Rtm.start
    url = String.to_char_list(json.url)
    :websocket_client.start_link(url, __MODULE__, json)
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

    Handler.FooHandler.setup_responder()

    {:ok, slack}
  end

  def websocket_info(:start, _connection, slack) do
    IO.puts "Starting"
    {:ok, slack}
  end

  def websocket_terminate(reason, _connection, slack) do
    IO.puts "Terminated"
    IO.inspect reason
    {:error, slack}
  end

  def websocket_handle({:ping, msg}, _connection, slack) do
    IO.puts "Ping"
    {:reply, {:pong, msg}, slack}
  end

  def websocket_handle({:text, msg}, _connection, slack) do
    message = Poison.Parser.parse!(msg, keys: :atoms)
    handle_message(message, slack)
    # {:ok, slack}
  end

  defp handle_message(message = %{type: "message", text: text}, slack) do
    Agent.get(__MODULE__, fn set ->
      Enum.find_value(set, fn({regex, func}) ->
        if Regex.match?(regex, text) do
          matches = Regex.scan(regex, text)
          response = func.(matches)
          {:reply, {:text, encode(response, message.channel)}, slack}
        end
      end)
    end)
  end

  def respond(regex, func) do
    item = {regex, func}
    Agent.update(__MODULE__, &Set.put(&1, item))
  end

  defp handle_message(_message, slack), do: {:ok, slack}

  defp encode(text, channel) do
    Poison.encode!(%{ type: "message", text: text, channel: channel })
  end

  def send_message(text, channel, slack) do
    msg = Poison.encode!(%{ type: "message", text: text, channel: channel })
    :websocket_client.send({:text, msg}, slack.socket)
  end
end
