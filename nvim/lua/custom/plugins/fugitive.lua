return {
  {
    "tpope/vim-fugitive",
    event = "VeryLazy",
    config = function()
      vim.schedule(function()
        local map = vim.keymap.set

        -- Define the Git group for which-key.nvim
        -- This entry itself will create the "Git" group under <leader>g
        map("n", "<leader>g", "<Nop>", { desc = "Git" }) -- 󰊢 is a common Git icon

        -- Git Group (g) - Now these will appear under the 'Git' group
        map("n", "<leader>gb", "<cmd>Git blame<cr>", { desc = "[g]it [b]lame" })
        map("n", "<leader>gc", "<cmd>Gvdiffsplit!<cr>", { desc = "[g]it [c]onflict split" })
        map("n", "<leader>gg", "<cmd>vertical G<cr>", { desc = "[g]it [g]status (vsplit)" })
        map("n", "<leader>gl", "<cmd>Git log --stat -p<cr>", { desc = "[g]it [l]og w/ diff" })
        map("n", "<leader>gP", "<cmd>Git pull<cr>", { desc = "[g]it [P]ull" })
        map("n", "<leader>gp", "<cmd>Git -c push.default=current push<cr>", { desc = "[g]it [p]ush" })
      end)
    end,
  },
}
