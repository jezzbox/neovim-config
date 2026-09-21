return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function () 
      local configs = require("nvim-treesitter.configs")

      configs.setup({
          ensure_installed = { "c", "lua", "vim", "vimdoc", "rust", "go", "terraform", "yaml", "python", "query", "elixir", "heex", "javascript", "html", "yaml", "helm" },
          sync_install = true,
          highlight = { enable = true },
          indent = { enable = true },  
	  additional_vim_regex_highlighting = false,
        })
    end
    }
