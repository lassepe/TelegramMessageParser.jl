# TelegramMessageParser.jl

A simpler parser for HTML exports of Telegram chats.


## Installation

From a Julia REPL:

```julia
using Pkg
pkg"activate ."
pkg"instantiate ."
```

## Usage

```julia
using TelegramMessageParser

file = "path/to/messages.html"
msgs = parse_messages(file)
```
