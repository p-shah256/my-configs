return {
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      max_lines = 3, -- How much is too much?
      min_window_height = 5,
      multiline_threshold = 1, -- Minimum lines needed for multi-line context
    },
  },
}
