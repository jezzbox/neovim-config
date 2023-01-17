-- Learn the keybindings, see :help lsp-zero-keybindings
-- Learn to configure LSP servers, see :help lsp-zero-api-showcase
local lsp = require('lsp-zero')
lsp.preset('recommended')

lsp.ensure_installed({
	'rust_analyzer',
	'pyright',
	'gopls'
})

lsp.set_preferences({
	sign_icons = { }
})

lsp.setup()
