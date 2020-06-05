using Test
using TelegramMessageParser

@testset "parsing" begin
    files = ["./data/messages.html"]
    msgs = parse_messages(files)
    println(msgs)
end
