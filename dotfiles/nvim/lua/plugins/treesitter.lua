return {
	'nvim-treesitter/nvim-treesitter',
	config = function()
		require("nvim-treesitter.configs").setup {
			ensure_installed = {
				"markdown",
				'bash',
				'c',
				'c',
				'cpp',
				'diff',
				'html',
				'lua',
				'python',
				'r',
				'rust',
			},
			auto_install = true,
		}
	end
}
