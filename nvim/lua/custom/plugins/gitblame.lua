return {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    keys = {
        {
            "<leader>hB",
            "<cmd>GitBlameToggle<CR>",
            desc = "Toggle Git Blame",
        },
    },
    opts = {
        enabled = true,
        message_template = " <summary> • <date> • <author> • <<sha>>",
        date_format = "%m-%d-%Y %H:%M:%S",
        virtual_text_column = 1,
    },
}

