require('nvim-autopairs').setup()
require('nvim-ts-autotag').setup()

vim.cmd [[
function! Multiple_cursors_before()
    lua require('nvim-autopairs').disable()
endfunction

function! Multiple_cursors_after()
    lua require('nvim-autopairs').enable()
endfunction
]]
