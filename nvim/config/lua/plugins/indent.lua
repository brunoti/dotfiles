return {
	{
		"nvimdev/indentmini.nvim",
		opts = {
		},
		init = function()
			vim.cmd.highlight('IndentLine guifg=#313244')
			vim.cmd.highlight('IndentLineCurrent guifg=#b4befe')
		end
	}
}
