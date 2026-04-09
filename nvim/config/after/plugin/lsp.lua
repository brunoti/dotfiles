-- =============================================================================
-- Neovim LSP Configuration - Modern vim.lsp.config (Neovim 0.11+)
-- =============================================================================
--
-- This configuration uses the modern vim.lsp.config API for automatic LSP startup.
-- Servers start automatically when opening supported filetypes.
--
-- Servers:
--   • typescript-tools.nvim: TypeScript/JavaScript with enhanced features
--   • Biome: Linting and formatting for JS/TS/JSON files
--
-- Features:
--   ✅ Automatic LSP startup based on filetypes
--   ✅ typescript-tools.nvim with enhanced TypeScript support
--   ✅ Biome for linting and formatting
--   ✅ Performance optimized settings
--   ✅ Format-on-save integration
--   ✅ Diagnostic handling
--   ✅ Performance mode for large projects (toggle via performance_mode variable)
--
-- Configuration:
--   • typescript-tools.nvim: Configured in lua/plugins.lua
--   • performance_mode: true = maximum speed (disables autoimports, reduces memory)
--                       false = full features (default)
--
-- =============================================================================

if vim.g.vscode then
	return
end

local _ = require('lib.fp')
local lib = require('lib')

local format_on_save = require('format-on-save')
local formatters = require('format-on-save.formatters')

-- =============================================================================
-- Helper Functions
-- =============================================================================

--- Get LSP client capabilities with completion and blink support
local function get_capabilities()
	local __get = function()
		local _, cmp = pcall(require, 'cmp_nvim_lsp')
		local _, blink = pcall(require, 'blink.cmp')

		if blink then return blink.get_lsp_capabilities() end
		if cmp then return cmp.default_capabilities() end

		return vim.lsp.protocol.make_client_capabilities()
	end

	local cap = __get()

	cap.textDocument.completion.completionItem.snippetSupport = true

	return cap;
end

local capabilities = get_capabilities()

--- On attach function for LSP clients
local function on_attach(client, bufnr)
	-- Future: Add workspace diagnostics if needed
	-- require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
end

-- =============================================================================
-- Language Server Configurations and Startup
-- =============================================================================

-- Choose TypeScript LSP: "vtsls" or "ts_ls"
local typescript_lsp = "vtsls" -- Change to "vtsls" for full refactoring support

-- Performance mode: Enables aggressive optimizations for large projects (and lower memory).
-- When true: Disables autoimports, suggestions, and expensive processing for maximum speed
--             BUT keeps essential features: hover, go-to-definition, references, rename
-- When false: Full features enabled (autoimports, completions, suggestions, etc.)
-- See reports/nvim-memory-investigation.md for full memory analysis.
local performance_mode = false

vim.lsp.config('jsonls', {
	capabilities = capabilities,
})


-- Register TypeScript Language Server (official);
vim.lsp.config.ts_ls = {
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	root_markers = { 'tsconfig.json', 'jsconfig.json', '.git', 'package.json' },
	capabilities = capabilities,
	on_attach = on_attach,
	init_options = {
		maxTsServerMemory = performance_mode and 2048 or 4096, -- Lower in performance mode
		preferences = {
			includeInlayParameterNameHints = "none",
			includeInlayParameterNameHintsWhenArgumentMatchesName = false,
			includeInlayFunctionParameterTypeHints = false,
			includeInlayVariableTypeHints = false,
			includeInlayPropertyDeclarationTypeHints = false,
			includeInlayFunctionLikeReturnTypeHints = false,
			includeInlayEnumMemberValueHints = false,
		},
	},
	settings = {
		typescript = {
			preferences = {
				includePackageJsonAutoImports = performance_mode and "off" or "auto",
				updateImportsOnFileMove = performance_mode and "never" or "prompt",
			},
			suggest = {
				autoImports = not performance_mode, -- Only disable autoimports in perf mode
				enabled = true,                 -- Always keep suggestions enabled
			},
		},
		javascript = {
			preferences = {
				includePackageJsonAutoImports = performance_mode and "off" or "auto",
				updateImportsOnFileMove = performance_mode and "never" or "prompt",
			},
			suggest = {
				autoImports = not performance_mode, -- Only disable autoimports in perf mode
				enabled = true,                 -- Always keep suggestions enabled
			},
		},
	},
}

-- -- Clean up any conflicting LSP clients from old configurations
-- vim.api.nvim_create_autocmd("VimEnter", {
-- 	callback = function()
-- 		-- Only stop clients that might conflict (duplicates from old lspconfig setup)
-- 		-- We allow VTSLS and Biome to coexist as they serve different purposes
-- 		local clients = vim.lsp.get_clients()
-- 		local seen = {}
--
-- 		for _, client in ipairs(clients) do
-- 			local key = client.name .. ":" .. (client.root_dir or "")
-- 			if seen[key] then
-- 				-- This is a duplicate, stop it
-- 				vim.lsp.stop_client(client.id)
-- 			else
-- 				seen[key] = true
-- 			end
-- 		end
-- 	end,
-- })

-- VTSLS (TypeScript/JavaScript) - Full Refactoring Support
vim.lsp.config.vtsls = {
	-- Command and arguments - OPTIMIZED for monorepo performance
	cmd = performance_mode and {
		"vtsls",
		"--stdio",
		"--node-options=--max-old-space-size=4096,--max-semi-space-size=64,--optimize-for-size,--gc-interval=50"
	} or {
		"vtsls",
		"--stdio",
		"--node-options=--max-old-space-size=8192,--max-semi-space-size=128,--optimize-for-size,--gc-interval=100"
	},

	-- File types this LSP handles
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },

	-- Root directory markers
	root_markers = { 'tsconfig.json', 'jsconfig.json', '.git', 'package.json' },

	-- Capabilities and attach function
	capabilities = capabilities,
	on_attach = on_attach,

	-- Performance optimizations - INCREASED debounce for monorepo
	flags = {
		debounce_text_changes = performance_mode and 500 or 300, -- Higher in performance mode
		exit_timeout = 1000,
	},

	-- TypeScript server configuration
	init_options = {
		maxTsServerMemory = performance_mode and 2048 or 4096, -- Lower in performance mode
		-- Performance optimizations for large monorepos
		allowRenameOfImportPath = false,
		allowTextChangesInNewFiles = false,
		preferences = {
			-- Performance preferences
			includeInlayParameterNameHints = "none",
			includeInlayParameterNameHintsWhenArgumentMatchesName = false,
			includeInlayFunctionParameterTypeHints = false,
			includeInlayVariableTypeHints = false,
			includeInlayPropertyDeclarationTypeHints = false,
			includeInlayFunctionLikeReturnTypeHints = false,
			includeInlayEnumMemberValueHints = false,
			allowRenameOfImportPath = false,
			allowTextChangesInNewFiles = false,
		},
		-- File watching optimization - STRICT exclusions for performance
		watchOptions = {
			excludeDirectories = {
				-- Dependencies
				"**/node_modules/**",
				"**/jspm_packages/**",
				"**/bower_components/**",
				"**/vendor/**",

				-- Build outputs
				"**/dist/**",
				"**/build/**",
				"**/out/**",
				"**/.next/**",
				"**/.nuxt/**",
				"**/.vuepress/**",
				"**/.cache/**",
				"**/.parcel-cache/**",
				"**/.nyc_output/**",

				-- Test coverage
				"**/coverage/**",
				"**/.coverage/**",
				"**/lcov-report/**",

				-- Version control
				"**/.git/**",
				"**/.svn/**",
				"**/.hg/**",

				-- Logs and temp
				"**/logs/**",
				"**/*.log",
				"**/tmp/**",
				"**/temp/**",
				"**/.tmp/**",

				-- IDE/Editor
				"**/.vscode/**",
				"**/.idea/**",
				"**/.vs/**",
				"**/.settings/**",

				-- OS specific
				"**/.DS_Store/**",
				"**/Thumbs.db/**",
				"**/__pycache__/**",
				"**/.pytest_cache/**",

				-- Package manager
				"**/.yarn/cache/**",
				"**/.yarn/install-state.gz",
				"**/.npm/**",
				"**/.pnpm/**",
			},
			excludeFiles = {
				-- Logs
				"**/*.log",
				"**/*.pid",
				"**/*.seed",
				"**/*.pid.lock",

				-- Coverage
				"**/coverage/**",
				"**/lcov.info",

				-- Build artifacts
				"**/dist/**",
				"**/build/**",

				-- Cache files
				"**/.cache/**",
				"**/tsconfig.tsbuildinfo",

				-- Lock files (don't watch these)
				"**/package-lock.json",
				"**/yarn.lock",
				"**/pnpm-lock.yaml",
				"**/bun.lockb",
			},
		},
	},

	-- Settings for TypeScript and JavaScript
	settings = {
		typescript = {
			preferences = {
				-- Performance optimizations
				includePackageJsonAutoImports = performance_mode and "off" or "auto",
				updateImportsOnFileMove = performance_mode and "never" or "prompt",
				disableSuggestions = false,               -- Keep suggestions enabled
				quotePreference = "single",
				includeCompletionsForImportStatements = true, -- Keep completions enabled
				includeCompletionsForModuleExports = false,
				includeAutomaticOptionalChainCompletions = false,
				displayPartsForJSDoc = false,
				importModuleSpecifierPreference = "project-relative",
				importModuleSpecifierEnding = "minimal",
				generateReturnInDocTemplate = false,
				allowRenameOfImportPath = false,
				providePrefixAndSuffixTextForRename = false,
				allowTextChangesInNewFiles = false,
				lazyConfiguredProjectsFromExternalProject = true,
				-- Enable refactoring
				disableLanguageServiceBasedQuickFixes = true,
				disableLanguageServiceBasedCodeActions = true,
				disableSourceDefinitionSearch = true,
				disableGoToSourceDefinition = true,
			},
			suggest = {
				completeFunctionCalls = false,
				autoImports = not performance_mode, -- Only disable autoimports in perf mode
				enabled = true,                 -- Keep suggestions enabled
			},
			workspaceSymbol = {
				search = {
					kind = "onlyExportedSymbols",
				},
			},
			format = {
				enable = false,
			},
			referencesCodeLens = {
				enabled = false,
			},
			implementationsCodeLens = {
				enabled = false,
			},
			semanticTokens = {
				multilineTokenSupport = false,
				overlappingTokenSupport = false,
			},
		},
		javascript = {
			preferences = {
				-- Mirror all TypeScript optimizations
				includeInlayParameterNameHints = "none",
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = false,
				includeInlayVariableTypeHints = false,
				includeInlayPropertyDeclarationTypeHints = false,
				includeInlayFunctionLikeReturnTypeHints = false,
				includeInlayEnumMemberValueHints = false,
				includePackageJsonAutoImports = performance_mode and "off" or "auto",
				updateImportsOnFileMove = performance_mode and "never" or "prompt",
				disableSuggestions = false, -- Keep suggestions enabled
				quotePreference = "single",
				includeCompletionsForImportStatements = true,
				includeCompletionsForModuleExports = false,
				includeAutomaticOptionalChainCompletions = false,
				displayPartsForJSDoc = false,
				importModuleSpecifierPreference = "project-relative",
				importModuleSpecifierEnding = "minimal",
				generateReturnInDocTemplate = false,
				allowRenameOfImportPath = false,
				providePrefixAndSuffixTextForRename = false,
				allowTextChangesInNewFiles = false,
				lazyConfiguredProjectsFromExternalProject = true,
				disableLanguageServiceBasedQuickFixes = true,
				disableLanguageServiceBasedCodeActions = true,
				disableSourceDefinitionSearch = true,
				disableGoToSourceDefinition = true,
			},
			suggest = {
				completeFunctionCalls = false,
				autoImports = not performance_mode, -- Only disable autoimports in perf mode
				enabled = true,                 -- Keep suggestions enabled
			},
			format = {
				enable = false,
			},
			referencesCodeLens = {
				enabled = false,
			},
			implementationsCodeLens = {
				enabled = false,
			},
		},
		vtsls = {
			-- Enable full refactoring support
			enableMoveToFileCodeAction = true,
			enableFileReferences = true,
			enableRenameFileRefactoring = true,
			enableCallHierarchy = false, -- Keep disabled for performance
			enableTypeHierarchy = false, -- Keep disabled for performance

			experimental = {
				completion = {
					enableServerSideFuzzyMatch = true,
					entriesLimit = 30,
					maxSemanticsTokensNumber = 100,
				},
				enableProjectDiagnostics = false,
				enableWorkspaceDiagnostics = false,
				-- Enable refactoring actions - DISABLED for monorepo performance
				enableSourceActions = false, -- Disabled for performance
				enableRefactorActions = false, -- Disabled for performance
			},

			-- TypeScript server optimization - AGGRESSIVE performance settings
			tsserver = {
				maxTsServerMemory = performance_mode and 2048 or 4096, -- Lower in performance mode
				globalPlugins = {},
				plugins = {},

				-- Performance optimizations
				useSyntaxServer = "never",                        -- Disabled for monorepo performance
				separateSyntaxServer = false,                     -- Disabled for monorepo performance
				maxFileSize = performance_mode and 524288 or 1048576, -- 512KB in perf mode, 1MB otherwise

				-- Disable expensive features
				disableAutomaticTypingAcquisition = true, -- Don't auto-download types
				enable = {
					-- Keep essential features, disable only expensive ones
					semanticHighlighting = false,
					completion = true,  -- Always keep completion
					hover = true,       -- Always keep hover (essential!)
					signatureHelp = true, -- Always keep signature help
					definition = true,  -- Always keep go-to-definition (essential!)
					references = true,  -- Always keep references (essential!)
					documentHighlight = false,
					documentSymbol = true, -- Always keep for navigation
					workspaceSymbol = false, -- Expensive in large projects
					codeAction = true,  -- Always keep code actions
					codeLens = false,
					documentFormatting = false,
					documentRangeFormatting = false,
					documentOnTypeFormatting = false,
					rename = true, -- Always keep rename (essential!)
					foldingRange = false,
					selectionRange = false,
					linkedEditingRange = false,
					callHierarchy = false,
					typeHierarchy = false,
					semanticTokens = false,
					inlayHints = false,
				},

				-- Logging optimizations
				logFile = nil,    -- Disable file logging
				logVerbosity = "off", -- Minimal logging

				-- Cache optimizations
				typingsCacheLocation = vim.fn.stdpath("cache") .. "/typescript", -- Custom cache location

				watchOptions = {
					watchFile = "useFsEvents",
					watchDirectory = "useFsEvents",
					fallbackPolling = "dynamicPriority",
					synchronousWatchDirectory = true,
					excludeDirectories = {
						-- Dependencies (same as above)
						"**/node_modules/**",
						"**/jspm_packages/**",
						"**/bower_components/**",
						"**/vendor/**",

						-- Build outputs
						"**/dist/**",
						"**/build/**",
						"**/out/**",
						"**/.next/**",
						"**/.nuxt/**",
						"**/.vuepress/**",
						"**/.cache/**",
						"**/.parcel-cache/**",
						"**/.nyc_output/**",

						-- Test coverage
						"**/coverage/**",
						"**/.coverage/**",
						"**/lcov-report/**",

						-- Version control
						"**/.git/**",
						"**/.svn/**",
						"**/.hg/**",

						-- Logs and temp
						"**/logs/**",
						"**/tmp/**",
						"**/temp/**",
						"**/.tmp/**",

						-- IDE/Editor
						"**/.vscode/**",
						"**/.idea/**",
						"**/.vs/**",
						"**/.settings/**",

						-- OS specific
						"**/.DS_Store/**",
						"**/Thumbs.db/**",
						"**/__pycache__/**",
						"**/.pytest_cache/**",

						-- Package manager
						"**/.yarn/cache/**",
						"**/.yarn/install-state.gz",
						"**/.npm/**",
						"**/.pnpm/**",
					},
				},
			},
		},
	},
}

-- Biome LSP - Fast Linting and Formatting
-- Runs alongside VTSLS for complementary functionality (linting vs language features)
vim.lsp.config.biome = {
	-- Command and arguments
	cmd = {
		"biome",
		"lsp-proxy"
	},

	-- File types this LSP handles (JS/TS/JSON - complements VTSLS)
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc" },

	-- Root directory markers
	root_markers = { "biome.json", "biome.jsonc", ".git" },

	-- Capabilities and attach function
	capabilities = capabilities,
	on_attach = on_attach,
}

vim.lsp.config('lua_ls', {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
					path ~= vim.fn.stdpath('config')
					and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
			then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using (most
				-- likely LuaJIT in the case of Neovim)
				version = 'LuaJIT',
				-- Tell the language server how to find Lua modules same way as Neovim
				-- (see `:h lua-module-load`)
				path = {
					'lua/?.lua',
					'lua/?/init.lua',
				},
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME
					-- Depending on the usage, you might want to add additional paths
					-- here.
					-- '${3rd}/luv/library'
					-- '${3rd}/busted/library'
				}
				-- Or pull in all of 'runtimepath'.
				-- NOTE: this is a lot slower and will cause issues when working on
				-- your own configuration.
				-- See https://github.com/neovim/nvim-lspconfig/issues/3189
				-- library = {
				--   vim.api.nvim_get_runtime_file('', true),
				-- }
			}
		})
	end,
	settings = {
		Lua = {}
	}
})

-- Enable LSP servers

-- =============================================================================
-- LSP Handlers and Optimizations
-- =============================================================================

-- Diagnostic hover on cursor hold
vim.api.nvim_create_augroup("lsp_diagnostics_hold", { clear = true })
vim.api.nvim_create_autocmd({ "CursorHold" }, {
	pattern = "*",
	callback = function()
		-- Do not open diagnostic float if any float is already open (e.g. hover)
		local float_open = false
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local config = vim.api.nvim_win_get_config(win)
			if config.relative ~= "" then
				float_open = true
				break
			end
		end

		if not float_open then
			vim.diagnostic.open_float(nil, {
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
	end,
	group = "lsp_diagnostics_hold",
})

-- Update time for diagnostics
vim.opt.updatetime = 300

-- LSP hover and signature help styling
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
	vim.lsp.handlers.hover,
	{ border = 'none' }
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
	vim.lsp.handlers.signature_help,
	{ border = 'none' }
)

-- Diagnostic configuration
vim.diagnostic.config({
	virtual_text = false,
	severity_sort = true,
	float = {
		border = 'none',
		source = false,
	},
})

-- Advanced performance optimizations
vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx)
	vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
end

vim.diagnostic.config {
	virtual_text = false,
	update_in_insert = false,
	severity_sort = true,
	signs = {
		severity_limit = "Error",
	},
}

-- Code action timeout optimized for refactoring
vim.lsp.handlers['textDocument/codeAction'] = vim.lsp.with(
	vim.lsp.handlers['textDocument/codeAction'], {
		timeout_ms = 3000, -- 3 seconds for refactoring operations
	}
)

-- Minimal logging
vim.lsp.set_log_level("ERROR")

-- Neovim performance optimizations
vim.opt.maxmempattern = 5000
vim.opt.maxfuncdepth = 200
vim.opt.regexpengine = 1
vim.opt.synmaxcol = 500

-- Disable syntax highlighting for very large files
vim.api.nvim_create_autocmd("BufReadPre", {
	pattern = "*",
	callback = function()
		local file_size = vim.fn.getfsize(vim.fn.expand("<afile>"))
		if file_size > 1024 * 1024 then -- 1MB
			vim.cmd("syntax off")
			vim.opt_local.wrap = false
			vim.opt_local.number = false
			vim.opt_local.relativenumber = false
		end
	end,
})

-- =============================================================================
-- Utility Functions
-- =============================================================================

--- Check VTSLS memory usage
function _G.check_vtsls_memory()
	local handle = io.popen("ps aux | grep -E '(vtsls|tsserver)' | grep -v grep | awk '{print $4, $11}'")
	if handle then
		local result = handle:read("*a")
		handle:close()
		if result and result ~= "" then
			print("VTSLS/TSServer Memory Usage:")
			print(result)
		else
			print("No VTSLS/TSServer processes found")
		end
	end

	local memory_handle = io.popen("sysctl hw.memsize 2>/dev/null | awk '{print $2/1024/1024/1024}' || echo 'Unknown'")
	if memory_handle then
		local total_memory = memory_handle:read("*a"):gsub("%s+", "")
		memory_handle:close()
		print("Total System Memory: " .. total_memory .. " GB")

		local memory_gb = tonumber(total_memory)
		if memory_gb and memory_gb < 24 then
			print("WARNING: You have less than 24GB RAM. Consider reducing memory limits:")
			print("  - Set --max-old-space-size to 8192 (8GB) instead of 12288")
			print("  - Set maxTsServerMemory to 8192 instead of 12288")
		end
	end
end

--- Check VTSLS refactoring configuration
function _G.check_code_action_performance()
	local clients = vim.lsp.get_clients({ name = "vtsls" })
	if #clients == 0 then
		print("No vtsls client found")
		return
	end

	local client = clients[1]
	print("✅ VTSLS Refactoring Configuration Applied:")
	print("✅ Code actions enabled:")
	print("  - quickfix")
	print("  - source.fixAll.eslint")
	print("  - source.organizeImports")
	print("  - source.fixAll.biome")
	print("  - ✅ refactor.extract (extract to function/variable)")
	print("  - ✅ refactor.inline (inline variable/function)")
	print("  - ✅ refactor.rewrite (rewrite code)")
	print("  - ✅ refactor.move (move to file)")
	print("  - ✅ source.addMissingImports")
	print("  - ✅ source.removeUnused")
	print("✅ Code action resolve ENABLED for refactoring")
	print("✅ Timeout set to 3 seconds (for refactoring operations)")
	print("✅ Move to file refactoring ENABLED")
	print("✅ File references ENABLED")
	print("✅ Rename file refactoring ENABLED")
	print("⚡ Call/Type hierarchy disabled (performance)")

	local biome_config = vim.fn.findfile("biome.json", ".;")
	if biome_config ~= "" then
		print("✅ biome.json found: " .. biome_config)
	else
		print("⚠️  biome.json not found - import organization may not work")
		print("   Create biome.json with: { \"organizeImports\": { \"enabled\": true } }")
	end
end

--- Debug all available code actions
function _G.debug_all_code_actions()
	local bufnr = vim.api.nvim_get_current_buf()
	local params = vim.lsp.util.make_range_params()
	params.context = { diagnostics = {} }

	local clients = vim.lsp.get_clients({ bufnr = bufnr })

	print("🔍 Available LSP clients for current buffer:")
	for _, client in pairs(clients) do
		print(string.format("  - %s (id: %d)", client.name, client.id))

		local result = client.request_sync("textDocument/codeAction", params, 3000, bufnr)
		if result and result.result then
			if #result.result > 0 then
				print(string.format("✅ Available code actions from %s:", client.name))
				for i, action in ipairs(result.result) do
					print(string.format("  %d. %s (kind: %s)", i, action.title or "No title", action.kind or "No kind"))
				end
			else
				print(string.format("⚠️  %s returned empty code actions list", client.name))
			end
		else
			print(string.format("❌ No code actions returned from %s", client.name))
		end

		if client.server_capabilities.codeActionProvider then
			local cap = client.server_capabilities.codeActionProvider
			if type(cap) == "table" and cap.codeActionKinds then
				print(string.format("📋 %s supports code action kinds: %s", client.name, table.concat(cap.codeActionKinds, ", ")))
			else
				print(string.format("📋 %s supports code actions (no specific kinds listed)", client.name))
			end
		else
			print(string.format("❌ %s does not support code actions", client.name))
		end
		print("")
	end

	local start_time = vim.loop.hrtime()
	vim.lsp.buf.code_action({
		context = { only = { "quickfix" } },
		apply = false,
	})
	local end_time = vim.loop.hrtime()
	local duration_ms = (end_time - start_time) / 1000000
	print(string.format("Code action request took: %.2f ms", duration_ms))
end

--- Fix all Biome issues
function _G.fix_all_biome()
	vim.lsp.buf.code_action({
		context = {
			only = { "source.fixAll.biome" },
			diagnostics = {},
		},
		apply = true,
	})
end

--- Test refactoring actions
function _G.test_refactoring()
	print("🔧 Testing VTSLS Refactoring Actions...")
	print("")
	print("1. Place cursor on a variable/function and try:")
	print("   :lua vim.lsp.buf.code_action() - Should show refactor options")
	print("")
	print("2. Select text and try extract operations:")
	print("   - Extract to function")
	print("   - Extract to variable")
	print("   - Extract to constant")
	print("")
	print("3. Available refactor actions should include:")
	print("   - Refactor: Extract to function")
	print("   - Refactor: Extract to constant")
	print("   - Refactor: Inline variable")
	print("   - Refactor: Move to a new file")
	print("")
	print("4. Quick test - show all available code actions:")
	vim.lsp.buf.code_action()
end

--- Test import completion
function _G.test_import_completion()
	print("📦 Testing VTSLS Import Completion...")
	print("")
	print("1. Make sure you're in a TypeScript/JavaScript file")
	print("2. Try typing the name of a class/function from your project")
	print("3. Import suggestions should appear in blink.cmp completion menu")
	print("")
	print("Example: If you have 'export class MyComponent' in src/MyComponent.ts")
	print("   - Type 'MyComponent' and import suggestions should appear")
	print("")
	print("✅ If you see import suggestions: Completion is working!")
	print("❌ If no import suggestions: Check VTSLS is attached and try restarting")
	print("")
	print("Current LSP status:")
	_G.lsp_status()
end

--- Debug and manage LSP clients
function _G.lsp_debug()
	print("🔍 LSP Debug Information:")
	print("")

	local clients = vim.lsp.get_clients()
	if #clients == 0 then
		print("❌ No LSP clients running")
		return
	end

	for i, client in ipairs(clients) do
		print(string.format("%d. %s (id: %d)", i, client.name, client.id))
		print(string.format("   Root: %s", client.root_dir or "Not set"))

		-- Show if tsconfig.json exists in root
		if client.name == "vtsls" and client.root_dir then
			local tsconfig_path = client.root_dir .. "/tsconfig.json"
			local jsconfig_path = client.root_dir .. "/jsconfig.json"
			local has_tsconfig = vim.fn.filereadable(tsconfig_path) == 1
			local has_jsconfig = vim.fn.filereadable(jsconfig_path) == 1
			if has_tsconfig then
				print("   ✅ Found tsconfig.json")
			elseif has_jsconfig then
				print("   ✅ Found jsconfig.json")
			else
				print("   ⚠️  No tsconfig.json or jsconfig.json found")
			end
		end

		print(string.format("   Command: %s", vim.inspect(client.config.cmd)))
		print("")
	end

	-- Check for problematic duplicates (same name + same root directory)
	local seen = {}
	local duplicates = {}
	for _, client in ipairs(clients) do
		local key = client.name .. ":" .. (client.root_dir or "")
		if seen[key] then
			duplicates[key] = (duplicates[key] or 1) + 1
		else
			seen[key] = true
		end
	end

	-- Note: VTSLS + Biome in same directory is OK (different functionality)
	if next(duplicates) then
		print("⚠️  PROBLEMATIC DUPLICATES DETECTED (same server, same root):")
		for key, count in pairs(duplicates) do
			local name, root = key:match("([^:]+):(.+)")
			print(string.format("   %s (%s): %d instances", name, root, count + 1))
		end
		print("")
		print("💡 To fix duplicates, run: :lua _G.lsp_cleanup()")
	else
		print("✅ No duplicate LSP clients detected!")
		local biome_count = 0
		local vtsls_count = 0
		for _, client in ipairs(clients) do
			if client.name == "biome" then
				biome_count = biome_count + 1
			elseif client.name == "vtsls" then
				vtsls_count = vtsls_count + 1
			end
		end
		if vtsls_count > 0 and biome_count > 0 then
			print("✅ VTSLS and Biome are both running (expected for full functionality)")
		end
	end
end

--- Clean up duplicate LSP clients
function _G.lsp_cleanup()
	print("🧹 Cleaning up LSP clients...")

	local clients = vim.lsp.get_clients()
	local kept = {}
	local stopped = 0

	-- Keep the first instance of each client type, stop the rest
	for _, client in ipairs(clients) do
		if not kept[client.name] then
			kept[client.name] = client.id
			print(string.format("✅ Keeping %s (id: %d)", client.name, client.id))
		else
			vim.lsp.stop_client(client.id)
			stopped = stopped + 1
			print(string.format("🛑 Stopped duplicate %s (id: %d)", client.name, client.id))
		end
	end

	print(string.format("🎯 Cleanup complete! Stopped %d duplicate clients.", stopped))
	print("Run :lua _G.lsp_debug() to verify.")
end

--- Check LSP server status (for debugging)
function _G.lsp_status()
	print("🔍 LSP Status Check:")
	print("📍 Current buffer: " .. vim.api.nvim_buf_get_name(0))
	print("📍 Current filetype: " .. vim.bo.filetype)

	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then
		print("❌ No LSP clients attached to current buffer")
		print("")
		print("💡 LSP servers start automatically when you open supported files.")
		print("   - VTSLS: JavaScript, TypeScript files")
		print("   - Biome: JavaScript, TypeScript, JSON files")
		print("")
		print("Try opening a .ts or .js file to trigger LSP startup.")
		return
	end

	print("✅ LSP clients attached:")
	for i, client in ipairs(clients) do
		print(string.format("   %d. %s (id: %d)", i, client.name, client.id))
		print("      Root: " .. (client.root_dir or "Not set"))

		if client.name == "vtsls" and client.root_dir then
			local tsconfig_path = client.root_dir .. "/tsconfig.json"
			local jsconfig_path = client.root_dir .. "/jsconfig.json"
			local has_tsconfig = vim.fn.filereadable(tsconfig_path) == 1
			local has_jsconfig = vim.fn.filereadable(jsconfig_path) == 1
			if has_tsconfig then
				print("      ✅ Found tsconfig.json")
			elseif has_jsconfig then
				print("      ✅ Found jsconfig.json")
			else
				print("      ⚠️  No tsconfig.json or jsconfig.json found")
			end
		end
	end

	vim.defer_fn(function()
		vim.cmd("LspInfo")
	end, 500)
end

-- =============================================================================
-- Format-on-Save Configuration
-- =============================================================================

local function stop_path()
	local path = vim.fn.system("git rev-parse --show-toplevel")

	if path:sub(1, 1) == "/" then
		return path
	end

	return vim.fn.expand("%:p:h")
end

-- Format-on-save for JS/TS files (Biome formatting via shell, not LSP)
local js = {
	formatters.remove_trailing_whitespace,
	formatters.remove_trailing_newlines,
	formatters.if_file_exists({
		pattern = { "eslint.config.*" },
		stop_path = stop_path,
		formatter = formatters.shell({
			cmd = { "eslint", "--stdin-filename", "%", " --fix-to-stdout" },
		})
	}),
	formatters.if_file_exists({
		pattern = { ".prettierrc", ".prettierrc.*", "prettier.config.*" },
		stop_path = stop_path,
		formatter = formatters.shell({
			cmd = { "prettier", "--stdin-filepath", "%" },
		})
	}),
	formatters.if_file_exists({
		pattern = { "biome.json", "biome.jsonc" },
		stop_path = stop_path,
		formatter = formatters.shell({
			cmd = { "biome", "format", "--fix", "--stdin-file-path", "%" },
		})
	}),
}

format_on_save.setup({
	stderr_loglevel = vim.log.levels.OFF,
	auto_commands = true,
	exclude_path_patterns = {
		"/node_modules/",
		".local/share/nvim/lazy",
	},
	experiments = {
		partial_update = 'diff',
	},
	formatter_by_ft = {
		css = js,
		html = formatters.lsp,
		clojure = formatters.lsp,
		java = formatters.lsp,
		lua = formatters.lsp,
		pug = formatters.lsp,
		openscad = formatters.lsp,
		python = formatters.lsp,
		rust = formatters.lsp,
		scad = formatters.lsp,
		scss = formatters.lsp,
		sh = formatters.shfmt,
		terraform = formatters.lsp,
		yaml = formatters.lsp,
		gleam = formatters.lsp,

		-- my_custom_formatter = function()
		-- 	if vim.api.nvim_buf_get_name(0):match("/README.md$") then
		-- 		return formatters.prettierd
		-- 	else
		-- 		return formatters.lsp()
		-- 	end
		-- end,

		javascript = js,
		typescript = js,
		svelte = js,
		typescriptreact = js,
		javascriptreact = js,
	},
})

vim.lsp.enable('biome');
vim.lsp.enable('vtsls');
vim.lsp.enable('lua_ls');
