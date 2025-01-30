return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim', config = true },
    'williamboman/mason-lspconfig.nvim',
    'p00f/clangd_extensions.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} }, -- Useful status updates for LSP.
    { 'hrsh7th/nvim-cmp', dependencies = { 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path' } },
    'SmiteshP/nvim-navic',
    {
      'SmiteshP/nvim-navbuddy',
      dependencies = {
        'SmiteshP/nvim-navic',
        'MunifTanjim/nui.nvim',
      },
    },
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        --  To jump back, press <C-t>.
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        map('<C-k>', vim.lsp.buf.signature_help, 'Signature Help')

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentSymbolProvider then
          require('nvim-navic').attach(client, event.buf)
          print 'Navic attached! 🎯' -- Add this line
        end
        if client then
          print('LSP Client:', client.name)
          print('Has documentSymbolProvider:', client.server_capabilities.documentSymbolProvider)
        end
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, { -- highlight types whenever we move our cursor on it
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, { -- When you move your cursor, the highlights will be cleared
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })

          if client.server_capabilities.codeLensProvider then
            vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
              group = highlight_augroup,
              callback = vim.lsp.codelens.refresh,
            })
          end
        end

        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then -- INLAY HINTS
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- Change diagnostic symbols in the sign column (gutter)
    vim.opt.signcolumn = 'yes'
    if vim.g.have_nerd_font then
      local signs = { ERROR = '', WARN = '', INFO = '', HINT = '' }
      local diagnostic_signs = {}
      for type, icon in pairs(signs) do
        diagnostic_signs[vim.diagnostic.severity[type]] = icon
      end
      vim.diagnostic.config { signs = { text = diagnostic_signs } }
    end

    --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    local servers = {
      pyright = {
        settings = {
          python = {
            pythonPath = vim.fn.getcwd() .. '/.venv/bin/python', -- Path to your virtual environment's Python
            venvPath = vim.fn.getcwd() .. '/.venv', -- Path to your virtual environment
          },
        },
        on_init = function(client)
          print('Python path:', client.config.settings.python.pythonPath)
          print('Venv path:', client.config.settings.python.venvPath)
        end,
      },
      clangd = {
        cmd = {
          '/run/current-system/sw/bin/clangd',
          '--log=verbose',
          -- '--header-insertion=never', -- Stop it from getting too creative with includes
          '--completion-style=detailed',
        },
        root_dir = function()
          -- Tell clangd to look from the project root
          return vim.fn.getcwd()
        end,
      },
      gopls = {
        capabilities = capabilities, -- Make sure it gets all our fancy capabilities
        settings = {
          gopls = {
            usePlaceholders = true,
            analyses = {
              unusedparams = true,
            },
          },
        },
      },
      ts_ls = {
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = 'all', -- Shows parameter names as you type
              includeInlayParameterNameHintsWhenArgumentMatchesName = false, -- Show even when name matches
              includeInlayFunctionParameterTypeHints = true, -- Parameter type hints
              includeInlayVariableTypeHints = true, -- Variable type hints
              includeInlayPropertyDeclarationTypeHints = true, -- Property type hints
              includeInlayFunctionLikeReturnTypeHints = true, -- Return type hints
              includeInlayEnumMemberValueHints = true, -- Enum value hints
            },
            suggest = {
              includeCompletionsForModuleExports = true,
              autoImports = true, -- The secret sauce! 🤫
            },
            preferences = {
              importModuleSpecifier = 'non-relative',
            },
          },
        },
      },

      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
          },
        },
      },
    }

    require('mason').setup()
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua',
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      ensure_installed = {},
      automatic_installation = {
        exclude = { 'clangd' }, -- Tell Mason to leave clangd alone
      },
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }

    require('nvim-navic').setup {
      highlight = true,
      lsp = {
        auto_attach = true,
        preference = nil,
      },
    }
    require('nvim-navbuddy').setup {
      window = {
        border = 'rounded', -- Smooth edges, we're not barbarians!
        size = '60%', -- Let's make it visible enough
        position = '50%', -- Center it like a boss
      },
      lsp = {
        auto_attach = true, -- Let it automatically attach to LSP servers
      },
    }
  end,
}
