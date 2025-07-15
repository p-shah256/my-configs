return {
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- Recommended for icons, but not strictly "basic" if you don't care for them
    config = function()
      require('lualine').setup({}) -- This is the magic line!
    end,
  },
}
