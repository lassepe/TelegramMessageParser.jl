module TelegramMessageParser

using Gumbo
using Gumbo: children
using AbstractTrees: PreOrderDFS
using Dates

export parse_messages

"--------------------------------- Implementation ---------------------------------"

struct Message
    raw::HTMLElement
    timestamp::DateTime
    from_name::String
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

    last_from_name = ""
    return map(raw_messages) do raw
        if length(children(raw)) == 2
            time, from_name, content = children(children(raw)[2])
            last_from_name = from_name
        else
            time, content = children(children(raw)[1])
            from_name = last_from_name
        end

        return Message(raw,
                       DateTime(attrs(time)["title"], dateformat"dd.mm.yyyy HH:MM:SS"),
                       strip(text(from_name[1])),
                       content)
    end
end

end # module
