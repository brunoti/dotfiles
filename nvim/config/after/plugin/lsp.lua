require('mason').setup()
require('mason-lspconfig').setup()

local lspconfig = require('lspconfig')
local format_on_save = require('format-on-save')
local formatters = require('format-on-save.formatters')

local lsp_defaults = lspconfig.util.default_config


lsp_defaults.capabilities = vim.tbl_deep_extend(
	'force',
	lsp_defaults.capabilities,
	require('cmp_nvim_lsp').default_capabilities()
)

local vscode_extension = lsp_defaults.capabilities
vscode_extension.textDocument.completion.completionItem.snippetSupport = true

lspconfig.jsonls.setup {
	capabilities = vscode_extension
}

lspconfig.hls.setup {
	filetypes = { 'haskell', 'lhaskell', 'cabal' },
}

lspconfig.eslint.setup({
	cmd = { "eslint_d", "--stdio" },
	on_attach = function(client, bufnr)
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			command = "EslintFixAll",
		})
	end,
})


lspconfig.fsharp_language_server.setup {
	dotnet =
	"/Users/bruno/.config/nvim/fsharp-language-server/src/FSharpLanguageServer/bin/Release/net6.0/FSharpLanguageServer.dll"
}
lspconfig.fsautocomplete.setup {
}
lspconfig.clojure_lsp.setup {
}
lspconfig.svelte.setup {
}
lspconfig.gleam.setup {
}
lspconfig.tailwindcss.setup {
}
lspconfig.html.setup {
}
lspconfig.jsonls.setup {
}
lspconfig.cssls.setup {
}
lspconfig.lua_ls.setup {
	on_init = function(client)
		local path = client.workspace_folders[1].name
		if not vim.loop.fs_stat(path .. '/.luarc.json') and not vim.loop.fs_stat(path .. '/.luarc.jsonc') then
			client.config.settings = vim.tbl_deep_extend('force', client.config.settings.Lua, {
				runtime = {
					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
					version = 'LuaJIT'
				},
				-- Make the server aware of Neovim runtime files
				workspace = {
					library = { vim.env.VIMRUNTIME }
					-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
					-- library = vim.api.nvim_get_runtime_file("", true)
				}
			})

			client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
		end
		return true
	end
}


vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", "<cmd>tab split | lua vim.lsp.buf.definition()<CR>", opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
		vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set('n', '<space>wl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
		-- vim.keymap.set('n', '<space>F', vim.lsp.buf.format, opts)
		vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
		vim.keymap.set({ 'n', 'v' }, '<space>ac', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
		vim.keymap.set('n', '<space>F', function()
			vim.lsp.buf.format { async = true }
		end, opts)
	end,
})

-- Function to check if a floating dialog exists and if not
-- then check for diagnostics under the cursor
function OpenDiagnosticIfNoFloat()
	for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.api.nvim_win_get_config(winid).zindex then
			return
		end
	end
	-- THIS IS FOR BUILTIN LSP
	vim.diagnostic.open_float(0, {
		scope = "cursor",
		focusable = false,
		close_events = {
			"CursorMoved",
			"CursorMovedI",
			"BufHidden",
			"InsertCharPre",
			"WinLeave",
		},
	})
end

-- Show diagnostics under the cursor when holding position
vim.api.nvim_create_augroup("lsp_diagnostics_hold", { clear = true })
vim.api.nvim_create_autocmd({ "CursorHold" }, {
	pattern = "*",
	command = "lua OpenDiagnosticIfNoFloat()",
	group = "lsp_diagnostics_hold",
})


vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
	vim.lsp.handlers.hover,
	{ border = 'none' }
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
	vim.lsp.handlers.signature_help,
	{ border = 'none' }
)

vim.diagnostic.config({
	virtual_text = false,
	severity_sort = true,
	float = {
		border = 'none',
		source = 'always',
	},
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = false
	}
)

local js = {
	formatters.if_file_exists({
		pattern = { "eslint.config.*" },
		formatter = formatters.shell({
			cmd = { "eslint_d", "--stdin-filepath", "%" },
		})
	}),
	formatters.if_file_exists({
		pattern = { ".prettierrc", ".prettierrc.*", "prettier.config.*" },
		formatter = formatters.shell({
			cmd = { "prettierd", "--stdin-filepath", "%" },
		})
	}),
	formatters.if_file_exists({
		pattern = { "biome.json" },
		formatter = formatters.shell({
			cmd = { "biome", "format", "--skip-errors", "--stdin-file-path", "%" },
		})
	}),
	formatters.lsp,
}

format_on_save.setup({
	exclude_path_patterns = {
		"/node_modules/",
		".local/share/nvim/lazy",
	},
	formatter_by_ft = {
		css = js,
		html = formatters.lsp,
		clojure = formatters.lsp,
		java = formatters.lsp,
		json = js,
		lua = formatters.lsp,
		pug = formatters.lsp,
		-- pug = formatters.prettierd,
		openscad = formatters.lsp,
		python = formatters.lsp,
		rust = formatters.lsp,
		scad = formatters.lsp,
		scss = formatters.lsp,
		sh = formatters.shfmt,
		terraform = formatters.lsp,
		yaml = formatters.lsp,
		gleam = formatters.lsp,

		-- Add your own shell formatters:
		-- myfiletype = formatters.shell({ cmd = { "myformatter", "%" } }),

		-- Add lazy formatter that will only run when formatting:
		my_custom_formatter = function()
			if vim.api.nvim_buf_get_name(0):match("/README.md$") then
				return formatters.prettierd
			else
				return formatters.lsp()
			end
		end,

		javascript = js,
		typescript = js,
		svelte = js,
		typescriptreact = js,
		javascriptreact = js,
	},

	-- Optional: fallback formatter to use when no formatters match the current filetype
	fallback_formatter = {
		formatters.remove_trailing_whitespace,
		formatters.remove_trailing_newlines,
	}

	-- By default, all shell commands are prefixed with "sh -c" (see PR #3)
	-- To prevent that set `run_with_sh` to `false`.
	-- run_with_sh = false,
})

-- lightbulb.setup {
-- 	autocmd = { enabled = true },
-- 	virtual_text = {
-- 		enabled = false,
-- 	},
-- }

require("typescript-tools").setup {
	single_file_support = false,
	root_dir = function(fname)
		local root_dir = lspconfig.util.root_pattern("tsconfig.json")(fname)

		-- this is needed to make sure we don't pick up root_dir inside node_modules
		local node_modules_index = root_dir
				and root_dir:find("node_modules", 1, true)
		if node_modules_index and node_modules_index > 0 then
			---@diagnostic disable-next-line: need-check-nil
			root_dir = root_dir:sub(1, node_modules_index - 2)
		end

		return root_dir
	end,
	settings = {
		-- spawn additional tsserver instance to calculate diagnostics on it
		separate_diagnostic_server = true,
		-- "change"|"insert_leave" determine when the client asks the server about diagnostic
		publish_diagnostic_on = "insert_leave",
		-- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
		-- "remove_unused_imports"|"organize_imports") -- or string "all"
		-- to include all supported code actions
		-- specify commands exposed as code_actions
		expose_as_code_action = "all",
		-- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
		-- not exists then standard path resolution strategy is applied
		-- tsserver_path = nil,
		-- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
		-- (see 💅 `styled-components` support section)
		-- tsserver_plugins = {},
		-- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
		-- memory limit in megabytes or "auto"(basically no limit)
		-- tsserver_max_memory = "auto",
		-- described below
		tsserver_format_options = {
			-- ref: https://github.com/microsoft/TypeScript/blob/v5.0.4/src/server/protocol.ts#L3418
			semicolons = false,
			insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = true,
		},
		tsserver_file_preferences = {
			disableSuggestions = false,
			quotePreference = "single",
			includeCompletionsForImportStatements = true,
			includeCompletionsForModuleExports = true,
			includeAutomaticOptionalChainCompletions = true,
			displayPartsForJSDoc = true,
			importModuleSpecifierPreference = "non-relative",
			importModuleSpecifierEnding = "auto",
			generateReturnInDocTemplate = true,
			-- https://github.com/microsoft/TypeScript/blob/v5.0.4/src/server/protocol.ts#L3439
		},
		-- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
		complete_function_calls = true,
	},
}

lspconfig.biome.setup {
	filetypes = { "javascript", "javascriptreact", "json", "jsonc", "typescript", "typescript.tsx", "typescriptreact", "astro", "svelte", "vue", "css" }
}

require('goto-preview').setup {}

require 'ionide'.setup {}
