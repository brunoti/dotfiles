--- @alias __PLACEHOLDER__ {}

--- Placeholder constant
--- @type __PLACEHOLDER__
local _ = {}

--- Creates a curried version of a function with placeholder support
--- @generic T : fun(...): any
--- @param func `T`
--- @return `T`
---
local function _curry(func)
	local args = {}

	local function collect(...)
		local new_args = { ... }
		for _, v in ipairs(new_args) do
			table.insert(args, v)
		end

		-- Check available arguments, ignoring placeholders
		local valid_args = {}
		for _, arg in ipairs(args) do
			if arg ~= _ then
				table.insert(valid_args, arg)
			end
		end

		-- If enough valid arguments have been collected
		if #valid_args >= debug.getinfo(func, "u").nparams then
			-- Call the original function with valid arguments
			args = {}
			return func(unpack(valid_args))
		else
			-- Return a new function to collect more arguments
			return collect
		end
	end

	return collect
	end


--- // make the following table	immutable. make it not possible to set or change props.	using the metamethods.	AI!
local curry = setmetatable({}, {
	__call = function(_, func)
		return _curry(func)
	end,
	__newindex = function()
		error("Attempt to modify immutable table", 2)
	end,
	__metatable = false,
})

return curry
