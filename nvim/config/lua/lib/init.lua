local M = {}

---Checks if some LSP server is active.
---@return boolean # True if the LSP server is active, false otherwise.
function M.is_lsp_active(lsp_name)
	local clients = vim.lsp.get_clients()
	for _, client in ipairs(clients) do
		if client.name == lsp_name then
			return true -- LSP is active
		end
	end
	return false -- LSP is not active
end

---Checks if the current mode is visual.
---@return boolean # True if in visual mode, false otherwise.
function M.is_visual_mode()
	local mode = vim.fn.mode()
	return mode == 'v' or mode == 'V' or mode == '\22' -- '\22' is the character for CTRL-V
end

---Checks if the current mode is visual.
---@return boolean # True if in normal mode, false otherwise.
function M.is_normal_mode()
	return vim.api.nvim_get_mode().mode == "n"
end

function M.start_command(command)
	vim.api.nvim_feedkeys(':' .. command .. ' ', vim.api.nvim_get_mode().mode, false)
end

function M.get_command(command)
	return "<cmd>" .. command .. "<cr>"
end

function M.press(key)
	local final_key = vim.api.nvim_replace_termcodes(key, true, false, true)
	vim.api.nvim_feedkeys(final_key, 'n', false)
end

function M.run_command(command)
	local final_command = vim.api.nvim_replace_termcodes("<cmd>" .. command .. "<cr>", true, false, true)
	vim.api.nvim_feedkeys(final_command, 'n', false)
end

function M.set_registry(name, value)
	vim.fn.setreg(name, value)
end

function M.get_registry(name)
	vim.fn.getreg(name)
end

function M.get_last_yanked()
	return M.get_registry('"')
end

function M.copy_last_yank()
	return M.copy_to_clipboard(M.get_last_yanked())
end

function M.to_clipboard(text)
	M.set_registry('+', text)
end

function M.copy_file_name()
	local file_name = vim.fn.expand('%:p')
	M.set_registry('+', file_name)
	Snacks.notify('Copied current file path to clipboard. \n\npath: ' .. file_name)
end

return M
