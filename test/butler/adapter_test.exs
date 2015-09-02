defmodule Butler.AdapterTest do
  use ExUnit.Case, async: true

  test "run/1"
  test "reply/1"
  test "send/1"

  test "sends messages to bot" do
    adapter = TestAdapter.start_link
    TestAdapter.send("This is a test")
  end
end

