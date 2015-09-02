defmodule Butler.Logger do
  require Logger

  def debug(msg) do
    Logger.debug(msg)
  end

  def error(msg) do
    Logger.error(msg)
  end
end

