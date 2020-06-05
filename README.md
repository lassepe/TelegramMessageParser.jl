# TelegramMessageParser.jl

![build](https://github.com/lassepe/TelegramMessageParser.jl/workflows/build/badge.svg)
[![codecov](https://codecov.io/gh/lassepe/TelegramMessageParser.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/lassepe/TelegramMessageParser.jl)

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
