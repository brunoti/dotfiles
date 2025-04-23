local M = {}


-- Snacks.terminal.open('zsh -c "npm run test -- --coverage=false --watch=false '..vim.fn.expand('%')..'; exec zsh"')

function M.term_run(command, opts)
	Snacks.terminal.open('zsh -c "' .. command .. '; exec zsh"', opts)
end

return M
