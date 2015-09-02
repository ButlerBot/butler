defmodule Butler.Adapters.ConsoleTest do
  use ExUnit.Case

  alias Butler.Adapters.Console, as: Console

  test "it displays the bots name in the prompt" do
    prompt = Console.prompt
    assert prompt == "Butler>"
  end
end
