defmodule Handler.FooHandler do
  def setup_responder() do
    Butler.Bot.respond(~r/hello (.*)/, fn(matches) ->
      "Hi yourself!"
    end)
  end
end
