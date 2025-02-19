require('mason').setup()
require('mason-lspconfig').setup()

local _ = require('lib.fp')
local lib = require('lib')

local lspconfig = require('lspconfig')
local format_on_save = require('format-on-save')
local formatters = require('format-on-save.formatters')

local lsp_defaults = lspconfig.util.default_config

local capabilities = vim.tbl_deep_extend(
	'force',
	lsp_defaults.capabilities,
	require('cmp_nvim_lsp').default_capabilities()
)
local on_attach = function(client, bufnr)
	-- require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
end

lsp_defaults.capabilities = capabilities
lsp_defaults.on_attach = on_attach
lsp_defaults.single_file_support = false

lspconfig.jsonls.setup {
	capabilities = capabilities,
	on_attach = on_attach,
}

-- lspconfig.ts_ls.setup {
-- 	single_file_support = false,
-- 	capabilities = capabilities,
-- 	on_attach = on_attach,
-- }

lspconfig.hls.setup {
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { 'haskell', 'lhaskell', 'cabal' },
}

lspconfig.eslint.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})


lspconfig.fsharp_language_server.setup {
	capabilities = capabilities,
	on_attach = on_attach,
	dotnet =
	"/Users/bruno/.config/nvim/fsharp-language-server/src/FSharpLanguageServer/bin/Release/net6.0/FSharpLanguageServer.dll"
}
lspconfig.fsautocomplete.setup {
	capabilities = capabilities,
	on_attach = on_attach,
}
lspconfig.clojure_lsp.setup {
	capabilities = capabilities,
	on_attach = on_attach,
}
lspconfig.svelte.setup {
	capabilities = capabilities,
	on_attach = on_attach,
}
lspconfig.gleam.setup {
	capabilities = capabilities,
	on_attach = on_attach,
}
lspconfig.html.setup {
	capabilities = capabilities,
	on_attach = on_attach,
}
lspconfig.jsonls.setup {
	capabilities = capabilities,
	on_attach = on_attach,
}
lspconfig.cssls.setup {
	capabilities = capabilities,
	on_attach = on_attach,
}
lspconfig.lua_ls.setup {
	capabilities = capabilities,
	on_attach = on_attach,
}



-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer

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
			cmd = { "eslint", "--stdin-filename", "%", " --fix-to-stdout" },
		})
	}),
	formatters.if_file_exists({
		pattern = { ".prettierrc", ".prettierrc.*", "prettier.config.*" },
		formatter = formatters.shell({
			cmd = { "prettier", "--stdin-filepath", "%" },
		})
	}),
	formatters.if_file_exists({
		pattern = { "biome.json", "biome.jsonc" },
		formatter = formatters.shell({
			cmd = { "biome", "check", "--apply-unsafe", "--skip-errors", "--stdin-file-path", "%" },
		})
	}),
	formatters.lsp,
}

format_on_save.setup({
	stderr_loglevel = vim.log.levels.OFF,
	auto_commands = false,
	--  user_commands = false,
	exclude_path_patterns = {
		"/node_modules/",
		".local/share/nvim/lazy",
	},
	experiments = {
		partial_update = 'diff', -- or 'line-by-line'
	},
	formatter_by_ft = {
		css = js,
		html = formatters.lsp,
		clojure = formatters.lsp,
		java = formatters.lsp,
		-- json = js,
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

-- require("typescript-tools").setup {
-- 	capabilities = capabilities,
-- 	on_attach = lsp_defaults.on_attach,
-- 	root_dir = function(fname)
-- 		local root_dir = lspconfig.util.root_pattern("tsconfig.json")(fname)
--
-- 		-- this is needed to make sure we don't pick up root_dir inside node_modules
-- 		local node_modules_index = root_dir
-- 				and root_dir:find("node_modules", 1, true)
-- 		if node_modules_index and node_modules_index > 0 then
-- 			---@diagnostic disable-next-line: need-check-nil
-- 			root_dir = root_dir:sub(1, node_modules_index - 2)
-- 		end
--
-- 		return root_dir
-- 	end,
-- 	settings = {
-- 		-- spawn additional tsserver instance to calculate diagnostics on it
-- 		separate_diagnostic_server = true,
-- 		-- "change"|"insert_leave" determine when the client asks the server about diagnostic
-- 		publish_diagnostic_on = "change",
-- 		-- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
-- 		-- "remove_unused_imports"|"organize_imports") -- or string "all"
-- 		-- to include all supported code actions
-- 		-- specify commands exposed as code_actions
-- 		expose_as_code_action = "all",
-- 		-- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
-- 		-- not exists then standard path resolution strategy is applied
-- 		-- tsserver_path = nil,
-- 		-- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
-- 		-- (see 💅 `styled-components` support section)
-- 		-- tsserver_plugins = {},
-- 		-- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
-- 		-- memory limit in megabytes or "auto"(basically no limit)
-- 		tsserver_max_memory = "8000",
-- 		code_lens = "off",
-- 		disable_member_code_lens = true,
-- 		-- described below
-- 		tsserver_format_options = {
-- 			-- ref: https://github.com/microsoft/TypeScript/blob/v5.0.4/src/server/protocol.ts#L3418
-- 			semicolons = false,
-- 			insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = true,
-- 		},
-- 		tsserver_file_preferences = {
-- 			disableSuggestions = false,
-- 			quotePreference = "single",
-- 			includeCompletionsForImportStatements = true,
-- 			includeCompletionsForModuleExports = true,
-- 			includeAutomaticOptionalChainCompletions = true,
-- 			displayPartsForJSDoc = true,
-- 			importModuleSpecifierPreference = "non-relative",
-- 			importModuleSpecifierEnding = "auto",
-- 			generateReturnInDocTemplate = true,
-- 			-- https://github.com/microsoft/TypeScript/blob/v5.0.4/src/server/protocol.ts#L3439
-- 		},
-- 		-- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
-- 		complete_function_calls = true,
-- 	},
-- }

local asdf_shims = os.getenv('HOME') .. '/.asdf/shims/'

lspconfig.biome.setup {
	capabilities = capabilities,
	on_attach = on_attach,
	cmd = { asdf_shims .. 'biome', "lsp-proxy" }
}

lspconfig.tailwindcss.setup {
	capabilities = capabilities,
	on_attach = on_attach,
	cmd = { asdf_shims .. "tailwindcss-language-server", "--stdio" }
}

lspconfig.intelephense.setup {
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "php" }
}

lspconfig.elixirls.setup {
	capabilities = capabilities,
	on_attach = on_attach,
	cmd = { "/Users/bruno/.local/share/nvim/mason/packages/elixir-ls/language_server.sh" }
}

local null_ls = require('null-ls')

-- Extracts the text within the specified selection from a table of lines.
-- @param lines string[] A table of strings, where each string represents a line of text.
-- @param selection_pos { row: number, col: number, end_row: number, end_col: number } A table containing the selection position:
--   - row (number): The starting row of the selection (1-based index).
--   - col (number): The starting column of the selection (1-based index).
--   - end_row (number): The ending row of the selection (1-based index).
--   - end_col (number): The ending column of the selection (1-based index).
-- @return string The extracted text, including newlines if the selection spans multiple lines.
-- @return string[] A table containing the extracted lines of text.
function get_selection_from_lines(lines, selection_pos)
	local selection = ""
	local extracted_lines = {}

	-- If the selection is on a single line
	if selection_pos.row == selection_pos.end_row then
		selection = string.sub(lines[selection_pos.row], selection_pos.col, selection_pos.end_col - 1)
		table.insert(extracted_lines, selection)
	else -- If the selection spans multiple lines
		-- Extract the part from the starting line
		local first_line_part = lines[selection_pos.row]:sub(selection_pos.col)
		table.insert(extracted_lines, first_line_part)

		-- Extract the full lines in between, if any
		for i = selection_pos.row + 1, selection_pos.end_row - 1 do
			table.insert(extracted_lines, lines[i])
		end

		-- Extract the part from the ending line
		local last_line_part = lines[selection_pos.end_row]:sub(1, selection_pos.end_col - 1)
		table.insert(extracted_lines, last_line_part)
	end

	return extracted_lines
end

--- Checks if a selection spans multiple lines.
-- @param selection_pos { row: number, end_row: number } A table containing the selection position:
--   - row (number): The starting row of the selection (1-based index).
--   - end_row (number): The ending row of the selection (1-based index).
-- @return boolean True if the selection spans multiple lines, false otherwise.
function is_multiline_selection(selection_pos)
	return selection_pos.row ~= selection_pos.end_row
end


local function indent_range(range)
	select_range(range)
	if range.end_row > range.row then
		vim.fn.feedkeys("=")
	end
end

local function safe_set_text(bufnr, range, new_lines)
	-- Check if the buffer number is valid
	if not vim.api.nvim_buf_is_valid(bufnr) then
		error("Invalid buffer number: " .. bufnr)
	end

	local line_count = vim.api.nvim_buf_line_count(bufnr)

	-- Check if the specified rows are within the buffer's bounds
	if range.row < 1 or range.row > line_count or range.end_row < 1 or range.end_row > line_count then
		error("Row out of bounds: valid range is 1 to " .. line_count)
	end

	-- Set the text in the buffer
	vim.api.nvim_buf_set_text(bufnr, range.row - 1, range.col - 1, range.end_row - 1, range.end_col - 1, new_lines)

	-- Determine the new end position after the text replacement
	local last_line_index
	if #new_lines == 1 then
		-- If new_lines is a single line, the end_row corresponds to the row where it is inserted
		last_line_index = range.row - 1 -- Using zero-based index
	else
		-- If there are multiple lines, calculate the last line index based on the new lines added
		last_line_index = range.row - 1 + #new_lines - 1
	end

	-- Calculate the end column
	local end_col
	if #new_lines == 1 then
		-- If new_lines is a single line, use its length to determine the end column
		end_col = range.col - 1 + #new_lines[1] -- Zero-based index adjustment
	else
		-- If there are multiple lines, use the length of the last line
		end_col = #new_lines[#new_lines] - 1 -- Zero-based index adjustment
	end

	-- Select the newly set text
	-- indent_range({
	-- 	col = range.col - 1,
	-- 	row = range.row - 1,
	-- 	end_col = end_col,
	-- 	end_row = last_line_index,
	-- })
end

local function wrap_selection(tokens, selection)
	if #selection == 1 then
		return {
			tokens[1] .. selection[1] .. tokens[2]
		}
	end

	return pipe(
		selection,
		_.prepend(tokens[1]),
		_.append(tokens[2])
	)
end

local function wrap_in_logging_function(params)
	-- Ensure a selection exists and it's a visual selection
	if not lib.is_visual_mode() then
		return nil -- No selection or not in visual mode
	end

	-- local content = params.content[1]   -- Get the current buffer content
	local range = params.range
	local selection = get_selection_from_lines(params.content, range)

	local code_actions = {
		{
			title = "Wrap in console.log",
			action = function()
				safe_set_text(params.bufnr, range, wrap_selection(
					{ "console.log(", ")" },
					selection
				))
			end,
		},
		{
			title = "Wrap in console.warn",
			action = function()
				safe_set_text(params.bufnr, range, wrap_selection(
					{ "console.warn(", ")" },
					selection
				))
			end,
		},
		{
			title = "Wrap in console.error",
			action = function()
				safe_set_text(params.bufnr, range, wrap_selection(
					{ "console.error(", ")" },
					selection
				))
			end,
		},
	}

	return code_actions
end

local logging_wrapper = {
	name = "logging_wrapper",
	method = null_ls.methods.CODE_ACTION,
	-- filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	filetypes = { "_all" },
	generator = {
		fn = wrap_in_logging_function,
	},
}


local function ts_extras(params)
	-- Ensure a selection exists and it's a visual selection
	if not lib.is_normal_mode() then
		return nil -- No selection or not in visual mode
	end

	local code_actions = {
		{
			title = "Remove unused imports",
			action = function()
				vim.schedule(function()
					vim.lsp.buf.code_action({
						apply = true,
						context = {
							only = { 'source.removeUnused.ts' },
							diagnostics = {},
						},
					})
				end)
			end,
		},
	}

	if not lib.is_lsp_active("ts_ls") or lib.is_lsp_active('vtsls') then
		return {}
	end

	return code_actions
end

function list_code_actions(bufnr, lsp_client, range)
	local params = {
		range = range,
	}
	return lsp_client.request_sync("textDocument/codeAction", params)
end

function show_code_actions()
	local bufnr = vim.fn.bufnr()
	local clients = vim.lsp.get_clients({ bufnr = bufnr }) -- Correct way to get clients

	if #clients == 0 then
		print("No LSP clients attached to this buffer.")
		return
	end

	-- Use the first client (you might need to handle multiple clients if necessary)
	local lsp_client = clients[1]

	local range = {}
	if vim.fn.visualmode() == 'v' then
		local start_pos = vim.fn.getpos('.')
		local end_pos = vim.fn.getpos('v')
		range = {
			start = { line = start_pos[2] - 1, character = start_pos[3] - 1 },
			["end"] = { line = end_pos[2] - 1, character = end_pos[3] - 1 },
		}
	else
		local current_pos = vim.fn.getcurpos()
		range = {
			start = { line = current_pos[2] - 1, character = current_pos[3] - 1 },
			["end"] = { line = current_pos[2] - 1, character = current_pos[3] - 1 },
		}
	end

	local result = list_code_actions(bufnr, lsp_client, range)

	_G.dd(result)

	-- if result and result.result then
	--   local actions = {}
	--   for _, action in ipairs(result.result) do
	--       if action.edit or action.command then -- Check if the action has edit or command
	--           table.insert(actions, {
	--               title = action.title,
	--               action = action,
	--               client_name = lsp_client.name,
	--           })
	--       end
	--   end
	--
	--       if #actions == 0 then
	--           print("No valid code actions available.")
	--           return
	--       end
	--
	--   -- Telescope integration (or your preferred picker):
	--   if require("telescope").pickers then
	--     -- ... (Telescope integration as before)
	--   else
	--     -- Fallback
	--     vim.ui.select(actions, {
	--       prompt = "Select Code Action:",
	--       format_item = function(action) return action.title end,
	--     }, function(choice)
	--       if choice then
	--         apply_code_action(bufnr, actions[choice])
	--       end
	--     end)
	--   end
	--
	-- elseif result and result.error then
	--   print("Error getting code actions: " .. result.error.message)
	-- else
	--   print("No code actions available or error occurred.")
	-- end
end

-- ... (apply_code_action and mappings remain the same)


-- function show_code_actions()
--   local bufnr = vim.fn.bufnr()
--   local clients = vim.lsp.get_clients()
--
--   local range = vim.fn.visualmode() == 'v' and vim.fn.getpos('.') or vim.fn.getcurpos()
--
-- 	for _, client in ipairs(clients) do
-- 		local result = list_code_actions(bufnr, client, range)
-- 		_G.dd(client, result)
-- 	end
--
--   -- if result.result then
--   --   local actions = {}
--   --   for _, action in ipairs(result.result) do
--   --     table.insert(actions, {
--   --       title = action.title,
--   --       action = action,
--   --       client_name = lsp_client.name,
--   --     })
--   --   end
--   --
--   --   -- Now 'actions' is a table containing the code actions.
--   --   -- You can use this table with any picker you like.
--   --
--   --   -- Example: Print the actions to the console (for testing)
--   --   for i, action in ipairs(actions) do
--   --     print(i .. ". " .. action.title)
--   --   end
--   --
--   --   -- Example using vim.ui.select (you can replace this with your picker):
--   --   vim.ui.select(actions, {
--   --     prompt = "Select Code Action:",
--   --     format_item = function(action) return action.title end,
--   --   }, function(choice)
--   --     if choice then
--   --       apply_code_action(bufnr, actions[choice])
--   --     end
--   --   end)
--   --
--   -- elseif result.error then
--   --   print("Error getting code actions: " .. result.error.message)
--   -- else
--   --   print("No code actions available.")
--   -- end
-- end

function apply_code_action(bufnr, selected_action)
	local client = vim.lsp.get_client_by_name(selected_action.client_name)
	if not client then
		print("LSP client not found for this action.")
		return
	end

	if selected_action.action.command then  -- Handle command actions
		vim.lsp.buf.execute_command(selected_action.action.command)
	elseif selected_action.action.edit then -- Handle edit actions
		local workspace_edit = selected_action.action.edit
		vim.lsp.util.apply_workspace_edit(workspace_edit, client.offset_encoding)
	else
		print("Code action has no command or edit.")
	end
end

local ts_extras_wrapper = {
	name = "ts_extras_wrapper",
	method = null_ls.methods.CODE_ACTION,
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	generator = {
		fn = ts_extras,
	},
}

null_ls.register(logging_wrapper)
null_ls.register(ts_extras_wrapper)

null_ls.setup({
	sources = {
	},
})

-- lspconfig.null_ls.setup {
-- 	capabilities = capabilities,
-- 	on_attach = on_attach,
-- }

require("lspconfig.configs").vtsls = require("vtsls").lspconfig -- set default server config, optional but recommended

require("lspconfig").vtsls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

lspconfig.emmet_language_server.setup({
	filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "pug", "typescriptreact" },
	-- Read more about this options in the [vscode docs](https://code.visualstudio.com/docs/editor/emmet#_emmet-configuration).
	-- **Note:** only the options listed in the table are supported.
	init_options = {
		---@type table<string, string>
		includeLanguages = {},
		--- @type string[]
		excludeLanguages = {},
		--- @type string[]
		extensionsPath = {},
		--- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
		preferences = {},
		--- @type boolean Defaults to `true`
		showAbbreviationSuggestions = true,
		--- @type "always" | "never" Defaults to `"always"`
		showExpandedAbbreviation = "always",
		--- @type boolean Defaults to `false`
		showSuggestionsAsSnippets = false,
		--- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
		syntaxProfiles = {},
		--- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
		variables = {},
	},
})
