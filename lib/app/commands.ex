defmodule App.Commands do
  use App.Router
  use App.Commander
  HTTPoison.start

  alias App.Commands.Outside

  command ["dad"] do
    url = "https://icanhazdadjoke.com/"
    headers = ["Accept": "text/plain"]

    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        send_message body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        send_message "404 Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.log :info, reason
    end
  end

  command ["webinar"] do
    {href, description} = App.Tocode.upcoming_webinar_url
    send_message "**הוובינר הקרוב בטוקוד**:\n#{description}\n פרטים והצטרפות בקישור:\n#{href}", parse_mode: "Markdown"
  end

  command ["daily"] do
    href = App.Tocode.daily_post_url
    send_message "Your daily read https://www.tocode.co.il#{href}"
  end

  # You can create commands in the format `/command` by
  # using the macro `command "command"`.
  command ["hello", "hi"] do
    # Logger module injected from App.Commander
    Logger.log :info, "Command /hello or /hi"

    # You can use almost any function from the Nadia core without
    # having to specify the current chat ID as you can see below.
    # For example, `Nadia.send_message/3` takes as first argument
    # the ID of the chat you want to send this message. Using the
    # macro `send_message/2` defined at App.Commander, it is
    # injected the proper ID at the function. Go take a look.
    #
    # See also: https://hexdocs.pm/nadia/Nadia.html
    send_message "Hello World!"
  end

  # The `message` macro must come at the end since it matches anything.
  # You may use it as a fallback.
  message do
    IO.inspect(update.message)
  end
end
