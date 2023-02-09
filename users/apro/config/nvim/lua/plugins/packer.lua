local check_packer = function()
	local fn = vim.fn
	local path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
	if fn.empty(fn.glob(path)) > 0 then
		fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', path })
		print('Packer not found. Installing. Please restart Neovim.')
		vim.cmd('packadd packer.nvim')
		return true
	end
	return false
end

local bootstrap = check_packer()

vim.cmd([[
  augroup packer_user_config
	autocmd!
	autocmd BufWritePost plugins/packer.lua source <afile> | PackerSync
  augroup end
]])

local _packer, packer = pcall(require, "packer")
if not _packer then return end


packer.init({
	display = {
		open_fn = function()
			return require('packer.util').float({ border = 'single' })
		end
	}
})

return packer.startup(function(use)
	-- Package Manager
	use { 'wbthomason/packer.nvim' }

	-- LSP, Completion, etc.
	use { 'sheerun/vim-polyglot' }
	use { 'neovim/nvim-lspconfig' }
	use { 'williamboman/mason.nvim' }
	use { 'williamboman/mason-lspconfig.nvim' }
	use { 'jose-elias-alvarez/null-ls.nvim' }
	use { 'jayp0521/mason-null-ls.nvim' }
	use { 'ms-jpq/coq_nvim', tag = 'coq', requires = { { 'ms-jpq/coq.artifacts', tag = 'artifacts' } } }
	use { 'ray-x/lsp_signature.nvim' }
	use { 'folke/trouble.nvim' }
	use { 'mfussenegger/nvim-dap' }
	use { 'rcarriga/nvim-dap-ui' }

	-- Snippets
	use { 'L3MON4D3/LuaSnip' }
	use { 'rafamadriz/friendly-snippets' }

	-- GUI and adjacent functionality
	use { 'goolord/alpha-nvim', requires = { 'Shatur/neovim-session-manager' } }
	use { 'feline-nvim/feline.nvim' }
	use { 'romgrk/barbar.nvim' }
	use { 'nvim-tree/nvim-tree.lua', requires = { 'nvim-tree/nvim-web-devicons' } }

	-- Telescope
	use { 'nvim-telescope/telescope.nvim', tag = '0.1.0', requires = { 'nvim-lua/plenary.nvim' } }
	use { 'nvim-telescope/telescope-ui-select.nvim' }
	use { 'nvim-telescope/telescope-file-browser.nvim' }
	use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

	-- Misc
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
	use { 'windwp/nvim-ts-autotag' }
	use { 'windwp/nvim-autopairs' }
	use { 'NvChad/nvim-colorizer.lua' }
	use { 'lukas-reineke/indent-blankline.nvim' }
	use { 'folke/which-key.nvim' }
	use { 'lewis6991/gitsigns.nvim', tag = 'release' }
	use { 'akinsho/toggleterm.nvim', tag = '*' }
	use { 'numToStr/Comment.nvim' }

	-- Themes
	use { 'catppuccin/nvim', as = 'catppuccin' }
	use { 'Everblush/everblush.nvim', as = 'everblush' }

	if bootstrap then
		packer.sync()
	end
end)
