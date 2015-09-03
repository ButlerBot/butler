defmodule Butler.Plugins.Decide do
  use Butler.Plugin

  def respond("decide" <> say, state) do
    options = String.split(say, " or ", trim: true)
    num_options = length options
    random = (:random.uniform num_options) - 1
    decided = Enum.at(options, random)

    {:reply, "Butler has decided that #{decided} is the right choice", state}
  end
end
