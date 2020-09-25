module TelegramMessageParser

using Gumbo: HTMLDocument, HTMLElement, HTMLText, attrs, children, parsehtml, text
using Cascadia: eachmatch, @sel_str
using AbstractTrees: PreOrderDFS
using Dates
using DocStringExtensions

export TelegramMessage, parse_messages

"--------------------------------- Implementation ---------------------------------"

"""
$(TYPEDEF)

A representation of a single message from a telegram chat.

# Fields
$(TYPEDFIELDS)
"""
struct TelegramMessage
    "The raw HTML representation of the message which may be used to extract further
    information (hint: use `Cascadia.jl` and/or `Gumbo.jl`)"
    raw::HTMLElement
    "The time at which this message has been sent"
    timestamp::DateTime
    "The author of this message."
    from_name::String
    "The message text (does not include line breaks)."
    text::String
end

function Base.show(io::IO, m::TelegramMessage)
    print(io,
    """
    timestamp: $(m.timestamp)
    from_name: $(m.from_name)
    text:      $(m.text)
    raw:       [ommitted]
    """)
end

"""
$(TYPEDSIGNATURES)

Parse messages from multiple files or documents. `files_or_docs` may be any
iterable with element type `String` (i.e. file names) or `Gumbo.HTMLDocument`.

"""
parse_messages(files_or_docs) = vcat(parse_messages.(files_or_docs)...)
"""
$(TYPEDSIGNATURES)

Parse messages from file at path `filename`.
"""
parse_messages(filename::AbstractString) = parse_messages(parsehtml(read(filename,
                                                                          String)))
"""
$(TYPEDSIGNATURES)

Parse messages from a given given html document.
"""
function parse_messages(doc::HTMLDocument)
    raw_messages = eachmatch(sel".message.default > .body", doc.root)

    last_from_name = ""
    map(raw_messages) do rmsg
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

        TelegramMessage(rmsg, time, from_name, body)
    end
end

end # module
