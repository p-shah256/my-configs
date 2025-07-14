return {
  'neovim/nvim-lspconfig', -- Primary plugin for LSP client configurations
  dependencies = {
    -- LSP Server and Tool Installation/Management
    { 'williamboman/mason.nvim', config = true }, -- Manages LSP servers, linters, formatters
    'williamboman/mason-lspconfig.nvim', -- Integrates Mason with nvim-lspconfig
    'WhoIsSethDaniel/mason-tool-installer.nvim', -- Automatically installs Mason tools based on detected language servers

    -- LSP Enhancements & Utilities
    'p00f/clangd_extensions.nvim', -- Provides additional features for clangd (e.g., AST highlighting).
    -- Make sure to configure this if you plan to use its features.
    { 'j-hui/fidget.nvim', opts = {} }, -- Provides subtle status updates for LSP actions (e.g., "LSP: Initializing").

    -- Autocompletion
    {
      'hrsh7th/nvim-cmp', -- The main completion plugin
      dependencies = {
        'hrsh7th/cmp-buffer', -- Source for buffer words
        'hrsh7th/cmp-path', -- Source for file system paths
        'hrsh7th/cmp-nvim-lsp', -- Source for LSP suggestions (crucial for LSP completion)
      },
    },

    -- Code Navigation & Structure
    'SmiteshP/nvim-navic', -- Displays the current code context (like breadcrumbs) in the statusline

    -- Top context
    {
      'nvim-treesitter/nvim-treesitter-context',
      opts = {
        max_lines = 3, -- How much is too much?
        min_window_height = 5,
        multiline_threshold = 1, -- Minimum lines needed for multi-line context
      },
    },
  },
  config = function()
    -- {{{ General LSP Configuration and Autocmds

    -- Set the highlight group for Inlay Hints.
    -- This makes inlay hints appear in a specific color (fg) and italic.
    -- Adjust 'fg' (foreground color) and 'italic' as per your theme preference.
    vim.api.nvim_set_hl(0, 'LspInlayHint', { fg = '#7f849c', bg = 'none', italic = true })

    -- Autocommand for 'LspAttach' event.
    -- This block defines actions to take whenever an LSP client attaches to a buffer.
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        -- Helper function to create buffer-local keymaps
        local map = function(keys, func, desc, mode)
          mode = mode or 'n' -- Default to normal mode
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Keymaps for common LSP functionalities:
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' }) -- Works in normal and visual mode
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        map('<C-k>', vim.lsp.buf.signature_help, 'Signature Help')

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- Integrate nvim-navic (breadcrumbs) with the LSP client
        -- Checks if the client supports 'documentSymbolProvider' before attaching.
        -- Note: nvim-navic's `auto_attach = true` in its `setup` might make this line redundant,
        -- but it's safe to keep for explicit attachment.
        if client and client.server_capabilities.documentSymbolProvider then
          require('nvim-navic').attach(client, event.buf)
        end

        -- Document Highlights: Highlight all references to the symbol under the cursor.
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })

          -- Highlight references when the cursor holds (stops moving)
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          -- Clear highlights when the cursor moves
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          -- Clear highlights and remove autocmds when LSP detaches from the buffer
          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })

          -- Code Lens Refresh: Refresh code lenses (e.g., "run test", "references")
          -- This often happens on buffer entry, cursor hold, or leaving insert mode.
          if client.server_capabilities.codeLensProvider then
            vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
              group = highlight_augroup,
              callback = vim.lsp.codelens.refresh,
            })
          end
        end

        -- Inlay Hints: Contextual information displayed inline in the code (e.g., parameter names, variable types).
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          -- Enable inlay hints by default for this buffer if the LSP client supports them.
          vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })

          -- Keymap to toggle inlay hints on/off for the current buffer.
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- Diagnostic Configuration: Visual indicators for errors, warnings, etc.
    vim.opt.signcolumn = 'yes' -- Always show the sign column to prevent text jumping

    -- Use Nerd Font symbols for diagnostics if available
    if vim.g.have_nerd_font then
      local signs = { ERROR = '', WARN = '', INFO = '', HINT = '' }
      local diagnostic_signs = {}
      for type, icon in pairs(signs) do
        diagnostic_signs[vim.diagnostic.severity[type]] = icon
      end
      vim.diagnostic.config { signs = { text = diagnostic_signs } }
    end
    -- }}}

    -- Updated configuration for mason-lspconfig v2.0.0
    -- Replace the entire "LSP Client Capabilities & Server Configurations" section with this:

    -- {{{ LSP Client Capabilities & Server Configurations

    -- Define LSP client capabilities.
    -- This extends default LSP capabilities with those provided by nvim-cmp for better completion.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- Configure individual servers using the new vim.lsp.config() API
    -- This replaces the old handlers system

    -- Python Language Server
    vim.lsp.config('pyright', {
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = 'workspace',
          },
        },
      },
      on_init = function(client)
        local config = client.config.settings.python
        -- print('Python settings:', vim.inspect(config)) -- Uncomment for debugging
      end,
      capabilities = capabilities,
    })

    -- Clangd Language Server
    vim.lsp.config('clangd', {
      root_dir = function()
        return vim.fn.getcwd()
      end,
      settings = {
        inlayHints = {
          parameterNames = true,
          typeHints = true,
          deducedTypes = true,
          variableTypes = true,
          autoDeclarations = true,
        },
      },
      capabilities = capabilities,
    })

    -- Go Language Server
    vim.lsp.config('gopls', {
      settings = {
        gopls = {
          usePlaceholders = true,
          analyses = {
            unusedparams = true,
          },
        },
      },
      init_options = {
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
      capabilities = capabilities,
    })

    -- TypeScript Language Server
    vim.lsp.config('ts_ls', {
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = 'all',
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
          suggest = {
            includeCompletionsForModuleExports = true,
            autoImports = true,
          },
          preferences = {
            importModuleSpecifier = 'non-relative',
          },
        },
      },
      capabilities = capabilities,
    })

    -- Lua Language Server
    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          completion = {
            callSnippet = 'Replace',
          },
        },
      },
      capabilities = capabilities,
    })

    -- {{{ Mason and Mason-LSPConfig Setup

    require('mason').setup()

    -- Define tools to be installed by mason-tool-installer
    local ensure_installed_tools = {
      'pyright',
      'clangd',
      'gopls',
      'ts_ls',
      'lua_ls',
      'stylua', -- Lua formatter
    }

    require('mason-tool-installer').setup {
      ensure_installed = ensure_installed_tools,
    }

    -- Configure Mason-LSPConfig with the new v2.0.0 API
    require('mason-lspconfig').setup {
      ensure_installed = { 'pyright', 'clangd', 'gopls', 'ts_ls', 'lua_ls' },
      automatic_enable = true, -- This replaces the old handlers system
    }

    -- }}}

    -- {{{ nvim-navic and nvim-navbuddy Setup

    -- Configure nvim-navic (breadcrumbs)
    require('nvim-navic').setup {
      highlight = true,
      lsp = {
        auto_attach = true,
        preference = nil,
      },
    }
    -- }}}
    -- }}}
  end,
}
