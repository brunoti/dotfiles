local autocmd = require('utils.autocmd')
local plugins = require('plugins')

-- make it faster
vim.opt.updatetime = 300
-- don't pass messages to uneeded places
vim.cmd('set shortmess+=c')
-- fix encoding
vim.opt.encoding = 'utf-8'
-- TextEdit might fail if hidden is not set.
vim.opt.hidden = true
-- don't use backup files
vim.opt.backup = false
-- don't backup the files while editing
vim.opt.writebackup = false
-- don't create swap files for new buffers
vim.opt.swapfile = false
-- don't write swap files after some number of updates
vim.opt.updatecount = 0

vim.opt.backupdir = {
	"~/.vim-tmp",
	"~/.tmp",
	"~/tmp",
	"/var/tmp",
	"/tmp"
}

vim.opt.directory = {
	"~/.vim-tmp",
	"~/.tmp",
	"~/tmp",
	"/var/tmp",
	"/tmp"
}

-- store the last 1000 commands entered
vim.opt.history = 10000
-- after configured number of characters, wrap line
vim.opt.textwidth = 120
-- make backspace behave in a sane manner
vim.opt.backspace = { "indent", "eol,start" }

-- searching
--------------------------------------------------------
-- case insensitive searching
vim.opt.ignorecase = true
-- case-sensitive if expresson contains a capital letter
vim.opt.smartcase = true
-- highlight search results
vim.opt.hlsearch = true
-- set incremental search, like modern browsers
vim.opt.incsearch = true
-- don't redraw while executing macros
vim.opt.lazyredraw = false
-- set magic on, for regular expressions
vim.opt.magic = true

if vim.fn.executable("rg") then
	-- if ripgrep installed, use that as a grepper
	vim.opt.grepprg = "rg --vimgrep --no-heading"
	vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

-- error bells
vim.opt.errorbells = false
vim.opt.visualbell = true
vim.opt.timeoutlen = 500

-- Appearance
---------------------------------------------------------
-- show cursor line
vim.opt.cursorline = false
-- show line numbers
vim.opt.number = false
-- show relative line number
vim.opt.relativenumber = false
-- turn on line wrapping
vim.opt.wrap = true
-- wrap lines when coming within n characters from side
vim.opt.wrapmargin = 8
-- set soft wrapping
vim.opt.linebreak = true
vim.opt.showbreak = ""
-- automatically set indent of new line
vim.opt.autoindent = true
-- faster redrawing
vim.opt.ttyfast = true
-- show the status line all the time
vim.opt.laststatus = 2
-- set 7 lines to the cursors - when moving vertical
vim.opt.scrolloff = 7
-- enhanced command line completion
vim.opt.wildmenu = true
-- current buffer can be put into background
vim.opt.hidden = true
-- show incomplete commands
vim.opt.showcmd = true
-- don't show which mode disabled for PowerLine
vim.opt.showmode = true
-- -- complete files like a shell
-- vim.opt.wildmode = { "list", "longest" }
-- set shell
vim.opt.shell = vim.env.SHELL
-- command bar height
vim.opt.cmdheight = 1
-- set terminal title
vim.opt.title = true
-- show matching braces
vim.opt.showmatch = true
-- how many tenths of a second to blink
vim.opt.mat = 2
vim.opt.updatetime = 300
vim.opt.signcolumn = "yes"
-- prompt message options
vim.opt.shortmess = "atToOFc"

-- Tab control
-- tab respects 'tabstop', 'shiftwidth', and 'softtabstop'
vim.opt.smarttab = true
-- the visible width of tabs
vim.opt.tabstop = 2
-- edit as if the tabs are 4 characters wide
vim.opt.softtabstop = 2
-- number of spaces to use for indent and unindent
vim.opt.shiftwidth = 2
-- round indent to a multiple of 'shiftwidth'
vim.opt.shiftround = true

-- folding control
-- don't fold by default
vim.opt.foldenable = false
-- only fold first level
vim.opt.foldlevel = 1

-- turn syntax on and filetype indentation
vim.cmd [[syntax on]]
vim.cmd [[filetype plugin indent on]]

-- set filetype to typescript always
autocmd({ 'BufNewFile', 'BufRead' }, { '*.tsx', ':set filetype=typescriptreact' })
autocmd({ 'BufNewFile', 'BufRead' }, { '*.js,*.jsx', ':set filetype=javascriptreact' })

vim.cmd [[
  autocmd FileType haskell setlocal expandtab
  autocmd FileType haskell setlocal tabstop=4
  autocmd FileType haskell setlocal shiftwidth=4
  autocmd FileType cabal setlocal expandtab
  autocmd FileType cabal setlocal tabstop=4
  autocmd FileType cabal setlocal shiftwidth=4
]]

vim.opt.undodir = "~/.config/nvim/.undo"
vim.opt.backupdir = "~/.config/nvim/.backup"
vim.opt.directory = "~/.config/nvim/.swp"
vim.opt.undofile = true

vim.cmd "set mouse="

plugins.setup()

-- -- Function to restart the LSP server for Svelte
-- local function restart_svelte_lsp()
-- 	vim.lsp.stop_client(vim.lsp.get_active_clients({ name = 'svelte' }))
-- 	vim.cmd('LspStart svelte')
-- end
--
-- -- Auto command group for Svelte LSP
-- vim.api.nvim_create_augroup('SvelteLspRestart', { clear = true })
--
-- -- Auto commands to trigger the LSP restart
-- vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost' }, {
-- 	group = 'SvelteLspRestart',
-- 	pattern = '*.svelte',
-- 	callback = restart_svelte_lsp,
-- })
--
-- -- Timer to restart the LSP server periodically
-- local timer = vim.loop.new_timer()
-- local interval = 60000 -- 60 seconds
--
-- timer:start(interval, interval, vim.schedule_wrap(function()
-- 	if vim.bo.filetype == 'svelte' then
-- 		restart_svelte_lsp()
-- 	end
-- end))
