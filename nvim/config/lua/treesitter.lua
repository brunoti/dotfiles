-- Not required by current config; treesitter is configured in lua/plugins.lua.
-- If you require this module, prefer a language list over "all" to avoid high memory/disk use.
return {
	setup = function()
		require('nvim-treesitter.configs').setup {
			ensure_installed = "all", -- consider e.g. { "lua", "vim", "javascript", "typescript", ... }
			context_commentstring = {
				enable = true
			},
			indent = {
				enable = true
			},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			rainbow = {
				enable = true,
				-- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
				extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
				max_file_lines = nil, -- Do not enable for files with more than n lines, int
				-- colors = {}, -- table of hex strings
				-- termcolors = {} -- table of colour name strings
			},
		}
		require('nvim-ts-autotag').setup()


		vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
			vim.lsp.diagnostic.on_publish_diagnostics,
			{
				underline = true,
				virtual_text = {
					spacing = 5,
					severity_limit = 'Warning',
				},
				update_in_insert = true,
			}
		)
	end
}
