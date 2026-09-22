-- nvim-treesitter, on the rewritten `main` branch.
--
-- The old `master` branch (and its `require('nvim-treesitter.configs').setup{}`
-- module system) has been retired. The rewrite has no modules: parsers are
-- installed with `install()`, and highlighting/indent are switched on per
-- buffer via `vim.treesitter.start()`.
return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  build = ':TSUpdate',
  config = function()
    local parsers = {
      'bash', 'c', 'elixir', 'go', 'heex', 'helm', 'html', 'javascript',
      'lua', 'luadoc', 'markdown', 'markdown_inline', 'python', 'query',
      'rust', 'terraform', 'toml', 'vim', 'vimdoc', 'yaml',
    }
    require('nvim-treesitter').install(parsers)

    ---@param buf integer
    ---@param language string
    local function try_attach(buf, language)
      if not vim.treesitter.language.add(language) then return end
      if not vim.api.nvim_buf_is_valid(buf) then return end

      vim.treesitter.start(buf, language)

      -- Treesitter-based indentation, where the language provides an indents query.
      if vim.treesitter.query.get(language, 'indents') ~= nil then
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end

    local available = require('nvim-treesitter').get_available()

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('user-treesitter-attach', { clear = true }),
      callback = function(args)
        local buf, filetype = args.buf, args.match

        local language = vim.treesitter.language.get_lang(filetype)
        if not language then return end

        local installed = require('nvim-treesitter').get_installed 'parsers'

        if vim.tbl_contains(installed, language) then
          try_attach(buf, language)
        elseif vim.tbl_contains(available, language) then
          -- Not installed yet: fetch it, then attach once it lands.
          require('nvim-treesitter').install(language):await(function()
            try_attach(buf, language)
          end)
        end
      end,
    })
  end,
}
