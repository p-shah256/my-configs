-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.clipboard = 'unnamedplus' -- Use the system clipboard for all operations

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Basic treesitter folding
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldenable = true
vim.opt.foldlevel = 99 -- Start with all folds open

-- Simple clean fold appearance
vim.opt.fillchars = { fold = ' ' }
vim.opt.foldtext = [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').' ...']]

-- Optional: jump between folds
-- vim.keymap.set('n', '}', 'zj')
-- vim.keymap.set('n', '{', 'zk')

-- Sync clipboard between OS and Neovim.
-- Schedule the setting after `UiEnter` because it can increase startup-time.
-- Remove this option if you want your OS clipboard to remain independent.
-- See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

vim.diagnostic.config {
  float = {
    source = true,
    border = 'rounded',
    focus = false,
    scope = 'cursor',
    header = '',
    prefix = '',
  },
  virtual_text = false,
}
vim.o.updatetime = 250
vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]

-- FONT CONFIG // CUSTOM
vim.cmd [[
  syntax enable
  set termguicolors
]]
-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.expandtab = true
vim.opt.tabstop = 4      -- Number of spaces a tab counts for
vim.opt.shiftwidth = 4   -- Number of spaces for each indentation level
vim.opt.softtabstop = 4  -- Number of spaces for tab in insert mode
vim.opt.smartindent = true

-- Highlights
vim.api.nvim_command 'highlight Comment cterm=italic gui=italic guifg=#777777'
vim.api.nvim_command 'highlight Function cterm=bold gui=bold guifg=#87afff'

-- Add this to your Neovim config
vim.filetype.add {
  extension = {
    h = 'c', -- "Dear Neovim, .h files are C files, kthxbai"
  },
}

--
-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = 'go',
--   callback = function()
--     vim.bo.tabstop = 4
--     vim.bo.shiftwidth = 4
--     vim.bo.expandtab = true
--   end,
-- })
--
-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = { 'c', 'cpp' },
--   callback = function()
--     vim.bo.tabstop = 4
--     vim.bo.shiftwidth = 4
--     vim.bo.expandtab = true
--   end,
-- })

vim.g.gitblame_delay = 2000
