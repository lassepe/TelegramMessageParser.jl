module TelegramMessageParser

using Gumbo
using AbstractTrees
using Dates

export parse_messages

"--------------------------------- Implementation ---------------------------------"

struct Message
    raw::HTMLElement
    timestamp::DateTime
    from::String
    content::HTMLElement
end

parse_messages(files_or_docs) = vcat(parse_messages.(files_or_docs)...)
parse_messages(filename::AbstractString) = parse_messages(parsehtml(read(filename, String)))

function parse_messages(doc::HTMLDocument)

    raw_messages = filter(collect(PreOrderDFS(doc.root))) do elem
        if elem isa HTMLText
            return false
        end
        return occursin("message default", get(attrs(elem), "class", ""))
    end

    last_from = ""
    return map(raw_messages) do raw
        if length(children(raw)) == 2
            time, from, content = children(children(raw)[2])
            global _last_from = from
        else
            time, content = children(children(raw)[1])
            from = _last_from
        end

        return Message(raw,
                       DateTime(attrs(time)["title"], dateformat"dd.mm.yyyy HH:MM:SS"),
                       strip(text(from[1])),
                       content)
    end
end

end # module
