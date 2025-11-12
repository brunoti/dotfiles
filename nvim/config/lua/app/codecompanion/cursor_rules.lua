-- CodeCompanion Cursor Rules Extension
-- Loads .cursorrules and .cursor/rules files into context

local M = {}

-- Function to safely read file content
local function read_file(filepath)
	local file = io.open(filepath, "r")
	if not file then
		return nil
	end
	local content = file:read("*all")
	file:close()
	return content and vim.trim(content) or nil
end

-- Function to check if file exists
local function file_exists(filepath)
	local file = io.open(filepath, "r")
	if file then
		file:close()
		return true
	end
	return false
end

-- Function to find git root specifically
local function find_git_root()
	-- Try using git command to find repository root
	local git_root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null")
	if vim.v.shell_error == 0 then
		return vim.trim(git_root)
	end
	return nil
end

-- Function to find project root by looking for common markers
local function find_project_root()
	-- First priority: try to find git root using git command
	local git_root = find_git_root()
	if git_root and git_root ~= "" then
		return git_root
	end

	-- Second priority: look for common markers starting from current file
	local current_dir = vim.fn.expand('%:p:h')
	local markers = { '.git', '.cursorrules', '.cursor', 'package.json', 'pyproject.toml', 'Cargo.toml' }

	-- Start from current file's directory and traverse up
	local dir = current_dir
	while dir ~= '/' and dir ~= '' do
		for _, marker in ipairs(markers) do
			if file_exists(dir .. '/' .. marker) then
				return dir
			end
		end
		dir = vim.fn.fnamemodify(dir, ':h')
	end

	-- Final fallback: current working directory
	return vim.fn.getcwd()
end

-- Function to load cursor rules from various locations
local function load_cursor_rules()
	local rules = {}
	local project_root = find_project_root()

	-- Determine if we found git root
	local is_git_root = find_git_root() ~= nil

	-- Possible cursor rules file locations (prioritizing git root)
	local rule_files = {
		project_root .. "/.cursorrules",
		project_root .. "/.cursor/rules",
		vim.fn.expand("~/.cursorrules"),
		vim.fn.expand("~/.cursor/rules")
	}

	for _, filepath in ipairs(rule_files) do
		local content = read_file(filepath)
		if content and content ~= "" then
			table.insert(rules, {
				path = filepath,
				content = content,
				is_git_root = is_git_root and (filepath:find(project_root, 1, true) == 1)
			})
		end
	end

	return rules
end

-- Function to format cursor rules for display
local function format_cursor_rules(rules)
	if #rules == 0 then
		return nil
	end

	local formatted = {}
	table.insert(formatted, "# Cursor Rules")
	table.insert(formatted, "")

	for i, rule in ipairs(rules) do
		local relative_path = rule.path:gsub(vim.fn.expand("~"), "~")
		local source_info = rule.is_git_root and " (git root)" or ""
		table.insert(formatted, string.format("## Rule Set %d: %s%s", i, relative_path, source_info))
		table.insert(formatted, "")
		table.insert(formatted, rule.content)
		if i < #rules then
			table.insert(formatted, "")
			table.insert(formatted, "---")
			table.insert(formatted, "")
		end
	end

	return table.concat(formatted, "\n")
end

-- Function to set cursor rules as codecompanion variable
function M.set_cursor_rules_variable()
	local rules = load_cursor_rules()
	local formatted_rules = format_cursor_rules(rules)

	if formatted_rules then
		-- Count git root vs other files
		local git_root_count = 0
		local other_count = 0
		for _, rule in ipairs(rules) do
			if rule.is_git_root then
				git_root_count = git_root_count + 1
			else
				other_count = other_count + 1
			end
		end

		-- Set as codecompanion variable (if the API supports it)
		if pcall(function()
					require("codecompanion").set_variable("cursor_rules", formatted_rules)
				end) then
			local source_info = git_root_count > 0 and string.format(" (%d from git root)", git_root_count) or ""
			vim.notify(string.format("Loaded %d cursor rule file(s) as variable%s", #rules, source_info), vim.log.levels.INFO)
		else
			-- Fallback: store in global variable for use in prompts
			vim.g.codecompanion_cursor_rules = formatted_rules
			local source_info = git_root_count > 0 and string.format(" (%d from git root)", git_root_count) or ""
			vim.notify(string.format("Loaded %d cursor rule file(s) as global variable%s", #rules, source_info),
				vim.log.levels.INFO)
		end

		-- The default prompt will automatically pick up the updated global variable

		return formatted_rules
	else
		vim.g.codecompanion_cursor_rules = ""
		vim.notify("No cursor rules files found", vim.log.levels.WARN)
		return nil
	end
end

-- Function to add cursor rules to current chat
function M.add_cursor_rules_to_chat()
	local rules = load_cursor_rules()
	local formatted_rules = format_cursor_rules(rules)

	if not formatted_rules then
		vim.notify("No cursor rules files found", vim.log.levels.WARN)
		return
	end

	-- Try to get the current chat buffer
	local bufnr = vim.api.nvim_get_current_buf()
	local filetype = vim.bo[bufnr].filetype

	if filetype == "codecompanion" then
		-- We're in a codecompanion buffer, add the rules directly
		local lines = vim.split(formatted_rules, "\n")
		local current_line = vim.api.nvim_win_get_cursor(0)[1]
		vim.api.nvim_buf_set_lines(bufnr, current_line, current_line, false, {
			"",
			"# Cursor Rules Context",
			"",
			"```markdown"
		})
		vim.api.nvim_buf_set_lines(bufnr, current_line + 4, current_line + 4, false, lines)
		vim.api.nvim_buf_set_lines(bufnr, current_line + 4 + #lines, current_line + 4 + #lines, false, {
			"```",
			""
		})
		vim.notify(string.format("Added %d cursor rule file(s) to chat", #rules), vim.log.levels.INFO)
	else
		-- Start a new chat with cursor rules as context
		vim.cmd("CodeCompanionChat")
		vim.defer_fn(function()
			M.add_cursor_rules_to_chat()
		end, 100)
	end
end

-- Function to create cursor rules prompt
function M.create_cursor_rules_prompt()
	local rules = load_cursor_rules()
	local formatted_rules = format_cursor_rules(rules)

	if not formatted_rules then
		return {
			role = "system",
			content = "No cursor rules found for this project."
		}
	end

	return {
		role = "system",
		content = string.format(
			[[You are an AI assistant working on a project with specific cursor rules. Please follow these rules when providing assistance:

%s

Always consider these rules when:
- Writing or reviewing code
- Suggesting improvements
- Explaining concepts
- Making recommendations

Apply these rules consistently throughout our conversation.]], formatted_rules)
	}
end

-- Setup function to integrate with codecompanion
function M.setup()
	-- Set cursor rules as variable on startup
	M.set_cursor_rules_variable()

	-- Create user commands for manual control
	vim.api.nvim_create_user_command("CodeCompanionLoadCursorRules", function()
		M.set_cursor_rules_variable()
	end, {
		desc = "Load cursor rules files as codecompanion variable"
	})

	vim.api.nvim_create_user_command("CodeCompanionAddCursorRules", function()
		M.add_cursor_rules_to_chat()
	end, {
		desc = "Add cursor rules to current codecompanion chat"
	})

	-- Auto-reload cursor rules when files change
	local group = vim.api.nvim_create_augroup("CodeCompanionCursorRules", { clear = true })

	vim.api.nvim_create_autocmd({ "BufWritePost" }, {
		group = group,
		pattern = { ".cursorrules", "rules" },
		callback = function()
			local filename = vim.fn.expand("%:t")
			if filename == ".cursorrules" or (filename == "rules" and vim.fn.expand("%:h:t") == ".cursor") then
				vim.defer_fn(function()
					M.set_cursor_rules_variable()
				end, 100)
			end
		end,
		desc = "Reload cursor rules when files are saved"
	})

	vim.api.nvim_create_autocmd({ "DirChanged" }, {
		group = group,
		callback = function()
			vim.defer_fn(function()
				M.set_cursor_rules_variable()
			end, 200)
		end,
		desc = "Reload cursor rules when directory changes"
	})
end

_G.CursorRules = M

return M
