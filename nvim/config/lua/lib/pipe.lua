--- Pipe function for Lua.
---
---@generic T
---@generic U
---@param initial_value `T` # the initial value
---@vararg fun(value: `T`): `U` # functions to apply to the value
---@return any result # the value of the last function
local function pipe(initial_value, ...)
	local args = { ... }
	local value = initial_value
	for i = 1, #args do
		value = args[i](value)
	end
	return value
end

return pipe
