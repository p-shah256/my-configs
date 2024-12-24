return {
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = ...},
  { "nyoom-engineering/oxocarbon.nvim" },
  { "rebelot/kanagawa.nvim", },
  { "rose-pine/neovim" },
  { "bluz71/vim-moonfly-colors",
    config = function()
      vim.cmd("colorscheme moonfly")
    end
  }
}
