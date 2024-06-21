-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>fm", "<cmd>set foldmethod=manual<cr>", { desc = "[f]old [m]anual" })
vim.keymap.set("n", "<leader>fi", "<cmd>set foldmethod=indent<cr>", { desc = "[f]old [i]ndent" })
