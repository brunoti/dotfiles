function dump(t, indent, done)
    done = done or {}
    indent = indent or 0

    done[t] = true

    for key, value in pairs(t) do
        print(string.rep(" ", indent))

        if type(value) == "table" and not done[value] then
            done[value] = true
            print(key, ":\n")

            dump(value, indent + 2, done)
            done[value] = nil
        else
            print(key, " = ", value, "\n")
        end
    end
end

function string.split(str, delimiter)
    local result = {}
    local pattern = "(.-)" .. delimiter
    local lastEnd = 1

    for match in str:gmatch(pattern) do
        if match ~= "" then
            table.insert(result, match)
        else
            table.insert(result, nil)  -- Inserting nil for consecutive delimiters
        end

        lastEnd = str:find(delimiter, lastEnd) + 1
    end

    -- Adding the last part of the string
    table.insert(result, str:sub(lastEnd))

    return result
end

function sveltalize(filename) 
	dump(filename:split('/'))
end

sveltalize("~/base/+server.ts")
