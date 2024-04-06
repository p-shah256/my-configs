require("neogen").setup({
	enabled = true,
	languages = {
		lua = {
			template = {
				annotation_convention = "emmylua", -- for a full list of annotation_conventions, see supported-languages below,
			},
		},
		python = {
			template = {
				annotation_convention = "reST",
			},
		},
	},
})
