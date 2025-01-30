return {
  "lervag/vimtex",
  lazy = false,
  init = function()
    -- Basic settings
    vim.g.vimtex_view_method = 'zathura'
    vim.g.vimtex_compiler_method = 'latexmk'
    
    -- Enable automatic compilation on save
    vim.g.vimtex_compiler_latexmk = {
      continuous = 1,  -- Enable continuous compilation
      options = {
        -- '-verbose',
        -- '-file-line-error',
        '-synctex=1',
        '-interaction=nonstopmode',
      }
    }

    -- Custom keybindings
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'tex',
      callback = function()
        -- Compile document
        vim.keymap.set('n', '<leader>c', '<cmd>VimtexCompile<cr>', {buffer=true})
        -- View PDF
        vim.keymap.set('n', '<leader>v', '<cmd>VimtexView<cr>', {buffer=true})
      end
    })
  end
}
