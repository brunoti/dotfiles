local mapping = require 'utils.mapping'
local nmap = mapping.nmap

require('telescope').setup {
	defaults = {
		initial_mode = "normal",
		borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' }
	},
	extensions = {
		media_files = {

			-- filetypes whitelist
			-- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
			filetypes = { "png", "webp", "jpg", "jpeg", "webm", "mp4", "pdf" },
			find_cmd = "rg" -- find command (defaults to `fd`)
		},
		["ui-select"] = {
			require("telescope.themes").get_dropdown {
				-- even more opts
			}
		}
	},
}

require('telescope').load_extension('media_files')
require('telescope').load_extension('node_modules')
require("telescope").load_extension("ui-select")


mapping.map('', '<space>', '<nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- telescope mappings
nmap('<leader>ff', '<cmd>Telescope find_files<cr>')
nmap('<leader>fg', '<cmd>Telescope live_grep<cr>')
nmap('<leader>fb', '<cmd>Telescope buffers<cr>')
