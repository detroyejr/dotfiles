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
			highlight = {
				enable = true,
				disable = { "" },
				additional_vim_regex_highlighting = true,
			},
			indent = { enable = true, disable = { "yaml" } },
			context_commentstring = {
				enable = true,
			},
		}
	end
}
