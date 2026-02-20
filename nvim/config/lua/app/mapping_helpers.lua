---@module 'app.mapping_helpers'
-- Mapping Helpers Module
--
-- This module provides helper functions for keymap configuration in Neovim.
-- It includes utility functions for checking buffer state, creating command
-- abbreviations, and factory functions for mini.files keymaps.
--
-- @usage
--   local helpers = require('app.mapping_helpers')
--   helpers.create_command_abbreviations(abbreviations_table)
--   helpers.is_dashboard()

local lib = require('lib')

local M = {}

--- Check if the current buffer is a snacks dashboard
---@return boolean True if current buffer filetype is "snacks_dashboard"
function M.is_dashboard()
	return vim.bo.filetype == "snacks_dashboard"
end

--- Prompt user for code companion action and execute it
--- Opens an input prompt asking what the user wants to do, then executes
--- the CodeCompanion command with the provided input.
---
--- @usage
---   _G.code_companion_call = helpers.code_companion_call
function M.code_companion_call()
	Snacks.input({
		icon = "󱝁 ",
		backdrop = true,
		prompt = "What do you want do?",
	}, function(value)
		if value and value ~= "" then
			lib.run_command("'<,'>CodeCompanion #{buffer} " .. value)
		end
	end)
end

--- Create Vim command abbreviations
--- Registers command abbreviations to prevent common typos and provide shortcuts
---
--- @param abbreviations table Array of abbreviation pairs where each entry is:
---   { "abbreviation", "full_command" }
---
--- @usage
---   local abbrs = {
---     { "W", "w" },
---     { "Q", "q" }
---   }
---   helpers.create_command_abbreviations(abbrs)
function M.create_command_abbreviations(abbreviations)
	for _, abbr in ipairs(abbreviations) do
		vim.cmd(string.format("cab %s %s", abbr[1], abbr[2]))
	end
end

--- Mini.files helper functions
-- Factory functions for creating which-key specifications for mini.files
M.minifiles = {}

--- Create a close keymap specification for mini.files
---@param map string Key sequence to map
---@return table which-key specification table
function M.minifiles.close(map)
	return {
		map,
		function()
			require('mini.files').close()
		end,
		mode = { "n" },
		desc = "Close",
		icon = "󰅖 ",
		buffer = true,
		noremap = true,
		silent = true,
	}
end

--- Create a go_in keymap specification for mini.files
---@param map string Key sequence to map
---@param config table|nil Configuration table for go_in (e.g., { close_on_file = false })
---@return table which-key specification table
function M.minifiles.go_in(map, config)
	return {
		map,
		function()
			require('mini.files').go_in(config)
		end,
		mode = { "n" },
		desc = "Go In",
		icon = " ",
		buffer = true,
		noremap = true,
		silent = true,
	}
end

--- Create a go_out keymap specification for mini.files
---@param map string Key sequence to map
---@return table which-key specification table
function M.minifiles.go_out(map)
	return {
		map,
		function()
			require('mini.files').go_out()
		end,
		mode = { "n" },
		desc = "Go Out",
		icon = " ",
		buffer = true,
		noremap = true,
		silent = true,
	}
end

--- Create a refresh keymap specification for mini.files
---@param map string Key sequence to map
---@return table which-key specification table
function M.minifiles.refresh(map)
	return {
		map,
		function()
			require('mini.files').refresh()
		end,
		mode = { "n" },
		desc = "Refresh",
		icon = "󰑓 ",
		buffer = true,
		noremap = true,
		silent = true,
	}
end

return M

