return {
  {'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
      -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
      -- animation = true,
      -- insert_at_start = true,
      -- …etc.
    -- vim.keymap.set('n', '<A-.>', '<Cmd>BufferNext<CR>', { silent = true })
    },
    keys = {
      { '<A-,>', '<Cmd>BufferPrevious<CR>', desc = 'Go to previous buffer' },
      { '<A-.>', '<Cmd>BufferNext<CR>', desc = 'Go to next buffer' },
    },
    version = '^1.0.0', -- optional: only update when a new 1.x version is released
    -- Previous/next buffer
  },
}


