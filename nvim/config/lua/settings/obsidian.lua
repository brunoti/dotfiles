local obsidian_path = "~/Obsidian"

return {
	setup = function()
		return {
			"epwalsh/obsidian.nvim",
			version = "*",
			lazy = true,
			cmd = "ObsidianNew",
			-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
			event = {
				-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
				-- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
				"BufReadPre " .. vim.fn.expand(obsidian_path) .. "/**.md",
				"BufNewFile " .. vim.fn.expand(obsidian_path) .. "/**.md",
			},
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
			opts = {
				disable_frontmatter = true,
				workspaces = {
					{
						name = "defalt",
						path = obsidian_path,
					},
				},
				templates = {
					subdir = "3. resources/templates",
				}
			},
		}
	end
}
