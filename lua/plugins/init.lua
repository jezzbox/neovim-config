return {
	{"rebelot/kanagawa.nvim"},
	{'lewis6991/gitsigns.nvim',
	    opts = {
	      -- See `:help gitsigns.txt`
	      signs = {
		add = { text = '+' },
		change = { text = '~' },
		delete = { text = '_' },
		topdelete = { text = '‾' },
		changedelete = { text = '~' },
	      },
	      on_attach = function(bufnr)
		vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk, { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
		vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
		vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
	      end,
	    },
	},
 	{'williamboman/mason.nvim'},
 	{'williamboman/mason-lspconfig.nvim'},
	{'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
	{'neovim/nvim-lspconfig'},
	{'L3MON4D3/LuaSnip',version = "v2.4", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- install jsregexp (optional!).
	build = "make install_jsregexp"
	},
	{ "qvalentin/helm-ls.nvim", ft = "helm",
		opts = {
			conceal_templates = {
				-- enable the replacement of templates with virtual text of their current values
				enabled = true, -- tree-sitter must be setup for this feature
			},
			indent_hints = {
				-- enable hints for indent and nindent functions
				enabled = true, -- tree-sitter must be setup for this feature
			},
		},
	},
}
