local lib = require('lib')
local _ = require('lib.fp')
local pred = require('lib.predicate')
local app_workspace = require "app.workspace"

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


-- Keymaps table with descriptions and file patterns (single level)
local KEYMAPS = {
	-- Disable the leader key by itself
	[" "]              = { mode = { "" }, cmd = function() end, desc = "Disable leader key" },

	-- Map jj and kk as <Esc> for faster exit from insert mode
	["jj"]             = { mode = { "i" }, cmd = function() vim.cmd.stopinsert() end, desc = "Escape from insert mode (jj)" },
	["kk"]             = { mode = { "i" }, cmd = function() vim.cmd.stopinsert() end, desc = "Escape from insert mode (kk)" },

	-- Neovim Tree bindings
	["<C-n>"]          = { mode = { "n" }, cmd = function() vim.cmd.NvimTreeToggle() end, desc = "Toggle NvimTree" },
	["<C-t>"]          = { mode = { "n" }, cmd = function() vim.cmd.NvimTreeFindFile() end, desc = "Find current file in NvimTree" },

	["L"]              = { mode = { "n" }, cmd = function() vim.cmd.tabnext() end, desc = "Go to next tab" },
	["H"]              = { mode = { "n" }, cmd = function() vim.cmd.tabprevious() end, desc = "Go to previous tab" },
	["[t"]             = { mode = { "n" }, cmd = function() vim.cmd.tabprevious() end, desc = "Go to previous tab" },
	["]t"]             = { mode = { "n" }, cmd = function() vim.cmd.tabnext() end, desc = "Go to next tab" },
	["gto"]            = { mode = { "n" }, cmd = function() vim.cmd.tabonly() end, desc = "Close all other tabs" },

	-- Clear search highlighting with 2x <leader>
	["<space><space>"] = { mode = { "n" }, cmd = function() vim.cmd.nohlsearch() end, desc = "Clear search highlighting" },

	-- Navigate the right way (respecting wrapped lines)
	-- ["k"] = { mode = { "n" }, cmd = function() vim.cmd.normal("gk") end, desc = "Move cursor up (respecting wrapped lines)", noremap = false },
	-- ["j"] = { mode = { "n" }, cmd = function() vim.cmd.normal("gj") end, desc = "Move cursor down (respecting wrapped lines)", noremap = false },

	-- Close and save stuff
	-- ["<leader>s"]      = { mode = { "n" }, cmd = function() vim.cmd.write() end, desc = "Save file" },
	["<leader>w"]      = { mode = { "n" }, cmd = function() vim.cmd.write() end, desc = "Save file" },
	["<leader>q"]      = { mode = { "n" }, cmd = function() vim.cmd.quit() end, desc = "Quit file" },
	["<leader>S"]      = { mode = { "n" }, cmd = function() vim.cmd.writequit() end, desc = "Save and quit file" },
	["<leader>Q"]      = { mode = { "n" }, cmd = function() vim.cmd.quit({ bang = true }) end, desc = "Force quit file" },

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
	["<leader>to"]  = { mode = { "n" }, cmd = function() lib.start_command("tabedit") end, desc = "Open file in new tab" },
	-- Navigate to the next tab
	["<leader>tn"]  = { mode = { "n" }, cmd = function() vim.cmd.tabnext() end, desc = "Go to next tab" },
	-- Navigate to the previous tab
	["<leader>tp"]  = { mode = { "n" }, cmd = function() vim.cmd.tabprevious() end, desc = "Go to previous tab" },

	-- Navigate buffers
	["<leader>bn"]  = { mode = { "n" }, cmd = function() vim.cmd.bnext() end, desc = "Go to next buffer" },
	["<leader>bp"]  = { mode = { "n" }, cmd = function() vim.cmd.bprevious() end, desc = "Go to previous buffer" },
	-- Delete current buffer
	["<leader>bd"]  = { mode = { "n" }, cmd = Snacks.bufdelete.delete, desc = "Delete current buffer" },

	-- Toggle terminal
	["<leader>;"]   = {
		mode = { "n", "t" },
		cmd = function()
			Snacks.terminal()
		end,
		desc = "Toggle terminal"
	},

	-- Jump to next/previous reference
	["]]"]          = {
		mode = { "n", "t" },
		cmd = function()
			Snacks.words.jump(vim.v.count1)
		end,
		desc = "Next Reference"
	},
	["[["]          = {
		mode = { "n", "t" },
		cmd = function()
			Snacks.words.jump(-vim.v.count1)
		end,
		desc = "Prev Reference"
	},

	--- Actions group
	["<leader>a"]   = { mode = { "n" }, group = "Actions", desc = "Actions" },
	["<leader>af"]  = {
		mode = { 'n' },
		cmd = require('format-on-save').format,
		desc = "Format current buffer"
	},
	--- Rulebook
	["<leader>ar"]  = { mode = { "n" }, group = "Rulebook actions", desc = "Rulebook actions" },
	["<leader>ari"] = { mode = { "n" }, cmd = function() require("rulebook").ignoreRule() end, desc = "Rulebook: ignore rule" },
	["<leader>arl"] = { mode = { "n" }, cmd = function() require("rulebook").lookupRule() end, desc = "Rulebook: lookup rule" },
	["<leader>ary"] = {
		mode = { "n" },
		cmd = function() require("rulebook").yankDiagnosticCode() end,
		desc = "Rulebook: Yank diagnostic code"
	},
	["<leader>arf"] = {
		mode = { "n", "x" },
		cmd = function() require("rulebook").suppressFormatter() end,
		desc = "Rulebook: Supress formatter"
	},
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
	["<leader>nn"]  = {
		mode = { "n" },
		cmd  = Snacks.notifier.show_history,
		desc = "Snacks: show notification history"
	},

	--- Group for file related mappings
	["<leader>f"]   = { mode = { "n" }, group = "File", desc = "" },
	["<leader>fc"]  = { mode = { "n" }, cmd = function() lib.start_command("CtrSF") end, desc = "Open CtrSF fuzzy finder" },
	["<leader>fG"]  = { mode = { "n" }, cmd = function() Snacks.picker.grep() end, desc = "Snacks: Open live grep" },
	["<leader>fb"]  = { mode = { "n" }, cmd = function() Snacks.picker.buffers() end, desc = "Snacks: Open buffers" },
	["<leader>f,"]  = { mode = { "n" }, cmd = function() Snacks.picker.git_files() end, desc = "Snacks: Open git files" },
	["<leader>ff"]  = { mode = { "n" }, cmd = function() Snacks.picker.files() end, desc = "Snacks: Find files" },
	["<leader>fg"]  = { mode = { "n" }, cmd = function() Snacks.picker.grep({ need_search = false, live = false }) end, desc = "Snacks: Open normal grep" },
	["<leader>fr"]  = { mode = { "n" }, cmd = function() Snacks.picker.recent({ filter = { cwd = vim.fn.getcwd() } }) end, desc = "Snacks: Recent files (workspaces)" },
	["<leader>fy"]  = { mode = { "n" }, cmd = lib.copy_file_name, desc = "Copy file path to clipboard" },

	--- Group for pickers
	["<leader>s"]   = { mode = { "n" }, group = "Pickers", desc = "General pickers" },
	["<space>sc"]   = {
		mode = { "n" },
		cmd  = function() Snacks.picker.command_history() end,
		desc = "Snacks: show command history"
	},
	["<leader>sf"]  = {
		mode = { "n" },
		cmd = function() Snacks.picker.files() end,
		desc = "Snacks: Open file finder"
	},
	["<leader>s,"]  = {
		mode = { "n" },
		cmd = function() Snacks.picker.git_files() end,
		desc = "Snacks: Open git files"
	},
	["<leader>sb"]  = { mode = { "n" }, cmd = function() Snacks.picker.lines() end, desc = "Buffer Lines" },
	["<leader>sB"]  = { mode = { "n" }, cmd = function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
	["<leader>sg"]  = { mode = { "n" }, cmd = function() Snacks.picker.grep() end, desc = "Grep" },
	["<leader>sw"]  = {
		mode = { "n" },
		cmd  = app_workspace.picker,
		desc = "Workspace picker"
	},
	["<leader>sy"]  = { mode = { "n" }, cmd = function() vim.cmd("Telescope neoclip") end, desc = "Open neoclip" },
	['<leader>s"']  = { mode = { "n" }, cmd = function() Snacks.picker.registers() end, desc = "Registers" },
	["<leader>sa"]  = { mode = { "n" }, cmd = function() Snacks.picker.autocmds() end, desc = "Autocmdk" },
	["<leader>yc"]  = { mode = { "n" }, cmd = function() Snacks.picker.command_history() end, desc = "Command History" },
	["<leader>sC"]  = { mode = { "n" }, cmd = function() Snacks.picker.commands() end, desc = "Commands" },
	["<leader>sd"]  = { mode = { "n" }, cmd = function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
	["<leader>sh"]  = { mode = { "n" }, cmd = function() Snacks.picker.help() end, desc = "Help Pages" },
	["<leader>sH"]  = { mode = { "n" }, cmd = function() Snacks.picker.highlights() end, desc = "Highlights" },
	["<leader>sj"]  = { mode = { "n" }, cmd = function() Snacks.picker.jumps() end, desc = "Jumps" },
	["<leader>sk"]  = { mode = { "n" }, cmd = function() Snacks.picker.keymaps() end, desc = "Keymaps" },
	["<leader>sl"]  = { mode = { "n" }, cmd = function() Snacks.picker.loclist() end, desc = "Location List" },
	["<leader>sM"]  = { mode = { "n" }, cmd = function() Snacks.picker.man() end, desc = "Man Pages" },
	["<leader>sm"]  = { mode = { "n" }, cmd = function() Snacks.picker.marks() end, desc = "Marks" },
	["<leader>sR"]  = { mode = { "n" }, cmd = function() Snacks.picker.resume() end, desc = "Resume" },
	["<leader>sq"]  = { mode = { "n" }, cmd = function() Snacks.picker.qflist() end, desc = "Quickfix List" },
	["<leader>ss"]  = { mode = { "n" }, cmd = function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },


	--- Git helpers
	["<leader>g"]  = { mode = { "n" }, group = "Git", desc = "Git and Lazygit stuff" },
	["<leader>gc"] = { mode = { "n" }, cmd = function() Snacks.picker.git_log() end, desc = "Git Log" },
	["<leader>gs"] = { mode = { "n" }, cmd = function() Snacks.picker.git_status() end, desc = "Git Status" },
	["<leader>gg"] = {
		mode = { "n" },
		cmd = function()
			Snacks.lazygit()
		end,
		desc = "Open Lazygit"
	},
	["<leader>gf"] = {
		mode = { "n" },
		cmd = function()
			Snacks.lazygit.log()
		end,
		desc = "Open Lazygit log"
	},
	["<leader>gb"] = {
		mode = { "n" },
		cmd = function()
			Snacks.git.blame_line()
		end,
		desc = "Open blame line"
	},
	["<leader>gB"] = {
		mode = { "n" },
		cmd = function()
			Snacks.gitbrowse()
		end,
		desc = "Git browse!"
	},
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
	local wk = require("which-key")

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

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

		set_keymaps({
			-- ["gr"]         = {
			-- 	mode = { "n" },
			-- 	cmd = function() Snacks.picker.lsp_references() end,
			-- 	desc = "LSP: Go to references"
			-- },
			-- ["gd"]         = {
			-- 	mode = { "n" },
			-- 	cmd = function() vim.lsp.buf.definition() end,
			-- 	desc = "LSP: Go to definition"
			-- },
			-- ["<leader>d"]  = {
			-- 	mode = { "n" },
			-- 	cmd = function() vim.cmd("Lspsaga peek_definition") end,
			-- 	desc = "LSP: peek definition"
			-- },
			-- ][]
			["K"]          = {
				mode = { "n" },
				cmd = vim.lsp.buf.hover,
				desc = "Show hover documentation"
			},
			-- ["gi"]         = {
			-- 	mode = { "n" },
			-- 	cmd = function() vim.lsp.buf.implementation() end,
			-- 	desc = "LSP: Go to implementation"
			-- },
			["<C-k>"]      = {
				mode = { "n" },
				cmd = function() vim.lsp.buf.signature_help() end,
				desc = "LSP: Show signature help"
			},
			["<leader>rn"] = {
				mode = { "n" },
				cmd  = function() vim.lsp.buf.rename() end,
				desc = "Rename symbol"
			},
			["<leader>ac"] = {
				mode = { "n", "v" },
				cmd  = vim.lsp.buf.code_action,
				desc = "Code action"
			},
			["<leader>e"]  = {
				mode = { "n" },
				cmd  = function() vim.diagnostic.open_float() end,
				desc = "Open diagnostics float"
			},
			["[d"]         = {
				mode = { "n" },
				cmd  = function() vim.diagnostic.goto_prev() end,
				desc = "LSP: Go to previous diagnostic"
			},
			["]d"]         = {
				mode = { "n" },
				cmd  = function() vim.diagnostic.goto_next() end,
				desc = "LSP: Go to next diagnostic"
			},
			["gd"]         = { mode = { "n" }, cmd = function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
			["gr"]         = { mode = { "n" }, cmd = function() Snacks.picker.lsp_references() end, desc = "References" },
			["gi"]         = { mode = { "n" }, cmd = function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
			["gt"]         = { mode = { "n" }, cmd = function() Snacks.picker.lsp_type_definitions() end, desc = "Goto [T]ype Definition" },
		})
	end,
})

-- Cabs to avoid errors on saving, quitting
local cmd_abbreviations = {
	{ "W",   "w" },
	{ "Wq",  "wq" },
	{ "Wqa", "wqa" },
	{ "WqA", "wqa" },
	{ "WQa", "wqa" },
	{ "WQA", "wqa" },
	{ "wQA", "wqa" },
	{ "wqA", "wqa" },
	{ "wQ",  "wq" },
	{ "WA",  "wa" },
	{ "Wa",  "wa" },
	{ "Q",   "q" },
	{ "Qa",  "qa" },
}

-- Create the command abbreviations
create_command_abbreviations(cmd_abbreviations)

-- Set the keymaps from the table

set_keymaps(KEYMAPS)
