function starts_with(needle, haystack)
	return haystack:sub(1, #needle) == needle
end

return {
	setup = function()
		return {
			'nanozuki/tabby.nvim',
			event = 'VimEnter',
			dependencies = 'nvim-tree/nvim-web-devicons',
			opts = {
				icons_enabled = true,
			},
			config = function()
				vim.opt.sessionoptions = 'curdir,folds,globals,help,tabpages,terminal,winsize'
				local theme = {
					fill = 'TabLineFill',
					head = 'TabLine',
					current_tab = 'TabLineSel',
					tab = 'TabLine',
					win = 'TabLine',
					tail = 'TabLine',
				}
				require('tabby.tabline').set(function(line)
					return {
						{
							{ '  ', hl = theme.head },
							line.sep('', theme.head, theme.fill),
						},
						line.tabs().foreach(function(tab)
							local hl = tab.is_current() and theme.current_tab or theme.tab
							return {
								line.sep('', hl, theme.fill),
								-- tab.is_current() and '' or '󰆣',
								tab.number(),
								tab.current_win().buf_name(),
								margin = '  ',
								tab.current_win().file_icon(),
								line.sep('', hl, theme.fill),
								hl = hl,
								margin = ' ',
							}
						end),
						line.spacer(),
						line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
							return {
								line.sep('', theme.win, theme.fill),
								win.file_icon(),
								margin = '  ',
								-- win.is_current() and '' or '',
								win.buf_name(),
								line.sep('', theme.win, theme.fill),
								hl = theme.win,
								margin = ' ',
							}
						end),
						{
							line.sep('', theme.tail, theme.fill),
							{ '  ', hl = theme.tail },
						},
						hl = theme.fill,
					}
				end, {
					buf_name = {
						mode = 'unique',
					},
				})
			end,
		}
	end
}
