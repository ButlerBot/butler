defmodule Butler.Adapters.Console do
  @name Application.get_env(:bot, :name)

  require Logger

  def start_link do
    loop_acceptor
  end

  def loop_acceptor do
    read |> evaluate

    loop_acceptor
  end

  def reply(msg) do
    msg |> format_reply |> print
  end

  def format_reply(msg) when is_binary(msg) do
    format_reply({:text, msg})
  end

  def format_reply({:code, msg}),  do: {:ok, "```\n#{msg}```"}
  def format_reply({:text, msg}),  do: {:ok, "#{msg}"}
  def format_reply({:quote, msg}), do: {:ok, ">#{msg}"}
  def format_reply(response), do: {:error, response}

  defp read do
    IO.gets prompt
  end

  defp evaluate(msg) do
    Butler.Bot.respond(msg)
  end

  defp print({:error, reponse}), do: Logger.error "Unknown response"
  defp print({:ok, output}) do
    IO.puts "\n#{output}"
  end

  def prompt do
    "#{@name}>"
  end
end
