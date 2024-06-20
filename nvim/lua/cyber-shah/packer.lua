-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	-- TELESCOPE
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.6",
		-- or                            , branch = '0.1.x',
		requires = { { "nvim-lua/plenary.nvim" } },
	})
	use({ "nvim-telescope/telescope-ui-select.nvim" })

	-- themes
	use({ "catppuccin/nvim", as = "catppuccin" })
	use("rose-pine/neovim")
	use("rebelot/kanagawa.nvim")
	use({ "ellisonleao/gruvbox.nvim" })
	use({ "kepano/flexoki-neovim", as = "flexoki" })
	use({ "nyoom-engineering/oxocarbon.nvim" })
	-- vim.cmd("colorscheme oxocarbon")

	use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
	use("nvim-treesitter/playground")

	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")

	-- LSP Configuration
	use("neovim/nvim-lspconfig")

	-- Autocompletion
	use("hrsh7th/nvim-cmp") -- Completion engine
	use("hrsh7th/cmp-nvim-lsp") -- LSP source for nvim-cmp
	use("hrsh7th/cmp-buffer") -- Buffer source for nvim-cmp
	use("hrsh7th/cmp-path") -- Path source for nvim-cmp
	use("hrsh7th/cmp-cmdline") -- Cmdline source for nvim-cmp

	use("L3MON4D3/LuaSnip")
	use("saadparwaiz1/cmp_luasnip")
	use("rafamadriz/friendly-snippets")

	use("SirVer/ultisnips")
	-- use("quangnguyen30192/cmp-nvim-ultisnips")

	use({
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons", -- optional
		},
	})

	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})

	-- Lua
	use({
		"folke/which-key.nvim",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
			require("which-key").setup({})
		end,
	})

	use({
		"folke/flash.nvim",
		config = function()
			require("flash").setup()
		end,
	})

	use({ "folke/todo-comments.nvim" })

	use({
		"ggandor/leap.nvim",
		config = function()
			require("leap").create_default_mappings()
		end,
	})
	use({ "ray-x/lsp_signature.nvim" })

	use({ "echasnovski/mini.nvim" })

	use({
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup()
		end,
	})

	use("lukas-reineke/indent-blankline.nvim")

	use("danymat/neogen")

	use("kdheepak/lazygit.nvim")

	use("LudoPinelli/comment-box.nvim")

	use({
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})

	use({
		"iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		setup = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	})

	use({
		"SmiteshP/nvim-navbuddy",
		requires = {
			"neovim/nvim-lspconfig",
			"SmiteshP/nvim-navic",
			"MunifTanjim/nui.nvim",
			"numToStr/Comment.nvim", -- Optional
			"nvim-telescope/telescope.nvim", -- Optional
		},
	})

	use({
		"nvim-lualine/lualine.nvim",
		requires = { "nvim-tree/nvim-web-devicons", opt = true },
	})
	use("EdenEast/nightfox.nvim")
	--
	-- use({
	-- 	"m4xshen/hardtime.nvim",
	-- 	requires = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
	-- })
	--
	-- GIT TOOLS
	use("lewis6991/gitsigns.nvim")
	use("tpope/vim-fugitive")
end)
