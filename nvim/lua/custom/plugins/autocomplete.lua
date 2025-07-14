-- Configuration for nvim-cmp: Neovim's autocompletion plugin.
-- This setup integrates nvim-cmp with LSP, LuaSnip (for snippets),
-- and path completion, providing a powerful and intuitive typing experience.

return {
  'hrsh7th/nvim-cmp',
  -- Load cmp when entering insert mode, as it's primarily an insert-mode plugin.
  event = 'InsertEnter',
  dependencies = {
    -- Snippet engine & integration
    { 'L3MON4D3/LuaSnip' },            -- The main snippet engine
    'saadparwaiz1/cmp_luasnip',        -- nvim-cmp source for LuaSnip snippets
    'rafamadriz/friendly-snippets',    -- A collection of common snippets for LuaSnip

    -- LSP & Path completion sources
    'hrsh7th/cmp-nvim-lsp',            -- nvim-cmp source for Neovim's LSP client
    'hrsh7th/cmp-path',                -- nvim-cmp source for file system paths
    'hrsh7th/cmp-buffer',              -- **[ADDED]** nvim-cmp source for words in current buffer

    -- Signature help source (provides function signatures)
    { 'hrsh7th/cmp-nvim-lsp-signature-help' },

    -- Optional: For icons in the completion menu (requires nvim-web-devicons to be installed globally)
    'nvim-tree/nvim-web-devicons',

    -- **[FIX]** Added lspkind.nvim dependency for formatting
    'onsails/lspkind.nvim',
  },
  config = function()
    -- Load nvim-cmp and LuaSnip modules
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    local lspkind = require 'lspkind' -- Load lspkind module

    -- LuaSnip configuration
    luasnip.config.setup {} -- Default setup is often sufficient

    -- Load snippets from VS Code-compatible snippet files (like friendly-snippets)
    require('luasnip.loaders.from_vscode').lazy_load()

    -- nvim-cmp setup
    cmp.setup {
      -- Snippet engine integration: tell cmp how to expand snippets
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body) -- Use LuaSnip to expand LSP-style snippets
        end,
      },

      -- Completion menu options
      completion = {
        -- 'menu': Show menu. 'menuone': Show menu if only one item. 'noinsert': Don't auto-insert first item.
        -- This prevents accidental insertions and requires explicit selection/confirmation.
        completeopt = 'menu,menuone,noinsert',
      },

      -- Experimental features (optional)
      experimental = {
        ghost_text = true, -- Show ghost text for the currently selected completion item
      },

      -- Customize the appearance of the completion and documentation windows
      window = {
        completion = cmp.config.window.bordered(),    -- Add borders to the completion pop-up
        documentation = cmp.config.window.bordered(), -- Add borders to the documentation pop-up
      },

      -- Keymaps for navigating and confirming completions/snippets
      -- For a deep dive into completion mappings, refer to `:help ins-completion`
      mapping = cmp.mapping.preset.insert {
        -- Navigate completion items
        ['<C-n>'] = cmp.mapping.select_next_item(), -- Select next item
        ['<C-p>'] = cmp.mapping.select_prev_item(), -- Select previous item

        -- Scroll documentation window
        ['<C-b>'] = cmp.mapping.scroll_docs(-4), -- Scroll documentation up
        ['<C-f>'] = cmp.mapping.scroll_docs(4),  -- Scroll documentation down

        -- Confirm completion or trigger fallback behavior
        -- ['<CR>'] = cmp.mapping.confirm { select = false }, -- Confirm completion (don't auto-select first item)

        -- Manually trigger completion menu
        ['<C-Space>'] = cmp.mapping.complete {},

        -- Tab/Shift-Tab for smart navigation (completion and snippets)
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- If completion menu is visible, select next item
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            -- If not, and current position is expandable/jumpable within a snippet, expand/jump
            luasnip.expand_or_jump()
          else
            -- Otherwise, fall back to default Tab behavior (e.g., insert tab character)
            fallback()
          end
        end, { 'i', 's' }), -- Apply in insert and snippet modes

        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- If completion menu is visible, select previous item
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            -- If not, and previous position is jumpable within a snippet, jump back
            luasnip.jump(-1)
          else
            -- Otherwise, fall back to default Shift-Tab behavior
            fallback()
          end
        end, { 'i', 's' }), -- Apply in insert and snippet modes
      },

      -- Sources for completion items, in order of preference.
      -- The order determines which source's items are prioritized.
      sources = {
        { name = 'nvim_lsp' },                   -- LSP suggestions (highly prioritized)
        { name = 'luasnip' },                    -- Snippets from LuaSnip
        { name = 'buffer' },                     -- Words from the current buffer
        { name = 'path' },                       -- File system paths
        { name = 'nvim_lsp_signature_help' },    -- Signature help as a source (can also be handled by separate keymap for pop-up)
        -- { name = 'lazydev', group_index = 0 }, -- If you use lazy.nvim's lazydev, keep this. Otherwise, remove.
      },

      -- Customization for how items are rendered in the completion menu
      formatting = {
        format = lspkind.cmp_format({ -- Now lspkind is available
          -- Show `kind` icons (Function, Variable, Method etc.)
          -- Requires `nvim-web-devicons` to render properly
          mode = 'symbol_and_text', -- Show both symbol and text
          maxwidth = 50,            -- Maximum width for item text
          ellipsis_text = '...',    -- Text to use for truncation
          -- See :h cmp-format for more options
        }),
      },

      -- Comparison algorithm for sorting completion items
      -- Prioritizes exact matches, then fuzzy matches, etc.
      compare = {
        cmp.config.compare.offset,     -- Sort by distance from cursor
        cmp.config.compare.exact,      -- Prioritize exact matches
        cmp.config.compare.score,      -- Prioritize items with higher score (e.g., LSP relevance)
        cmp.config.compare.recently_used, -- Prioritize recently used items
        cmp.config.compare.locality,   -- Prioritize items from local scope
        cmp.config.compare.kind,       -- Sort by completion item kind (e.g., functions before variables)
        cmp.config.compare.sort_text,  -- Sort by sortText (LSP-provided sort order)
        cmp.config.compare.length,     -- Sort by length
        cmp.config.compare.order,      -- Sort by source order
      },
    }

    -- NOTE: THIS WORKS REGARDLESS
    -- Optional: Setup for cmp-nvim-lsp-signature-help (if you want it to pop up without a keymap)
    -- This makes the signature help pop up automatically as you type function calls.
    -- If you prefer to only see it on <C-k>, you might not need this.
  end,
}
