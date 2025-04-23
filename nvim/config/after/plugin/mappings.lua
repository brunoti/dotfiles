local lib = require('lib')
local _ = require('lib.fp')
local pred = require('lib.predicate')
local app_workspace = require "app.workspace"
local wk = require("which-key")

vim.keymap.set({ 'n', 'x' }, 's', '<Nop>')

-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "
local TEST_FILE_PATTERN = {
	"*.test.js",
	"*.test.jsx",
	"*.test.ts",
	"*.test.tsx",
	"*.spec.js",
	"*.spec.jsx",
	"*.spec.ts",
	"*.spec.tsx",
}

local FILETYPE_MAP = {
	CODE_COMPANION = "codecompanion"
}

-- Keymaps table with descriptions and file patterns (single level)
local KEYMAPS = {
	-- Disable the leader key by itself
	[" "]              = { mode = { "" }, cmd = function() end, desc = "Disable leader key" },

	-- Map jj and kk as <Esc> for faster exit from insert mode
	["jj"]             = { mode = { "i" }, cmd = function() vim.cmd.stopinsert() end, desc = "Escape from insert mode (jj)" },

	-- Neovim Tree bindings
	["<C-N>"]          = { mode = { "n" }, cmd = function() vim.cmd.NvimTreeToggle() end, desc = "Toggle NvimTree" },
	-- ["<C-T>"]          = { mode = { "n" }, cmd = function() vim.cmd.NvimTreeFindFile() end, desc = "Find current file in NvimTree" },

	["L"]              = { mode = { "n" }, cmd = function() vim.cmd.tabnext() end, desc = "Go to next tab" },
	["H"]              = { mode = { "n" }, cmd = function() vim.cmd.tabprevious() end, desc = "Go to previous tab" },

	-- Clear search highlighting with 2x <leader>
	["<space><space>"] = { mode = { "n" }, cmd = function() vim.cmd.nohlsearch() end, desc = "Clear search highlighting" },

	-- Indentation helpers (normal and visual modes)
	["<Tab>"]          = {
		mode = { "n", "v" },
		cmd = {
			n = function() vim.cmd.normal(">>") end, -- Normal mode command
			v = function() vim.cmd.normal(">gv") end, -- Visual mode command
		},
		desc = "Indent line(s)",
	},
	[";"]              = {
		mode = { "n", "v" },
		cmd = function()
			vim.api.nvim_feedkeys("c", 'n', false) -- Insert search register content
		end,
		desc = "alternative to [c]hange",
		noremap = true,
		silent = true,
	},
	["<S-Tab>"]        = {
		mode = { "n", "v" },
		cmd = {
			n = function() vim.cmd.normal("<<") end, -- Normal mode command
			v = function() vim.cmd.normal("<gv") end, -- Visual mode command
		},
		desc = "Unindent line(s)",
	},

	-- Visual star and # search (escaped for special characters)
	["*"]              = {
		mode = { "v" },
		cmd = function()
			local search_term = vim.fn.escape(vim.fn.getreg('"'), '/')
			vim.cmd.normal("y")                              -- Yank selection to default register
			vim.cmd.search(string.format("\\V%s", search_term)) -- Search for the escaped term
		end,
		desc = "Visual star search (escaped)",
	},
	["#"]              = {
		mode = { "v" },
		cmd = function()
			local search_term = vim.fn.escape(vim.fn.getreg('"'), '/')
			vim.cmd.normal("y")                                                    -- Yank selection to default register
			vim.cmd.search(string.format("\\V%s", search_term), { backwards = true }) -- Search backwards
		end,
		desc = "Visual # search (escaped)",
	},

	-- System clipboard integration for yank and paste
	["<leader>y"]      = { mode = { "v" }, cmd = function() vim.cmd.normal([["+y]]) end, desc = "Yank to system clipboard" },
	["<leader>p"]      = { mode = { "v" }, cmd = function() vim.cmd.normal([["+p]]) end, desc = "Paste from system clipboard" },

	-- Escape from terminal mode
	["<Esc>"]          = { mode = { "t" }, cmd = function() vim.cmd.stopinsert() end, desc = "Escape from terminal mode" },

	-- Neotest mappings with descriptions for which-key
	-- ["<leader>t"]      = { mode = { "n" }, group = "Neotest" }, -- Group for Neotest
	-- ["<leader>tt"]     = {
	-- 	mode = { "n" },
	-- 	cmd = function() require('neotest').summary() end,
	-- 	desc = "Open test summary",
	-- 	file_pattern = TEST_FILE_PATTERN,
	-- },
	--
	-- -- Test mappings (applied only to test files)
	-- ["<leader>tr"]     = {
	-- 	mode = { "n" },
	-- 	cmd = function() require('neotest').run.run() end,
	-- 	desc = "Run nearest test",
	-- 	file_pattern = TEST_FILE_PATTERN,
	-- },
	-- ["<leader>tf"]     = {
	-- 	mode = { "n" },
	-- 	cmd = function() require('neotest').run.run(vim.fn.expand('%')) end,
	-- 	desc = "Run test file",
	-- 	file_pattern = TEST_FILE_PATTERN,
	-- },
	-- ["<leader>to"]     = {
	-- 	mode = { "n" },
	-- 	cmd = function() require('neotest').output.open() end,
	-- 	desc = "Show test output",
	-- 	file_pattern = TEST_FILE_PATTERN,
	-- },
	-- ["<leader>ts"]     = {
	-- 	mode = { "n" },
	-- 	cmd = function() require('neotest').run.stop() end,
	-- 	desc = "Stop running tests",
	-- 	file_pattern = TEST_FILE_PATTERN,
	-- },
	-- ["<leader>td"]     = {
	-- 	mode = { "n" },
	-- 	cmd = function() require('neotest').run.run({ strategy = 'dap' }) end,
	-- 	desc = "Debug nearest test",
	-- 	file_pattern = TEST_FILE_PATTERN,
	-- },

	-- Show which-key help for buffer-local mappings
	["<leader>?"]      = {
		mode = { "n" },
		cmd = function()
			require("which-key").show({ global = false })
		end,
		desc = "Buffer Local Keymaps (which-key)",
	},

	-- Replace the word under the cursor with the word from the search register
	-- ["<leader>rr"]     = {
	-- 	mode = { "n" },
	-- 	cmd = function()
	-- 		vim.api.nvim_feedkeys(":%s/", 'n', false)                                                         -- Insert search register content
	-- 		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-r><C-w>', true, false, true), 'n', false) -- Insert search register content
	-- 		vim.api.nvim_feedkeys("//g", 'n', false)                                                          -- Insert search register content
	-- 		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Left><Left>', true, false, true), 'n', false) -- Insert search register content
	-- 	end,
	-- 	desc = "Replace word under cursor with search register"
	-- },
	-- ["<leader>rs"]     = {
	-- 	mode = { "n" },
	-- 	cmd = function()
	-- 		vim.api.nvim_feedkeys(":%S/", 'n', false)                                                         -- Insert search register content
	-- 		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-r><C-w>', true, false, true), 'n', false) -- Insert search register content
	-- 		vim.api.nvim_feedkeys("//g", 'n', false)                                                          -- Insert search register content
	-- 		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Left><Left>', true, false, true), 'n', false) -- Insert search register content
	-- 	end,
	-- 	desc = "Replace word under cursor with search register (case sensitive)"
	-- },

	-- Replace the visually selected text with the word from the search register
	-- ["<leader>rR"]     = {
	-- 	mode = { "x" },
	-- 	cmd = function()
	-- 		vim.api.nvim_feedkeys("\"ay:%s/", 'n', false)                                                     -- Insert search register content
	-- 		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-r>', true, false, true), 'n', false)     -- Insert search register content
	-- 		vim.api.nvim_feedkeys("a//g", 'n', false)                                                         -- Insert search register content
	-- 		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Left><Left>', true, false, true), 'n', false) -- Insert search register content
	-- 	end,
	-- 	desc = "Replace visual selection with search register"
	-- },
	-- ["<leader>rS"]     = {
	-- 	mode = { "x" },
	-- 	cmd = function()
	-- 		vim.api.nvim_feedkeys("\"ay:%S/", 'n', false)                                                     -- Insert search register content
	-- 		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-r>', true, false, true), 'n', false)     -- Insert search register content
	-- 		vim.api.nvim_feedkeys("a//g", 'n', false)                                                         -- Insert search register content
	-- 		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Left><Left>', true, false, true), 'n', false) -- Insert search register content
	-- 	end,
	-- 	desc = "Replace visual selection with search register (case sensitive)"
	-- },


	-- Open a new tab with the given file
	-- ["<leader>t"]   = { mode = { "n" }, group = "Tabs", desc = "Tabs" },
	-- ["<leader>to"]  = { mode = { "n" }, cmd = function() lib.start_command("tabedit") end, desc = "Open file in new tab" },
	-- ["<leader>tn"]  = { mode = { "n" }, cmd = function() vim.cmd.tabnext() end, desc = "Go to next tab" },
	-- ["<leader>tp"]  = { mode = { "n" }, cmd = function() vim.cmd.tabprevious() end, desc = "Go to previous tab" },
	-- ["<leader>tq"]  = { mode = { "n" }, cmd = function() vim.cmd.tabonly() end, desc = "Close all other tabs" },
	-- ["[t"]             = { mode = { "n" }, cmd = function() vim.cmd.tabprevious() end, desc = "Go to previous tab" },
	-- ["]t"]             = { mode = { "n" }, cmd = function() vim.cmd.tabnext() end, desc = "Go to next tab" },

	-- Toggle terminal

	-- ["<leaderkxx"] = {
	-- 	mode = { "n" },
	-- 	cmd = function() vim.cmd("Trouble diagnostics toggle") end,
	-- 	desc = "Diagnostics (Trouble)"
	-- },
	-- ["<leader>xX"] = {
	-- 	mode = { "n" },
	-- 	cmd = function() vim.cmd("Trouble diagnostics toggle filter.buf=0") end,
	-- 	desc = "Buffer Diagnostics (Trouble)"
	-- },
	-- ["<leader>cs"] = {
	-- 	mode = { "n" },
	-- 	cmd = function() vim.cmd("Trouble symbols toggle focus=false") end,
	-- 	desc = "Symbols (Trouble)"
	-- },
	-- ["<leader>cl"] = {
	-- 	mode = { "n" },
	-- 	cmd = function() vim.cmd("Trouble lsp toggle focus=false win.position=right") end,
	-- 	desc = "LSP Definitions / references / ... (Trouble)"
	-- },
	-- ["<leader>xL"] = {
	-- 	mode = { "n" },
	-- 	cmd = function() vim.cmd("Trouble loclist toggle") end,
	-- 	desc = "Location List (Trouble)"
	-- },
	-- ["<leader>xQ"] = {
	-- 	mode = { "n" },
	-- 	cmd = function() vim.cmd("Trouble qflist toggle") end,
	-- 	desc = "Quickfix List (Trouble)"
	-- },
	["<leader>n"]  = { mode = { "n" }, group = "Notifications", desc = "" },
	["<leader>nn"] = {
		mode = { "n" },
		cmd  = Snacks.notifier.show_history,
		desc = "Snacks: show notification history"
	},
	["<leader>nq"] = {
		mode = { "n" },
		cmd  = Snacks.notifier.hide,
		desc = "Snacks: hide all notifications"
	},

	--- Group for file related mappings
	-- ["<leader>f"]  = { mode = { "n" }, group = "File", desc = "" },
	-- ["<leader>fc"] = { mode = { "n" }, cmd = function() lib.start_command("CtrSF") end, desc = "Open CtrSF fuzzy finder" },
	-- ["<leader>fG"] = { mode = { "n" }, cmd = function() Snacks.picker.grep() end, desc = "Snacks: Open live grep" },
	-- ["<leader>fb"] = { mode = { "n" }, cmd = function() Snacks.picker.buffers() end, desc = "Snacks: Open buffers" },
	-- ["<leader>f,"] = { mode = { "n" }, cmd = function() Snacks.picker.git_files() end, desc = "Snacks: Open git files" },
	-- ["<leader>ff"] = { mode = { "n" }, cmd = function() Snacks.picker.files() end, desc = "Snacks: Find files" },
	-- ["<leader>fg"] = { mode = { "n" }, cmd = function() Snacks.picker.grep({ need_search = false, live = false }) end, desc = "Snacks: Open normal grep" },
	-- ["<leader>fr"] = { mode = { "n" }, cmd = function() Snacks.picker.recent({ filter = { cwd = vim.fn.getcwd() } }) end, desc = "Snacks: Recent files (workspaces)" },
	-- ["<leader>fy"] = { mode = { "n" }, cmd = lib.copy_file_name, desc = "Copy file path to clipboard" },

	--- Group for pickers
	-- ["<leader>s"]  = { mode = { "n" }, group = "Pickers", desc = "General pickers" },
	-- ["<space>sc"]  = {
	--   mode = { "n" },
	--   cmd  = function() Snacks.picker.command_history() end,
	--   desc = "Snacks: show command history"
	-- },
	-- ["<leader>sf"] = {
	--   mode = { "n" },
	--   cmd = function() Snacks.picker.files() end,
	--   desc = "Snacks: Open file finder"
	-- },
	-- ["<leader>s,"] = {
	--   mode = { "n" },
	--   cmd = function() Snacks.picker.git_files() end,
	--   desc = "Snacks: Open git files"
	-- },
	-- ["<leader>sb"] = { mode = { "n" }, cmd = function() Snacks.picker.lines() end, desc = "Buffer Lines" },
	-- ["<leader>sB"] = { mode = { "n" }, cmd = function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
	-- ["<leader>sg"] = { mode = { "n" }, cmd = function() Snacks.picker.grep() end, desc = "Grep" },
	-- ["<leader>sw"] = {
	--   mode = { "n" },
	--   cmd  = app_workspace.picker,
	--   desc = "Workspace picker"
	-- },
	-- ['<leader>s"'] = { mode = { "n" }, cmd = function() Snacks.picker.registers() end, desc = "Registers" },
	-- ["<leader>sa"] = { mode = { "n" }, cmd = function() Snacks.picker.autocmds() end, desc = "Autocmd" },
	-- ["<leader>yc"] = { mode = { "n" }, cmd = function() Snacks.picker.command_history() end, desc = "Command History" },
	-- ["<leader>sC"] = { mode = { "n" }, cmd = function() Snacks.picker.commands() end, desc = "Commands" },
	-- ["<leader>sd"] = { mode = { "n" }, cmd = function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
	-- ["<leader>sh"] = { mode = { "n" }, cmd = function() Snacks.picker.help() end, desc = "Help Pages" },
	-- ["<leader>sH"] = { mode = { "n" }, cmd = function() Snacks.picker.highlights() end, desc = "Highlights" },
	-- ["<leader>sj"] = { mode = { "n" }, cmd = function() Snacks.picker.jumps() end, desc = "Jumps" },
	-- ["<leader>sk"] = { mode = { "n" }, cmd = function() Snacks.picker.keymaps() end, desc = "Keymaps" },
	-- ["<leader>sl"] = { mode = { "n" }, cmd = function() Snacks.picker.loclist() end, desc = "Location List" },
	-- ["<leader>sM"] = { mode = { "n" }, cmd = function() Snacks.picker.man() end, desc = "Man Pages" },
	-- ["<leader>sm"] = { mode = { "n" }, cmd = function() Snacks.picker.marks() end, desc = "Marks" },
	-- ["<leader>sR"] = { mode = { "n" }, cmd = function() Snacks.picker.resume() end, desc = "Resume" },
	-- ["<leader>sq"] = { mode = { "n" }, cmd = function() Snacks.picker.qflist() end, desc = "Quickfix List" },
	-- ["<leader>ss"] = { mode = { "n" }, cmd = function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },


	--- Git helpers
	-- ["<leader>g"]  = { mode = { "n" }, group = "Git", desc = "Git and Lazygit stuff" },
	-- ["<leader>gc"] = { mode = { "n" }, cmd = function() Snacks.picker.git_log() end, desc = "Git Log" },
	-- ["<leader>gs"] = { mode = { "n" }, cmd = function() Snacks.picker.git_status() end, desc = "Git Status" },
	-- ["<leader>gg"] = {
	-- 	mode = { "n" },
	-- 	cmd = function()
	-- 		Snacks.lazygit()
	-- 	end,
	-- 	desc = "Open Lazygit"
	-- },
	-- ["<leader>gf"] = {
	-- 	mode = { "n" },
	-- 	cmd = function()
	-- 		Snacks.lazygit.log()
	-- 	end,
	-- 	desc = "Open Lazygit log"
	-- },
	-- ["<leader>gb"] = {
	-- 	mode = { "n" },
	-- 	cmd = function()
	-- 		Snacks.git.blame_line()
	-- 	end,
	-- 	desc = "Open blame line"
	-- },
	-- ["<leader>gB"] = {
	-- 	mode = { "n" },
	-- 	cmd = function()
	-- 		Snacks.gitbrowse()
	-- 	end,
	-- 	desc = "Git browse!"
	-- },
}

local function get_cmd(keymap, mode)
	if not pred.has_key("cmd", keymap) then
		return nil
	end

	if pred.is_function(keymap.cmd) then
		return keymap.cmd
	end

	if pred.has_key(mode, keymap.cmd) then
		return keymap.cmd[mode]
	end

	return nil
end

-- Function to set keymaps with file pattern, function support, and which-key integration
local function set_keymaps(keymaps)
	for key, keymap_data in pairs(keymaps) do
		-- If file_pattern is a table, create an autocmd for each pattern
		if type(keymap_data.file_pattern) == "table" then
			vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
				pattern = keymap_data.file_pattern,
				callback = function()
					-- Use wk.add here with correct argument types
					for __, mode in ipairs(keymap_data.mode) do
						local cmd = get_cmd(keymap_data, mode)
						assert(cmd, "set_keymaps: `cmd` is required for conditional keymaps")

						vim.keymap.set(mode, key, cmd, {
							desc = _.key_or(keymap_data, 'desc', ""),
							buffer = true,
							noremap = _.key_or(keymap_data, 'noremap', true),
							silent = _.key_or(keymap_data, 'silent', true),
						})
					end
				end
			})
		else -- Otherwise, set the keymap globally
			-- Use wk.add here with correct argument types
			for __, mode in ipairs(keymap_data.mode) do
				local cmd = get_cmd(keymap_data, mode)

				-- Use the group key for starter descriptions in which-key
				wk.add({
					key,                  -- lhs (left-hand side)
					cmd,                  -- rhs (right-hand side) or cmd function
					group = keymap_data.group, -- Group for description
					desc = keymap_data.desc, -- Description
					mode = mode,
					noremap = _.key_or(keymap_data, 'noremap', true),
					silent = _.key_or(keymap_data, 'silent', true),
					buffer = _.key_or(keymap_data, 'buffer', false),
				})
			end
		end
	end
end

-- Function to create command abbreviations
local function create_command_abbreviations(abbreviations)
	for _, abbr in ipairs(abbreviations) do
		vim.cmd(string.format("cab %s %s", abbr[1], abbr[2]))
	end
end

wk.add({
	"K",
	vim.lsp.buf.hover,
	desc = "LSP: Show hover documentation",
	icon = " ",
	mode = { "n" },
})

wk.add({
	"<leader>a",
	group = " Code Actions",
	icon = " ",
	{
		"<leader>af",
		require('format-on-save').format,
		mode = { 'n' },
		desc = "LSP: Format current buffer",
		icon = " "
	},
	{
		"<leader>ar",
		function() vim.lsp.buf.rename() end,
		desc = "LSP: Rename symbol",
		icon = "󰑕 ",
		mode = { "n" },
	},
	{
		"<leader>ac",
		vim.lsp.buf.code_action,
		desc = "LSP: Code action",
		icon = "",
		mode = { "n", "v" },
	},
	{
		"<leader>aa",
		vim.lsp.buf.code_action,
		desc = "LSP: Code action",
		icon = "",
		mode = { "n", "v" },
	},
})

wk.add({
	"]",
	group = " Movement   Next (])",
	icon = " ",
	mode = { "n" },
	{
		"]d",
		function() vim.diagnostic.goto_next() end,
		desc = "Next diagnostic",
		icon = " ",
	},
	{
		"]]",
		function() Snacks.words.jump(vim.v.count1) end,
		desc = "Next Reference",
		icon = " ",
	},
	{
		"]t",
		function() vim.cmd.tabnext() end,
		desc = "next tab",
		icon = " ",
	},
})

wk.add({
	"[",
	group = " Movement   Previous ([)",
	icon = " ",
	mode = { "n" },
	{
		"[d",
		function() vim.diagnostic.goto_prev() end,
		desc = "Previous diagnostic",
		icon = " ",
	},
	{
		"[[",
		function() Snacks.words.jump(-vim.v.count1) end,
		desc = "Prev Reference",
		icon = " ",
	},
	{
		"[t",
		function() vim.cmd.tabprevious() end,
		desc = "previous tab",
		icon = " ",
	},
})

wk.add({
	"m",
	group = " Movement   Previous (m)",
	icon = " ",
	mode = { "n" },
	{
		"md",
		function() vim.diagnostic.goto_prev() end,
		desc = "Previous diagnostic",
		icon = " ",
	},
	{
		"mm",
		function() Snacks.words.jump(-vim.v.count1) end,
		desc = "Prev Reference",
		icon = " ",
	},
	{
		"mt",
		function() vim.cmd.tabprevious() end,
		desc = "previous tab",
		icon = " ",
	},
	{
		"mb",
		function() vim.cmd.bprevious() end,
		desc = "previous buffer",
		icon = " ",
	},
})

wk.add({
	",",
	group = " Movement   Next (,)",
	icon = " ",
	mode = { "n" },
	{
		",d",
		function() vim.diagnostic.goto_next() end,
		desc = "Next diagnostic",
		icon = " ",
	},
	{
		",,",
		function() Snacks.words.jump(vim.v.count1) end,
		desc = "Next Reference",
		icon = " ",
	},
	{
		",t",
		function() vim.cmd.tabnext() end,
		desc = "next tab",
		icon = " ",
	},
	{
		",b",
		function() vim.cmd.bnext() end,
		desc = "next buffer",
		icon = " ",
	},
})

wk.add({
	"<leader>u",
	group = " Toggle",
	icon = "  ",
})

wk.add({
	"g",
	group = " Goto",
	icon = " ",
	mode = { "n" },
	{
		"gd",
		function() Snacks.picker.lsp_definitions() end,
		desc = "LSP: Go to Definition",
		icon = "",
	},
	{
		"gr",
		function() Snacks.picker.lsp_references() end,
		desc = "LSP: Find References",
		icon = "",
	},
	{
		"gi",
		function() Snacks.picker.lsp_implementations() end,
		desc = "LSP: Go to Implementation",
		icon = "",
	},
	{
		"gt",
		function() Snacks.picker.lsp_type_definitions() end,
		desc = "LSP: Go to Type Definition",
		icon = "",
	},
	{
		"gP",
		function() require('goto-preview').close_all_win() end,
		desc = "Goto Preview: Close All Windows",
		icon = "",
	},
	{
		group = " Goto Preview",
		icon = " ",
		mode = { "n" },
		{
			"gpp",
			function() require('goto-preview').goto_preview_definition() end,
			desc = "Goto Preview: Definition",
			icon = " ",
		},
		{
			"gpt",
			function() require('goto-preview').goto_preview_type_definition() end,
			desc = "Goto Preview: Type Definition",
			icon = " ",
		},
		{
			"gpi",
			function() require('goto-preview').goto_preview_implementation() end,
			desc = "Goto Preview: Implementation",
			icon = " ",
		},
		{
			"gpD",
			function() require('goto-preview').goto_preview_declaration() end,
			desc = "Goto Preview: Declaration",
			icon = " ",
		},
		{
			"gpr",
			function() require('goto-preview').goto_preview_references() end,
			desc = "Goto Preview: References",
			icon = " ",
		},
	}
})

wk.add({
	{
		"<leader>at",
		":TSC<cr>",
		mode = { "n" },
		desc = "TypeScript check",
		cond = function()
			return _.contains(
				vim.bo.filetype,
				{ "typescript", "typescriptreact", "javascript", "javascriptreact" }
			)
		end
	},
})

-- Cabs to avoid errors on saving, quitting
local cmd_abbreviations = {
	{ "W",    "w" },
	{ "Wq",   "wq" },
	{ "Wqa",  "wqa" },
	{ "WqA",  "wqa" },
	{ "WQa",  "wqa" },
	{ "WQA",  "wqa" },
	{ "wQA",  "wqa" },
	{ "wqA",  "wqa" },
	{ "wQ",   "wq" },
	{ "WA",   "wa" },
	{ "Wa",   "wa" },
	{ "Q",    "q" },
	{ "Qa",   "qa" },
	{ "lazy", "Lazy" },
	{ "cc",   "CodeCompanion #buffer #lsp" },
	{ "ccc",  "CodeCompanionChat" },
	{ "cca",  "CodeCompanionActions" },
}

-- Create the command abbreviations
create_command_abbreviations(cmd_abbreviations)

-- Set the keymaps from the table

set_keymaps(KEYMAPS)


wk.add({
	"<C-w>",
	"<C-\\><C-o><C-w>",
	mode = { 't' },
	desc = "Window Management: Terminal"
})

wk.add({
	"<C-w>",
	"<Esc><C-w>",
	mode = { 'i' },
	desc = "Window Management: Insert"
})

wk.add({
	"<leader>r",
	group = " Replace",
	icon = "",
	{
		"<leader>rr",
		':<C-u>lua require("grug-far").with_visual_selection({ prefills = { paths = vim.fn.expand("%") } })<cr>',
		mode = { 'x' },
		desc = "Grug: Replace selection"
	},
	{
		"<leader>rl",
		function()
			vim.api.nvim_feedkeys("V", 'n', false);
			vim.schedule(function()
				require('grug-far').open({ visualSelectionUsage = 'operate-within-range' })
			end)
		end,
		mode = { 'n', "x" },
		desc = "Grug: Replace in line"
	},
	{
		"<leader>rv",
		function()
			require('grug-far').open({ visualSelectionUsage = 'operate-within-range' })
		end,
		mode = { 'n', "x" },
		desc = "Grug: Replace in selection"
	},
	{
		"<leader>rr",
		function()
			require("grug-far").open({ prefills = { paths = vim.fn.getcwd() } })
		end,
		mode = { 'n' },
		desc = "Grug: Replace in workspace"
	},
	{
		"<leader>rf",
		function()
			require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
		end,
		mode = { 'n', "x" },
		desc = "Grug: Replace in file"
	}
})

wk.add({
	"<leader>o",
	group = "  Open",
	icon = " ",
	{
		"<leader>od",
		function() vim.diagnostic.open_float() end,
		desc = "LSP: Show diagnostics in a floating window",
		icon = " ",
		mode = { "n" },
	},
	{
		"<leader>oe",
		function()
			Snacks.explorer()
		end,
		desc = "Open file explorer",
		icon = " ",
		mode = { "n", "x" },
	},
	{
		"<leader>oo",
		function()
			require('mini.files').open()
		end,
		desc = "Open mini.files",
		icon = " ",
		mode = { "n", "x" },
	},
	{
		"<leader>of",
		function()
			require('mini.files').open(vim.api.nvim_buf_get_name(0))
		end,
		desc = "Open mini.files for current buffer",
		icon = " ",
		mode = { "n", "x" },
	},
	{
		"<leader>ot",
		function()
			Snacks.terminal.toggle(nil, {
				win = { position = 'right', width = 0.3 }
			})
		end,
		desc = "Toggle vertical terminal",
		icon = " ",
		mode = { "n", "x" },
	},

})

wk.add({
	"<leader>s",
	mode = { "n", "x" },
	group = "󰢷 Pickers",
	icon = "󰢷 ",
	{
		"<leader>sy",
		Snacks.picker.yanky,
		desc = "Show yank history",
		icon = " ",
	},
	{
		"<leader>si",
		Snacks.picker.icons,
		desc = "Show available icons",
		icon = " "
	},
	{
		"<space>sc",
		function() Snacks.picker.command_history() end,
		desc = "Show command history",
		icon = " ",
	},
	{
		"<leader>sf",
		function() Snacks.picker.files() end,
		desc = "Open file finder",
		icon = " ",
	},
	{
		"<leader>s,",
		function() Snacks.picker.git_files() end,
		desc = "Open git files",
		icon = " ",
	},
	{
		"<leader>sb",
		function() Snacks.picker.lines() end,
		desc = "Show buffer lines",
		icon = " ",
	},
	{
		"<leader>sB",
		function() Snacks.picker.grep_buffers() end,
		desc = "Grep open buffers",
		icon = " ",
	},
	{
		"<leader>sg",
		function() Snacks.picker.grep() end,
		desc = "Grep in project",
		icon = " ",
	},
	{
		"<leader>sw",
		app_workspace.picker,
		desc = "Open workspace picker",
		icon = " ",
	},
	{
		'<leader>s"',
		function() Snacks.picker.registers() end,
		desc = "Show registers",
		icon = " ",
	},
	{
		"<leader>sa",
		function() Snacks.picker.autocmds() end,
		desc = "Show autocmds",
		icon = " ",
	},
	{
		"<leader>sc",
		function() Snacks.picker.command_history() end,
		desc = "Show command history",
		icon = " ",
	},
	{
		"<leader>sC",
		function() Snacks.picker.commands() end,
		desc = "Show available commands",
		icon = " ",
	},
	{
		"<leader>sd",
		function() Snacks.picker.diagnostics() end,
		desc = "Show diagnostics",
		icon = " ",
	},
	{
		"<leader>sh",
		function() Snacks.picker.help() end,
		desc = "Show help pages",
		icon = "󰋖",
	},
	{
		"<leader>sH",
		function() Snacks.picker.highlights() end,
		desc = "Show highlights",
		icon = " ",
	},
	{
		"<leader>sj",
		function() Snacks.picker.jumps() end,
		desc = "Show jumps",
		icon = " ",
	},
	{
		"<leader>sk",
		function() Snacks.picker.keymaps() end,
		desc = "Show keymaps",
		icon = " ",
	},
	{
		"<leader>sl",
		function() Snacks.picker.loclist() end,
		desc = "Show location list",
		icon = " ",
	},
	{
		"<leader>sM",
		function() Snacks.picker.man() end,
		desc = "Show man pages",
		icon = " ",
	},
	{
		"<leader>sm",
		function() Snacks.picker.marks() end,
		desc = "Show marks",
		icon = " ",
	},
	{
		"<leader>sR",
		function() Snacks.picker.resume() end,
		desc = "Resume last picker",
		icon = " ",
	},
	{
		"<leader>sq",
		function() Snacks.picker.qflist() end,
		desc = "Show quickfix list",
		icon = " ",
	},
	{
		"<leader>sS",
		function() Snacks.picker.lsp_symbols() end,
		desc = "Show LSP symbols",
		icon = " ",
	},
	{
		"<leader>ss",
		function() require('window-picker').pick_window() end,
		desc = "Pick window",
		icon = " ",
	},
})

wk.add({
	group = "  Yanky",
	{
		mode = { "n", "x" },
		{ "p", "<Plug>(YankyPutAfter)", desc = "Yanky: Put after", icon = "󰄬" }, -- Icon for paste
		{ "P", "<Plug>(YankyPutBefore)", desc = "Yanky: Put before", icon = "󰄬" }, -- Icon for paste
		{ "gp", "<Plug>(YankyGPutAfter)", desc = "Yanky: GPut after", icon = "󰄬" }, -- Icon for paste
		{ "gP", "<Plug>(YankyGPutBefore)", desc = "Yanky: GPut before", icon = "󰄬" }, -- Icon for paste
	},
	{
		mode = { "n" },
		{ "<c-j>", "<Plug>(YankyPreviousEntry)", desc = "Yanky: Previous entry", icon = "󰄉" }, -- Icon for previous
		{ "<c-k>", "<Plug>(YankyNextEntry)", desc = "Yanky: Next entry", icon = "󰄊" } -- Icon for next
	}
})

wk.add({
	"<leader>b",
	mode = { "n" },
	group = "  Buffers",
	icon = " ", -- Icon for buffers group
	{
		"<leader>bn",
		function() vim.cmd.bnext() end,
		desc = "Go to next buffer",
		icon = " ", -- Icon for next buffer
	},
	{
		"<leader>bp",
		function() vim.cmd.bprevious() end,
		desc = "Go to previous buffer",
		icon = " ", -- Icon for previous buffer
	},
	{
		"<leader>bd",
		Snacks.bufdelete.delete,
		desc = "Delete current buffer",
		icon = "", -- Icon for delete buffer
	},
	{
		"<leader>bo",
		Snacks.bufdelete.other,
		desc = "Delete other buffers",
		icon = " ", -- Icon for delete buffer
	},
	{
		",b",
		function() vim.cmd.bnext() end,
		desc = "Go to next buffer",
		icon = " ", -- Icon for next buffer
	},
	{
		"mb",
		function() vim.cmd.bprevious() end,
		desc = "Go to previous buffer",
		icon = " ", -- Icon for previous buffer
	},
})

wk.add({
	"<leader>t",
	mode = { "n" },
	group = "  Tabs",
	{
		"<leader>te",
		function() lib.start_command("tabedit") end,
		desc = "Open file in new tab",
		icon = " " -- Icon for open new tab
	},
	{
		"<leader>tn",
		function() vim.cmd.tabnext() end,
		desc = "Go to next tab",
		icon = "" -- Icon for next tab
	},
	{
		"<leader>tp",
		function() vim.cmd.tabprevious() end,
		desc = "Go to previous tab",
		icon = "" -- Icon for previous tab
	},
	{
		"<leader>to",
		function() vim.cmd.tabonly() end,
		desc = "Close all other tabs",
		icon = "" -- Icon for close other tabs
	},
})

wk.add({
	group = " First level actions",
	icon = " ",
	{
		"<leader>w",
		":w<CR>",
		desc = "Save the current file",
		icon = " ",
		mode = { "n" },
	},
	{
		"<leader>q",
		function()
			if vim.bo.filetype == FILETYPE_MAP.CODE_COMPANION then
				lib.run_command("CodeCompanionChat Toggle")
			else
				lib.run_command("q")
			end
		end,
		desc = "Quit the current file",
		icon = "",
		mode = { "n" },
	},
	{
		"<leader>S",
		":wq<CR>",
		desc = "Save and quit the current file",
		icon = " ",
		mode = { "n" },
	},
	{
		"<leader>Q",
		":q!<CR>",
		desc = "Force quit the current file",
		icon = "",
		mode = { "n" },
	},
})

wk.add({
	"<leader>c",
	group = "󱐏  AI Chat",
	icon = "󱐏 ",
	{
		"<leader>cc",
		"<cmd>CodeCompanionChat Toggle<cr>",
		desc = "Code Companion: Chat",
		icon = "󱐏 ",
		mode = { "n" },
	},
	{
		"<leader>ca",
		function()
			lib.start_command("CodeCompanion #lsp #buffer")
		end,
		desc = "Code Companion: Write action",
		icon = "󱐏 ",
		mode = { "n", "x" },
	},
})

wk.add({
	"<leader>x",
	group = " Textcase Current",
	icon = " ",
	mode = { "x", "n" },
	{
		"<leader>xu",
		function()
			if lib.is_visual_mode() then
				require('textcase').current_word('to_upper_case')
			else
				require('textcase').operator('to_upper_case')
			end
		end,
		desc = "Textcase: Convert to UPPER CASE",
	},
	{
		"<leader>xl",
		function()
			if lib.is_visual_mode() then
				require('textcase').current_word('to_lower_case')
			else
				require('textcase').operator('to_lower_case')
			end
		end,
		desc = "Textcase: Convert to lower case",
	},
	{
		"<leader>xs",
		function()
			if lib.is_visual_mode() then
				require('textcase').current_word('to_snake_case')
			else
				require('textcase').operator('to_snake_case')
			end
		end,
		desc = "Textcase: Convert to snake_case",
	},
	{
		"<leader>xd",
		function()
			if lib.is_visual_mode() then
				require('textcase').current_word('to_dash_case')
			else
				require('textcase').operator('to_dash_case')
			end
		end,
		desc = "Textcase: Convert to dash-case",
	},
	{
		"<leader>xn",
		function()
			if lib.is_visual_mode() then
				require('textcase').current_word('to_constant_case')
			else
				require('textcase').operator('to_constant_case')
			end
		end,
		desc = "Textcase: Convert to CONSTANT_CASE",
	},
	{
		"<leader>xd",
		function()
			if lib.is_visual_mode() then
				require('textcase').current_word('to_dot_case')
			else
				require('textcase').operator('to_dot_case')
			end
		end,
		desc = "Textcase: Convert to dot.case",
	},
	{
		"<leader>x,",
		function()
			if lib.is_visual_mode() then
				require('textcase').current_word('to_comma_case')
			else
				require('textcase').operator('to_comma_case')
			end
		end,
		desc = "Textcase: Convert to comma,case",
	},
	{
		"<leader>xa",
		function()
			if lib.is_visual_mode() then
				require('textcase').current_word('to_phrase_case')
			else
				require('textcase').operator('to_phrase_case')
			end
		end,
		desc = "Textcase: Convert to phrase case",
	},
	{
		"<leader>xc",
		function()
			if lib.is_visual_mode() then
				require('textcase').current_word('to_camel_case')
			else
				require('textcase').operator('to_camel_case')
			end
		end,
		desc = "Textcase: Convert to camelCase",
	},
	{
		"<leader>xp",
		function()
			if lib.is_visual_mode() then
				require('textcase').current_word('to_pascal_case')
			else
				require('textcase').operator('to_pascal_case')
			end
		end,
		desc = "Textcase: Convert to PascalCase",
		ms
	},
	{
		"<leader>xt",
		function()
			if lib.is_visual_mode() then
				require('textcase').current_word('to_title_case')
			else
				require('textcase').operator('to_title_case')
			end
		end,
		desc = "Textcase: Convert to Title Case",
	},
	{
		"<leader>xf",
		function()
			if lib.is_visual_mode() then
				require('textcase').current_word('to_path_case')
			else
				require('textcase').operator('to_path_case')
			end
		end,
		desc = "Textcase: Convert to path/case",
	},
})

wk.add({
	"<leader>f",
	group = "  File",
	icon = " ",
	mode = { "n" },
	{
		"<leader>fc",
		function() lib.start_command("CtrSF") end,
		desc = "Open CtrSF fuzzy finder",
		icon = " ",
	},
	{
		"<leader>fG",
		function() Snacks.picker.grep() end,
		desc = "Snacks: Open live grep",
		icon = " ",
	},
	{
		"<leader>fb",
		function() Snacks.picker.buffers() end,
		desc = "Snacks: Open buffers",
		icon = " ",
	},
	{
		"<leader>f,",
		function() Snacks.picker.git_files() end,
		desc = "Snacks: Open git files",
		icon = " ",
	},
	{
		"<leader>ff",
		function() Snacks.picker.files() end,
		desc = "Snacks: Find files",
		icon = " ",
	},
	{
		"<leader>fa",
		function() Snacks.picker.git_files() end,
		desc = "Snacks: Git files",
		icon = " ",
	},
	{
		"<leader>fg",
		function() Snacks.picker.grep({ need_search = false, live = false }) end,
		desc = "Snacks: Open normal grep",
		icon = " ",
	},
	{
		"<leader>fr",
		function() Snacks.picker.recent({ filter = { cwd = vim.fn.getcwd() } }) end,
		desc = "Snacks: Recent files (workspaces)",
		icon = " ",
	},
	{
		"<leader>fy",
		lib.copy_file_name,
		desc = "Copy file path to clipboard",
		icon = " ",
	},
})


wk.add({
	"<leader>g",
	group = " Git",
	icon = " ",
	desc = "Git and Lazygit operations",
	mode = { "n" },
	{
		"<leader>gc",
		function() Snacks.picker.git_log() end,
		desc = "View Git Log",
		icon = " ",
	},
	{
		"<leader>gs",
		function() Snacks.picker.git_status() end,
		desc = "View Git Status",
		icon = " ",
	},
	{
		"<leader>gg",
		function() Snacks.lazygit() end,
		desc = "Open Lazygit",
		icon = " ",
	},
	{
		"<leader>gl",
		function() Snacks.lazygit.log_file() end,
		desc = "Open Lazygit Log for current buffer",
		icon = " ",
	},
	{
		"<leader>gL",
		function() Snacks.lazygit.log() end,
		desc = "Open Lazygit Log",
		icon = " ",
	},
	{
		"<leader>gb",
		function() Snacks.git.blame_line() end,
		desc = "Show Git Blame for Line",
		icon = " ",
	},
	{
		"<leader>gB",
		function() Snacks.gitbrowse() end,
		desc = "Browse Git Repository",
		icon = " ",
	},
})


wk.add({
	"<leader>e",
	group = " Execute",
	icon = " ",
	mode = { "n" },
	{
		"<leader>er",
		"<cmd>OverseerRun<cr>",
		desc = "Overseer: Show tasks",
		icon = " ",
	},
	{
		"<leader>et",
		"<cmd>OverseerToggle right<cr>",
		desc = "Overseer toggle",
		icon = " ",
	},
})


wk.add({
	{
		"<C-g>",
		function() Snacks.lazygit() end,
		desc = "LazyGit",
		icon = " ",
		mode = { "n", "t", "x" },
	},
	{
		"<C-e>",
		function() Snacks.explorer() end,
		desc = "Explorer",
		icon = " ",
		mode = { "n", "t", "x" },
	},
	{
		"<C-t>",
		function()
			Snacks.terminal.toggle(nil, {
				win = {
					style = "terminal",
					position = "float"
				}
			})
		end,
		mode = { "n", "t", "x" },
		icon = " ",
		desc = "Toggle terminal",
	},
	{
		"<C-p>",
		function()
			Snacks.picker.files()
		end,
		mode = { "n" },
		desc = "File finder",
		icon = " ",
	},
	{
		"<C-a>",
		function()
			vim.lsp.buf.code_action()
		end,
		mode = { "n", "x" },
		desc = "LSP: Code action",
		icon = " ",
	},
	{
		"<C-p>",
		"<C-r>\"",
		mode = { "i" },
		desc = "Paste from register",
		icon = " "
	},
	{
		"<C-w>",
		"<Esc><C-w>",
		mode = { "i" },
		desc = "Window Management: Insert",
		icon = " ",
	}
})


vim.api.nvim_create_autocmd("FileType", {
	pattern = "minifiles",
	callback = function()
		local minifiles = require('mini.files')

		wk.add({
			"<CR>",
			function()
				minifiles.go_in({ close_on_file = true })
			end,
			mode = { "n" },
			desc = "Open",
			buffer = true,
			noremap = true,
			silent = true,
		})

		wk.add({
			"<tab>",
			function()
				minifiles.go_in({ close_on_file = false })
			end,
			mode = { "n" },
			desc = "Open",
			buffer = true,
			noremap = true,
			silent = true,
		})

		wk.add({
			"<S-tab>",
			function()
				minifiles.go_out()
			end,
			mode = { "n" },
			desc = "Out",
			buffer = true,
			noremap = true,
			silent = true,
		})

		---@param map string
		---@return wk.Spec
		local function close(map)
			return {
				map,
				function()
					minifiles.close()
				end,
				mode = { "n" },
				desc = "Close",
				icon = "󰅖 ",
				buffer = true,
				noremap = true,
				silent = true,
			}
		end

		wk.add(close("<leader>q"))
		wk.add(close("q"))

		wk.add({
			"<leader>w",
			function()
				minifiles.synchronize()
			end,
			mode = { "n" },
			desc = "Sync",
			buffer = true,
			noremap = true,
			silent = true,
		})
	end,
})
