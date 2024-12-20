-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    filesystem = {
      follow_current_file = {
        enabled = true, -- This will make Neotree follow the current file
        leave_dirs_open = true, -- This will leave parent folders open when following
      },
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
    git_status = {
      symbols = {
        -- Change them to your preferred symbols
        added     = "✚",
        modified  = "",
        deleted   = "✖",
        renamed   = "󰁕",
        untracked = "",
        ignored   = "",
        unstaged  = "󰄱",
        staged    = "",
        conflict  = "",
      },
      window = {
        position = "float",
        mappings = {
          ["A"]  = "git_add_all",
          ["gu"] = "git_unstage_file",
          ["ga"] = "git_add_file",
          ["gr"] = "git_revert_file",
          ["gc"] = "git_commit",
          ["gp"] = "git_push",
          ["gg"] = "git_commit_and_push",
        }
      }
    },
    event_handlers = {
      {
        event = "file_opened",
        handler = function(file_path)
          -- auto close
          require("neo-tree").close_all()
        end
      },
    },
    source_selector = {
      winbar = true,
      statusline = false,
      content_layout = "center",
      sources = {
        { source = "filesystem", display_name = " File" },
        { source = "git_status", display_name = " Git" },
        { source = "buffers", display_name = "󰈙 Buffers" },
      },
    },
  },
}
