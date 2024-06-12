require("gitsigns").setup({
	signs = {
		add = { text = "┃" },
		change = { text = "┃" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
	numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
	linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
	word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
	watch_gitdir = {
		follow_files = true,
	},
	auto_attach = true,
	attach_to_untracked = false,
	current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
		delay = 1000,
		ignore_whitespace = false,
		virt_text_priority = 100,
	},
	current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
	current_line_blame_formatter_opts = {
		relative_time = false,
	},
	sign_priority = 6,
	update_debounce = 100,
	status_formatter = nil, -- Use default
	max_file_length = 40000, -- Disable if file is longer than this (in lines)
	preview_config = {
		-- Options passed to nvim_open_win
		border = "single",
		style = "minimal",
		relative = "cursor",
		row = 0,
		col = 1,
	},
	--
	-- remaps
	--
	on_attach = function(bufnr)
		local gitsigns = require("gitsigns")

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				gitsigns.nav_hunk("next")
			end
		end)

		map("n", "[c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end)

		-- Actions
		map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "[h]unk [s]tage" })
		map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "[h]unk [r]eset" })
		map("v", "<leader>hs", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "[h]unk [s]tage selected lines V" })
		map("v", "<leader>hr", function()
			gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "[h]unk [r]eset selected lines V" })
		map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "[h]unk [S]tage ALL changes" })
		map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "[h]unk [u]ndo stage" })
		map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "[h]unk [R]eset all changes in buffer" })
		map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "[h]unk [p]review current" })
		map("n", "<leader>hb", function()
			gitsigns.blame_line({ full = true })
		end, { desc = "show full [h]unk [b]lame current line" })
		map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[t]oggle [b]lame current line" })
		map("n", "<leader>hd", gitsigns.diffthis, { desc = "[h]unk [d]iff with HEAD" })
		map("n", "<leader>hD", function()
			gitsigns.diffthis("~")
		end, { desc = "diff [h]unk current [D]irectory" })
		map("n", "<leader>td", gitsigns.toggle_deleted, { desc = "[t]oggle [d]eleted lines" })

		-- Text object
		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "select current hunk as text" })
	end,
})
