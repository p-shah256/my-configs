return {
  {'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    lazy = false,  -- This makes the plugin load at startup
    init = function() vim.g.barbar_auto_setup = false end,
    opts = {
      -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
      animation = true,
      insert_at_start = true,
    },
    keys = {
    { '<S-h>', '<Cmd>BufferPrevious<CR>', desc = 'Go to previous buffer' },
    { '<S-l>', '<Cmd>BufferNext<CR>', desc = 'Go to next buffer' },
    { '<S-c>', '<Cmd>BufferClose<CR>', desc = 'Close current buffer' },
    },
    version = '^1.0.0', -- optional: only update when a new 1.x version is released
    -- Previous/next buffer
  },
}


