-- options.lua
vim.opt.showtabline = 2
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.api.nvim_set_keymap('n', '<S-T>', ':tabnext<CR>', { noremap = true })

vim.keymap.set('n', '<Leader>e', ':Neotree toggle<CR>')
