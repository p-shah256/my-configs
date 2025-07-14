return {
  'stevearc/aerial.nvim',
  opts = {},
  -- Optional dependencies
  keys = {
    {
      '<leader>co',
      '<cmd>AerialToggle<CR>',
      desc = 'Toggle Outline',
    },
  },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
}
