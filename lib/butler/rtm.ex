defmodule Butler.Adapters.Slack.Rtm do
  @slack_token Application.get_env(:slack, :api_key)
  @user_agent [ {"User-agent", "Butler the slack bot"} ]
  @url "https://slack.com/api/rtm.start?token=#{@slack_token}"

  def start do
    HTTPoison.get(@url, @user_agent) |> handle_response
  end

  defp handle_response({:ok, %HTTPoison.Response{body: body}}) do
    json = Poison.Parser.parse!(body, keys: :atoms)
    {:ok, json}
  end

  defp handle_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end
end
