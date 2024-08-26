return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.8',
	dependencies = { 'nvim-lua/plenary.nvim' },
	keys = {
		{ "<leader>ff", ":Telescope find_files<cr>", "Find Files",  silent = true },
		{ "<leader>fF", ":Telescope live_grep<cr>",  "Find Text",   silent = true },
		{ "<leader>fb", ":Telescope buffers<cr>",    "Find Buffer", silent = true },
		{ "<leader>fh", ":Telescope help_tags<cr>",  "Help Tags",   silent = true },
	}
}
