defmodule Adapter do
  use Behaviour

  defcallback hear()
  defcallback emote()
  defcallback reply()
  defcallback topic()
  defcallback run()
  defcallback close
end
