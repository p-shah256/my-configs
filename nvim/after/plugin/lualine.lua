local function get_active_formatters()
	local conform = require("conform")
	local formatters = conform.formatters_by_ft[vim.bo.filetype]
	if formatters then
		return table.concat(formatters)
	end
end

local function get_active_LSP()
	local clients = vim.lsp.get_active_clients()
	for _, client in ipairs(clients) do
		local filetypes = client.config.filetypes
		if filetypes and vim.fn.index(filetypes, vim.bo.filetype) ~= -1 then
			return client.name
		end
	end
end

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = false,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = {
			function()
				return vim.fn.fnamemodify(vim.fn.expand("%:p"), ":h") -- Get the parent directory of the file
			end,
		},
		lualine_x = {
			-- "encoding",
			"fileformat",
			"filetype",
		},
		lualine_y = {
			"progress",
			{
				get_active_formatters,
				icon = "󰉪",
			},
			{
				get_active_LSP,
				icon = " ",
			},
		},
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {},
})
