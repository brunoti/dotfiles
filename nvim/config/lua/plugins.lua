local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
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
					ensure_installed = "all",
					sync_install = false,
					auto_install = false,
					context_commentstring = {
						enable = true
					},
					indent = {
						enable = true,
						additional_vim_regex_highlighting = true,
					},
					highlight = { enable = true },
				})
			end
		},
		{
			"nvim-lua/plenary.nvim",
			branch = "master",
		},
		-- 'alvan/vim-closetag',
		-- 'tpope/vim-abolish',
		'dyng/ctrlsf.vim',
		{
			'kyazdani42/nvim-web-devicons', -- optional, for file icons
		},
		-- nvim-tree: file explorer
		{
			'kyazdani42/nvim-tree.lua',
			dependencies = {
				'kyazdani42/nvim-web-devicons', -- optional, for file icons
			},
		},

		-- git commands
		-- 'tpope/vim-fugitive',
		-- surround
		-- 'tpope/vim-surround',
		-- telescope: fuzzy file search
		{
			'nvim-telescope/telescope.nvim',
			dependencies = {
				'nvim-telescope/telescope-media-files.nvim',
				'nvim-telescope/telescope-packer.nvim',
				'nvim-telescope/telescope-node-modules.nvim',
				'nvim-telescope/telescope-ui-select.nvim',
				'mollerhoj/telescope-recent-files.nvim',
				'LukasPietzschmann/telescope-tabs',
				'jonarrien/telescope-cmdline.nvim',
			}
		},

		'norcalli/nvim-colorizer.lua',

		{
			'windwp/nvim-ts-autotag',
			opts = {}
		},
		'gpanders/editorconfig.nvim',
		'ethanholz/nvim-lastplace',
		'chaoren/vim-wordmotion',
		'godlygeek/tabular',
		{
			"SmiteshP/nvim-navic",
			init = function()
				require('nvim-navic').setup({
					depth_limit = 2,
					highlight = true,
					separator = "  ",
					lazy_update_context = true,
					depth_limit_indicator = "[...]",
					lsp = {
						auto_attach = true
					}
				})
			end,
		},
		{
			"nvimtools/none-ls.nvim",
			dependencies = {
				"nvimtools/none-ls-extras.nvim",
			},
		},
		{
			'nvim-lualine/lualine.nvim',
			event = "VeryLazy",
			init = function()
				local theme = require 'lualine.themes.catppuccin'
				local overseer = require 'overseer'
				theme.normal.c.mg = "#313244"
				require('lualine').setup({
					sections = {
						lualine_c = {
							'filename',
							{
								"navic",
								color_correction = "dynamic"
							}
						},
						lualine_x = {
						},
						lualine_y = {
							"progress",
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
					extensions = { 'quickfix', 'nvim-tree', 'lazy', 'mason' }
				})

				vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
				vim.api.nvim_create_autocmd("User", {
					group = "lualine_augroup",
					pattern = "LspProgressStatusUpdated",
					callback = require("lualine").refresh,
				})
			end,
		},
		-- {
		-- 	"j-hui/fidget.nvim",
		-- 	opts = {
		-- 		-- options
		-- 	},
		-- },
		-- 'windwp/nvim-autopairs',
		'mattn/emmet-vim',

		'lambdalisue/suda.vim',

		{
			'folke/which-key.nvim',
			event = "VeryLazy",
			opts = {
				preset = "helix",
			}
		},
		{
			'ojroques/nvim-lspfuzzy',
			dependencies = {
				{ 'junegunn/fzf' },
				{ 'junegunn/fzf.vim' }, -- to enable preview (optional)
			},
			opts = {},
		},
		{
			'hrsh7th/nvim-cmp',
			event = "InsertEnter",
			dependencies = {
				"zbirenbaum/copilot-cmp",
				'hrsh7th/cmp-nvim-lsp',
				'hrsh7th/cmp-buffer',
				'hrsh7th/cmp-path',
				'saadparwaiz1/cmp_luasnip',
				'hrsh7th/cmp-cmdline',
				'roginfarrer/cmp-css-variables',
				"jcha0713/cmp-tw2css",
				'hrsh7th/cmp-nvim-lsp-signature-help',
				'hrsh7th/cmp-nvim-lsp-document-symbol',
			},
			init = function()
				local cmp = require 'cmp'
				local lspkind = require 'lspkind'
				lspkind.init({
					symbol_map = {
						Copilot = "",
					},
				})

				vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#a6d189" })

				local has_words_before = function()
					if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
					local line, col = unpack(vim.api.nvim_win_get_cursor(0))
					return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
				end

				cmp.setup({
					snippet = {
						expand = function(args)
							require('luasnip').lsp_expand(args.body)
						end
					},
					---@diagnostic disable-next-line: missing-fields
					formatting = {
						format = lspkind.cmp_format({
							mode = 'symbol_text', -- show only symbol annotations
							maxwidth = {
								-- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
								-- can also be a function to dynamically calculate max width such as
								-- menu = function() return math.floor(0.45 * vim.o.columns) end,
								menu = 80,       -- leading text (labelDetails)
								abbr = 80,       -- actual suggestion item
							},
							ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
							show_labelDetails = true, -- show labelDetails in menu. Disabled by default

							-- The function below will be called before any actual modifications from lspkind
							-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
							before = function(entry, vim_item)
								-- ...
								return vim_item
							end
						})
					},
					-- formatting = {
					-- 	fields = { "kind", "abbr", "menu" },
					-- 	format = function(entry, vim_item)
					-- 		local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
					-- 		local strings = vim.split(kind.kind, "%s", { trimempty = true })
					-- 		kind.kind = " " .. (strings[1] or "") .. " "
					-- 		kind.menu = "    [" .. (strings[2] or "") .. "]"
					--
					-- 		return kind
					-- 	end,
					-- },
					mapping = cmp.mapping.preset.insert({
						['<C-b>'] = cmp.mapping.scroll_docs(-4),
						['<C-f>'] = cmp.mapping.scroll_docs(4),
						['<C-Space>'] = cmp.mapping.complete(),
						['<C-e>'] = cmp.mapping.abort(),
						['<CR>'] = cmp.mapping.confirm({ select = true }),
						["<Tab>"] = vim.schedule_wrap(function(fallback)
							if cmp.visible() and has_words_before() then
								cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
							else
								fallback()
							end
						end),
					}),
					sources = cmp.config.sources({
						{ name = "copilot" },
						{
							name = "lazydev",
							group_index = 0, -- set group index to 0 to skip loading LuaLS completions
						},
						{ name = 'nvim_lsp', },
						{ name = 'path', },
						-- { name = 'nvim_lsp_signature_help', },
					}, {
						{ name = 'buffer' },
						{ name = 'luasnip' },
						{ name = 'css-variables' },
						{ name = 'cmp-tw2css' },
					})
				})

				require("copilot_cmp").setup()

				-- Set configuration for specific filetype.
				cmp.setup.filetype('gitcommit', {
					sources = cmp.config.sources({
						{ name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
					}, {
						{ name = 'buffer' },
					})
				})

				-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
				cmp.setup.cmdline({ '/', '?' }, {
					mapping = cmp.mapping.preset.cmdline(),
					sources = cmp.config.sources({
						{ name = 'nvim_lsp_document_symbol' }
					}, {
						{ name = 'cmdline_history' },
						{ name = 'buffer' }
					})
				})

				-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
				cmp.setup.cmdline(':', {
					mapping = cmp.mapping.preset.cmdline(),
					matching = { disallow_symbol_nonprefix_matching = false },
					sources = cmp.config.sources({
						{ name = 'path' },
					}, {
						{ name = 'cmdline_history' },
						{ name = 'cmdline' }
					})
				})


				local sign = function(opts)
					vim.fn.sign_define(opts.name, {
						texthl = opts.name,
						text = opts.text,
						numhl = ''
					})
				end

				sign({ name = 'DiagnosticSignError', text = '✘' })
				sign({ name = 'DiagnosticSignWarn', text = '▲' })
				sign({ name = 'DiagnosticSignHint', text = '⚑' })
				sign({ name = 'DiagnosticSignInfo', text = '' })
			end
		},
		{
			"zbirenbaum/copilot.lua",
			cmd = "Copilot",
			event = "InsertEnter",
			config = function()
				require("copilot").setup({
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
						debounce = 75,
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
				})
			end,
		},

		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
		'neovim/nvim-lspconfig',
		'elentok/format-on-save.nvim',

		{
			"johmsalas/text-case.nvim",
			dependencies = { "nvim-telescope/telescope.nvim" },
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
			-- If you want to use the interactive feature of the `Subs` command right away, text-case.nvim
			-- has to be loaded on startup. Otherwise, the interactive feature of the `Subs` will only be
			-- available after the first executing of it or after a keymap of text-case.nvim has been used.
			lazy = false,
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
			opts = {},
		},

		'heavenshell/vim-jsdoc',

		'onsails/lspkind.nvim',
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
				return {
					bigfile = { enabled = true },
					indent = {
						enabled = false,
						char = "│",
						only_scope = true,
						only_current = false,
						priority = 1,
					},
					scope = {
						enabled = true,
						priority = 200,
						char = "│",
						underline = false, -- underline the start of the scope
						only_current = true, -- only show scope in the current window
						hl = "SnacksIndentScope", ---@type string|string[] hl group for scopes
					},
					input = { enabled = true },
					quickfile = { enabled = true },
					scroll = { enabled = false },
					chunk = { enable = true },
					picker = { enable = true },
					animation = { enabled = true },
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
							{
								pane = 2,
								icon = " ",
								title = "Git Status",
								section = "terminal",
								enabled = function()
									return Snacks.git.get_root() ~= nil
								end,
								cmd = "hub status --short --branch --renames",
								height = 2,
								padding = 2,
								ttl = 5 * 60,
								indent = 3,
							},
							{ section = "startup" },
						},
					},
					notifier = { enabled = true },
					statuscolumn = { enabled = false },
					words = {
						enabled = true,      -- enable/disable the plugin
						debounce = 200,      -- time in ms to wait before updating
						notify_jump = false, -- show a notification when jumping
						notify_end = true,   -- show a notification when reaching the end
						foldopen = true,     -- open folds after jumping
						jumplist = true,     -- set jump point before jumping
						modes = { "n", "i", "c" }, -- modes to show references
					}
				}
			end,
			-- opts = {
			-- 	bigfile = { enabled = true },
			-- 	indent = {
			-- 		enabled = false,
			-- 		char = "│",
			-- 		only_scope = true,
			-- 		only_current = false,
			-- 		priority = 1,
			-- 	},
			-- 	scope = {
			-- 		enabled = false,
			-- 		priority = 200,
			-- 		char = "│",
			-- 		underline = false, -- underline the start of the scope
			-- 		only_current = true, -- only show scope in the current window
			-- 		hl = "SnacksIndentScope", ---@type string|string[] hl group for scopes
			-- 	},
			-- 	input = { enabled = true },
			-- 	quickfile = { enabled = true },
			-- 	scroll = { enabled = false },
			-- 	chunk = { enable = true },
			-- 	picker = { enable = true },
			-- 	animation = { enabled = true },
			-- 	dashboard = {
			-- 		enabled = true,
			-- 		autokeys = "123456789asdfghjkl",
			-- 		preset = {
			-- 			keys = {
			-- 				{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
			-- 				{ icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
			-- 				{ icon = " ", key = "r", desc = "Recent Files", action = ":lua require('telescope').extensions['recent-files'].recent_files({})" },
			-- 				{ icon = "󱠒", key = "r", desc = "Recent Files", action = ":lua require('telescope').extensions['recent-files'].recent_files({})" },
			-- 				-- { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
			-- 				-- { icon = " ", key = "s", desc = "Restore Session", section = "session" },
			-- 				{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
			-- 			}
			-- 		},
			-- 		sections = {
			-- 			{ section = "header" },
			-- 			{ section = "keys", gap = 0, padding = 2 },
			-- 			{ pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
			-- 			{ pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
			-- 			{
			-- 				pane = 2,
			-- 				icon = " ",
			-- 				title = "Git Status",
			-- 				section = "terminal",
			-- 				enabled = function()
			-- 					return Snacks.git.get_root() ~= nil
			-- 				end,
			-- 				cmd = "hub status --short --branch --renames",
			-- 				height = 2,
			-- 				padding = 2,
			-- 				ttl = 5 * 60,
			-- 				indent = 3,
			-- 			},
			-- 			{ section = "startup" },
			-- 		},
			-- 	},
			-- 	notifier = { enabled = true },
			-- 	statuscolumn = { enabled = false },
			-- 	words = {
			-- 		enabled = true,       -- enable/disable the plugin
			-- 		debounce = 200,       -- time in ms to wait before updating
			-- 		notify_jump = false,  -- show a notification when jumping
			-- 		notify_end = true,    -- show a notification when reaching the end
			-- 		foldopen = true,      -- open folds after jumping
			-- 		jumplist = true,      -- set jump point before jumping
			-- 		modes = { "n", "i", "c" }, -- modes to show references
			-- 	}
			-- },
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
			lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
			version = "*", -- Pin Neorg to the latest stable release
			config = true,
			init = function()
				require('neorg').setup()
			end
		},
		-- {
		--   'stevearc/dressing.nvim',
		--   opts = {},
		-- },
		{
			"sindrets/diffview.nvim",
			opts = {},
		},
		{
			"folke/noice.nvim",
			event = "VeryLazy",
			opts = {
				-- add any options here
			},
			dependencies = {
				-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
				"MunifTanjim/nui.nvim",
				-- OPTIONAL:
				--   `nvim-notify` is only needed, if you want to use the notification view.
				--   If not available, we use `mini` as the fallback
				"rcarriga/nvim-notify",
			}
		},
		{ "artemave/workspace-diagnostics.nvim" },
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
			opts = {
				focus = true,
				win = {
					type = "split",
					position = "right",
					size = { width = 0.35 },
				},
				preview = {
					type = "float",
					relative = "cursor",
					border = "rounded",
					scratch = true,
					title = "Preview",
					title_pos = "center",
					position = { 0, -2 },
					size = { width = 0.3, height = 0.3 },
					zindex = 200,
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
		-- {
		-- 	'dmmulroy/tsc.nvim',
		-- 	opts = {
		-- 		auto_open_qflist = false,
		-- 		auto_start_watch_mode = true,
		-- 		use_diagnostics = true,
		-- 		run_as_monorepo = true,
		-- 		use_trouble_qflist = true,
		-- 		flags = {
		-- 			noEmit = true,
		-- 			watch = true,
		-- 		},
		-- 	}
		-- },
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
			"ibhagwan/fzf-lua",
			-- optional for icon support
			dependencies = { "nvim-tree/nvim-web-devicons" },
			-- or if using mini.icons/mini.nvim
			-- dependencies = { "echasnovski/mini.icons" },
			opts = {}
		},
		{
			'echasnovski/mini.surround',
			version = '*',
			opts = {
				-- mappings = {
				-- 	add = 'sa',      -- Add surrounding in Normal and Visual modes
				-- 	delete = 'sd',   -- Delete surrounding
				-- 	find = 'sf',     -- Find surrounding (to the right)
				-- 	find_left = 'sF', -- Find surrounding (to the left)
				-- 	highlight = 'sh', -- Highlight surrounding
				-- 	replace = 'sr',  -- Replace surrounding
				-- 	update_n_lines = 'sn', -- Update `n_lines`
				--
				-- 	suffix_last = 'l', -- Suffix to search with "prev" method
				-- 	suffix_next = 'n', -- Suffix to search with "next" method
				-- },
			}
		},
		{ 'yioneko/nvim-vtsls' },
		{ 'echasnovski/mini.icons',             version = '*', opts = {} },
		{ 'echasnovski/mini.diff',              version = '*', opts = {} },
		{ 'echasnovski/mini-git',               version = '*', main = 'mini.git',                                                 opts = {} },
		{ 'echasnovski/mini.ai',                version = '*', opts = {} },
		{ 'echasnovski/mini.align',             version = '*', opts = { mappings = { start = 'gt', start_with_preview = 'gT', } } },
		{ 'echasnovski/mini.comment',           version = '*', opts = {} },
		{ 'echasnovski/mini.splitjoin',         version = '*', opts = {} },
		-- {
		-- 	"rachartier/tiny-code-action.nvim",
		-- 	dependencies = {
		-- 		{ "nvim-lua/plenary.nvim" },
		-- 		{ "nvim-telescope/telescope.nvim" },
		-- 	},
		-- 	event = "LspAttach",
		-- 	config = function()
		-- 		require('tiny-code-action').setup()
		-- 	end
		-- },
		-- {
		-- 	'nvimdev/lspsaga.nvim',
		-- 	event = "LspAttach",
		-- 	config = function()
		-- 		require('lspsaga').setup({
		-- 			symbol_in_winbar = {
		-- 				enable = false
		-- 			},
		-- 			lightbulb = {
		-- 				enable = false,
		-- 			}
		-- 		})
		-- 	end,
		-- 	dependencies = {
		-- 		'nvim-treesitter/nvim-treesitter', -- optional
		-- 		'nvim-tree/nvim-web-devicons', -- optional
		-- 	}
		-- },
		{
			'nvim-treesitter/nvim-treesitter-context',
			opts = {
				enable = false,
			},
		},
		{
			"OXY2DEV/markview.nvim",
			lazy = false
		},
		{
			'linrongbin16/lsp-progress.nvim',
			config = function()
				require('lsp-progress').setup()
			end
		},
		{
			'echasnovski/mini.operators',
			version = '*',
			opts = {
				-- Each entry configures one operator.
				-- `prefix` defines keys mapped during `setup()`: in Normal mode
				-- to operate on textobject and line, in Visual - on selection.

				-- Evaluate text and replace with output
				evaluate = {
					prefix = 'cr=',

					-- Function which does the evaluation
					func = nil,
				},

				-- Exchange text regions
				exchange = {
					prefix = 'crx',

					-- Whether to reindent new text to match previous indent
					reindent_linewise = true,
				},

				-- Multiply (duplicate) text
				multiply = {
					prefix = 'crm',

					-- Function which can modify text before multiplying
					func = nil,
				},

				-- Replace text with register
				replace = {
					prefix = 'crr',

					-- Whether to reindent new text to match previous indent
					reindent_linewise = true,
				},

				-- Sort text
				sort = {
					prefix = 'crs',

					-- Function which does the sort
					func = nil,
				}
			}
		},
		{
			"zeioth/garbage-day.nvim",
			event = "VeryLazy",
			opts = {
				-- your options here
			}
		},
		{
			'chrisgrieser/nvim-rulebook'
		},
		{
			{
				"antosha417/nvim-lsp-file-operations",
				config = function()
					require("lsp-file-operations").setup()
				end,
			},
		},
		require('settings.luasnips').setup(),
		require('settings.tabby').setup(),
		require('settings.better-ts-errors').setup(),
		require('settings.catppuccin').setup(),
		-- require('settings.faster').setup(),
		require('settings.neoclip').setup(),

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
			config = true,
		},
	})
end

return {
	setup = setup,
}
