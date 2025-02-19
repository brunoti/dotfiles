return {
	setup = function()
		return {
			"AckslD/nvim-neoclip.lua",
			config = function()
				require('neoclip').setup()
			end,
		}
	end,
}
