local pipe      = require "lib.pipe"
local compose   = require "lib.compose"
local curry, _  = require "lib.curry"
local predicate = require "lib.predicate"

local M = {}

M.pipe = pipe
M.compose = compose
M.curry = curry
M._ = _

--- Returns a deep copy of the given object. Non-table objects are copied as
--- in a typical Lua assignment, whereas table objects are copied recursively.
--- Functions are naively copied, so functions in the copied table point to the
--- same functions as those in the input table. Userdata and threads are not
--- copied and will throw an error.
---
--- Note: `noref=true` is much more performant on tables with unique table
--- fields, while `noref=false` is more performant on tables that reuse table
--- fields.
---
---@generic T: table
---@param orig T Table to copy
---@param noref? boolean
--- When `false` (default) a contained table is only copied once and all
--- references point to this single copy. When `true` every occurrence of a
--- table results in a new copy. This also means that a cyclic reference can
--- cause `deepcopy()` to fail.
---@return T Table of copied keys and (nested) values.
function M.deep_copy(orig, noref)
  return vim.deepcopy(orig, noref)
end

-- Adds an item at the beginning of a table
---@param tbl table The table to which the item is to be added
---@param item any The item to be added
---@return table
M.prepend = curry(function(item, tbl)
	local new_tbl = M.deep_copy(tbl)
	table.insert(new_tbl, 1, item)
	return new_tbl;
end)

-- Adds an item at the end of a table
---@param tbl table The table to which the item is to be added
---@param item any The item to be added
---@return table
M.append = curry(function(item, tbl)
	local new_tbl = M.deep_copy(tbl)
	table.insert(new_tbl, item)
	return new_tbl;
end)

M.map = curry(function(fn, tbl)
	local new_tbl = {}
	for k, v in pairs(tbl) do
		new_tbl[k] = fn(v)
	end
	return new_tbl
end)

M.filter = curry(function(fn, tbl)
	local new_tbl = {}
	for k, v in pairs(tbl) do
		if fn(v) then
			new_tbl[k] = v
		end
	end
	return new_tbl
end)

M.reduce = curry(function(fn, acc, tbl)
	for _, v in pairs(tbl) do
		acc = fn(acc, v)
	end
	return acc
end)

--- Maps over a table and returns a new table with the same keys, but with the
--- values replaced by the result of the function.
--- 
--- @overload fun(fn: fun(value: any, key: any): any, tbl: table): any
--- @overload fun(fn: fun(value: any, key: any): any): fun(tbl: table): any
M.map_indexed = curry(function(fn, tbl)
	local new_tbl = {}
	for k, v in pairs(tbl) do
		new_tbl[k] = fn(v, k)
	end
	return new_tbl
end)

--- Runs a function for each element of the table
M.for_each = curry(function(fn, tbl)
	for _, v in pairs(tbl) do
		fn(v)
	end
end)

M.complement = curry(function(fn, ...)
	return not fn(...)
end)

M.identity = function(...)
	return ...
end

--- Returns a function that always returns the same value.
---@generic T
---@vararg T
---@return fun(): `T` # The function that returns the value
M.always = function(...)
	local args = ...
	return function()
		return args
	end
end

function M.ternary(cond, T, F)
	if cond then return T() else return F() end
end

function M.key_or(table, key, or_value)
	if predicate.has_key(table, key) then
		return table[key]
	end

	return or_value
end

M.merge = vim.tbl_extend
M.merge_deep = vim.tbl_extend_deep

return M
