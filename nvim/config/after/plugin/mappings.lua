local mapping = require('utils.mapping')
local map = mapping.map
local normal_map = mapping.normal_map
local visual_map = mapping.visual_map

-- disable arrow keys
map('', '<up>', '<nop>')
map('', '<down>', '<nop>')
map('', '<left>', '<nop>')
map('', '<right>', '<nop>')

-- remap <space> as leader key
map('', '<space>', '<nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- split window movement
map('n', '<leader>wh', '<C-w>h', { noremap = false })
map('n', '<leader>wj', '<C-w>j', { noremap = false })
map('n', '<leader>wk', '<C-w>k', { noremap = false })
map('n', '<leader>wl', '<C-w>l', { noremap = false })


-- map jj as <es> for faster back
map('i', 'jj', '<esc>')
map('i', 'kk', '<esc>')

-- neovim tree bindings
map('n', '<C-n>', '<cmd>NvimTreeToggle<cr>')
map('n', '<C-t>', '<cmd>NvimTreeFindFile<cr>')

-- tab navigation
normal_map('L', '<cmd>tabnext<cr>')
normal_map('H', '<cmd>tabprevious<cr>')
normal_map('[t', '<cmd>tabprevious<cr>')
normal_map(']t', '<cmd>tabnext<cr>')

-- clear search highlighting with 2x <leader>
map('n', '<space><space>', '<cmd>nohl<CR>')

-- navigate the right way
normal_map('k', 'gk')
normal_map('j', 'gj')

-- toggle number
normal_map('<leader>n', ':set number! | set relativenumber!<CR>')

-- Cabs to avoid errors on saving, quiting
vim.cmd [[
cab W  w
cab Wq wq
cab Wqa wqa
cab WqA wqa
cab WQa wqa
cab WQA wqa
cab wQA wqa
cab wqA wqa
cab wQ wq
cab WA wa
cab Wa wa
cab Q  q
cab Qa  qa
]]

-- close and save stuff
normal_map('<leader>s', '<cmd>w<cr>')
normal_map('<leader>w', '<cmd>w<cr>')
normal_map('<leader>S', '<cmd>wq<cr>')
normal_map('<leader>Q', '<cmd>q!<cr>')

-- indentation helpers
normal_map('<tab>', '>>')
normal_map('<s-tab>', '<<')
visual_map('<tab>', '>gv')
visual_map('<s-tab>', '<gv')

normal_map('<leader>yf', '<cmd>let @+ = expand("%:p")<cr>')

visual_map('*', "y/\\V<C-R>=escape(@\",'/\')<CR><CR>")
visual_map('#', "y?\\V<C-R>=escape(@\",'/\')<CR><CR>")

map('t', '<esc>', '<C-\\><C-n>')

vim.api.nvim_create_user_command('Autofix',
	function()
		vim.cmd('CocCommand eslint.executeAutofix')
		vim.cmd('CocCommand editor.action.formatDocument')
	end,
	{ nargs = 0 }
)
