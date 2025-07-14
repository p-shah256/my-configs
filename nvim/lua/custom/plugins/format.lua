return {
  { -- Autoformat using conform.nvim
    'stevearc/conform.nvim',
    -- Only load conform when one of these events occur (e.g., before writing a buffer)
    event = { 'BufWritePre' },
    -- Define commands provided by the plugin
    cmd = { 'ConformInfo' },
    keys = {
      -- Keymap for formatting the entire buffer (normal mode)
      {
        '<leader>f',
        function()
          -- Asynchronously format the entire buffer.
          -- 'lsp_format = "fallback"' means try LSP formatting first, then fall back to Conform's formatters.
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = 'n', -- Normal mode
        desc = '[F]ormat buffer',
      },
      -- Keymap for formatting a visual selection (visual mode)
      {
        '<leader>f',
        function()
          -- When called in visual mode, conform.nvim automatically formats the selected range.
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = 'x', -- Visual mode (for selection)
        desc = '[F]ormat selection',
      },
    },
    opts = {
      -- Do not show notifications for successful formatting, only for errors
      notify_on_error = false,
      -- Define which formatters to use for each file type.
      -- Order matters: conform will try formatters in the list until one succeeds.
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'isort', 'black' }, -- Use isort for imports, then black for general formatting
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { 'prettierd', stop_after_first = true }, -- Use prettierd for TypeScript; stop after it succeeds.
        -- Add more file types and their preferred formatters here:
        -- go = { 'goimports', 'gofmt' },
        -- json = { 'prettierd' },
        -- markdown = { 'prettierd' },
        -- css = { 'prettierd' },
        -- html = { 'prettierd' },
      },
      -- You can also define global formatters or default options here if needed.
      -- format_on_save = { timeout_ms = 500, lsp_format = 'fallback' },
    },
  },
}
