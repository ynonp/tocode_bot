# ToCode Bot

A helpful bot for ToCode telegram group

## Setup Instructions
To play with this bot's code you'll need to create your own bot token
by talking to telegram's botfather.

After that's done create a file named `config/config.exs` with the following content:

```
use Mix.Config

config :app,
  bot_name: "TocodeBot"

config :nadia,
  token: "type-here-your-telegram-bot-token"

config :app, group_chat_id: "type-your-group-chat-id-here"

```

Setup dependencies and compile:

```
$ mix deps.get
$ mix compile
```

And run the bot:

```
$ mix run --no-halt
```

## Contribute
Care to help? Want some new functionality for this bot? It's easy.

Most of the relevant code is in the file `lib/app/commands.ex`, just look at the code there and modify or create your own new commands.

You'll probably want to learn some elixir before you do, and this guide is a good place to start: https://elixir-lang.org/getting-started/introduction.html

Here are some TODOs for this bot:

1. Reply to /webinar with a link to the next planned webinar

2. Send the /daily link every morning to a group defined in a config file

3. Automatically sign up a user to a webinar (using Zoom API). Remember the email address so users can join more webinars.

4. Connect the bot with Tocode users system, so the bot would be able to bug you about the next lesson you want to take or notify you about new content.
