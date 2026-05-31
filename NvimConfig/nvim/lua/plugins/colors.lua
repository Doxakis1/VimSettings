return {
	{
		"morhetz/gruvbox",
		config = function()
			vim.cmd.colorscheme "gruvbox"
		end
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			theme = "tokyonight",
		}
	},
}
