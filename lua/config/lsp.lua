-- LSP setup.
--
-- Previously this used lsp-zero + mason-lspconfig's `handlers` option. Both are
-- gone: mason-lspconfig v2 removed `handlers`, and lsp-zero has been wound down
-- in favour of Neovim's native vim.lsp.config/vim.lsp.enable (0.11+). This file
-- uses the native API directly.

-- Broadcast nvim-cmp's extra completion capabilities to every server.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
vim.lsp.config('*', { capabilities = capabilities })

require('mason').setup({})

-- mason-lspconfig v2 enables each installed server via vim.lsp.enable()
-- automatically (`automatic_enable` defaults to true), so listing them here is
-- all that is needed to get them installed and running.
require('mason-lspconfig').setup({
  ensure_installed = {
    'lua_ls',
    'rust_analyzer',
    'pyright',
    'gopls',
    'yamlls',
    'helm_ls',
  },
})

-- ── per-server configuration ────────────────────────────────────────────────

vim.lsp.config('lua_ls', {
  on_init = function(client)
    local folders = client.workspace_folders
    if folders and folders[1] then
      local path = folders[1].name
      if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua or {}, {
      -- Tell the language server which version of Lua you're using
      -- (LuaJIT, in the case of Neovim)
      runtime = { version = 'LuaJIT' },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME },
      },
    })
  end,
  settings = { Lua = {} },
})

vim.lsp.config('helm_ls', {
  settings = {
    ['helm-ls'] = {
      yamlls = { path = 'yaml-language-server' },
    },
  },
})

vim.lsp.config('yamlls', {})

-- ── keymaps (these replace lsp-zero's default_keymaps) ──────────────────────

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
  callback = function(event)
    local function map(keys, fn, desc)
      vim.keymap.set('n', keys, fn, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    map('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    map('go', vim.lsp.buf.type_definition, 'Type [D]efinition')
    map('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
    map('K', vim.lsp.buf.hover, 'Hover documentation')
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    map('<leader>f', function() vim.lsp.buf.format({ async = true }) end, '[F]ormat buffer')

    vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help,
      { buffer = event.buf, desc = 'LSP: Signature help' })
  end,
})
