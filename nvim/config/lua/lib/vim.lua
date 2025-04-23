local M = {}

function M.set_sign_text(opts)
	vim.fn.sign_define(opts.name, {
		texthl = opts.name,
		text = opts.text,
		numhl = ''
	})
end


return M
