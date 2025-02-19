local open_with_trouble = require("trouble.sources.telescope").open

-- -- Use this to add more results without clearing the trouble list
-- local add_to_trouble = require("trouble.sources.telescope").add

require('telescope').setup {
	defaults = {
		initial_mode = "normal",
		borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
		mappings = {
			n = {
				['D'] = require('telescope.actions').delete_buffer,
				["<c-t>"] = open_with_trouble,
				["g?"] = "which_key"
			},
			i = {
				["<c-t>"] = open_with_trouble,
				["<C-h>"] = "which_key",
				['<c-d>'] = require('telescope.actions').delete_buffer
			},
		},
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
require("telescope").load_extension("recent-files")
require("telescope").load_extension("telescope-tabs")
require("telescope").load_extension("cmdline")
require('telescope-tabs').setup()
require("telescope").load_extension("workspaces")
