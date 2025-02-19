---Compose functions.
---
---@vararg fun(value: any): any
---@return fun(...): any
local function compose(...)
	local args = { ... }
	return function(value)
		for i = #args, 1, -1 do
			value = args[i](value)
		end
		return value
	end
end

return compose

