module TelegramMessageParser

using Gumbo: HTMLDocument, HTMLElement, HTMLText, attrs, children, parsehtml, text
using Cascadia: eachmatch, @sel_str
using AbstractTrees: PreOrderDFS
using Dates

export TelegramMessage, parse_messages

"--------------------------------- Implementation ---------------------------------"

struct TelegramMessage
    raw::HTMLElement
    timestamp::DateTime
    from_name::String
    text::String
end

parse_messages(files_or_docs) = vcat(parse_messages.(files_or_docs)...)
parse_messages(filename::AbstractString) = parse_messages(parsehtml(read(filename,
                                                                          String)))

function parse_messages(doc::HTMLDocument)
    raw_messages = eachmatch(sel".message.default > .body", doc.root)

    last_from_name = ""
    return map(raw_messages) do rmsg
        time = begin
            date_elem = eachmatch(sel".date", rmsg) |> only
            DateTime(attrs(date_elem)["title"], dateformat"dd.mm.yyyy HH:MM:SS")
        end
        from_name = begin
            fname_array = eachmatch(sel".from_name", rmsg)
            if !isempty(fname_array)
                last_from_name = fname_array |> first |> text |> strip
            end
            last_from_name
        end
        body = begin
            rtext_array = eachmatch(sel".text" , rmsg)
            isempty(rtext_array) ? "" : only(rtext_array) |> text |> strip
        end


        return TelegramMessage(rmsg, time, from_name, body)
    end
end

end # module
