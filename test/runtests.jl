using Test

using Glob
using TelegramMessageParser

@testset "parsing" begin
    files = glob("./data/ChatExport_11_03_2020/messages*.html")
    msgs = parse_messages(files)
    println("Parsed $(length(msgs)) messages.")

    println("""
            Last message was:
            $(last(msgs))

            from_name: $(last(msgs).from_name)
            timestamp: $(last(msgs).timestamp)
            """)
end
