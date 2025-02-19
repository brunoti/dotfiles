local curry = require "lib.curry"
local M = {}

--- Check if a table has a key.
--- @param key any
--- @param table table<any, any>
--- @return boolean
M.has_key = curry(function (key, table)
	return table[key] ~= nil
end)

--- Check if a value is a function.
--- @param value any
--- @return boolean
function M.is_function(value)
	return type(value) == "function"
end

return M
