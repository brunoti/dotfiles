local defaults = { noremap = true, silent = true }
local mapping = {}

mapping.map = function(type, shortcut, command, config)
	config = config or defaults
	vim.api.nvim_set_keymap(type, shortcut, command, config)
end

mapping.nmap = function(shortcut, command, config)
	config = config or defaults
	vim.api.nvim_set_keymap('n', shortcut, command, config)
end

mapping.normal_map = function(shortcut, command, config)
	config = config or defaults
	vim.api.nvim_set_keymap('n', shortcut, command, config)
end

mapping.imap = function(shortcut, command, config)
	config = config or defaults
	vim.api.nvim_set_keymap('i', shortcut, command, config)
end

mapping.insert_map = function(shortcut, command, config)
	config = config or defaults
	vim.api.nvim_set_keymap('i', shortcut, command, config)
end

mapping.select_map = function(shortcut, command, config)
	config = config or defaults
	vim.api.nvim_set_keymap('s', shortcut, command, config)
end

mapping.visual_map = function(shortcut, command, config)
	config = config or defaults
	vim.api.nvim_set_keymap('x', shortcut, command, config)
end

return mapping
