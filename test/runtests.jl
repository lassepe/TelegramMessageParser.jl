using Test
using TelegramMessageParser

@testset "parsing" begin
    files = "./data/messages.html"
    msgs = parse_messages(files)
    println("Parsed $(length(msgs)) messages.")

    println("""
            Last message was:
            $(last(msgs))

            from_name: $(last(msgs).from_name)
            timestamp: $(last(msgs).timestamp)
            text:      $(last(msgs).text)
            """)
end
