local _ = require 'lib.fp'

local M = {}

---@module 'snacks'

---@class Workspace
---@field custom string
---@field last_opened string
---@field name string
---@field path string
---@field type string

---@return Workspace[]
local function get_workspaces()
	return require('workspaces').get()
end

---@type fun(data: Workspace[]): snacks.picker.finder.Item[]
local function transform_to_picker_items(data)
	return _.map_indexed(function(item, idx)
		return {
			custom = item.custom,
			last_opened = item.last_opened,
			name = item.name,
			path = item.path,
			type = item.type,
			idx = idx,
			score = idx,
			text = item.name,
		}
	end, data)
end

local function get_current_workspace()
	return require('workspaces').name()
end

function M.picker(fn)
	local callback = fn and fn or _.noop
	local data = get_workspaces()
	local picker_items = transform_to_picker_items(data)

	Snacks.picker({
		items = picker_items,
		format = "text",
		preview = "none",
		title = "Workspaces \\ Current: " .. (get_current_workspace() or "None"),
		layout = {
			preset = "vscode",
		},
		confirm = function(picker, item)
			picker:close()
			if item then
				require('workspaces').open(item.name)
				callback(item)
				Snacks.picker.files()
			end
		end
	})
end

return M
