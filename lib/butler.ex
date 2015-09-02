defmodule Butler do
  use Application

  def start(_type, {adapter, plugins}) do
    Butler.Supervisor.start_link(adapter, plugins)
  end

  def stop(_) do
    IO.puts "Cheerio"
  end
end
