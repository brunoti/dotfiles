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
local transform_to_picker_items = _.map_indexed(function(item, idx)
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
	end)

function M.picker()
	local data = get_workspaces()
	local picker_items = transform_to_picker_items(data)

	Snacks.picker({
		items = picker_items,
		format = "text",
		preview = "none",
		layout = {
			preset = "vscode",
		},
		confirm = function(picker, item)
			picker:close()
			if item then
				require('workspaces').open(item.name)
			end
		end
	})
end

return M
