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
				enabled = false,
				name = "catppuccin",
				priority = 1000,
				opts = {
					-- term_colors = true,
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
					color_overrides = {
					},
					integrations = {
						telescope = {
							enabled = false,
						},
						which_key = true,
						navic = {
							enabled = true,
						},
						blink_cmp = true,
						nvimtree = true,
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
						noice = true,
						snacks = true,
						notify = true,
						mini = {
							enabled = true,
							indentscope_color = "lavender",
						},
						grug_far = true,
						lsp_saga = true,
						diffview = true,
						mason = true,
						overseer = true,
						neotest = true
					},
					init = function()
						vim.cmd.colorscheme("catppuccin")
					end
				},
			},
		}
	end
}
