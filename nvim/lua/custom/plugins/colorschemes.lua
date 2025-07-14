return {
  { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },
  { 'ellisonleao/gruvbox.nvim', priority = 1000, config = true, opts = ... },
  { 'nyoom-engineering/oxocarbon.nvim' },
  { 'rebelot/kanagawa.nvim' },
  { 'sam4llis/nvim-tundra' },
  { 'rose-pine/neovim' },
  {
    'projekt0n/github-nvim-theme',
    priority = 1000,
    config = function()
      vim.cmd 'colorscheme github_dark_default'
    end,
  },
  { 'bluz71/vim-moonfly-colors' },
}
