return {
	setup = function()
		return {
			-- {
			-- 	"LazyVim/LazyVim",
			-- 	opts = {
			-- 		colorscheme = "catppuccin",
			-- 	},
			-- 	init = function()
			-- 		normal_map('L', '<cmd>tabnext<cr>')
			-- 		normal_map('H', '<cmd>tabprevious<cr>')
			-- 	end
			-- },
			{
				"catppuccin/nvim",
				name = "catppuccin",
				priority = 1000,
				opts = {
					term_colors = true,
					transparent_background = false,
					background = {
						light = "latte",
						dark = "mocha",
					},
					styles = {
						comments = {},
						conditionals = {},
						loops = {},
						functions = {},
						keywords = {},
						strings = {},
						variables = {},
						numbers = {},
						booleans = {},
						properties = {},
						types = {},
					},
					-- color_overrides = {
					-- 	mocha = {
					-- 		base = "#000000",
					-- 		mantle = "#000000",
					-- 		crust = "#000000",
					-- 	},
					-- },
					integrations = {
						telescope = {
							enabled = true,
						},
						cmp = true,
						nvimtree = false,
						treesitter = true,
						native_lsp = {
							enabled = true,
							virtual_text = {
								errors = { "italic" },
								hints = { "italic" },
								warnings = { "italic" },
								information = { "italic" },
							},
							underlines = {
								errors = { "underline" },
								hints = { "underline" },
								warnings = { "underline" },
								information = { "underline" },
							},
							inlay_hints = {
								background = true,
							},
						},
						mason = true
					},
					init = function()
						vim.cmd.colorscheme("catppuccin")
					end
				},
			},
		}
	end
}
