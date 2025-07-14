return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        panel = {
          enabled = true,
          auto_refresh = true,
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          accept = false, -- disable built-in keymapping
        },
      }

      -- Custom keybinding to accept suggestions
      vim.keymap.set('i', '<C-j>', function()
        if require('copilot.suggestion').is_visible() then
          require('copilot.suggestion').accept()
        end
      end, { silent = true })
    end,
  },
}
