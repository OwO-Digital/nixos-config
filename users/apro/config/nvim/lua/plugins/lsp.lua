local _lspconf,  lspconf  = pcall(require, 'lspconfig')
local _mason,    mason    = pcall(require, 'mason')
local _masonlsp, masonlsp = pcall(require, 'mason-lspconfig')
local _nullls,   nullls   = pcall(require, 'null-ls')
local _masonnls, masonnls = pcall(require, 'mason-null-ls')
local _lspsign,  lspsign  = pcall(require, 'lsp_signature')
local _trouble,  trouble  = pcall(require, 'trouble')
local _dapui,    dapui    = pcall(require, 'dapui')
if not (_lspconf and _mason and _masonlsp) then return end

vim.g.coq_settings = { auto_start = 'shut-up' }
pcall(require, 'coq')

mason.setup({
	ui = {
		icons = {
			package_installed   = "✅",
			package_pending     = "...",
			package_uninstalled = "❎",
		},
		border = "single",
	}
})
masonlsp.setup({
	ensure_installed = {
		"clangd",        -- C
		"html",          -- HTML
		"cssls",         -- CSS
		"dockerls",      -- Docker
		"grammarly",     -- Grammarly (why do i find this so funny)
		"jsonls",        -- JSON
		"eslint",        -- ESLint
		"tsserver",      -- JavaScript & TypeScript
		"sumneko_lua",   -- Lua
		"marksman",      -- Markdown
		"rnix",          -- Nix
		"pyright",       -- Python
		"tailwindcss",   -- TailwindCSS
		"yamlls",        -- YAML
	}
})

masonlsp.setup_handlers {
	function(lspserver)
		lspconf[lspserver].setup({})
	end
}

if _nullls then
	nullls.setup()

	if _masonnls then
		masonnls.setup({
			ensure_installed = {
				"clang_format",          -- C
				"jq",                    -- JSON
				"stylua",                -- Lua
				"autopep8",              -- Python
				"shfmt",                 -- Shell
				"prettier", "prettierd", -- Webdev
				"yamlfmt",               -- YAML
			},
			automatic_setup = true,
			automatic_installation = true,
		})
		masonnls.setup_handlers()
	end
end

if _lspsign then
	lspsign.setup({
		bind = true,
		handler_opts = {
			border = 'single'
		}
	})
end

if _trouble then
	trouble.setup()
end

if _dapui then
	dapui.setup()
end

