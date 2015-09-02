defmodule Butler.BotTest do
  use ExUnit.Case, async: true

  defmodule TestAdapter do
    def start_link do
    end
  end

  test "listens to messages through the adapter" do
    adapter = TestAdapter.start_link
    bot = Butler.Bot.start_link(adapter)
    TestAdapter.received(adapter, "Hello World")
  end

  test "sends messages to plugins"
  test "matches messages that start with the robots name"
  test "does not match unaddressed messages"
  test "receive/1 calls all registered plugins"
end
