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
