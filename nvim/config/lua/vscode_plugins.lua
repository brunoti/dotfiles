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

require('lazy').setup({

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
		'nvim-tree/nvim-web-devicons', -- optional, for file icons
	},
	-- nvim-tree: file explorer
	{
		'nvim-tree/nvim-tree.lua',
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
		"johmsalas/text-case.nvim",
		opts = {},
		cmd = {
			-- NOTE: The Subs command name can be customized via the option "substitude_command_name"
			"Subs",
		},
		lazy = true,
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
		'onsails/lspkind.nvim',
		init = function()
			local lspkind = require 'lspkind'
			lspkind.init({
				symbol_map = {
					Copilot = "",
				},
			})
		end
	},
	{
		'glepnir/nerdicons.nvim',
		cmd = 'NerdIcons',
		opts = {}
	},
	{
		"chrisgrieser/nvim-various-textobjs",
		lazy = false,
		opts = { keymaps = { useDefaults = false } },
	},
	{
		'echasnovski/mini.surround',
		version = '*',
		opts = {
			mappings = {
				add = 'sa',        -- Add surrounding in Normal and Visual modes
				delete = 'sd',     -- Delete surrounding
				find = 'sf',       -- Find surrounding (to the right)
				find_left = 'sF',  -- Find surrounding (to the left)
				highlight = 'sh',  -- Highlight surrounding
				replace = 'sr',    -- Replace surrounding
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
	{ 'echasnovski/mini.icons', version = '*', opts = {} },
	-- {
	-- 	'echasnovski/mini.diff',
	-- 	enable = false,
	-- 	version = '*',
	-- 	opts = {},
	-- 	event = { "BufReadPost", "BufNewFile", "BufWritePre" }
	-- },
	{ 'echasnovski/mini-git',   version = '*', main = 'mini.git', opts = {} },
	{ 'echasnovski/mini.ai',    version = '*', opts = {} },
	{
		'echasnovski/mini.align',
		enable = false,
		version = '*',
		opts = { mappings = { start = 'al', start_with_preview = 'aL', } }
	},
	{ 'echasnovski/mini.comment',   version = '*', opts = {} },
	{ 'echasnovski/mini.splitjoin', version = '*', opts = {} },
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
	{
		"gbprod/yanky.nvim",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
	{
		"tpope/vim-abolish",
		cmd = { "Abolish", "S", "Subvert" },
	},
	{
		'lewis6991/gitsigns.nvim',
		opts = {}
	},
})
