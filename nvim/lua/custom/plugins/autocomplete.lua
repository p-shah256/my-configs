return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    { 'L3MON4D3/LuaSnip' },
    'saadparwaiz1/cmp_luasnip', --  nvim-cmp does not ship with all sources by default. They are split
    'rafamadriz/friendly-snippets',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    { 'hrsh7th/cmp-nvim-lsp-signature-help' },
  },
  config = function()
    -- See `:help cmp`
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    luasnip.config.setup {}

    require('luasnip.loaders.from_vscode').lazy_load()

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = 'menu,menuone,noinsert' },
      experimental = {
        ghost_text = true,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },

      -- For an understanding of why these mappings were
      -- chosen, you will need to read `:help ins-completion`
      --
      -- No, but seriously. Please read `:help ins-completion`, it is really good!
      mapping = cmp.mapping.preset.insert {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-y>'] = cmp.mapping.confirm { select = true },
        ['<C-Space>'] = cmp.mapping.complete {},
        -- <c-l> will move you to the right of each of the expansion locations.
        -- <c-h> is similar, except moving you backwards.
        ['<C-l>'] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { 'i', 's' }),
        ['<C-h>'] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { 'i', 's' }),
      },
      sources = {
        {
          name = 'lazydev',
          group_index = 0,
        },
        { name = 'nvim_lsp_signature_help' }, -- Add this line!
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
      },
    }
  end,
}





-- return {
--   'saghen/blink.cmp',
--   dependencies = 'rafamadriz/friendly-snippets',
--
--   opts = {
--     keymap = { preset = 'default' },
--     appearance = {
--       nerd_font_variant = 'mono'
--     },
--     sources = {
--       default = { 'lsp', 'path', 'snippets', 'buffer' },
--     },
--   },
--   opts_extend = { "sources.default" }
-- }
