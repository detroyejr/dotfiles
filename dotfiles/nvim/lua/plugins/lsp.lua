return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lspconfig = require('lspconfig')

		local servers = {
			"clangd",
			"lua_ls",
			"nixd",
			"pylsp",
			"r_language_server",
		}

		local opts = {
			capabilities = require('cmp_nvim_lsp').default_capabilities()
		}

		local signs = {
			{ name = "DiagnosticSignError", text = "" },
			{ name = "DiagnosticSignWarn", text = "" },
			{ name = "DiagnosticSignHint", text = "" },
			{ name = "DiagnosticSignInfo", text = "" },
		}

		local config = {
			virtual_text = true,
			signs = {
				active = signs,
			},
			update_in_insert = true,
			underline = true,
			severity_sort = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		}
		vim.diagnostic.config(config)

		for _, server in pairs(servers) do
			local ok, setting = pcall(require, "plugins.settings." .. server)
			if ok then
				opts = vim.tbl_deep_extend("force", opts, setting)
				lspconfig[server].setup(opts)
			else
				lspconfig[server].setup(opts)
			end
		end

		for _, sign in ipairs(signs) do
			vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
		end
	end,
	keys = {
		{ "<leader>li", "<cmd>LspInfo<cr>", },
		{ "<leader>lf", ":lua vim.lsp.buf.format()<cr>",             silent = true },
		{ "<leader>ll", ":lua vim.lsp.buf.format()<cr>",             silent = true },
		{ "gd",         ":lua vim.lsp.buf.definition()<cr>",         silent = true },
		{ "gD",         "<cmd>lua vim.lsp.buf.declaration()<CR>",    silent = true },
		{ "gk",         "<cmd>lua vim.lsp.buf.hover()<CR>",          silent = true },
		{ "gi",         "<cmd>lua vim.lsp.buf.implementation()<CR>", silent = true },
		{ "gj",         "<cmd>lua vim.lsp.buf.signature_help()<CR>", silent = true },
		{ "gr",         "<cmd>lua vim.lsp.buf.references()<CR>",     silent = true },
	}
}
