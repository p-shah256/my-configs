return {
  {
    "ycm-core/YouCompleteMe",
    run = "./install.py --ts-completer --rust-completer --cs-completer", -- Install YouCompleteMe with support for TypeScript, Rust, and C#
    config = function()
      -- YCM configuration settings
      vim.g.ycm_collect_identifiers_from_tags_files = 1 -- Let YCM read tags from Ctags file
      vim.g.ycm_use_ultisnips_completer = 1 -- Default 1, just ensure
      vim.g.ycm_seed_identifiers_with_syntax = 1 -- Completion for programming language's keyword
      vim.g.ycm_complete_in_comments = 1 -- Completion in comments
      vim.g.ycm_complete_in_strings = 1 -- Completion in strings
    end,
  },
  {
    "SirVer/UltiSnips",
    config = function()
      vim.g.UltiSnipsExpandTrigger = "<tab>"
      vim.g.UltiSnipsJumpForwardTrigger = "<c-j>"
      vim.g.UltiSnipsJumpBackwardTrigger = "<c-k>"
      vim.g.UltiSnipsListSnippets = "<c-l>"
    end,
  },
}
