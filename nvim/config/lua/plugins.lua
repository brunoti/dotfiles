---@diagnostic disable: missing-fields
--@diagnostic disable: missing-fields
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
		{
			"OXY2DEV/markview.nvim",
			lazy = false,
			priority = 1,
			opts = {
				preview = {
					filetypes = { "markdown", "codecompanion", "Avante" },
					ignore_buftypes = {},
				},
			},
			init = function()
			end
		},
		-- neovim tree sitter
		{
			"nvim-treesitter/nvim-treesitter",
			priority = 2,
			dependencies = {
				'nvim-treesitter/nvim-treesitter-textobjects'
			},
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
					textobjects = {
						enabled = true
					}
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
				icons = {
					File = '  ',
					Module = '  ',
					Namespace = '  ',
					Package = '  ',
					Class = '  ',
					Method = '  ',
					Property = '  ',
					Field = '  ',
					Constructor = '  ',
					Enum = '  ',
					Interface = '  ',
					Function = '  ',
					Variable = '  ',
					Constant = '  ',
					String = '  ',
					Number = '  ',
					Boolean = '  ',
					Array = '  ',
					Object = '  ',
					Key = '  ',
					Null = '  ',
					EnumMember = '  ',
					Struct = '  ',
					Event = '  ',
					Operator = '  ',
					TypeParameter = '  '
				},
				depth_limit = 0,
				highlight = true,
				separator = "  ",
				lazy_update_context = false,
				depth_limit_indicator = "[...]",
				space_output = true,
				click = true,
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
					theme = 'tokyonight-night',
					options = {
						component_separators = { left = '', right = '' },
						section_separators = { left = '', right = '' },
						always_divide_middle = false,
						globalstatus = true,
						disabled_filetypes = {
							winbar = {
								"snacks_terminal",
							},
							-- 'NvimTree',
							-- "grug-far",
							-- "grug-far-history",
							-- "grug-far-help",
							-- "dashboard",
							-- "trouble",
							-- "kitty-scrollback",
							-- "OverseerList",
							-- "Avante",
							-- "AvanteInput",
							-- "AvanteSelectedFiles",
							-- "AvantePromptInput",
							-- "codecompanion",
							-- "text.kulala_ui",
						},
					},
					sections = {
						lualine_x = {
							{
								"overseer",
								label = "",     -- Prefix for task counts
								colored = true, -- Color the task icons and counts
								symbols = {
									[overseer.STATUS.FAILURE] = " :",
									[overseer.STATUS.CANCELED] = " :",
									[overseer.STATUS.SUCCESS] = " :",
									[overseer.STATUS.RUNNING] = " :",
								},
								unique = false,     -- Unique-ify non-running task count by name
								name = nil,         -- List of task names to search for
								name_not = false,   -- When true, invert the name search
								status = nil,       -- List of task statuses to display
								status_not = false, -- When true, invert the status search
							},
							lualine_codecompanion_spinner(),
						},
						lualine_y = {
						},
						lualine_z = {
							'location'
						}
					},
					winbar = {
						lualine_c = {
							-- { "filename" },
							{
								"navic",
								color_correction = nil,
								navic_opts = nil
							}
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
				"Aider",
			},
			keys = {
				{ "<leader>a/", "<cmd>Aider toggle<cr>", desc = "Open Aider" },
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
				"mikavilpas/blink-ripgrep.nvim",
				'Kaiser-Yang/blink-cmp-avante',
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
					['<M-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
					['<M-a>'] = { function(cmp) cmp.show({ providers = { 'copilot', 'codeium', } }) end },
					['<M-s>'] = { function(cmp) cmp.show({ providers = { 'snippets' } }) end },
					['<M-l>'] = { function(cmp) cmp.show({ providers = { 'lsp' } }) end },
				},
				appearance = {
					-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
					-- Adjusts spacing to ensure icons are aligned
					nerd_font_variant = 'normal',
					use_nvim_cmp_as_default = false,
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
							columns = { { "kind_icon", "label" }, { "kind", "source_icon", "source_name", gap = 1 } },
							components = {
								kind = {
									ellipsis = false,
									width = { fill = true },
									text = function(ctx)
										local function uc_first(str)
											return (str:gsub("^%l", string.upper))
										end
										return '[' .. uc_first(ctx.kind) .. ']'
									end,
								},
								source_name = {
									ellipsis = false,
									text = function(ctx)
										local function uc_first(str)
											return (str:gsub("^%l", string.upper))
										end
										return '[' .. uc_first(ctx.kind) .. ']'
									end,
								},
								source_icon = {
									-- don't truncate source_icon
									ellipsis = false,
									text = function(ctx)
										local source_icons = {
											orgmode = '',
											otter = '󰼁',
											nvim_lsp = '',
											lsp = '',
											buffer = '',
											luasnip = '',
											snippets = '',
											path = '',
											git = '',
											tags = '',
											cmdline = '󰘳',
											latex_symbols = '',
											cmp_nvim_r = '󰟔',
											codeium = '󰩂',
											-- FALLBACK
											fallback = '󱧊',
										}
										local symbol = source_icons[ctx.source_name:lower()] or source_icons.fallback
										return symbol
									end,
									highlight = 'BlinkCmpSource',
								},
								kind_icon = {
									ellipsis = false,
									text = function(ctx)
										local extra_icons = {
											claude = '󰋦',
											openai = '󱢆',
											codestral = '󱎥',
											gemini = '',
											Groq = '',
											Openrouter = '󱂇',
											Ollama = '󰳆',
											['Llama.cpp'] = '󰳆',
											Deepseek = '',
											Codeium = "",
											AvanteCmd = '',
											AvanteMention = '',
											Avante = '',
										}

										local symbol = extra_icons[ctx.kind] or require('lspkind').symbolic(ctx.kind, {
											mode = 'symbol',
											preset = 'default'
										}) or "X"

										return " " .. symbol .. "  "
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
					default = {
						'lazydev',
						'lsp',
						'path',
						'buffer',
						'ripgrep',
						'copilot',
					},
					per_filetype = {
						minifiles = {
							'path',
							'buffer',
							'ripgrep',
						},
						codecompanion = {
							'codecompanion',
							'path',
							'buffer',
							'ripgrep',
						},
					},
					providers = {
						codecompanion = {
							name = "CodeCompanion",
							module = "codecompanion.providers.completion.blink",
							enabled = true,
							score_offset = 700,
						},
						lsp = {
							name = 'LSP',
							module = 'blink.cmp.sources.lsp',
							score_offset = 500,
							async = true,
						},
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
						codeium = {
							name = 'Codeium',
							module = 'codeium.blink',
							async = true,
							score_offset = 50,
						},
						lazydev = {
							name = "LazyDev",
							module = "lazydev.integrations.blink",
							-- make lazydev completions top priority (see `:h blink.cmp`)
							score_offset = 100,
						},
						ripgrep = {
							module = "blink-ripgrep",
							name = "Ripgrep",
							score_offset = 10,
							-- the options below are optional, some default values are shown
							---@module "blink-ripgrep"
							---@type blink-ripgrep.Options
							opts = {
								toggles = {
									-- The keymap to toggle the plugin on and off from blink
									-- completion results. Example: "<leader>tg"
									on_off = nil,
								},
								backend = {
									fallback_to_regex_highlighting = true,
									context_size = 5,
									rigpreg = {
										prefix_min_len = 3,
										max_filesize = "1M",
										project_root_marker = ".git",
										project_root_fallback = true,

										search_casing = "--ignore-case",

										additional_rg_options = {},
										ignore_paths = {},
										additional_paths = {},

									},

									use = "ripgrep",
								},
							},
						},
					},
				},
			},
		},
		{
			"zbirenbaum/copilot.lua",
			opts = {
				copilot_node_command = vim.fn.expand("$HOME") .. "/.asdf/installs/nodejs/22.14.0/bin/node",
				disable_limit_reached_message = true,
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
						accept = "<M-p>",
						accept_word = false,
						accept_line = false,
						next = "<M-k>",
						prev = "<M-j>",
						dismiss = "<M-;>",
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
			},
		},

		-- 'williamboman/mason.nvim',
		-- 'williamboman/mason-lspconfig.nvim',
		'neovim/nvim-lspconfig',
		'elentok/format-on-save.nvim',

		{
			"johmsalas/text-case.nvim",
			opts = {},
			cmd = { "Subs" },
			lazy = true,
		},
		{
			'nvim-mini/mini.files',
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
			'nvim-mini/mini.pairs',
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

				vim.keymap.set({ "i" }, "<C-k>", function() ls.expand() end, { silent = true })
				vim.keymap.set({ "i", "s" }, "<C-l>", function() ls.jump(1) end, { silent = true })
				vim.keymap.set({ "i", "s" }, "<C-j>", function() ls.jump(-1) end, { silent = true })

				vim.keymap.set({ "i", "s" }, "<C-e>", function()
					if ls.choice_active() then
						ls.change_choice(1)
					end
				end, { silent = true })
			end,
		},
		-- {
		-- 	'nvim-mini/mini.snippets',
		-- 	version = '*',
		-- 	dependencies = {
		-- 		'brunoti/friendly-snippets'
		-- 	},
		-- 	opts = {},
		-- },
		{
			'stevearc/overseer.nvim',
			config = function()
				local overseer = require 'overseer'
				overseer.setup()
				-- overseer.register_template({
				-- 	-- Required fields
				-- 	name = "Some Task",
				-- 	builder = function(params)
				-- 		-- This must return an overseer.TaskDefinition
				-- 		return {
				-- 			-- cmd is the only required field
				-- 			cmd = { 'echo' },
				-- 			-- additional arguments for the cmd
				-- 			args = { "hello", "world" },
				-- 			-- the name of the task (defaults to the cmd of the task)
				-- 			name = "Greet",
				-- 			-- set the working directory for the task
				-- 			-- the list of components or component aliases to add to the task
				-- 			components = { "default" },
				-- 		}
				-- 	end,
				-- 	-- Optional fields
				-- 	desc = "Optional description of task",
				-- 	-- Tags can be used in overseer.run_template()
				-- 	params = {
				-- 		-- See :help overseer-params
				-- 	},
				-- 	priority = 50,
				-- 	condition = {
				-- 		filetype = { "typescriptreact" },
				-- 	},
				-- })
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
				-- set_kind_hl()
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
						underline = false,   -- underline the start of the scope
						only_current = true, -- only show scope in the current window
					},
					input = { enabled = true },
					scroll = { enabled = false },
					chunk = { enable = true, priority = 200, only_current = true },
					picker = {
						enable = true,
						ui_select = true,
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
							select = {
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
					},
					animation = { enabled = true },
					bigfile = { enabled = true },
					explorer = { enabled = true },
					notifier = {
						enabled = true,
						level = vim.log.levels.DEBUG,
						style = "fancy"
					},
					quickfile = { enabled = true },
					statuscolumn = {
						enabled = true,
						left = { "sign" },         -- priority of signs on the left (high to low)
						right = { "fold", "git" }, -- priority of signs on the right (high to low)
						folds = {
							open = true,             -- show open fold icons
							git_hl = false,          -- use Git Signs hl for fold icons
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
							-- { pane = 2, icon = " ", title = "Sessions", section = 'session', indent = 2, padding = 2 },
							{ section = "startup" },
						},
					},
					words = {
						enabled = true,            -- enable/disable the plugin
						debounce = 200,            -- time in ms to wait before updating
						notify_jump = false,       -- show a notification when jumping
						notify_end = true,         -- show a notification when reaching the end
						foldopen = true,           -- open folds after jumping
						jumplist = true,           -- set jump point before jumping
						modes = { "n", "i", "c" }, -- modes to show references
					},
					zen = {
						toggles = {
							dim = false,
							git_signs = false,
							mini_diff_signs = false,
							line_number = false,
							indent = false,
						}
					},
					styles = {
						default = {
							border = "none",
						},
						notification = {
							focusable = false,
						},
						zen = {
							backdrop = { transparent = false }
						}
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
						Snacks.toggle.indent():map("<leader>ui")
						-- Snacks.toggle({
						-- 	name = 'mini.diff overlay',
						-- 	get = function()
						-- 		return require('mini.diff').get_overlay_visibility()
						-- 	end,
						-- 	set = function(value)
						-- 		return require('mini.diff').set_overlay_visibility(value)
						-- 	end,
						-- }):map("<leader>ud")
						-- Snacks.toggle({
						-- 	name = 'indent_scope',
						-- 	get = function()
						-- 		return not vim.g.miniindentscope_disable
						-- 	end,
						-- 	set = function(value)
						-- 		vim.g.miniindentscope_disable = value
						-- 		require("mini.indentscope").enable()
						-- 	end,
						-- }):map("<leader>ui")
					end,
				})
			end,
		},
		{
			"chrisgrieser/nvim-various-textobjs",
			lazy = false,
			opts = { keymaps = { useDefaults = false } },
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
						-- if starts_with(vim.bo.filetype, "Avante") then
						-- 	vim.api.nvim_set_current_dir(get_root())
						-- 	return
						-- end


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

						if selected_workspace then
							require('lib').run_command("BufferLineTabRename " .. selected_workspace.name)
							workspaces.open(selected_workspace.name)
						end
						-- Don't change directory if we didn't find a matching workspace
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
			'nvim-mini/mini.surround',
			version = '*',
			opts = {
				mappings = {
					add = 'sa',            -- Add surrounding in Normal and Visual modes
					delete = 'sd',         -- Delete surrounding
					find = 'sf',           -- Find surrounding (to the right)
					find_left = 'sF',      -- Find surrounding (to the left)
					highlight = 'sh',      -- Highlight surrounding
					replace = 'sr',        -- Replace surrounding
					update_n_lines = 'sn', -- Update `n_lines`

					suffix_last = 'l',     -- Suffix to search with "prev" method
					suffix_next = 'n',     -- Suffix to search with "next" method
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
		{ 'nvim-mini/mini.icons', version = '*', opts = {} },
		{
			'nvim-mini/mini.diff',
			version = '*',
			--- @module 'mini.diff'
			opts = {
				mappings = {
					mappings = {
						-- Apply hunks inside a visual/operator region
						apply = 'gh',

						-- Reset hunks inside a visual/operator region
						reset = 'gH',

						-- Hunk range textobject to be used inside operator
						-- Works also in Visual mode if mapping differs from apply and reset
						textobject = 'gh',

						-- Go to hunk range in corresponding direction
						goto_first = '[H',
						goto_prev = '[h',
						goto_next = ']h',
						goto_last = ']H',
					},

				}
			},
			event = { "BufReadPost", "BufNewFile", "BufWritePre" }
		},
		{ 'nvim-mini/mini-git',   version = '*', main = 'mini.git', opts = {} },
		{
			lazy = false,
			'nvim-mini/mini.ai',
			version = '*',
			init = function()
				local MiniAi = require('mini.ai')
				MiniAi.setup({
					custom_highlights = {
						w = '[a-zA-Z0-9_\\-\\?!]+',
						F = MiniAi.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }),
					}
				})
			end
		},
		{
			'nvim-mini/mini.align',
			enable = false,
			version = '*',
			opts = { mappings = { start = '<leader>al', start_with_preview = '<leader>aL', } }
		},
		{ 'nvim-mini/mini.comment',   version = '*', opts = {} },
		{ 'nvim-mini/mini.splitjoin', version = '*', opts = {} },
		{
			'linrongbin16/lsp-progress.nvim',
			opts = {},
		},
		{
			'nvim-mini/mini.operators',
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
		},
		-- 	 {
		-- 	'nanozuki/tabby.nvim',
		-- 	event = 'VeryLazy',
		-- 	opts = {
		-- 		icons_enabled = true,
		-- 	},
		-- 	config = function()
		-- 		vim.opt.sessionoptions = 'curdir,folds,globals,help,tabpages,terminal,winsize'
		-- 		local theme = {
		-- 			fill = 'TabLineFill',
		-- 			head = 'TabLine',
		-- 			current_tab = 'TabLineSel',
		-- 			tab = 'TabLine',
		-- 			win = 'TabLine',
		-- 			tail = 'TabLine',
		-- 		}
		-- 		require('tabby.tabline').set(function(line)
		-- 			return {
		-- 				{
		-- 					{ '  ', hl = theme.head },
		-- 					line.sep('', theme.head, theme.fill),
		-- 				},
		-- 				line.tabs().foreach(function(tab)
		-- 					local hl = tab.is_current() and theme.current_tab or theme.tab
		-- 					return {
		-- 						line.sep('', hl, theme.fill),
		-- 						-- tab.is_current() and '' or '󰆣',
		-- 						tab.number(),
		-- 						tab.current_win().buf_name(),
		-- 						margin = '  ',
		-- 						tab.current_win().file_icon(),
		-- 						line.sep('', hl, theme.fill),
		-- 						hl = hl,
		-- 					}
		-- 				end),
		-- 				line.spacer(),
		-- 				line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
		-- 					return {
		-- 						line.sep('', theme.win, theme.fill),
		-- 						win.file_icon(),
		-- 						margin = '  ',
		-- 						-- win.is_current() and '' or '',
		-- 						win.buf_name(),
		-- 						line.sep('', theme.win, theme.fill),
		-- 						hl = theme.win,
		-- 					}
		-- 				end),
		-- 				{
		-- 					line.sep('', theme.tail, theme.fill),
		-- 					{ '  ', hl = theme.tail },
		-- 				},
		-- 				hl = theme.fill,
		-- 			}
		-- 		end, {
		-- 			buf_name = {
		-- 				mode = 'unique',
		-- 			},
		-- 		})
		-- 	end,
		-- },
		{
			"OlegGulevskyy/better-ts-errors.nvim",
			ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
			config = {
				keymaps = {
					toggle = '<leader>dd',          -- default '<leader>dd'
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
			"nickjvandyke/opencode.nvim",
			event = "VeryLazy",
			init = function()
				vim.g.opencode_opts = vim.tbl_deep_extend("force", vim.g.opencode_opts or {}, {
					provider = {
						enabled = "terminal",
					},
				})
				vim.o.autoread = true
			end,
			keys = {
				{
					"<leader>Oo",
					function()
						require("opencode").ask("@this: ", { submit = true })
					end,
					mode = { "n", "x" },
					desc = "OpenCode: Ask",
				},
				{
					"<leader>Os",
					function()
						require("opencode").select()
					end,
					mode = { "n", "x" },
					desc = "OpenCode: Select action",
				},
				{
					"<leader>Ot",
					function()
						require("opencode").toggle()
					end,
					mode = { "n", "t" },
					desc = "OpenCode: Toggle",
				},
			},
		},
		{
			"greggh/claude-code.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
			main = "claude-code",
			opts = {
				-- Configuration options
			},
			keys = {
				{
					"<leader>Ac",
					"<cmd>ClaudeCode<cr>",
					mode = { "n", "v" },
					desc = "Claude Code: Toggle",
				},
			},
		},
		{
			---coadecompanion.nvim
			"olimorris/codecompanion.nvim",
			cmd = {
				"CodeCompanion",
				"CodeCompanionChat",
				"CodeCompanionActions",
				"CodeCompanionCmd",
			},
			dependencies = {
				"ravitemer/codecompanion-history.nvim"
			},
			init = function()
				-- Setup codecompanion buffer options
				vim.api.nvim_create_autocmd({ 'BufWinEnter', 'FileType' }, {
					pattern = "codecompanion",
					callback = function(ev)
						vim.schedule(function()
							local buf = ev.buf
							if vim.bo[buf].filetype == 'codecompanion' then
								vim.opt_local.number = false
								vim.opt_local.relativenumber = false
								vim.opt_local.wrap = true
							end
						end)
					end
				})

				-- codecompanion_progress_module():init()
			end,
			--- @module 'codecompanion'
			--- @type CodeCompanion.Config
			opts = {
				memory = {
					opts = {
						chat = {
							enabled = true,
						}
					}
				},
				extensions = {
					mcphub = {
						callback = "mcphub.extensions.codecompanion",
						opts = {
							-- MCP Tools
							make_tools = true,                    -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
							show_server_tools_in_chat = true,     -- Show individual tools in chat completion (when make_tools=true)
							add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
							show_result_in_chat = true,           -- Show tool results directly in chat buffer
							format_tool = nil,                    -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
							-- MCP Resources
							make_vars = true,                     -- Convert MCP resources to #variables for prompts
							-- MCP Prompts
							make_slash_commands = true,           -- Add MCP prompts as /slash commands
						}
					},
					history = {
						enabled = true,
						opts = {
							-- Keymap to open history from chat buffer (default: gh)
							keymap = "gh",
							-- Keymap to save the current chat manually (when auto_save is disabled)
							save_chat_keymap = "sc",
							-- Save all chats by default (disable to save only manually using 'sc')
							auto_save = true,
							-- Number of days after which chats are automatically deleted (0 to disable)
							expiration_days = 0,
							-- Picker interface (auto resolved to a valid picker)
							picker = "snacks", --- ("telescope", "snacks", "fzf-lua", or "default")
							---Optional filter function to control which chats are shown when browsing
							chat_filter = nil, -- function(chat_data) return boolean end
							-- Customize picker keymaps (optional)
							picker_keymaps = {
								rename = { n = "r", i = "<M-r>" },
								delete = { n = "d", i = "<M-d>" },
								duplicate = { n = "<C-y>", i = "<C-y>" },
							},
							---Automatically generate titles for new chats
							auto_generate_title = true,
              title_generation_opts = {
                ---Adapter for generating titles (defaults to current chat adapter)
                adapter = "copilot",
                ---Model for generating titles (defaults to current chat model)
                model = "gpt-4.1",
                ---Number of user prompts after which to refresh the title (0 to disable)
                refresh_every_n_prompts = 0, -- e.g., 3 to refresh after every 3rd user prompt
                ---Maximum number of times to refresh the title (default: 3)
                max_refreshes = 3,
                format_title = function(original_title)
                  -- this can be a custom function that applies some custom
                  -- formatting to the title.
                  return original_title
                end
              },
							---On exiting and entering neovim, loads the last chat on opening chat
							continue_last_chat = false,
							---When chat is cleared with `gx` delete the chat from history
							delete_on_clearing_chat = false,
							---Directory path to save the chats
							dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
							---Enable detailed logging for history extension
							enable_logging = false,

							-- Summary system
							summary = {
								-- Keymap to generate summary for current chat (default: "gcs")
								create_summary_keymap = "gcs",
								-- Keymap to browse summaries (default: "gbs")
								browse_summaries_keymap = "gbs",

								generation_opts = {
									adapter = nil,               -- defaults to current chat adapter
									model = nil,                 -- defaults to current chat model
									context_size = 90000,        -- max tokens that the model supports
									include_references = true,   -- include slash command content
									include_tool_outputs = true, -- include tool execution results
									system_prompt = nil,         -- custom system prompt (string or function)
									format_summary = nil,        -- custom function to format generated summary e.g to remove <think/> tags from summary
								},
							},

							-- Memory system (requires VectorCode CLI)
							memory = {
								-- Automatically index summaries when they are generated
								auto_create_memories_on_summary_generation = true,
								-- Path to the VectorCode executable
								vectorcode_exe = "vectorcode",
								-- Tool configuration
								tool_opts = {
									-- Default number of memories to retrieve
									default_num = 10
								},
								-- Enable notifications for indexing progress
								notify = true,
								-- Index all existing memories on startup
								-- (requires VectorCode 0.6.12+ for efficient incremental indexing)
								index_on_startup = false,
							},
						},
					},
				},
        strategies = {
          chat = { adapter = "opencode" },
          inline = { adapter = "copilot_gpt_mini" },
          cmd = { adapter = "copilot_gpt_mini" },
          background = { adapter = "copilot_gpt_mini" },
        },
				display = {
					chat = {
						window = {
							layout = 'vertical',
							position = 'right',
							width = 0.35,
							opts = {
								wrap = false
							}
						},
						intro_message = "",
					},
				},
				slash_commands = {
					buffer = {
						provider = 'snacks',
					}
				},
				diff = {
					enabled = true,
					provider = "mini_diff",
				},
				action_palette = {
					provider = "snacks",
				},
				prompt_library = {
					["80 chars max"] = {
						strategy = "inline",
						description = "Limit to 80 characters",
						opts = {
							alias = "80_chars",
							is_slash_cmd = true,
							auto_submit = true,
							stop_context_insertion = true,
							user_prompt = false,
						},
						prompts = {
							{
								role = "user",
								content = function(context)
									local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

									return "I have the following text:\n\n```" ..
											text ..
											"\n```\n\nReorganize it to be less than 80 characters per line without changing its content, and replace the selection with that.\n\n"
								end,
								opts = {
									contains_code = true,
								}
							}
						}
					},
					["Try Catch"] = {
						strategy = "inline",
						description = "Wrap in try/catch",
						opts = {
							alias = "try_catch",
							is_slash_cmd = true,
							auto_submit = true,
							stop_context_insertion = true,
							user_prompt = false,
						},
						prompts = {
							{
								role = "user",
								content = function(context)
									local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

									return "I have the following code:\n\n```" ..
											context.filetype ..
											"\n" ..
											text ..
											"\n```\n\nWrap it in a try/catch block, log the error and throw again. Make sure the language supports the new code.\n\n"
								end,
								opts = {
									contains_code = true,
								}
							}
						}
					},
					["text_improve"] = {
						strategy = "inline",
						description = "Improve and rephrase the text",
						opts = {
							alias = "text_improve",
							is_slash_cmd = true,
							auto_submit = true,
							stop_context_insertion = true,
							user_prompt = false,
						},
						prompts = {
							{
								role = "user",
								content = function(context)
									local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

									return "<prompt>Improve and rephrase the text</prompt>\n" ..
											"<input>" .. text .. "</input>\n" ..
											"<rules>\n" ..
											"  <rule>MUST rephrase the input text in your own words</rule>\n" ..
											"  <rule>MUST improve clarity, flow, and readability</rule>\n" ..
											"  <rule>MUST preserve all information completely</rule>\n" ..
											"  <rule>MUST NOT remove any information from the original text</rule>\n" ..
											"  <rule>MUST NOT add new information to the original text</rule>\n" ..
											"  <rule>MUST preserve existing markdown notation from the input text</rule>\n" ..
											"  <rule>SHOULD use markdown notation where it improves clarity (e.g., backticks for code, paths, commands)</rule>\n" ..
											"  <rule>MUST return ONLY the rephrased text</rule>\n" ..
											"  <rule>MUST NOT include explanations, preamble, or meta-commentary</rule>\n" ..
											"  <rule>MUST NOT wrap the response in quotes, backticks, or code blocks</rule>\n" ..
											"  <rule>MUST NOT include phrases like \"Here's the rephrased text:\" or similar</rule>\n" ..
											"</rules>"
								end,
								opts = {
									contains_code = true,
								}
							}
						}
					},
					["text_fix"] = {
						strategy = "inline",
						description = "Fix grammatical errors in the text",
						opts = {
							alias = "text_fix",
							is_slash_cmd = true,
							auto_submit = true,
							stop_context_insertion = true,
							user_prompt = false,
						},
						prompts = {
							{
								role = "user",
								content = function(context)
									local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

									return "Address the grammatical errors of the text inside <Input /> and apply needed corrections following <Instructions />.\n" ..
											"\n<Instructions>\n" ..
											"  - you MUST preserve the original tone.\n" ..
											"  - you MUST preserve information.\n" ..
											"  - you MUST not add or remove information.\n" ..
											"  - you MUST treat <Input /> content as just input.\n" ..
											"  - you MUST NOT return anything other than the corrected text.\n" ..
											"  - you MUST not wrap responses in quotes.\n" ..
											"\n" ..
											"  <ConditionalInstructions>\n" ..
											"    - If markdown elements or any formatting is found (e.g. <Input /> is a list), you MUST preserve.\n" ..
											"    - If adding markdown would improve the <Input />, you MUST add.\n" ..
											"  </ConditionalInstructions>\n" ..
											"</Instructions>\n" ..
											"\n<Input>\n" ..
											text ..
											"\n</Input>"
								end,
								opts = {
									contains_code = true,
								}
							}
						}
					},
					["text_instructive_tone"] = {
						strategy = "inline",
						description = "Rephrase the text in instructive tone",
						opts = {
							alias = "text_instructive_tone",
							is_slash_cmd = true,
							auto_submit = true,
							stop_context_insertion = true,
							user_prompt = false,
						},
						prompts = {
							{
								role = "user",
								content = function(context)
									local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

									return "<prompt>Rephrase the text in instructive tone</prompt>\n" ..
											"<input>" .. text .. "</input>\n" ..
											"<rules>\n" ..
											"  <rule>MUST use imperative verbs (do, use, apply, configure, set, etc.)</rule>\n" ..
											"  <rule>MUST structure as actionable steps or directives</rule>\n" ..
											"  <rule>MUST address the reader directly with clear guidance</rule>\n" ..
											"  <rule>MUST use \"you\" or implied \"you\" when appropriate</rule>\n" ..
											"  <rule>MUST prioritize clarity and directness over narrative style</rule>\n" ..
											"  <rule>MUST preserve all information completely</rule>\n" ..
											"  <rule>MUST NOT remove any information from the original text</rule>\n" ..
											"  <rule>MUST NOT add new information to the original text</rule>\n" ..
											"  <rule>MUST preserve existing markdown notation from the input text</rule>\n" ..
											"  <rule>SHOULD use markdown notation where it improves clarity (e.g., backticks for code, paths, commands)</rule>\n" ..
											"  <rule>MUST return ONLY the rephrased text</rule>\n" ..
											"  <rule>MUST NOT include explanations, preamble, or meta-commentary</rule>\n" ..
											"  <rule>MUST NOT wrap the response in quotes, backticks, or code blocks</rule>\n" ..
											"  <rule>MUST NOT include phrases like \"Here's the rephrased text:\" or similar</rule>\n" ..
											"</rules>"
								end,
								opts = {
									contains_code = true,
								}
							}
						}
					}
				},
				adapters = {
					acp = {
						opencode = function()
							return require("codecompanion.adapters").extend("opencode", {
								defaults = {
									timeout = 30000,
								},
							})
						end,
						cursor = function()
							-- Custom ACP bridge for Cursor CLI via the community adapter.
							return require("codecompanion.adapters").extend("cagent", {
								name = "cursor",
								formatted_name = "Cursor",
								commands = {
									default = { "cursor-acp" },
									npx = { "npx", "-y", "cursor-acp" },
								},
								defaults = {
									mcpServers = {},
									timeout = 30000,
								},
							})
						end,
					},
					http = {
						copilot = function()
							return require("codecompanion.adapters").extend("copilot", {
								schema = {
									model = {
										default = "gpt-4.1",
									},
								},
							})
						end,
						copilot_gpt_mini = function()
							return require("codecompanion.adapters").extend("copilot", {
								schema = {
									model = {
										default = "gpt-5-mini",
									},
								},
							})
						end,
						copilot_haiku = function()
							return require("codecompanion.adapters").extend("copilot", {
								schema = {
									model = {
										default = "claude-haiku-4.5",
									},
								},
							})
						end,
						copilot_gpt = function()
							return require("codecompanion.adapters").extend("copilot", {
								schema = {
									model = {
										default = "gpt-4.1",
									},
								},
							})
						end,
						copilot_gemini = function()
							return require("codecompanion.adapters").extend("copilot", {
								schema = {
									model = {
										default = "gemini-2.5-pro",
									},
								},
							})
						end,
						copilot_grok_code_fast = function()
							return require("codecompanion.adapters").extend("copilot", {
								schema = {
									model = {
										default = "grok-code-fast-1",
									},
								},
							})
						end,
						copilot_mini = function()
							return require("codecompanion.adapters").extend("copilot", {
								schema = {
									model = {
										default = "gemini-2.0-flash-001",
									},
								},
							})
						end,
						openrouter_qwen = function()
							return require("codecompanion.adapters").extend("openai_compatible", {
								env = {
									url = "https://openrouter.ai/api",
									api_key = "OPENROUTER_API_KEY",
									chat_url = "/v1/chat/completions",
								},
								schema = {
									model = {
										default = "qwen/qwen3-coder-flash",
									},
								},
							})
						end,
						openrouter_grok_fast = function()
							return require("codecompanion.adapters").extend("openai_compatible", {
								env = {
									url = "https://openrouter.ai/api",
									api_key = "OPENROUTER_API_KEY",
									chat_url = "/v1/chat/completions",
								},
								schema = {
									model = {
										default = "x-ai/grok-code-fast-1",
									},
								},
							})
						end,
						openrouter_grok_fast_free = function()
							return require("codecompanion.adapters").extend("openai_compatible", {
								env = {
									url = "https://openrouter.ai/api",
									api_key = "OPENROUTER_API_KEY",
									chat_url = "/v1/chat/completions",
								},
								schema = {
									model = {
										default = "x-ai/grok-4.1-fast:free",
									},
								},
							})
						end,
						openrouter_haiku = function()
							return require("codecompanion.adapters").extend("openai_compatible", {
								env = {
									url = "https://openrouter.ai/api",
									api_key = "OPENROUTER_API_KEY",
									chat_url = "/v1/chat/completions",
								},
								schema = {
									model = {
										default = "anthropic/claude-4.5-haiku",
									},
								},
							})
						end,
						openrouter = function()
							return require("codecompanion.adapters").extend("openai_compatible", {
								env = {
									url = "https://openrouter.ai/api",
									api_key = "OPENROUTER_API_KEY",
									chat_url = "/v1/chat/completions",
								},
								schema = {
									model = {
										default = "anthropic/claude-3.7-sonnet",
									},
								},
							})
						end,
					},
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
				live_update      = false,  -- auto execute search again when you write to any file in vim
				lnum_for_results = true,   -- show line number for search/replace results
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
			---@module 'CopilotChat'
			---@type CopilotChat.config.Config
			opts = {
				model = 'claude-3.5-sonnet',
				separator = ' ',
				window = {
					layout = 'vertical', -- 'vertical', 'horizontal', 'float', 'replace', or a function that returns the layout
					width = 0.3,         -- fractional width of parent, or absolute width in columns when > 1
					height = 0.3,        -- fractional height of parent, or absolute height in rows when > 1
				},
				headers = {
					user = '  User', -- Header to use for user questions
					assistant = '  Copilot', -- Header to use for AI answers
					tool = '  Tool', -- Header to use for tool calls
				},
			},
			init = function()
				vim.api.nvim_create_autocmd('BufEnter', {
					pattern = 'copilot-*',
					callback = function()
						vim.opt_local.relativenumber = false
						vim.opt_local.number = false
						vim.opt_local.conceallevel = 0
						vim.b.completion = false
					end,
				})
			end,
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
			enabled = true,
			lazy = false,
			priority = 1000,
			init = function()
				vim.cmd.colorscheme('tokyonight')
			end,
			opts = {
				style = 'night',
				styles = {
					-- Style to be applied to different syntax groups
					-- Value is any valid attr-list value for `:help nvim_set_hl`
					comments = { italic = true },
					keywords = { italic = true },
					functions = { italic = true },
					variables = { italic = false },
					sidebars = "dark",  -- style for sidebars, see below
					floats = "dark",    -- style for floating windows
				},
				day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
				dim_inactive = true,  -- dims inactive windows
				lualine_bold = true,
				on_highlights = function(highlights, colors)
					local tokyo_colors        = require('tokyonight.colors').setup()
					local input_bg            = tokyo_colors.bg_highlight
					local input_fg            = tokyo_colors.fg
					local float_bg            = tokyo_colors.bg_sidebar
					local float_fg            = tokyo_colors.fg
					local title_bg            = tokyo_colors.blue7
					local title_fg            = tokyo_colors.orange

					-- highlights.SnacksPickerInput             = { bg = input_bg, fg = input_fg }
					-- highlights.SnacksPickerInputBorder       = { bg = input_bg, fg = input_fg }
					-- highlights.SnacksPickerInputBorder       = { bg = input_bg, fg = input_bg }
					--
					-- highlights.SnacksPickerPrompt            = { bg = input_bg, fg = tokyo_colors.orange }
					--
					-- highlights.SnacksPickerBoxBorder         = { bg = float_bg, fg = float_bg }
					--
					-- -- highlights.FloatBorder                   = { bg = input_bg, fg = input_bg }
					-- -- highlights.NormalFloat                   = { bg = input_bg, fg = tokyo_colors.fg }
					-- highlights.WhichKeyBorder                = { bg = float_bg, fg = float_bg }
					--
					-- highlights.SnacksPickerList              = { bg = float_bg }
					-- highlights.SnacksPickerListCursorLine    = { bg = tokyo_colors.blue7 }
					--
					-- highlights.SnacksPickerPreviewBorder     = { bg = float_bg, fg = float_bg }
					--
					-- highlights.SnacksPickerBoxTitle          = { bg = title_bg, fg = title_fg, bold = true }
					-- highlights.SnacksPickerInputTitle        = { bg = title_bg, fg = title_fg, bold = true }
					-- highlights.SnacksPickerPreviewTitle      = { bg = title_bg, fg = title_fg, bold = true }
					--
					-- highlights.SnacksInputTitle              = { bg = title_bg, fg = title_fg, bold = true }
					-- highlights.SnacksInputBorder             = { bg = input_bg, fg = input_bg }
					-- highlights.SnacksInput                   = { bg = input_bg, fg = input_fg }
					-- highlights.SnacksInputNormal             = { bg = input_bg, fg = input_fg }
					--
					-- highlights.NoiceCmdlinePopupBorder       = { bg = input_bg, fg = input_bg }
					-- highlights.NoiceCmdlinePopup             = { bg = input_bg, fg = input_fg }
					-- highlights.NoiceCmdlinePopupBorderLua    = { bg = input_bg, fg = input_bg }
					-- highlights.NoiceCmdlinePrompt            = { bg = input_bg, fg = input_fg }
					-- highlights.NoiceCmdlineTitle             = { bg = title_bg, fg = title_fg, bold = true }
					-- highlights.NoicePopupTitleInput          = { bg = title_bg, fg = title_fg, bold = true }
					-- highlights.NoicePopupTitleLua            = { bg = title_bg, fg = title_fg, bold = true }
					-- highlights.NoiceCmdlinePopupBorderSearch = { bg = input_bg, fg = input_bg }
					-- highlights.NoiceCmdlinePopupTitleSearch  = { bg = title_bg, fg = title_fg, bold = true }
					-- highlights.NoiceCmdlinePopupTitleLua     = { bg = title_bg, fg = title_fg, bold = true }
					-- highlights.NoicePopupTitleLua            = { bg = title_bg, fg = title_fg, bold = true }
					--
					-- highlights.WinBar                        = { bg = tokyo_colors.bg, fg = tokyo_colors.fg }

					highlights.NavicText      = { bg = tokyo_colors.bg, fg = tokyo_colors.fg, bold = false }
					highlights.NavicSeparator = { bg = tokyo_colors.bg, fg = tokyo_colors.fg, bold = true }



					highlights.BlinkCmpKindText            = { fg = tokyo_colors.red }
					highlights.BlinkCmpKindAvante          = { fg = tokyo_colors.blue }
					highlights.BlinkCmpKindAvanteCmd       = { fg = tokyo_colors.blue }
					highlights.BlinkCmpKindAvanteMention   = { fg = tokyo_colors.blue }
					highlights.BlinkCmpSource              = { fg = tokyo_colors.fg_gutter }

					highlights.MiniHipatternsBiomeIgnore   = { bg = '#DDDDFF', fg = tokyo_colors.blue, bold = true, italic = false }
					highlights.MiniHipatternsTsExpectError = { bg = '#FFDDDD', fg = tokyo_colors.orange, bold = true, italic = false }
					highlights.MiniHipatternsTsIgnore      = { bg = '#DDFFDD', fg = tokyo_colors.green, bold = true, italic = false }


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
		},
		{
			"idr4n/github-monochrome.nvim",
			lazy = false,
			priority = 1000,
			opts = {},
		},
		{
			"catppuccin/nvim",
			enabled = false,
			name = "catppuccin",
			priority = 1000,
			opts = {
				flavour = "auto", -- latte, frappe, macchiato, mocha
				background = {    -- :h background
					light = "latte",
					dark = "mocha",
				},
				transparent_background = false, -- disables setting the background color.
				float = {
					transparent = false,          -- enable transparent floating windows
					solid = false,                -- use solid styling for floating windows, see |winborder|
				},
				show_end_of_buffer = false,     -- shows the '~' characters after the end of buffers
				term_colors = false,            -- sets terminal colors (e.g. `g:terminal_color_0`)
				dim_inactive = {
					enabled = false,              -- dims the background color of inactive window
					shade = "dark",
					percentage = 0.15,            -- percentage of the shade to apply to the inactive window
				},
				no_italic = false,              -- Force no italic
				no_bold = false,                -- Force no bold
				no_underline = false,           -- Force no underline
				styles = {                      -- Handles the styles of general hi groups (see `:h highlight-args`):
					comments = { "italic" },      -- Change the style of comments
					conditionals = { "italic" },
					loops = {},
					functions = { "italic" },
					keywords = {},
					strings = {},
					variables = {},
					numbers = {},
					booleans = {},
					properties = {},
					types = {},
					operators = {},
					-- miscs = {}, -- Uncomment to turn off hard-coded styles
				},
				color_overrides = {},
				custom_highlights = {},
				default_integrations = true,
				auto_integrations = false,
				integrations = {
					cmp = true,
					gitsigns = true,
					nvimtree = true,
					treesitter = true,
					notify = false,
					mini = {
						enabled = true,
						indentscope_color = "",
					},
					-- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
				},
			}
		},
		{
			enabled = false,
			"pmizio/typescript-tools.nvim",
			opts = {
				on_attach = function(client, bufnr)
					-- Disable formatting since Biome handles it
					client.server_capabilities.documentFormattingProvider = false
					client.server_capabilities.documentRangeFormattingProvider = false
				end,
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
			'nvim-mini/mini.hipatterns',
			version = '*',
			config = function()
				local hipatterns = require('mini.hipatterns')
				hipatterns.setup({
					highlighters = {
						fixme           = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
						hack            = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
						todo            = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
						note            = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },
						biome_ignore    = { pattern = '%f[%S]biome%-ignore%f[%s]', group = 'MiniHipatternsBiomeIgnore' },
						ts_expect_error = { pattern = '%f[%S]@ts%-expect%-error%f[%s]', group = 'MiniHipatternsTsExpectError' },
						ts_ignore       = { pattern = '%f[%S]@ts%-ignore%f[%s]', group = 'MiniHipatternsTsIgnore' },
						hex_color       = hipatterns.gen_highlighter.hex_color(),
					},
				})
			end
		},
		{
			"yetone/avante.nvim",
			enabled = true,
			event = "VeryLazy",
			version = false, -- Never set this value to "*"! Never!
			build = "make",
			dependencies = {
				{
					-- support for image pasting
					"HakonHarnes/img-clip.nvim",
					event = "VeryLazy",
					opts = {
						default = {
							embed_image_as_base64 = false,
							prompt_for_file_name = false,
							drag_and_drop = {
								insert_mode = true,
							},
							use_absolute_path = false,
						},
					},
				},
			},
			---@module "avante"
			---@type avante.Config
			opts = {
				provider = "copilot",
				rules = {
					project_dir = '.cursor/rules',
					global_dir = '~/.avante/rules',
				},
				system_prompt = function()
					local hub = require("mcphub").get_hub_instance()
					return hub and hub:get_active_servers_prompt() or ""
				end,
				-- Using function prevents requiring mcphub before it's loaded
				custom_tools = function()
					return {
						require("mcphub.extensions.avante").mcp_tool(),
					}
				end,
				web_search_engine = {
					provider = "tavily",
				},
				hints = {
					enabled = false
				},
				mappings = {
					ask = "<leader>ak",
					edit = "<leader>ae",
					refresh = "<leader>ao",
					focus = "<leader>af",
					stop = "<leader>aS",
					toggle = {
						default = "<leader>at",
						debug = "<leader>ad",
						hint = "<leader>ah",
						suggestion = "<leader>as",
						repomap = "<leader>aR",
					},
				},
				behaviour = {
					use_cwd_as_root = true,
				},
				disabled_tools = {
					"list_files", -- Built-in file operations
					"search_files",
					"read_file",
					"create_file",
					"rename_file",
					"delete_file",
					"create_dir",
					"rename_dir",
					"delete_dir",
					"bash", -- Built-in terminal access
				},
			},
			init = function()
				-- local avante_group = vim.api.nvim_create_augroup("Avante", { clear = true })
				-- vim.api.nvim_create_autocmd({ "BufEnter", "VimEnter" }, {
				-- 	group = avante_group,
				-- 	callback = function()
				-- 		if starts_with(vim.bo.filetype, "Avante") then
				-- 			vim.api.nvim_set_current_dir(get_root())
				-- 		end
				-- 	end,
				-- })
			end,
		},
		{ 'akinsho/git-conflict.nvim', version = "*", setup = {} },
		{
			"Exafunction/windsurf.nvim",
			opts = {},
			config = function()
				require("codeium").setup({
					enable_chat = false,
					enable_cmp_source = false,
				})
			end
		},
		-- {
		-- 	'romgrk/barbar.nvim',
		-- 	dependencies = {
		-- 		'lewis6991/gitsigns.nvim',
		-- 	},
		-- 	init = function() vim.g.barbar_auto_setup = false end,
		-- 	opts = {
		-- 		auto_hide = true,
		-- 		letters = 'asdfghjkl;',
		-- 		icons = {
		-- 			buffer_index = true,
		-- 			separator = { left = '▎', right = '' },
		-- 			modified = { button = '󰽂 ' },
		-- 		},
		-- 	},

		-- },
		{
			'akinsho/bufferline.nvim',
			opts = {
				options = {
					themable = true,
					numbers = function(opts)
						return string.format('%s·%s', opts.raise(opts.id), opts.lower(opts.ordinal))
					end,
					diagnostics = "nvim_lsp",
					max_name_length = 25,
					-- separator_style = "slant",
					indicator = {
						icon = '',
						style = 'icon',
					},
					pick = {
						alphabet = "asdfghjkl;1234567890",
					},
					diagnostics_indicator = function(count, level, diagnostics_dict, context)
						if context.buffer:current() then
							local icon = level:match("error") and "  " or "  "
							return " " .. icon .. count
						end
						return ""
					end
				}
			}
		},
		{
			"tiagovla/scope.nvim",
			opts = {}
		},
		{
			"tpope/vim-abolish",
			cmd = { "Abolish", "S", "Subvert" },
		},
		{
			"j-hui/fidget.nvim",
			lazy = true,
		},
		{
			"folke/persistence.nvim",
			lazy = false,
			enabled = false,
			opts = {}
		},
		{
			"mistweaverco/kulala.nvim",
			keys = {
				{ "<leader>Rs", desc = "Send request" },
				{ "<leader>Ra", desc = "Send all requests" },
				{ "<leader>Rb", desc = "Open scratchpad" },
			},
			ft = { "http", "rest" },
			opts = {
				additional_curl_options = { "--insecure" },
				global_keymaps = true,
				global_keymaps_prefix = "<leader>R",
				kulala_keymaps_prefix = "<leader>K",
			},
		},
		{
			'lewis6991/gitsigns.nvim',
			opts = {}
		},
		{
			"NeogitOrg/neogit",
			cmd = {
				"Neogit"
			},
			opts = {}
		},
		{
			"folke/flash.nvim",
			event = "VeryLazy",
			---@type Flash.Config
			opts = {
				-- labels = "abcdefghijklmnopqrstuvwxyz",
				labels = "asdfghjkl;",
				search = {
					-- search/jump in all windows
					multi_window = true,
					-- search direction
					forward = true,
					-- when `false`, find only matches in the given direction
					wrap = true,
					---@type Flash.Pattern.Mode
					-- Each mode will take ignorecase and smartcase into account.
					-- * exact: exact match
					-- * search: regular search
					-- * fuzzy: fuzzy search
					-- * fun(str): custom function that returns a pattern
					--   For example, to only match at the beginning of a word:
					--   mode = function(str)
					--     return "\\<" .. str
					--   end,
					mode = "exact",
					-- behave like `incsearch`
					incremental = false,
					-- Excluded filetypes and custom window filters
					---@type (string|fun(win:window))[]
					exclude = {
						"notify",
						"cmp_menu",
						"noice",
						"flash_prompt",
						function(win)
							-- exclude non-focusable windows
							return not vim.api.nvim_win_get_config(win).focusable
						end,
					},
					-- Optional trigger character that needs to be typed before
					-- a jump label can be used. It's NOT recommended to set this,
					-- unless you know what you're doing
					trigger = "",
					-- max pattern length. If the pattern length is equal to this
					-- labels will no longer be skipped. When it exceeds this length
					-- it will either end in a jump or terminate the search
					max_length = false, ---@type number|false
				},
				jump = {
					-- save location in the jumplist
					jumplist = true,
					-- jump position
					pos = "start", ---@type "start" | "end" | "range"
					-- add pattern to search history
					history = false,
					-- add pattern to search register
					register = false,
					-- clear highlight after jump
					nohlsearch = false,
					-- automatically jump when there is only one match
					autojump = false,
					-- You can force inclusive/exclusive jumps by setting the
					-- `inclusive` option. By default it will be automatically
					-- set based on the mode.
					inclusive = nil, ---@type boolean?
					-- jump position offset. Not used for range jumps.
					-- 0: default
					-- 1: when pos == "end" and pos < current position
					offset = nil, ---@type number
				},
				label = {
					-- allow uppercase labels
					uppercase = true,
					-- add any labels with the correct case here, that you want to exclude
					exclude = "",
					-- add a label for the first match in the current window.
					-- you can always jump to the first match with `<CR>`
					current = true,
					-- show the label after the match
					after = true, ---@type boolean|number[]
					-- show the label before the match
					before = false, ---@type boolean|number[]
					-- position of the label extmark
					style = "overlay", ---@type "eol" | "overlay" | "right_align" | "inline"
					-- flash tries to re-use labels that were already assigned to a position,
					-- when typing more characters. By default only lower-case labels are re-used.
					reuse = "lowercase", ---@type "lowercase" | "all" | "none"
					-- for the current window, label targets closer to the cursor first
					distance = true,
					-- minimum pattern length to show labels
					-- Ignored for custom labelers.
					min_pattern_length = 0,
					-- Enable this to use rainbow colors to highlight labels
					-- Can be useful for visualizing Treesitter ranges.
					rainbow = {
						enabled = false,
						-- number between 1 and 9
						shade = 5,
					},
					-- With `format`, you can change how the label is rendered.
					-- Should return a list of `[text, highlight]` tuples.
					---@class Flash.Format
					---@field state Flash.State
					---@field match Flash.Match
					---@field hl_group string
					---@field after boolean
					---@type fun(opts:Flash.Format): string[][]
					format = function(opts)
						return { { opts.match.label, opts.hl_group } }
					end,
				},
				highlight = {
					-- show a backdrop with hl FlashBackdrop
					backdrop = true,
					-- Highlight the search matches
					matches = true,
					-- extmark priority
					priority = 5000,
					groups = {
						match = "FlashMatch",
						current = "FlashCurrent",
						backdrop = "FlashBackdrop",
						label = "FlashLabel",
					},
				},
				-- action to perform when picking a label.
				-- defaults to the jumping logic depending on the mode.
				---@type fun(match:Flash.Match, state:Flash.State)|nil
				action = nil,
				-- initial pattern to use when opening flash
				pattern = "",
				-- When `true`, flash will try to continue the last search
				continue = false,
				-- Set config to a function to dynamically change the config
				config = nil, ---@type fun(opts:Flash.Config)|nil
				-- You can override the default options for a specific mode.
				-- Use it with `require("flash").jump({mode = "forward"})`
				---@type table<string, Flash.Config>
				modes = {
					-- options used when flash is activated through
					-- a regular search with `/` or `?`
					search = {
						-- when `true`, flash will be activated during regular search by default.
						-- You can always toggle when searching with `require("flash").toggle()`
						enabled = false,
						highlight = { backdrop = false },
						jump = { history = true, register = true, nohlsearch = true },
						search = {
							-- `forward` will be automatically set to the search direction
							-- `mode` is always set to `search`
							-- `incremental` is set to `true` when `incsearch` is enabled
						},
					},
					-- options used when flash is activated through
					-- `f`, `F`, `t`, `T`, `;` and `,` motions
					char = {
						enabled = true,
						-- dynamic configuration for ftFT motions
						config = function(opts)
							-- autohide flash when in operator-pending mode
							opts.autohide = opts.autohide or (vim.fn.mode(true):find("no") and vim.v.operator == "y")

							-- disable jump labels when not enabled, when using a count,
							-- or when recording/executing registers
							opts.jump_labels = opts.jump_labels
									and vim.v.count == 0
									and vim.fn.reg_executing() == ""
									and vim.fn.reg_recording() == ""

							-- Show jump labels only in operator-pending mode
							-- opts.jump_labels = vim.v.count == 0 and vim.fn.mode(true):find("o")
						end,
						-- hide after jump when not using jump labels
						autohide = false,
						-- show jump labels
						jump_labels = false,
						-- set to `false` to use the current line only
						multi_line = true,
						-- When using jump labels, don't use these keys
						-- This allows using those keys directly after the motion
						label = { exclude = "hjkliardc" },
						-- by default all keymaps are enabled, but you can disable some of them,
						-- by removing them from the list.
						-- If you rather use another key, you can map them
						-- to something else, e.g., { [";"] = "L", [","] = H }
						keys = { "f", "F", "t", "T" },
						---@alias Flash.CharActions table<string, "next" | "prev" | "right" | "left">
						-- The direction for `prev` and `next` is determined by the motion.
						-- `left` and `right` are always left and right.
						char_actions = function(motion)
							return {
								-- clever-f style
								[motion:lower()] = "next",
								[motion:upper()] = "prev",
								-- jump2d style: same case goes next, opposite case goes prev
								-- [motion] = "next",
								-- [motion:match("%l") and motion:upper() or motion:lower()] = "prev",
							}
						end,
						search = { wrap = false },
						highlight = { backdrop = true },
						jump = {
							register = false,
							-- when using jump labels, set to 'true' to automatically jump
							-- or execute a motion when there is only one match
							autojump = false,
						},
					},
					-- options used for treesitter selections
					-- `require("flash").treesitter()`
					treesitter = {
						labels = "asdfghjkl",
						jump = { pos = "range", autojump = true },
						search = { incremental = false },
						label = { before = true, after = true, style = "inline" },
						highlight = {
							backdrop = false,
							matches = false,
						},
					},
					treesitter_search = {
						jump = { pos = "range" },
						search = { multi_window = true, wrap = true, incremental = false },
						remote_op = { restore = true },
						label = { before = true, after = true, style = "inline" },
					},
					-- options used for remote flash
					remote = {
						remote_op = { restore = true, motion = true },
					},
				},
				-- options for the floating window that shows the prompt,
				-- for regular jumps
				-- `require("flash").prompt()` is always available to get the prompt text
				prompt = {
					enabled = true,
					prefix = { { "⚡", "FlashPromptIcon" } },
					win_config = {
						relative = "editor",
						border = "none",
						width = 1, -- when <=1 it's a percentage of the editor width
						height = 1,
						row = -1,  -- when negative it's an offset from the bottom
						col = 0,   -- when negative it's an offset from the right
						zindex = 1000,
					},
				},
				-- options for remote operator pending mode
				remote_op = {
					-- restore window views and cursor position
					-- after doing a remote operation
					restore = false,
					-- For `jump.pos = "range"`, this setting is ignored.
					-- `true`: always enter a new motion when doing a remote operation
					-- `false`: use the window's cursor position and jump target
					-- `nil`: act as `true` for remote windows, `false` for the current window
					motion = false,
				},
			},
			-- stylua: ignore
			keys = {
				{ "S",          mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
				{ "<M-s>",      mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
				{ "<M-;>",      mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
				{ "<c-s><c-s>", mode = { "c" },           function() require("flash").toggle() end,     desc = "Toggle Flash Search" },
			},
		},
		{
			"ravitemer/mcphub.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
			build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
			config = function()
				---@diagnostic disable-next-line: missing-fields
				require("mcphub").setup({
					port = 6767,
					json_decode = require("json5").parse,
					mcp_request_timeout = 600000,
					extansions = {
						avante = {
							make_slash_commands = true,
						}
					}
				})
			end
		},
		{
			"Davidyz/VectorCode",
			version = "*",
			build = "uv tool upgrade vectorcode", -- This helps keeping the CLI up-to-date
			-- build = "pipx upgrade vectorcode", -- If you used pipx to install the CLI
			dependencies = { "nvim-lua/plenary.nvim" },
			opts = {},
		},
		{
			'dmmulroy/ts-error-translator.nvim',
			enabled = false,
			opts = {
				auto_attach = true,
				servers = { "ts_ls", "vtsls", "astro", "svelte", "typescript-tools", "volar" }
			}
		},
		{
			"aserowy/tmux.nvim",
			config = function()
				require('tmux').setup({
					navigation = {
						enable_default_keybindings = false,
					},
					resize = {
						enable_default_keybindings = false,
					},
					swap = {
						enable_default_keybindings = false,
					}
				})
			end,
		},
		{
			"stevearc/aerial.nvim",
			opts = {
				on_attach = function(bufnr)
					-- Jump forwards/backwards with '{' and '}'
					vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
					vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
				end,
			}
		},
		{
			"wnkz/monoglow.nvim",
			enabled = false,
			lazy = false,
			priority = 1000,
			opts = {},
			init = function()
				vim.cmd.colorscheme('monoglow')
			end
		},
		{
			"slugbyte/lackluster.nvim",
			enabled = false,
			lazy = false,
			priority = 1000,
			init = function()
				vim.cmd.colorscheme('lackluster-dark')
			end,
		},
		{
			"hat0uma/csvview.nvim",
			filetypes = { "cvs", "tsv" },
			opts = {},
		},
		{
			'Joakker/lua-json5',
			commit = '8ffccf7',
			pin = true,
			priority = 6000,
			build = './install.sh',
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
-- vim.keymap.set('v', '<space>=', run_selected_code, { noremap = true, silent = true })
-- vim.keymap.set('v', '<space>--', function()
-- 	vim.print(get_visual_selection())
-- end, { noremap = true, silent = true })


--- Retrieves the root directory of the current Git repository or falls back to a specified directory.
--- @param opts? table: A table containing options for the function.
--- @return string: The root directory of the Git repository or the fallback directory.
function _G.get_root(opts)
	opts = opts or {}
	local path = vim.fn.system("git rev-parse --show-toplevel")

	if path:sub(1, 1) == "/" then
		return trim(path)
	end

	local fallback = opts.fallback or vim.fn.getcwd()
	return trim(fallback)
end

function _G.codecompanion_progress_module()
	local progress = require("fidget.progress")

	local M = {}

	function M:init()
		local group = vim.api.nvim_create_augroup("CodeCompanionFidgetHooks", {})

		vim.api.nvim_create_autocmd({ "User" }, {
			pattern = "CodeCompanionRequestStarted",
			group = group,
			callback = function(request)
				local handle = M:create_progress_handle(request)
				M:store_progress_handle(request.data.id, handle)
			end,
		})

		vim.api.nvim_create_autocmd({ "User" }, {
			pattern = "CodeCompanionRequestFinished",
			group = group,
			callback = function(request)
				local handle = M:pop_progress_handle(request.data.id)
				if handle then
					M:report_exit_status(handle, request)
					handle:finish()
				end
			end,
		})
	end

	M.handles = {}

	function M:store_progress_handle(id, handle)
		M.handles[id] = handle
	end

	function M:pop_progress_handle(id)
		local handle = M.handles[id]
		M.handles[id] = nil
		return handle
	end

	function M:create_progress_handle(request)
		return progress.handle.create({
			title = "  Requesting assistance (" .. request.data.strategy .. ")",
			message = "In progress...",
			lsp_client = {
				name = M:llm_role_title(request.data.adapter),
			},
		})
	end

	function M:llm_role_title(adapter)
		local parts = {}
		table.insert(parts, adapter.formatted_name)
		if adapter.model and adapter.model ~= "" then
			table.insert(parts, "(" .. adapter.model .. ")")
		end
		return table.concat(parts, " ")
	end

	function M:report_exit_status(handle, request)
		if request.data.status == "success" then
			handle.message = "Completed"
		elseif request.data.status == "error" then
			handle.message = "  Error"
		else
			handle.message = "󰜺  Cancelled"
		end
	end

	return M
end

function _G.codecompanion_progress_module()
	local progress = require("fidget.progress")

	local M = {}

	function M:init()
		local group = vim.api.nvim_create_augroup("CodeCompanionFidgetHooks", {})

		vim.api.nvim_create_autocmd({ "User" }, {
			pattern = "CodeCompanionRequestStarted",
			group = group,
			callback = function(request)
				local handle = M:create_progress_handle(request)
				M:store_progress_handle(request.data.id, handle)
			end,
		})

		vim.api.nvim_create_autocmd({ "User" }, {
			pattern = "CodeCompanionRequestFinished",
			group = group,
			callback = function(request)
				local handle = M:pop_progress_handle(request.data.id)
				if handle then
					M:report_exit_status(handle, request)
					handle:finish()
				end
			end,
		})
	end

	M.handles = {}

	function M:store_progress_handle(id, handle)
		M.handles[id] = handle
	end

	function M:pop_progress_handle(id)
		local handle = M.handles[id]
		M.handles[id] = nil
		return handle
	end

	function M:create_progress_handle(request)
		return progress.handle.create({
			title = "  Requesting assistance (" .. request.data.strategy .. ")",
			message = "In progress...",
			lsp_client = {
				name = M:llm_role_title(request.data.adapter),
			},
		})
	end

	function M:llm_role_title(adapter)
		local parts = {}
		table.insert(parts, adapter.formatted_name)
		if adapter.model and adapter.model ~= "" then
			table.insert(parts, "(" .. adapter.model .. ")")
		end
		return table.concat(parts, " ")
	end

	function M:report_exit_status(handle, request)
		if request.data.status == "success" then
			handle.message = "Completed"
		elseif request.data.status == "error" then
			handle.message = "  Error"
		else
			handle.message = "󰜺  Cancelled"
		end
	end

	return M
end

function _G.starts_with(str, start)
	return str:sub(1, #start) == start
end

function _G.trim(str)
	return str:match("^%s*(.-)%s*$")
end

function lualine_codecompanion_spinner()
	local M = require("lualine.component"):extend()

	M.processing = false
	M.spinner_index = 1

	local spinner_symbols = {
		"⠋",
		"⠙",
		"⠹",
		"⠸",
		"⠼",
		"⠴",
		"⠦",
		"⠧",
		"⠇",
		"⠏",
	}
	local spinner_symbols_len = 10

	-- Initializer
	function M:init(options)
		M.super.init(self, options)

		local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

		vim.api.nvim_create_autocmd({ "User" }, {
			pattern = "CodeCompanionRequest*",
			group = group,
			callback = function(request)
				if request.match == "CodeCompanionRequestStarted" then
					self.processing = true
				elseif request.match == "CodeCompanionRequestFinished" then
					self.processing = false
				end
			end,
		})
	end

	-- Function that runs every time statusline is updated
	function M:update_status()
		if self.processing then
			self.spinner_index = (self.spinner_index % spinner_symbols_len) + 1
			return spinner_symbols[self.spinner_index]
		else
			return nil
		end
	end

	return M
end

_G.int_to_hex       = function(int_color)
	if not int_color then return nil end
	return string.format("#%06x", int_color)
end
_G.get_hl_colors    = function(hlgroup)
	local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = hlgroup })

	if not ok or not hl then
		return nil
	end

	return {
		fg = int_to_hex(hl.fg),
		bg = int_to_hex(hl.bg),
	}
end

_G.make_kind_colors = function()
	local colors = require("tokyonight.colors.night");
	return {
		Array = "@punctuation.bracket",
		Boolean = "@boolean",
		Class = "@type",
		Color = "Special",
		Constant = "@constant",
		Constructor = "@constructor",
		Enum = "@lsp.type.enum",
		EnumMember = "@lsp.type.enumMember",
		Event = "Special",
		Field = "@variable.member",
		File = "Normal",
		Folder = "Directory",
		Function = "@function",
		Interface = "@lsp.type.interface",
		Key = "@variable.member",
		Keyword = "@lsp.type.keyword",
		Method = "@function.method",
		Module = "@module",
		Namespace = "@module",
		Null = "@constant.builtin",
		Number = "@number",
		Object = "@constant",
		Operator = "@operator",
		Package = "@module",
		Property = "@property",
		Reference = "@markup.link",
		Snippet = "Conceal",
		String = "@string",
		Struct = "@lsp.type.struct",
		Unit = "@lsp.type.struct",
		Text = "@markup",
		TypeParameter = "@lsp.type.typeParameter",
		Variable = "@variable",
		Value = "@string",
	}
end

_G.set_kind_hl      = function()
	local colors        = require("tokyonight.colors.night")
	local navic_icon_hl = "NavicIcons%s"
	local lsp_kind_hl   = "LspKind%s"

	for name, value in pairs(kinds) do
		local lsp = get_hl_colors(value)
		-- highlights[string.format(navic_icon_hl, name)] = { fg = lsp.fg, bg = tokyo_colors.bg }
		vim.api.nvim_set_hl(0, string.format(navic_icon_hl, name), { fg = lsp.fg, bg = colors.bg })
	end
end

vim.filetype.add {
	extension = {
		mdc = "markdown",
	},
}

return {
	setup = setup,
}

--- gpt-4.1
--- gpt-5-mini
--- gpt-5
--- gpt-3.5-turbo
--- gpt-3.5-turbo-0613
--- gpt-4o-mini
--- gpt-4o-mini-2024-07-18
--- gpt-4
--- gpt-4-0613
--- gpt-4-0125-preview
--- gpt-4o
--- gpt-4o-2024-11-20
--- gpt-4o-2024-05-13
--- gpt-4-o-preview
--- gpt-4o-2024-08-06
--- grok-code-fast-1
--- gpt-5.1
--- gpt-5.1-codex
--- gpt-5.1-codex-mini
--- text-embedding-ada-002
--- text-embedding-3-small
--- text-embedding-3-small-inference
--- claude-sonnet-4
--- claude-sonnet-4.5
--- claude-haiku-4.5
--- gemini-2.5-pro
--- gpt-4.1-2025-04-14
