defmodule App.Tocode do
  use App.Commander

  def daily_post_url do
    url = "https://www.tocode.co.il/blog"
    headers = ["Accept": "application/json; Charset=utf-8"]
    options = [hackney: [pool: :default]]

    with {:ok, response} <- HTTPoison.get(url, headers, options),
         {:ok, appstate} <- Poison.decode(response.body),
         %{ "blog" => %{ "posts" => [%{"href" => href} | _] } } <- appstate do
           "https://www.tocode.co.il#{href}"
    end
  end

  def upcoming_webinar_url do
    url = "https://www.tocode.co.il/workshops"
    headers = ["Accept": "application/json; Charset=utf-8"]
    options = [hackney: [pool: :default]]

    with {:ok, response} <- HTTPoison.get(url, headers, options),
         {:ok, appstate} <- Poison.decode(response.body),
         %{ "workshops" => %{ "items" => [%{"id" => id, "short_description" => description} | _] } } <- appstate do
           { "https://www.tocode.co.il/workshops/#{id}", description }
         end
  end

  def publish_daily_post_url_to_group() do
    href = App.Tocode.daily_post_url
    chat_id = Application.fetch_env!(:app, :group_chat_id)
    Nadia.send_message(chat_id, "New Post #{href}")
  end
end
