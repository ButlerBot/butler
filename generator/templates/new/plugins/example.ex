defmodule <%= mod_name %>.Example do
  use Butler.Plugin
  alias Butler.Plugin.Responders, as: Responder

  @moduledoc """
  echoes back; demonstrates parsing basic user input
  """
  respond ~r/echo (.*)/, conn, [_all, say] do
    reply conn, "#{say}"
  end

  @usage """
  hears ping, says pong; demonstrates basic listening and a broadcast
  """
  hear ~r/ping/, conn do
    # ["test"|tests]
    say conn, "-> pong"
  end

  @moduledoc """
  replies back with code; demonstrates escaping code blocks
  """
  respond ~r/code/, conn do
    response = "console.log('this should look like code!');"
      |> Responder.code
    reply conn, response
  end
end
