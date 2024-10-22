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

local treesitter = require('treesitter')

local function setup()
	require('lazy').setup({
		-- neovim tree sitter
		{ 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate', config = treesitter.setup },
		'alvan/vim-closetag',
		'andymass/vim-matchup',

		'dyng/ctrlsf.vim',
		'tpope/vim-abolish',

		-- nvim-tree: file explorer
		{
			'kyazdani42/nvim-tree.lua',
			dependencies = {
				'kyazdani42/nvim-web-devicons', -- optional, for file icons
			},
		},

		-- git commands
		'tpope/vim-fugitive',
		-- surround
		'tpope/vim-surround',
		-- multi cursor
		'terryma/vim-multiple-cursors',
		-- plenary: async helpers
		'nvim-lua/plenary.nvim',
		-- telescope: fuzzy file search
		{
			'nvim-telescope/telescope.nvim',
			dependencies = {
				'nvim-telescope/telescope-media-files.nvim',
				'nvim-telescope/telescope-packer.nvim',
				'nvim-telescope/telescope-node-modules.nvim',
				'nvim-telescope/telescope-ui-select.nvim',
			}
		},

		-- aquarium: colorscheme
		'frenzyexists/aquarium-vim',

		'norcalli/nvim-colorizer.lua',
		'numToStr/Comment.nvim',

		'windwp/nvim-ts-autotag',
		'alvarosevilla95/luatab.nvim',
		'rafamadriz/friendly-snippets',
		'yamatsum/nvim-cursorline',
		'gpanders/editorconfig.nvim',
		'phaazon/hop.nvim',
		'chaoren/vim-wordmotion',
		'ethanholz/nvim-lastplace',
		'godlygeek/tabular',
		'nvim-lualine/lualine.nvim',
		'rust-lang/rust.vim',
		'windwp/nvim-autopairs',
		'mattn/emmet-vim',
		'lambdalisue/suda.vim',
		'jparise/vim-graphql',
		'styled-components/vim-styled-components',

		'liquidz/vim-iced',
		'Olical/conjure',
		'guns/vim-sexp',
		'tpope/vim-sexp-mappings-for-regular-people',

		'0styx0/abbreinder.nvim',
		'folke/which-key.nvim',
		{
			'folke/zen-mode.nvim',
			opts = {
				window = {
					backdrop = 1,
					width = 80,
				},
				plugins = {
					options = {
						enabled = true,
					},
					tmux = { enabled = false }, -- disables the tmux statusline	
					wezterm = {
						enabled = true,
						font = '+4'
					}
				}
			}
		},

		'ray-x/aurora',

		'rmagatti/goto-preview',
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-buffer',
		'hrsh7th/cmp-path',
		'hrsh7th/cmp-cmdline',
		{
			'hrsh7th/nvim-cmp',
			commit = 'b356f2c'
		},
		'mfussenegger/nvim-lint',
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
		'neovim/nvim-lspconfig',
		'elentok/format-on-save.nvim',
		'kosayoda/nvim-lightbulb',
		{
			"pmizio/typescript-tools.nvim",
			dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
			opts = {},
		},


		'heavenshell/vim-jsdoc',

		'ionide/Ionide-vim',

		{
			"chrisgrieser/nvim-various-textobjs",
			lazy = false,
			opts = { useDefaultKeymaps = true },
		},

		{
			'Exafunction/codeium.vim',
			event = 'BufEnter'
		},

		'saadparwaiz1/cmp_luasnip',
		'onsails/lspkind.nvim',
		require('settings.obsidian').setup(),
		require('settings.luasnips').setup(),
		require('settings.tabby').setup(),
		require('settings.better-ts-errors').setup(),
		require('settings.catppuccin').setup(),
	})
end

return {
	setup = setup,
}
