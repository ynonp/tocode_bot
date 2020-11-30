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

  def send_all(messages, chat_id) do
    results = messages
              |> Enum.map(fn chunk ->
                :timer.sleep(200)
                Nadia.send_message(chat_id, chunk, parse_mode: "Markdown")
              end)

    had_errors = Enum.find(results, fn
      {:ok, _} -> false
      {:error, _} -> true
    end)

    if had_errors do
      results
      |> Enum.filter(fn {status, _} -> status == :ok end)
      |> Enum.map(fn {:ok, msg} -> msg.message_id end)
      |> Enum.each(fn msg_id -> Nadia.delete_message(chat_id, msg_id) end)
    end
  end

  def blog_post_with_iv(url) do
    "https://t.me/iv?url=#{URI.encode_www_form(url)}&rhash=c8260195ae67de"
  end

  def publish_daily_post_content do
    post_url = App.Tocode.daily_post_url
    href = post_url <> "/md"
    headers = []
    options = [hackney: [pool: :default]]

    {:ok, response} = HTTPoison.get(href, headers, options)
    Nadia.send_message("@tocodeil", blog_post_with_iv(daily_post_url()), parse_mode: "HTML")
    response.body
    |> split_long_messages(4000)
    |> send_all("@tocodeil")
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
           |> App.Tocode.blog_post_with_iv

    chat_id = Application.fetch_env!(:app, :group_chat_id)
    Nadia.send_message(chat_id, href)
  end


  def break_by(text, []) do
    { text, "" }
  end

  def break_by(text, [head | tail]) do
    if String.contains?(text, head) do
      parts = text |> String.split(head)
      {
        (parts |> Enum.drop(-1) |> Enum.join(head)) <> head,
        parts |> Enum.take(-1) |> Enum.at(0)
      }

    else
      break_by(text, tail)
    end
  end
  

  def split_long_messages(text, max_length) do
    chunk_fun = fn element, acc ->
      if String.length(acc) >= max_length do
        { chunk, rest } = break_by(acc, ["\n", " "])
        fix_code_blocks(chunk, rest <> element)
      else
        {:cont, acc <> element}
      end
    end

    after_fun = fn
      acc -> {:cont, String.trim(acc), ""}
    end

    Enum.chunk_while(text |> String.graphemes, "", chunk_fun, after_fun)
  end

  def fix_code_blocks(chunk, acc) do
    codeblock_count = Regex.scan(~r/```/i, chunk) |> length
    if rem(codeblock_count, 2) == 0 do
      { :cont, String.trim(chunk), acc }
    else
      { :cont, String.trim(chunk) <> "\n```\n", "\n```\n" <> acc }
    end
  end


end
