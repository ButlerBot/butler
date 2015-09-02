defmodule Butler.Plugin do
  @doc false
  defmacro __using__(_opts) do
    quote do
      use GenEvent

      @bot_name Application.get_env(:bot, :name)

      @before_compile Butler.Plugin

      def handle_event({:message, text}, state) do
        if bot_mentioned?(text) do
          strip_name(text)
          |> respond(state)
          |> handle_response
        else
          hear(text, state)
          |> handle_response
        end
      end

      defp handle_response({:noreply, state}), do: {:ok, state}
      defp handle_response({:reply, response, state}) do
        {:ok, response} = Butler.Bot.reply(response)
        {:ok, state}
      end

      def bot_mentioned?(text) do
        name = @bot_name |> String.downcase
        [first | _] = String.split(text)
        first |> String.downcase |> String.contains?(name)
      end

      def strip_name(text) do
        [_ | msg] = String.split(text)
        Enum.join(msg, " ")
      end
    end
  end

  defmacro __before_compile__(env) do
    quote do
      def hear(_msg, state), do: {:noreply, state}
      def respond(_msg, state), do: {:noreply, state}
      defoverridable [hear: 2, respond: 2]
    end
  end
end
