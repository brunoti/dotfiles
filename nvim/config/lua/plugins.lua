---@diagnostic disable: missing-fields
local _ = require('lib.fp')
local uv = require('luv')
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not uv.fs_stat(lazypath) then
	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)


local function setup()
	require('lazy').setup({
		-- neovim tree sitter
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			config = function()
				local configs = require("nvim-treesitter.configs")

				---@diagnostic disable-next-line: missing-fields
				configs.setup({
					sync_install = true,
					auto_install = true,
					context_commentstring = {
						enable = true
					},
					indent = {
						enable = true,
						additional_vim_regex_highlighting = true,
					},
					highlight = { enable = true },
				})

				vim.wo.foldmethod = 'expr'
				vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
			end
		},
		{
			"MunifTanjim/nui.nvim",
		},
		{
			"nvim-lua/plenary.nvim",
			branch = "master",
		},
		{
			'dyng/ctrlsf.vim',
			cmd = {
				"CtrlSF",
			},
		},
		{
			'kyazdani42/nvim-web-devicons', -- optional, for file icons
		},
		-- nvim-tree: file explorer
		{
			'kyazdani42/nvim-tree.lua',
			cmd = {
				"NvimTreeToggle",
				"NvimTreeOpen",
			},
		},
		{
			'nvim-telescope/telescope.nvim',
			enabled = false,
			event = "VeryLazy",
			opts = {
				defaults = {
					initial_mode = "normal",
					borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
					mappings = {
						n = {
							["g?"] = "which_key"
						},
						i = {
							["<C-h>"] = "which_key",
						},
					},
				},
				extensions = {
					media_files = {


					},
				},
			},
		},

		{
			'windwp/nvim-ts-autotag',
			ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
			opts = {}
		},
		{
			'chaoren/vim-wordmotion',
			event = 'VeryLazy'
		},
		{
			"SmiteshP/nvim-navic",
			event = 'VeryLazy',
			opts = {
				depth_limit = 2,
				highlight = true,
				separator = "  ",
				lazy_update_context = true,
				depth_limit_indicator = "[...]",
				lsp = {
					auto_attach = true
				}
			}
		},
		{
			"nvimtools/none-ls.nvim",
			dependencies = {
				"nvimtools/none-ls-extras.nvim",
			},
		},
		{
			'nvim-lualine/lualine.nvim',
			init = function()
				local overseer = require 'overseer'
				require('lualine').setup({
					theme = 'tokyonight',
					options = {
						component_separators = { left = '', right = '' },
						section_separators = { left = '', right = '' },
						disabled_filetypes = {
							'NvimTree',
							"grug-far",
							"grug-far-history",
							"grug-far-help",
							"dashboard",
							"snacks_dashboard",
							"trouble",
							"snacks_explorer",
							"kitty-scrollback",
						},
					},
					{
						lualine_c = {
							{
								"navic",
								color_correction = "dynamic"
							}
						},
						lualine_x = {
						},
						lualine_y = {
						},
						lualine_z = {
							{
								"overseer",
								label = "", -- Prefix for task counts
								colored = true, -- Color the task icons and counts
								symbols = {
									[overseer.STATUS.FAILURE] = "F:",
									[overseer.STATUS.CANCELED] = "C:",
									[overseer.STATUS.SUCCESS] = "S:",
									[overseer.STATUS.RUNNING] = "R:",
								},
								unique = false, -- Unique-ify non-running task count by name
								name = nil, -- List of task names to search for
								name_not = false, -- When true, invert the name search
								status = nil, -- List of task statuses to display
								status_not = false, -- When true, invert the status search
							},
							'location'
						}
					},
					extensions = { 'quickfix', 'nvim-tree', 'lazy', 'mason', "trouble", "man", "overseer" },
				})

				vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
				vim.api.nvim_create_autocmd("User", {
					group = "lualine_augroup",
					pattern = "LspProgressStatusUpdated",
					callback = require("lualine").refresh,
				})
			end,
		},
		{
			'lambdalisue/suda.vim',
			cmd = {
				"SudaWrite",
				"SudaRead",
			}
		},
		{
			'folke/which-key.nvim',
			event = "VeryLazy",
			opts = {
				preset = "helix",
				triggers = {
					{ "<auto>", mode = "nxso" },
					{ "m",      mode = 'n' },
					{ ",",      mode = 'n' },
					{ "]",      mode = 'n' },
					{ "[",      mode = 'n' },
				},
			}
		},
		{
			'ojroques/nvim-lspfuzzy',
			lazy = true,
			dependencies = {
				{ 'junegunn/fzf' },
				{ 'junegunn/fzf.vim' }, -- to enable preview (optional)
			},
			opts = {},
		},
		{
			"fladson/vim-kitty",
			ft = "kitty",
		},
		{
			"GeorgesAlkhouri/nvim-aider",
			cmd = {
				"AiderTerminalToggle", "AiderHealth",
			},
			keys = {
				-- { "<leader>a/", "<cmd>AiderTerminalToggle<cr>",    desc = "Open Aider" },
				-- { "<leader>as", "<cmd>AiderTerminalSend<cr>",      desc = "Send to Aider",                  mode = { "n", "v" } },
				-- { "<leader>ac", "<cmd>AiderQuickSendCommand<cr>",  desc = "Send Command To Aider" },
				-- { "<leader>ab", "<cmd>AiderQuickSendBuffer<cr>",   desc = "Send Buffer To Aider" },
				-- { "<leader>a+", "<cmd>AiderQuickAddFile<cr>",      desc = "Add File to Aider" },
				-- { "<leader>a-", "<cmd>AiderQuickDropFile<cr>",     desc = "Drop File from Aider" },
				-- { "<leader>ar", "<cmd>AiderQuickReadOnlyFile<cr>", desc = "Add File as Read-Only" },
				-- -- Example nvim-tree.lua integration if needed
				-- { "<leader>a+", "<cmd>AiderTreeAddFile<cr>",       desc = "Add File from Tree to Aider",    ft = "NvimTree" },
				-- { "<leader>a-", "<cmd>AiderTreeDropFile<cr>",      desc = "Drop File from Tree from Aider", ft = "NvimTree" },
			},
			config = true,
		},
		-- {
		-- 	'hrsh7th/nvim-cmp',
		-- 	event = "InsertEnter",
		-- 	dependencies = {
		-- 		"zbirenbaum/copilot-cmp",
		-- 		'hrsh7th/cmp-nvim-lsp',
		-- 		'hrsh7th/cmp-buffer',
		-- 		'hrsh7th/cmp-path',
		-- 		'saadparwaiz1/cmp_luasnip',
		-- 		'hrsh7th/cmp-cmdline',
		-- 		'roginfarrer/cmp-css-variables',
		-- 		"jcha0713/cmp-tw2css",
		-- 		'hrsh7th/cmp-nvim-lsp-signature-help',
		-- 		'hrsh7th/cmp-nvim-lsp-document-symbol',
		-- 	},
		-- 	init = function()
		-- 		local cmp = require 'cmp'
		-- 		local lspkind = require 'lspkind'
		-- 		lspkind.init({
		-- 			symbol_map = {
		-- 				Copilot = "",
		-- 			},
		-- 		})
		--
		-- 		vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#a6d189" })
		--
		-- 		local has_words_before = function()
		-- 			if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
		-- 			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		-- 			return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
		-- 		end
		--
		-- 		cmp.setup({
		-- 			snippet = {
		-- 				expand = function(args)
		-- 					require('luasnip').lsp_expand(args.body)
		-- 				end
		-- 			},
		-- 			---@diagnostic disable-next-line: missing-fields
		-- 			formatting = {
		-- 				format = lspkind.cmp_format({
		-- 					mode = 'symbol_text', -- show only symbol annotations
		-- 					maxwidth = {
		-- 						-- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
		-- 						-- can also be a function to dynamically calculate max width such as
		-- 						-- menu = function() return math.floor(0.45 * vim.o.columns) end,
		-- 						menu = 80,       -- leading text (labelDetails)
		-- 						abbr = 80,       -- actual suggestion item
		-- 					},
		-- 					ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
		-- 					show_labelDetails = true, -- show labelDetails in menu. Disabled by default
		--
		-- 					-- The function below will be called before any actual modifications from lspkind
		-- 					-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
		-- 					before = function(entry, vim_item)
		-- 						-- ...
		-- 						return vim_item
		-- 					end
		-- 				})
		-- 			},
		-- 			-- formatting = {
		-- 			-- 	fields = { "kind", "abbr", "menu" },
		-- 			-- 	format = function(entry, vim_item)
		-- 			-- 		local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
		-- 			-- 		local strings = vim.split(kind.kind, "%s", { trimempty = true })
		-- 			-- 		kind.kind = " " .. (strings[1] or "") .. " "
		-- 			-- 		kind.menu = "    [" .. (strings[2] or "") .. "]"
		-- 			--
		-- 			-- 		return kind
		-- 			-- 	end,
		-- 			-- },
		-- 			mapping = cmp.mapping.preset.insert({
		-- 				['<C-b>'] = cmp.mapping.scroll_docs(-4),
		-- 				['<C-f>'] = cmp.mapping.scroll_docs(4),
		-- 				['<C-Space>'] = cmp.mapping.complete(),
		-- 				['<C-e>'] = cmp.mapping.abort(),
		-- 				['<CR>'] = cmp.mapping.confirm({ select = true }),
		-- 				["<Tab>"] = vim.schedule_wrap(function(fallback)
		-- 					if cmp.visible() and has_words_before() then
		-- 						cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
		-- 					else
		-- 						fallback()
		-- 					end
		-- 				end),
		-- 			}),
		-- 			sources = cmp.config.sources({
		-- 				{ name = "copilot" },
		-- 				{
		-- 					name = "lazydev",
		-- 					group_index = 0, -- set group index to 0 to skip loading LuaLS completions
		-- 				},
		-- 				{ name = 'nvim_lsp', },
		-- 				{ name = 'path', },
		-- 				-- { name = 'nvim_lsp_signature_help', },
		-- 			}, {
		-- 				{ name = 'buffer' },
		-- 				{ name = 'luasnip' },
		-- 				{ name = 'css-variables' },
		-- 				{ name = 'cmp-tw2css' },
		-- 			})
		-- 		})
		--
		-- 		require("copilot_cmp").setup()
		--
		-- 		-- Set configuration for specific filetype.
		-- 		cmp.setup.filetype('gitcommit', {
		-- 			sources = cmp.config.sources({
		-- 				{ name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
		-- 			}, {
		-- 				{ name = 'buffer' },
		-- 			})
		-- 		})
		--
		-- 		cmp.setup.filetype('codecompanion', {
		-- 			sources = {
		-- 				name = 'codecompanion'
		-- 			}
		-- 		})
		--
		-- 		-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
		-- 		cmp.setup.cmdline({ '/', '?' }, {
		-- 			mapping = cmp.mapping.preset.cmdline(),
		-- 			sources = cmp.config.sources({
		-- 				{ name = 'nvim_lsp_document_symbol' }
		-- 			}, {
		-- 				{ name = 'cmdline_history' },
		-- 				{ name = 'buffer' }
		-- 			})
		-- 		})
		--
		-- 		-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
		-- 		cmp.setup.cmdline(':', {
		-- 			mapping = cmp.mapping.preset.cmdline(),
		-- 			matching = { disallow_symbol_nonprefix_matching = false },
		-- 			sources = cmp.config.sources({
		-- 				{ name = 'path' },
		-- 			}, {
		-- 				{ name = 'cmdline_history' },
		-- 				{ name = 'cmdline' }
		-- 			})
		-- 		})
		--
		--
		-- 		local sign = function(opts)
		-- 			vim.fn.sign_define(opts.name, {
		-- 				texthl = opts.name,
		-- 				text = opts.text,
		-- 				numhl = ''
		-- 			})
		-- 		end
		--
		-- 		sign({ name = 'DiagnosticSignError', text = '✘' })
		-- 		sign({ name = 'DiagnosticSignWarn', text = '▲' })
		-- 		sign({ name = 'DiagnosticSignHint', text = '⚑' })
		-- 		sign({ name = 'DiagnosticSignInfo', text = '' })
		-- 	end
		-- },
		{
			"saghen/blink.cmp",
			version = "*",
			opts_extend = { "sources.default" },
			dependencies = {
				{
					"fang2hou/blink-copilot",
					opts = {
						max_completions = 3,
						max_attempts = 2,
					}
				},
			},
			cmdline = {
				enabled = false
			},

			---@module 'blink.cmp'
			---@type blink.cmp.Config
			opts = {
				-- 'default' for mappings similar to built-in completion
				-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
				-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
				-- See the full "keymap" documentation for information on defining your own keymap.
				keymap = {
					preset = 'enter',
				},

				appearance = {
					-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
					-- Adjusts spacing to ensure icons are aligned
					nerd_font_variant = 'normal'
				},
				completion = {
					ghost_text = {
						enabled = true,
					},
					list = {
						selection = {
							preselect = false,
						}
					},
					documentation = {
						-- Controls whether the documentation window will automatically show when selecting a completion item
						auto_show = true,
						-- Delay before showing the documentation window
						auto_show_delay_ms = 500,
						-- Delay before updating the documentation window when selecting a new item,
						-- while an existing item is still visible
						update_delay_ms = 50,
						-- Whether to use treesitter highlighting, disable if you run into performance issues
						treesitter_highlighting = true,
						-- Draws the item in the documentation window, by default using an internal treessitter based implementation
					},
					menu = {
						border = 'none',
						scrollbar = false,
						draw = {
							gap = 2,
							treesitter = { "lsp" },
							columns = { { "label", "label_description", gap = 2 }, { "kind_icon", "kind" } },
							components = {
								kind = {
									ellipsis = false,
									width = { fill = true },
									text = function(ctx) return '[' .. ctx.kind .. ']' end,
								},
								kind_icon = {
									ellipsis = false,
									text = function(ctx)
										local symbol = require('lspkind').symbolic(ctx.kind, {
											mode = 'symbol',
											preset = 'default'
										})
										return " " .. symbol .. " "
									end,
								},
							},
						}
					}
				},
				snippets = { preset = 'luasnip' },
				-- Default list of enabled providers defined so that you can extend it
				-- elsewhere in your config, without redefining it, due to `opts_extend`
				sources = {
					default = { 'copilot', 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
					providers = {
						copilot = {
							name = "copilot",
							module = "blink-copilot",
							score_offset = 100,
							async = true,
							opts = {
								-- Local options override global ones
								-- Final settings: max_completions = 3, max_attempts = 2, kind = "Copilot"
								max_completions = 3, -- Override global max_completions
							}
						},
						-- minuet = {
						-- 	name = 'minuet',
						-- 	module = 'minuet.blink',
						-- 	score_offset = 8,   -- Gives minuet higher priority among suggestions
						-- },
						lazydev = {
							name = "LazyDev",
							module = "lazydev.integrations.blink",
							-- make lazydev completions top priority (see `:h blink.cmp`)
							score_offset = 100,
						},
					},
				},
			},
		},
		{
			"zbirenbaum/copilot.lua",
			opts = {
				panel = {
					enabled = false,
					auto_refresh = true,
					keymap = {
						jump_prev = "[[",
						jump_next = "]]",
						accept = "<CR>",
						refresh = "gr",
						open = "<M-CR>"
					},
					layout = {
						position = "bottom", -- | top | left | right | horizontal | vertical
						ratio = 0.4
					},
				},
				suggestion = {
					enabled = false,
					auto_trigger = false,
					hide_during_completion = true,
					keymap = {
						-- accept = "<M-l>",
						-- accept_word = false,
						-- accept_line = false,
						-- next = "<M-]>",
						-- prev = "<M-[>",
						-- dismiss = "<C-]>",
					},
				},
				filetypes = {
					yaml = false,
					markdown = false,
					help = false,
					gitcommit = false,
					gitrebase = false,
					hgcommit = false,
					svn = false,
					cvs = false,
					["grug-far"] = false,
					["grug-far-history"] = false,
					["grug-far-help"] = false,
					["."] = false,
					sh = function()
						if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then
							-- disable for .env files
							return false
						end
						return true
					end,
					lua = true,
					javascript = true,
					typescript = true,
					typescriptreact = true,
					javascriptreact = true,
				},
				copilot_node_command = 'node', -- Node.js version must be > 18.x
				-- server_opts_overrides = {
				-- 	advanced = {
				-- 		-- listCount = 10,   -- #completions for panel
				-- 		-- inlineSuggestCount = 3, -- #completions for getCompletions
				-- 	}
				-- },
			},
		},

		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
		'neovim/nvim-lspconfig',
		'elentok/format-on-save.nvim',

		{
			"johmsalas/text-case.nvim",
			config = function()
				require("textcase").setup({})
				require("telescope").load_extension("textcase")
			end,
			cmd = {
				-- NOTE: The Subs command name can be customized via the option "substitude_command_name"
				"Subs",
				"TextCaseOpenTelescope",
				"TextCaseOpenTelescopeQuickChange",
				"TextCaseOpenTelescopeLSPChange",
				"TextCaseStartReplacingCommand",
			},
			lazy = true,
		},
		{
			'echasnovski/mini.files',
			version = '*',
			opts = {
				mappings = {
					close       = '',
					go_in       = '',
					go_in_plus  = '',
					go_out      = '',
					go_out_plus = '',
					mark_goto   = "",
					mark_set    = '',
					reset       = '',
					reveal_cwd  = '',
					show_help   = 'g?',
					synchronize = '',
					trim_left   = '',
					trim_right  = '',
				}
			}
		},
		{
			'echasnovski/mini.pairs',
			version = '*',
			opts = {
				-- In which modes mappings from this `config` should be created
				modes = { insert = true, command = false, terminal = false },

				-- Global mappings. Each right hand side should be a pair information, a
				-- table with at least these fields (see more in |MiniPairs.map|):
				-- - <action> - one of 'open', 'close', 'closeopen'.
				-- - <pair> - two character string for pair to be used.
				-- By default pair is not inserted after `\`, quotes are not recognized by
				-- `<CR>`, `'` does not insert pair after a letter.
				-- Only parts of tables can be tweaked (others will use these defaults).
				mappings = {
					['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
					['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
					['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },

					[')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
					[']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
					['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },

					['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
					["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\].', register = { cr = false } },
					['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].', register = { cr = false } },
				},
			}
		},
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
			-- install jsregexp (optional!).
			build = "make install_jsregexp",
			dependencies = { "brunoti/friendly-snippets" },
			config = function()
				local ls = require("luasnip")
				require("luasnip.loaders.from_vscode").lazy_load()

				vim.keymap.set({ "i" }, "<C-K>", function() ls.expand() end, { silent = true })
				vim.keymap.set({ "i", "s" }, "<C-L>", function() ls.jump(1) end, { silent = true })
				vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(-1) end, { silent = true })

				vim.keymap.set({ "i", "s" }, "<C-E>", function()
					if ls.choice_active() then
						ls.change_choice(1)
					end
				end, { silent = true })
			end,
		},
		-- {
		-- 	'echasnovski/mini.snippets',
		-- 	version = '*',
		-- 	dependencies = {
		-- 		'brunoti/friendly-snippets'
		-- 	},
		-- 	opts = {},
		-- },
		{
			'echasnovski/mini.indentscope',
			version = '*',
			init = function()
				vim.g.miniindentscope_disable = true
				require('mini.indentscope').setup({
					symbol = "│"
				})
			end
		},
		{
			'stevearc/overseer.nvim',
			config = function()
				local overseer = require 'overseer'
				overseer.setup()
				overseer.register_template({
					-- Required fields
					name = "Some Task",
					builder = function(params)
						-- This must return an overseer.TaskDefinition
						return {
							-- cmd is the only required field
							cmd = { 'echo' },
							-- additional arguments for the cmd
							args = { "hello", "world" },
							-- the name of the task (defaults to the cmd of the task)
							name = "Greet",
							-- set the working directory for the task
							-- the list of components or component aliases to add to the task
							components = { "default" },
						}
					end,
					-- Optional fields
					desc = "Optional description of task",
					-- Tags can be used in overseer.run_template()
					params = {
						-- See :help overseer-params
					},
					priority = 50,
					condition = {
						filetype = { "typescriptreact" },
					},
				})
			end
		},
		{
			'onsails/lspkind.nvim',
			init = function()
				local lspkind = require 'lspkind'
				lspkind.init({
					symbol_map = {
						Copilot = "",
					},
				})

				vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#a6d189" })
			end
		},
		{
			'glepnir/nerdicons.nvim',
			cmd = 'NerdIcons',
			opts = {}
		},
		{
			"folke/snacks.nvim",
			priority = 1000,
			lazy = false,
			filter = function(buf)
				return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ""
			end,
			opts = function()
				---@module 'snacks'
				---@type snacks.Config
				local config = {
					indent = {
						enabled = true,
						char = "│",
						only_scope = true,
						only_current = true,
						priority = 1,
					},
					scope = {
						enabled = true,
						priority = 200,
						char = "│",
						underline = false, -- underline the start of the scope
						only_current = true, -- only show scope in the current window
					},
					input = { enabled = true },
					scroll = { enabled = false },
					chunk = { enable = true },
					picker = {
						enable = true,
						prompt = '   ',
						layouts = {
							vscode = {
								layout = {
									width = 0.5,
									backdrop = false,
									row = 1,
									min_width = 80,
									height = 0.4,
									border = "none",
									box = "vertical",
									{ win = "input",   height = 1,          border = "vpad", title = "{title} {live} {flags}", title_pos = "center" },
									{ win = "list",    border = "none" },
									{ win = "preview", title = "{preview}", border = "none" },
								},
							},
							default = {
								layout = {
									box = "horizontal",
									width = 0.8,
									min_width = 120,
									height = 0.8,
									{
										box = "vertical",
										border = "none",
										title = "{title} {live} {flags}",
										{ win = "input", height = 1,     border = "vpad" },
										{ win = "list",  border = "none" },
									},
									{ win = "preview", title = "{preview}", border = "solid", width = 0.5 },
								},
							},
						},
						sources = {
							keymaps = { layout = { preset = 'vscode' } },
							recent = { title = 'Most Recently Used Files' },
						},
						win = {
							-- input window
							input = {
								keys = {
									-- to close the picker on ESC instead of going to normal mode,
									-- add the following keymap to your config
									-- ["<Esc>"] = { "close", mode = { "n", "i" } },
									["/"] = "toggle_focus",
									["<C-Down>"] = { "history_forward", mode = { "i", "n" } },
									["<C-Up>"] = { "history_back", mode = { "i", "n" } },
									["<C-c>"] = { "cancel", mode = "i" },
									["<C-w>"] = { "<c-s-w>", mode = { "i" }, expr = true, desc = "delete word" },
									["<CR>"] = { "confirm", mode = { "n", "i" } },
									["<Down>"] = { "list_down", mode = { "i", "n" } },
									["<Esc>"] = "cancel",
									["<S-CR>"] = { { "pick_win", "jump" }, mode = { "n", "i" } },
									["<S-Tab>"] = { "select_and_prev", mode = { "i", "n" } },
									["<Tab>"] = { "select_and_next", mode = { "i", "n" } },
									["<Up>"] = { "list_up", mode = { "i", "n" } },
									["<a-d>"] = { "inspect", mode = { "n", "i" } },
									["<a-f>"] = { "toggle_follow", mode = { "i", "n" } },
									["<a-h>"] = { "toggle_hidden", mode = { "i", "n" } },
									["<a-i>"] = { "toggle_ignored", mode = { "i", "n" } },
									["<a-m>"] = { "toggle_maximize", mode = { "i", "n" } },
									["<a-p>"] = { "toggle_preview", mode = { "i", "n" } },
									["<a-w>"] = { "cycle_win", mode = { "i", "n" } },
									["<c-a>"] = { "select_all", mode = { "n", "i" } },
									["<c-b>"] = { "preview_scroll_up", mode = { "i", "n" } },
									["<c-d>"] = { "list_scroll_down", mode = { "i", "n" } },
									["<c-f>"] = { "preview_scroll_down", mode = { "i", "n" } },
									["<c-g>"] = { "toggle_live", mode = { "i", "n" } },
									["<c-j>"] = { "list_down", mode = { "i", "n" } },
									["<c-k>"] = { "list_up", mode = { "i", "n" } },
									["<c-n>"] = { "list_down", mode = { "i", "n" } },
									["<c-p>"] = { "list_up", mode = { "i", "n" } },
									["<c-q>"] = { "qflist", mode = { "i", "n" } },
									["<c-s>"] = { "edit_split", mode = { "i", "n" } },
									["<c-t>"] = { "tab", mode = { "n", "i" } },
									["<c-u>"] = { "list_scroll_up", mode = { "i", "n" } },
									["<c-v>"] = { "edit_vsplit", mode = { "i", "n" } },
									["<c-r>#"] = { "insert_alt", mode = "i" },
									["<c-r>%"] = { "insert_filename", mode = "i" },
									["<c-r><c-a>"] = { "insert_cWORD", mode = "i" },
									["<c-r><c-f>"] = { "insert_file", mode = "i" },
									["<c-r><c-l>"] = { "insert_line", mode = "i" },
									["<c-r><c-p>"] = { "insert_file_full", mode = "i" },
									["<c-r><c-w>"] = { "insert_cword", mode = "i" },
									["<c-w>H"] = "layout_left",
									["<c-w>J"] = "layout_bottom",
									["<c-w>K"] = "layout_top",
									["<c-w>L"] = "layout_right",
									["?"] = "toggle_help_input",
									["G"] = "list_bottom",
									["gg"] = "list_top",
									["j"] = "list_down",
									["k"] = "list_up",
									["q"] = "close",
								},
								b = {
									minipairs_disable = true,
								},
							},
							-- result list window
							list = {
								keys = {
									["/"] = "toggle_focus",
									["<2-LeftMouse>"] = "confirm",
									["<CR>"] = "confirm",
									["<Down>"] = "list_down",
									["<Esc>"] = "cancel",
									["<S-CR>"] = { { "pick_win", "jump" } },
									["<S-Tab>"] = { "select_and_prev", mode = { "n", "x" } },
									["<Tab>"] = { "select_and_next", mode = { "n", "x" } },
									["<Up>"] = "list_up",
									["<a-d>"] = "inspect",
									["<a-f>"] = "toggle_follow",
									["<a-h>"] = "toggle_hidden",
									["<a-i>"] = "toggle_ignored",
									["<a-m>"] = "toggle_maximize",
									["<a-p>"] = "toggle_preview",
									["<a-w>"] = "cycle_win",
									["<c-a>"] = "select_all",
									["<c-b>"] = "preview_scroll_up",
									["<c-d>"] = "list_scroll_down",
									["<c-f>"] = "preview_scroll_down",
									["<c-j>"] = "list_down",
									["<c-k>"] = "list_up",
									["<c-n>"] = "list_down",
									["<c-p>"] = "list_up",
									["<c-q>"] = "qflist",
									["<c-s>"] = "edit_split",
									["<c-t>"] = "tab",
									["<c-u>"] = "list_scroll_up",
									["<c-v>"] = "edit_vsplit",
									["<c-w>H"] = "layout_left",
									["<c-w>J"] = "layout_bottom",
									["<c-w>K"] = "layout_top",
									["<c-w>L"] = "layout_right",
									["?"] = "toggle_help_list",
									["G"] = "list_bottom",
									["gg"] = "list_top",
									["i"] = "focus_input",
									["j"] = "list_down",
									["k"] = "list_up",
									["q"] = "close",
									["zb"] = "list_scroll_bottom",
									["zt"] = "list_scroll_top",
									["zz"] = "list_scroll_center",
								},
								wo = {
									conceallevel = 2,
									concealcursor = "nvc",
								},
							},
							-- preview window
							preview = {
								keys = {
									["<Esc>"] = "cancel",
									["q"] = "close",
									["i"] = "focus_input",
									["<a-w>"] = "cycle_win",
								},
							},
						},
					},
					animation = { enabled = true },
					bigfile = { enabled = true },
					explorer = { enabled = true },
					notifier = { enabled = true },
					quickfile = { enabled = true },
					statuscolumn = {
						enabled = true,
						left = { "sign" },   -- priority of signs on the left (high to low)
						right = { "fold", "git" }, -- priority of signs on the right (high to low)
						folds = {
							open = true,       -- show open fold icons
							git_hl = false,    -- use Git Signs hl for fold icons
						},
						git = {
							-- patterns to match Git signs
							patterns = { "GitSign", "MiniDiffSign" },
						},
						refresh = 50, -- refresh at most every 50ms
					},
					dashboard = {
						enabled = true,
						autokeys = "123456789asdfghjkl",
						preset = {
							keys = {
								{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
								{ icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
								{ icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent({ filter = { cwd = vim.fn.getcwd() } })" },
								{ icon = "", key = "w", desc = "Workspaces", action = ":lua require('app.workspace').picker()" },
								-- { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
								-- { icon = " ", key = "s", desc = "Restore Session", section = "session" },
								{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
							}
						},
						sections = {
							{ section = "header" },
							{ section = "keys", gap = 0, padding = 2 },
							{ pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
							{ pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
							{ section = "startup" },
						},
					},
					words = {
						enabled = true,     -- enable/disable the plugin
						debounce = 200,      -- time in ms to wait before updating
						notify_jump = false, -- show a notification when jumping
						notify_end = true,   -- show a notification when reaching the end
						foldopen = true,     -- open folds after jumping
						jumplist = true,     -- set jump point before jumping
						modes = { "n", "i", "c" }, -- modes to show references
					},
					styles = {
						default = {
							border = "none",
						},
						notification = {
							focusable = false,
						},
					}
				}

				return config;
			end,
			init = function()
				vim.api.nvim_create_autocmd("User", {
					pattern = "VeryLazy",
					callback = function()
						-- Setup some globals for debugging (lazy-loaded)
						_G.dd = function(...)
							Snacks.debug.inspect(...)
						end
						_G.bt = function()
							Snacks.debug.backtrace()
						end
						vim.print = _G.dd -- Override print to use snacks for `:=` command
						vim.ui.input = Snacks.input

						-- Rename events for mini files
						vim.api.nvim_create_autocmd("User", {
							pattern = "MiniFilesActionRename",
							callback = function(event)
								Snacks.rename.on_rename_file(event.data.from, event.data.to)
							end,
						})

						-- Rename events for nvim-tree
						local prev = { new_name = "", old_name = "" } -- Prevents duplicate events
						vim.api.nvim_create_autocmd("User", {
							pattern = "NvimTreeSetup",
							callback = function()
								local events = require("nvim-tree.api").events
								events.subscribe(events.Event.NodeRenamed, function(data)
									if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
										data = data
										Snacks.rename.on_rename_file(data.old_name, data.new_name)
									end
								end)
							end,
						})

						vim.api.nvim_create_autocmd("QuickFixCmdPost", {
							callback = function()
								Snacks.picker.qflist()
							end,
						})

						-- Create some toggle mappings
						Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
						Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
						Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
						Snacks.toggle.diagnostics():map("<leader>ud")
						Snacks.toggle.line_number():map("<leader>ul")
						Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
								:map("<leader>uc")
						Snacks.toggle.treesitter():map("<leader>uT")
						Snacks.toggle.option("background", {
							off = "light",
							on = "dark",
							name = "Dark Background"
						}):map("<leader>ub")
						Snacks.toggle.option("cursorline", {
							name = "Cursor Line"
						}):map("<leader>uc")
						Snacks.toggle.option("paste", {
							name = "Paste Mode"
						}):map("<leader>up")
						Snacks.toggle.inlay_hints():map("<leader>uh")
						Snacks.toggle.indent():map("<leader>ug")
						Snacks.toggle.dim():map("<leader>uD")
						Snacks.toggle.zen():map("<leader>uz")
						Snacks.toggle({
							name = 'mini.diff overlay',
							get = function()
								return require('mini.diff').get_overlay_visibility()
							end,
							set = function(value)
								return require('mini.diff').set_overlay_visibility(value)
							end,
						}):map("<leader>ud")
						Snacks.toggle({
							name = 'mini.indentscope',
							get = function()
								return not vim.g.miniindentscope_disable
							end,
							set = function(value)
								vim.g.miniindentscope_disable = value
							end,
						}):map("<leader>ui")
					end,
				})
			end,
		},
		{
			"chrisgrieser/nvim-various-textobjs",
			lazy = false,
			opts = { keymaps = { useDefaults = true } },
		},
		{
			"nvim-neorg/neorg",
			version = "*", -- Pin Neorg to the latest stable release
			opts = {},
			ft = { 'neorg' },
		},
		{
			"folke/noice.nvim",
			event = "VeryLazy",
			opts = {
				-- add any options here
			},
			-- dependencies = {
			--   "rcarriga/nvim-notify",
			-- }
		},
		{
			"folke/trouble.nvim",
			specs = {
				"folke/snacks.nvim",
				opts = function(_, opts)
					return vim.tbl_deep_extend("force", opts or {}, {
						picker = {
							actions = require("trouble.sources.snacks").actions,
							win = {
								input = {
									keys = {
										["<c-t>"] = {
											"trouble_open",
											mode = { "n", "i" },
										},
									},
								},
							},
						},
					})
				end,
			},
			---@module 'trouble'
			---@type trouble.Config
			opts = {
				focus = true,
				win = {
					type = "split",
					position = "right",
					size = { width = 0.35 },
				},
				preview = {
					type = "split",
					relative = "win",
					position = "bottom",
					size = { height = 0.35 },
				},
				modes = {
					diagnostics_buffer = {
						mode = "diagnostics", -- inherit from diagnostics mode
						filter = { buf = 0 }, -- filter diagnostics to the current buffer
					},
					preview_float = {
						mode = "diagnostics",
						preview = {
							type = "float",
							relative = "editor",
							border = "squared",
							title = "Preview",
							title_pos = "center",
							position = { 0, -2 },
							size = { width = 0.3, height = 0.3 },
							zindex = 200,
						},
					},
				}
			},
		},
		{
			'natecraddock/workspaces.nvim',
			init = function()
				-- returns true if `dir` is a child of `parent`
				local is_dir_in_parent = function(dir, parent)
					if parent == nil then return false end
					local ws_str_find, _ = string.find(dir, parent, 1, true)
					if ws_str_find == 1 then
						return true
					else
						return false
					end
				end

				-- convenience function which wraps is_dir_in_parent with active file
				-- and workspace.
				local current_file_in_ws = function()
					local workspaces = require('workspaces')
					local ws_path = require('workspaces.util').path
					local current_ws = workspaces.path()
					local current_file_dir = ws_path.parent(vim.fn.expand('%:p', true))

					return is_dir_in_parent(current_file_dir, current_ws)
				end

				-- set workspace when changing buffers
				local my_ws_grp = vim.api.nvim_create_augroup("my_ws_grp", { clear = true })
				vim.api.nvim_create_autocmd({ "BufEnter", "VimEnter" }, {
					callback = function()
						-- do nothing if not file type
						local buf_type = vim.api.nvim_get_option_value("buftype", { buf = 0 })
						if (buf_type ~= "" and buf_type ~= "acwrite") then
							return
						end

						-- do nothing if already within active workspace
						if current_file_in_ws() then
							return
						end

						local workspaces = require('workspaces')
						local ws_path = require('workspaces.util').path
						local current_file_dir = ws_path.parent(vim.fn.expand('%:p', true))

						-- filtered_ws contains workspace entries that contain current file
						local filtered_ws = vim.tbl_filter(function(entry)
							return is_dir_in_parent(current_file_dir, entry.path)
						end, workspaces.get())

						-- select the longest match
						local selected_workspace = nil
						for _, value in pairs(filtered_ws) do
							if not selected_workspace then
								selected_workspace = value
							end
							if string.len(value.path) > string.len(selected_workspace.path) then
								selected_workspace = value
							end
						end

						if selected_workspace then workspaces.open(selected_workspace.name) end
					end,

					group = my_ws_grp
				})



				require("workspaces").setup(
					{
						-- path to a file to store workspaces data in
						-- on a unix system this would be ~/.local/share/nvim/workspaces
						path = vim.fn.stdpath("data") .. "/workspaces",

						-- to change directory for nvim (:cd), or only for window (:lcd)
						-- deprecated, use cd_type instead
						-- global_cd = true,

						-- controls how the directory is changed. valid options are "global", "local", and "tab"
						--   "global" changes directory for the neovim process. same as the :cd command
						--   "local" changes directory for the current window. same as the :lcd command
						--   "tab" changes directory for the current tab. same as the :tcd command
						--
						-- if set, overrides the value of global_cd
						cd_type = "global",

						-- sort the list of workspaces by name after loading from the workspaces path.
						sort = true,

						-- sort by recent use rather than by name. requires sort to be true
						mru_sort = true,

						-- option to automatically activate workspace when opening neovim in a workspace directory
						auto_open = true,

						-- option to automatically activate workspace when changing directory not via this plugin
						-- set to "autochdir" to enable auto_dir when using :e and vim.opt.autochdir
						-- valid options are false, true, and "autochdir"
						auto_dir = true,

						-- enable info-level notifications after adding or removing a workspace
						notify_info = true,

						-- lists of hooks to run after specific actions
						-- hooks can be a lua function or a vim command (string)
						-- lua hooks take a name, a path, and an optional state table
						-- if only one hook is needed, the list may be omitted
						hooks = {
							add = {},
							remove = {},
							rename = {},
							open_pre = {},
							open = {
								-- do not run hooks if file already in active workspace
								function()
									if current_file_in_ws() then
										return false
									end
								end,
								function(name)
									Snacks.notifier.notify(
										"Workspace changed to: " .. name,
										"info",
										{ title = "Workspaces" }
									)
								end,
							}
						},
					})
			end
		},
		{
			'echasnovski/mini.surround',
			version = '*',
			opts = {
				mappings = {
					add = 'sa',       -- Add surrounding in Normal and Visual modes
					delete = 'sd',    -- Delete surrounding
					find = 'sf',      -- Find surrounding (to the right)
					find_left = 'sF', -- Find surrounding (to the left)
					highlight = 'sh', -- Highlight surrounding
					replace = 'sr',   -- Replace surrounding
					update_n_lines = 'sn', -- Update `n_lines`

					suffix_last = 'l', -- Suffix to search with "prev" method
					suffix_next = 'n', -- Suffix to search with "next" method
				},

				search_method = "cover_or_next",

			},

			keys = function(_, keys)
				-- Populate the keys based on the user's options
				local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
				local opts = require("lazy.core.plugin").values(plugin, "opts", false)
				local mappings = {
					{ opts.mappings.add,            desc = "Add surrounding",                     mode = { "n", "v" } },
					{ opts.mappings.delete,         desc = "Delete surrounding" },
					{ opts.mappings.find,           desc = "Find right surrounding" },
					{ opts.mappings.find_left,      desc = "Find left surrounding" },
					{ opts.mappings.highlight,      desc = "Highlight surrounding" },
					{ opts.mappings.replace,        desc = "Replace surrounding" },
					{ opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
				}
				mappings = vim.tbl_filter(function(m)
					return m[1] and #m[1] > 0
				end, mappings)
				return vim.list_extend(mappings, keys)
			end,
			init = function()
				local custom_surroundings = {
					{
						filetype = { "typescriptreact", "typescript" },
						T = {
							output = function()
								local function_name = MiniSurround.user_input('Type name:')
								return { left = function_name .. '<', right = '>' }
							end
						},
					},
					{
						filetype = { "markdown" },
						["B"] = { -- Surround for bold
							input = { "%*%*().-()%*%*" },
							output = { left = "**", right = "**" },
						},
						["I"] = { -- Surround for italics
							input = { "%_().-()%_" },
							output = { left = "_", right = "_" },
						},
						["M"] = { -- Surround for monospace
							input = { "%`().-()%`" },
							output = { left = "`", right = "`" },
						},
						["L"] = {
							input = { "%[().-()%]%([^)]+%)" },
							output = function()
								local href = require("mini.surround").user_input("Href")
								return {
									left = "[",
									right = "](" .. href .. ")",
								}
							end,
						},
						["R"] = {
							input = { "%[().-()%]%[[^)]+%]" },
							output = function()
								local label = require("mini.surround").user_input("Label")
								return {
									left = "[",
									right = "][" .. label .. "]",
								}
							end,
						},
					},
				}
				vim.api.nvim_create_autocmd("FileType", {
					group = vim.api.nvim_create_augroup("dotfiles-mini_surround", {}),
					pattern = vim.fn.join(_.flat_map(function(item)
						return item.filetype
					end, custom_surroundings), ","),
					callback = function()
						local ft = vim.opt.filetype:get()
						vim.b.minisurround_config = {
							custom_surroundings = _.find(
								function(item)
									return _.contains(ft, item.filetype)
								end,
								custom_surroundings
							),
						}
					end,
				})
			end,
		},
		{
			'yioneko/nvim-vtsls',
			ft = {
				"typescript",
				"typescriptreact",
				"javascript",
				"javascriptreact"
			}
		},
		{ 'echasnovski/mini.icons', version = '*', opts = {} },
		{
			'echasnovski/mini.diff',
			version = '*',
			opts = {},
			event = { "BufReadPost", "BufNewFile", "BufWritePre" }
		},
		{ 'echasnovski/mini-git',   version = '*', main = 'mini.git', opts = {} },
		{ 'echasnovski/mini.ai',    version = '*', opts = {} },
		{
			'echasnovski/mini.align',
			enable = false,
			version = '*',
			opts = { mappings = { start = 'gt', start_with_preview = 'gT', } }
		},
		{ 'echasnovski/mini.comment',   version = '*', opts = {} },
		{ 'echasnovski/mini.splitjoin', version = '*', opts = {} },
		{
			'linrongbin16/lsp-progress.nvim',
			opts = {},
		},
		{
			'echasnovski/mini.operators',
			version = '*',
			enable = false,
			opts = {
				-- Each entry configures one operator.
				-- `prefix` defines keys mapped during `setup()`: in Normal mode
				-- to operate on textobject and line, in Visual - on selection.

				-- Evaluate text and replace with output
				evaluate = {
					prefix = '',

					-- Function which does the evaluation
					func = nil,
				},

				-- Exchange text regions
				exchange = {
					prefix = '',

					-- Whether to reindent new text to match previous indent
					reindent_linewise = true,
				},

				-- Multiply (duplicate) text
				multiply = {
					prefix = '',

					-- Function which can modify text before multiplying
					func = nil,
				},

				-- Replace text with register
				replace = {
					prefix = '',

					-- Whether to reindent new text to match previous indent
					reindent_linewise = true,
				},

				-- Sort text
				sort = {
					prefix = '',

					-- Function which does the sort
					func = nil,
				}
			}
		},
		-- {
		-- 	"zeioth/garbage-day.nvim",
		-- 	enable = false,
		-- 	event = "VeryLazy",
		-- 	opts = {
		-- 		exclude_lsp_clients = {
		-- 			"null-ls",
		-- 			"jdtls",
		-- 			"marksman",
		-- 			"lua_ls",
		-- 			"copilot",
		-- 		},
		-- 	}
		-- },
		{
			'chrisgrieser/nvim-rulebook',
			lazy = true,
			event = "VeryLazy",
			opts = {},
		},
		{
			"antosha417/nvim-lsp-file-operations",
			event = "VeryLazy",
			opts = {},
		}, {
		'nanozuki/tabby.nvim',
		event = 'VeryLazy',
		opts = {
			icons_enabled = true,
		},
		config = function()
			vim.opt.sessionoptions = 'curdir,folds,globals,help,tabpages,terminal,winsize'
			local theme = {
				fill = 'TabLineFill',
				head = 'TabLine',
				current_tab = 'TabLineSel',
				tab = 'TabLine',
				win = 'TabLine',
				tail = 'TabLine',
			}
			require('tabby.tabline').set(function(line)
				return {
					{
						{ '  ', hl = theme.head },
						line.sep('', theme.head, theme.fill),
					},
					line.tabs().foreach(function(tab)
						local hl = tab.is_current() and theme.current_tab or theme.tab
						return {
							line.sep('', hl, theme.fill),
							-- tab.is_current() and '' or '󰆣',
							tab.number(),
							tab.current_win().buf_name(),
							margin = '  ',
							tab.current_win().file_icon(),
							line.sep('', hl, theme.fill),
							hl = hl,
						}
					end),
					line.spacer(),
					line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
						return {
							line.sep('', theme.win, theme.fill),
							win.file_icon(),
							margin = '  ',
							-- win.is_current() and '' or '',
							win.buf_name(),
							line.sep('', theme.win, theme.fill),
							hl = theme.win,
						}
					end),
					{
						line.sep('', theme.tail, theme.fill),
						{ '  ', hl = theme.tail },
					},
					hl = theme.fill,
				}
			end, {
				buf_name = {
					mode = 'unique',
				},
			})
		end,
	},
		{
			"OlegGulevskyy/better-ts-errors.nvim",
			ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
			config = {
				keymaps = {
					toggle = '<leader>dd',     -- default '<leader>dd'
					go_to_definition = '<leader>dx' -- default '<leader>dx'
				}
			}
		},
		-- require('settings.catppuccin').setup(),
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					{ path = "snacks.nvim", words = { "Snacks" } },
					{ path = "LazyVim",     words = { "LazyVim" } },
				},
			},
		},
		{
			"olimorris/codecompanion.nvim",
			cmd = {
				"CodeCompanion",
				"CodeCompanionChat",
				"CodeCompanionActions",
				"CodeCompanionCmd",
			},
			opts = {
				strategies = {
					chat = {
						adapter = "copilot",
					},
					inline = {
						adapter = "copilot",
					},
				},
				display = {
					chat = {
						window = {
							layout = 'float',
						},
						intro_message = "",
					},
					action_pallete = {
						provider = 'default'
					}
				},
				slash_commands = {
					buffer = {
						provider = 'snacks',
					}
				},
				diff = {
					enabled = false,
					close_chat_at = 240,
					layout = "vertical",
					opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
					provider = "mini_diff",
				},
			},
		},
		{
			"OXY2DEV/markview.nvim",
			lazy = false,
			opts = {
				preview = {
					filetypes = { "markdown", "codecompanion" },
					ignore_buftypes = {},
				},
			},
		},
		{
			'nvim-pack/nvim-spectre',
			lazy = true,
			cmd = { "Spectre" },
			opts = {
				color_devicons   = true,
				open_cmd         = 'vnew', -- can also be a lua function
				live_update      = false, -- auto execute search again when you write to any file in vim
				lnum_for_results = true, -- show line number for search/replace results
				line_sep_start   = '┌────────────────────────────────────────',
				result_padding   = '│  ',
				line_sep         = '└────────────────────────────────────────',
				mapping          = {
					['tab'] = {
						map = '<Tab>',
						cmd = "<cmd>lua require('spectre').tab()<cr>",
						desc = 'next query'
					},
					['shift-tab'] = {
						map = '<S-Tab>',
						cmd = "<cmd>lua require('spectre').tab_shift()<cr>",
						desc = 'previous query'
					},
					-- ['toggle_line'] = {
					-- 	map = "dd",
					-- 	cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
					-- 	desc = "toggle item"
					-- },
					['enter_file'] = {
						map = "<cr>",
						cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
						desc = "open file"
					},
					['send_to_qf'] = {
						map = "",
						cmd = "",
						desc = "send all items to quickfix"
					},
					['replace_cmd'] = {
						map = "<leader>c",
						cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
						desc = "input replace command"
					},
					['show_option_menu'] = {
						map = "<leader>o",
						cmd = "<cmd>lua require('spectre').show_options()<CR>",
						desc = "show options"
					},
					['run_current_replace'] = {
						map = "<leader>rc",
						cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
						desc = "replace current line"
					},
					['run_replace'] = {
						map = "<leader>R",
						cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
						desc = "replace all"
					},
					['change_view_mode'] = {
						map = "<leader>v",
						cmd = "<cmd>lua require('spectre').change_view()<CR>",
						desc = "change result view mode"
					},
					['change_replace_sed'] = {
						map = "trs",
						cmd = "<cmd>lua require('spectre').change_engine_replace('sed')<CR>",
						desc = "use sed to replace"
					},
					['change_replace_oxi'] = {
						map = "tro",
						cmd = "<cmd>lua require('spectre').change_engine_replace('oxi')<CR>",
						desc = "use oxi to replace"
					},
					['toggle_live_update'] = {
						map = "tu",
						cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
						desc = "update when vim writes to file"
					},
					['toggle_ignore_case'] = {
						map = "ti",
						cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
						desc = "toggle ignore case"
					},
					['toggle_ignore_hidden'] = {
						map = "th",
						cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
						desc = "toggle search hidden"
					},
					['resume_last_search'] = {
						map = "<leader>l",
						cmd = "<cmd>lua require('spectre').resume_last_search()<CR>",
						desc = "repeat last search"
					},
					['select_template'] = {
						map = '<leader>rp',
						cmd = "<cmd>lua require('spectre.actions').select_template()<CR>",
						desc = 'pick template',
					},
					['delete_line'] = {
						map = '<leader>rd',
						cmd = "<cmd>lua require('spectre.actions').run_delete_line()<CR>",
						desc = 'delete line',
					}
					-- you can put your mapping here it only use normal mode
				},
				default          = {
					find = {
						cmd = "rg",
					},
					replace = {
						cmd = "sed"
					}
				},
				find_engine      = {
					-- rg is map with finder_cmd
					['rg'] = {
						cmd = "rg",
						-- default args
						args = {
							'--color=never',
							'--no-heading',
							'--with-filename',
							'--line-number',
							'--column',
							'--pcre2'
						},
						options = {
							['ignore-case'] = {
								value = "--ignore-case",
								icon = "[I]",
								desc = "ignore case"
							},
							['hidden'] = {
								value = "--hidden",
								desc = "hidden file",
								icon = "[H]"
							},
							-- you can put any rg search option you want here it can toggle with
							-- show_option function
						}
					},
				},
				open_template    = {
					-- an template to use on open function
					-- see the 'custom function' section below to learn how to configure the template
					-- { search_text = 'text1', replace_text = '', path = "" }
				}
			}
		},
		{
			"sindrets/diffview.nvim",
			cmd = {
				"DiffviewOpen",
				"DiffviewClose",
				"DiffviewToggleFiles",
				"DiffviewFocusFiles",
				"DiffviewRefresh",
				"DiffviewFileHistory"
			}
		},
		{
			'mikesmithgh/kitty-scrollback.nvim',
			enabled = true,
			lazy = true,
			cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth', 'KittyScrollbackGenerateCommandLineEditing' },
			event = { 'User KittyScrollbackLaunch' },
			version = '*', -- latest stable version, may have breaking changes if major version changed
			opts = {},
		},
		{
			'dmmulroy/tsc.nvim',
			lazy = true,
			cmd = { "TSC", "TSCOpen", "TSCClose" },
			opts = {
				use_trouble_qflist = false,
			}
		},
		{
			'MagicDuck/grug-far.nvim',
			config = function()
				require('grug-far').setup({
					-- options, see Configuration section below
					-- there are no required options atm
					-- engine = 'ripgrep' is default, but 'astgrep' can be specified
					keymaps = {
						replace = { n = '<leader>w' },
						qflist = false,
						syncLocations = { n = '<leader>s' },
						syncLine = { n = '<leader>l' },
						close = { n = '<leader>q' },
						historyOpen = { n = '<leader>t' },
						historyAdd = { n = '<leader>a' },
						refresh = { n = '<leader>f' },
						openLocation = { n = '<leader>o' },
						openNextLocation = { n = '<down>' },
						openPrevLocation = { n = '<up>' },
						gotoLocation = { n = '<enter>' },
						pickHistoryEntry = { n = '<enter>' },
						abort = { n = '<leader>b' },
						help = { n = 'g?' },
						toggleShowCommand = { n = '<leader>p' },
						swapEngine = { n = '<leader>e' },
						previewLocation = { n = '<leader>i' },
						swapReplacementInterpreter = { n = '<leader>x' },
						applyNext = { n = '<leader>j' },
						applyPrev = { n = '<leader>k' },
					},
				});
			end
		},
		{
			'pteroctopus/faster.nvim',
			opts = {
				-- Behaviour table contains configuration for behaviours faster.nvim uses
				behaviours = {
					-- Bigfile configuration controls disabling and enabling of features when
					-- big file is opened
					bigfile = {
						-- Behaviour can be turned on or off. To turn on set to true, otherwise
						-- set to false
						on = true,
						-- Table which contains names of features that will be disabled when
						-- bigfile is opened. Feature names can be seen in features table below.
						-- features_disabled can also be set to "all" and then all features that
						-- are on (on=true) are going to be disabled for this behaviour
						features_disabled = {
							"illuminate", "matchparen", "lsp", "treesitter",
							"indent_blankline", "vimopts", "syntax", "filetype"
						},
						-- Files larger than `filesize` are considered big files. Value is in MB.
						filesize = 2,
						-- Autocmd pattern that controls on which files behaviour will be applied.
						-- `*` means any file.
						pattern = "*",
						-- Optional extra patterns and sizes for which bigfile behaviour will apply.
						-- Note! that when multiple patterns (including the main one) and filesizes
						-- are defined: bigfile behaviour will be applied for minimum filesize of
						-- those defined in all applicable patterns for that file.
						-- extra_pattern example in multi line comment is bellow:
						--[[
      extra_patterns = {
        -- If this is used than bigfile behaviour for *.md files will be
        -- triggered for filesize of 1.1MiB
        { filesize = 1.1, pattern = "*.md" },
        -- If this is used than bigfile behaviour for *.log file will be
        -- triggered for the value in `behaviours.bigfile.filesize`
        { pattern  = "*.log" },
        -- Next line is invalid without the pattern and will be ignored
        { filesize = 3 },
      },
      ]]
						-- By default `extra_patterns` is an empty table: {}.
						extra_patterns = {
							{ pattern = "kitty-scrollback" }
						},
					},
					-- Fast macro configuration controls disabling and enabling features when
					-- macro is executed
					fastmacro = {
						-- Behaviour can be turned on or off. To turn on set to true, otherwise
						-- set to false
						on = true,
						-- Table which contains names of features that will be disabled when
						-- macro is executed. Feature names can be seen in features table below.
						-- features_disabled can also be set to "all" and then all features that
						-- are on (on=true) are going to be disabled for this behaviour.
						-- Specificaly: lualine plugin is disabled when macros are executed because
						-- if a recursive macro opens a buffer on every iteration this error will
						-- happen after 300-400 hundred iterations:
						-- `E5108: Error executing lua Vim:E903: Process failed to start: too many open files: "/usr/bin/git"`
						features_disabled = { "lualine" },
					}
				},
				-- Feature table contains configuration for features faster.nvim will disable
				-- and enable according to rules defined in behaviours.
				-- Defined feature will be used by faster.nvim only if it is on (`on=true`).
				-- Defer will be used if some features need to be disabled after others.
				-- defer=false features will be disabled first and defer=true features last.
				features = {
					-- Neovim filetype plugin
					-- https://neovim.io/doc/user/filetype.html
					filetype = {
						on = true,
						defer = true,
					},
					-- Illuminate plugin
					-- https://github.com/RRethy/vim-illuminate
					illuminate = {
						on = true,
						defer = false,
					},
					-- Indent Blankline
					-- https://github.com/lukas-reineke/indent-blankline.nvim
					indent_blankline = {
						on = true,
						defer = false,
					},
					-- Neovim LSP
					-- https://neovim.io/doc/user/lsp.html
					lsp = {
						on = true,
						defer = false,
					},
					-- Lualine
					-- https://github.com/nvim-lualine/lualine.nvim
					lualine = {
						on = true,
						defer = false,
					},
					-- Neovim Pi_paren plugin
					-- https://neovim.io/doc/user/pi_paren.html
					matchparen = {
						on = true,
						defer = false,
					},
					-- Neovim syntax
					-- https://neovim.io/doc/user/syntax.html
					syntax = {
						on = true,
						defer = true,
					},
					-- Neovim treesitter
					-- https://neovim.io/doc/user/treesitter.html
					treesitter = {
						on = true,
						defer = false,
					},
					-- Neovim options that affect speed when big file is opened:
					-- swapfile, foldmethod, undolevels, undoreload, list
					vimopts = {
						on = true,
						defer = false,
					}
				}
			}
		},
		{
			"CopilotC-Nvim/CopilotChat.nvim",
			build = "make tiktoken", -- Only on MacOS or Linux
			opts = {
				-- See Configuration section for options
			},
			cmd = {
				'CopilotChat',
				'CopilotChatOpen',
				'CopilotChatClose',
				'CopilotChatToggle',
				'CopilotChatStop',
				'CopilotChatReset',
				'CopilotChatSave',
				'CopilotChatLoad',
				'CopilotChatPrompts',
				'CopilotChatModels',
				'CopilotChatAgents'
			}
		},
		{
			"gbprod/yanky.nvim",
			opts = {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			},
		},
		{
			"folke/tokyonight.nvim",
			lazy = false,
			priority = 1000,
			opts = {
				style = 'storm',
				styles = {
					-- Style to be applied to different syntax groups
					-- Value is any valid attr-list value for `:help nvim_set_hl`
					comments = { italic = true },
					keywords = { italic = true },
					functions = { italic = true },
					variables = { italic = false },
					sidebars = "dark", -- style for sidebars, see below
					floats = "dark", -- style for floating windows
				},
				day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
				dim_inactive = true, -- dims inactive windows
				lualine_bold = true,
				on_highlights = function(highlights, colors)
					local tokyo_colors                 = require('tokyonight.colors').setup()
					local input_bg                     = tokyo_colors.bg_highlight
					local input_fg                     = tokyo_colors.fg
					local float_bg                     = tokyo_colors.bg_sidebar
					local float_fg                     = tokyo_colors.fg
					local title_bg                     = tokyo_colors.blue7
					local title_fg                     = tokyo_colors.orange

					highlights.SnacksPickerInput       = { bg = input_bg, fg = input_fg }
					highlights.SnacksPickerInputBorder = { bg = input_bg, fg = input_fg }
					highlights.SnacksPickerInputBorder = { bg = input_bg, fg = input_bg }

					highlights.SnacksPickerPrompt      = { bg = input_bg, fg = tokyo_colors.orange }

					highlights.SnacksPickerBoxBorder   = { bg = float_bg, fg = float_bg }


					highlights.SnacksPickerList              = { bg = float_bg }
					highlights.SnacksPickerListCursorLine    = { bg = tokyo_colors.blue7 }

					highlights.SnacksPickerPreviewBorder     = { bg = float_bg, fg = float_bg }

					highlights.SnacksPickerBoxTitle          = { bg = title_bg, fg = title_fg, bold = true }
					highlights.SnacksPickerInputTitle        = { bg = title_bg, fg = title_fg, bold = true }
					highlights.SnacksPickerPreviewTitle      = { bg = title_bg, fg = title_fg, bold = true }

					highlights.NoiceCmdlinePopupBorder       = { bg = input_bg, fg = input_bg }
					highlights.NoiceCmdlinePopup             = { bg = input_bg, fg = input_fg }
					highlights.NoiceCmdlinePopupBorderLua    = { bg = input_bg, fg = input_bg }
					highlights.NoiceCmdlinePrompt            = { bg = input_bg, fg = input_fg }
					highlights.NoiceCmdlineTitle             = { bg = title_bg, fg = title_fg, bold = true }
					highlights.NoicePopupTitleInput          = { bg = title_bg, fg = title_fg, bold = true }
					highlights.NoicePopupTitleLua            = { bg = title_bg, fg = title_fg, bold = true }
					highlights.NoiceCmdlinePopupBorderSearch = { bg = input_bg, fg = input_bg }
					highlights.NoiceCmdlinePopupTitleSearch  = { bg = title_bg, fg = title_fg, bold = true }
					highlights.NoiceCmdlinePopupTitleLua     = { bg = title_bg, fg = title_fg, bold = true }
					highlights.NoicePopupTitleLua            = { bg = title_bg, fg = title_fg, bold = true }

					highlights.MiniHipatternsBiomeIgnore     = { bg = '#FFFFFF', fg = tokyo_colors.red, bold = true, italic = false }

					local function test()
						local tokyo_colors = require('tokyonight.colors').setup()
						-- local input_bg = '#23273b'
						-- local input_fg = '#C0CAF5'

						local input_bg = tokyo_colors.bg_search
						local input_fg = tokyo_colors.fg

						vim.api.nvim_set_hl(0, 'SnacksPickerInputBorder', { bg = input_bg, fg = input_bg })
						vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupBorder', { bg = input_bg, fg = input_bg })
						vim.api.nvim_set_hl(0, 'NoiceCmdlinePopup', { bg = input_bg, fg = input_bg })
						vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupBorderLua', { bg = input_bg, fg = input_bg })
						vim.api.nvim_set_hl(0, 'NoiceCmdlinePopup', { bg = input_bg, fg = input_bg })
						vim.api.nvim_set_hl(0, 'NoiceCmdlinePrompt', { bg = input_bg, fg = input_fg })
					end

					-- test()

					-- Colors for Snacks pickers
					-- highlights.SnacksPickerBoxTitle = { bg = '#1c99f2', fg = '#ffffff', bold = true }
					-- highlights.SnacksPickerBoxBorder = { bg = '#23273b', fg = '#23273b' }
					-- highlights.SnacksPickerListBorder = { bg = '#262e46', fg = '#23273b' }
					-- highlights.SnacksPickerPreviewBorder = { bg = '#23273b', fg = '#23273b' }
					-- highlights.SnacksPickerList = { bg = '#262e46' }
					-- highlights.SnacksPickerInputTitle = { bg = '#1c99f2', fg = '#ffffff', bold = true }
					-- highlights.SnacksPickerListCursorLine = { bg = '#1a1d2f' }
					-- highlights.SnacksPickerPrompt = { bg = '#23273b', fg = '#1c99f2' }
					--
					-- highlights.NoiceCmdlinePopupBorder = { bg = '#23273b', fg = '#23273b' }
					-- highlights.NoiceCmdlinePrompt = { bg = '#23273b', }
					-- highlights.NoiceCmdline = { bg = '#23273b', }
				end,
			},
			init = function()
				vim.cmd.colorscheme('tokyonight')
			end
		},
		{
			"pmizio/typescript-tools.nvim",
		},
		{
			's1n7ax/nvim-window-picker',
			name = 'window-picker',
			event = 'VeryLazy',
			version = '2.*',
			opts = {
				hint = 'statusline-winbar',
				selection_chars = 'asdfghjkl;',
				show_prompt = false,
			},
		},
		{
			"rmagatti/goto-preview",
			dependencies = { "rmagatti/logger.nvim" },
			event = "BufEnter",
			config = true,
			opts = {
				default_mappings = false,
			}
		},
		{
			'echasnovski/mini.hipatterns',
			version = '*',
			config = function()
				local hipatterns = require('mini.hipatterns')
				hipatterns.setup({
					highlighters = {
						fixme        = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
						hack         = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
						todo         = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
						note         = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
						biome_ignore = { pattern = '%f[%S]biome%-ignore%f[%s]', group = 'MiniHipatternsBiomeIgnore' },
						hex_color    = hipatterns.gen_highlighter.hex_color(),
					},
				})
			end
		},
		{
			"tpope/vim-abolish",
			cmd = { "Abolish", "S", "Subvert" },
		}
	})
end



local function is_visual()
	local mode = vim.fn.mode()
	return mode:find("v") or mode:find("V") or mode:find("\\<C-v>")
end

function get_visual_selection()
	local _, srow, scol = unpack(vim.fn.getpos('v'))
	local _, erow, ecol = unpack(vim.fn.getpos('.'))

	-- visual line mode
	if vim.fn.mode() == 'V' then
		if srow > erow then
			return vim.api.nvim_buf_get_lines(0, erow - 1, srow, true)
		else
			return vim.api.nvim_buf_get_lines(0, srow - 1, erow, true)
		end
	end

	-- regular visual mode
	if vim.fn.mode() == 'v' then
		if srow < erow or (srow == erow and scol <= ecol) then
			return vim.api.nvim_buf_get_text(0, srow - 1, scol - 1, erow - 1, ecol, {})
		else
			return vim.api.nvim_buf_get_text(0, erow - 1, ecol - 1, srow - 1, scol, {})
		end
	end

	-- visual block mode
	if vim.fn.mode() == '\22' then
		local lines = {}
		if srow > erow then
			srow, erow = erow, srow
		end
		if scol > ecol then
			scol, ecol = ecol, scol
		end
		for i = srow, erow do
			table.insert(
				lines,
				vim.api.nvim_buf_get_text(0, i - 1, math.min(scol - 1, ecol), i - 1, math.max(scol - 1, ecol), {})[1]
			)
		end
		return lines
	end
end

function eval_lua_code(code)
	local f, err = load(code)
	if not f then
		return "Error: " .. err
	end
	return f() -- Execute the function and return the result
end

local function run_selected_code()
	local visual_selection = get_visual_selection()
	vim.print(visual_selection)
	eval_lua_code(vim.fn.join(visual_selection, "\n"))
end


-- Map the function to a visual mode keybinding
vim.keymap.set('v', '<space>=', run_selected_code, { noremap = true, silent = true })
vim.keymap.set('v', '<space>--', function()
	vim.print(get_visual_selection())
end, { noremap = true, silent = true })




return {
	setup = setup,
}
