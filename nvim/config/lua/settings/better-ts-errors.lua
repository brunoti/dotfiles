return {
	setup = function()
		return {
			"OlegGulevskyy/better-ts-errors.nvim",
			dependencies = { "MunifTanjim/nui.nvim" },
			opts = {
				keymaps = {
					toggle = '<space>dd',     -- default '<leader>dd'
					go_to_definition = '<space>dx' -- default '<leader>dx'
				}
			}
		}
	end
}
