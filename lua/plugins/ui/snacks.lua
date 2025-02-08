-- snacks.nvim
--
-- Meta plugin providing a collection of small quality-of-life plugins for Neovim. All these plugigns work very nicely
-- out-of-the-box, with great default behaviors, and bring many UI improvements as well as new cool atomic features.

return {
  "folke/snacks.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  priority = 500, -- Main UI stuff should be loaded first (but after the colorscheme)
  keys = {
    -- Bufdelete
    { "<leader><BS>", function() Snacks.bufdelete.delete() end, desc = "Delete current buffer" },
    { "<leader><S-BS>", function() Snacks.bufdelete.all() end, desc = "Delete all buffers" },
    { "<leader><M-BS>", function() Snacks.bufdelete.other() end, desc = "Delete other buffers" },

    -- Gitbrowse
    { "<leader>gr", function() Snacks.gitbrowse.open() end, desc = "[G]it: open [R]epository" },

    -- Notifier
    { "<leader>n", function() Snacks.notifier.show_history() end, desc = "[N]otifications" },

    -- Picker
    {
      "<leader>u",
      function()
        Snacks.picker.undo({
          win = {
            input = {
              keys = {
                -- Customize keymaps and add "close" action
                ["<C-y>"] = { { "yank_add", "close" }, mode = "i" }, -- Same keymap as default
                ["Ú"] = { { "yank_del", "close" }, mode = "i" }, -- <M-y> instead of <C-M-y> I can't use
              },
            },
          },
          actions = {
            -- Yank in main register
            yank_add = { action = "yank", field = "added_lines", reg = '"' },
            yank_del = { action = "yank", field = "removed_lines", reg = '"' },
          },
        })
      end,
      desc = "[U]ndo tree",
    },

    -- Scratch buffers
    {
      "<leader>;",
      function() Snacks.scratch.open({ name = "Note", ft = "markdown" }) end,
      desc = "Scratch note",
    },
    { "<leader>.", function() Snacks.scratch.open() end, desc = "Scratch file" },
    { "<leader>=", function() Snacks.scratch.select() end, desc = "Select scratch" },

    -- Zen mode
    { "<leader>z", function() Snacks.zen() end, desc = "[Z]en mode" },
  },
  opts = {
    bigfile = { enabled = true },

    dashboard = {
      enabled = true,
      sections = {
        { section = "header" },
        { icon = " ", key = "c", desc = "Open current directory", action = function() require("oil").open() end },
        {
          icon = " ",
          key = "f",
          desc = "Find Files",
          action = function() require("plugins.core.telescope.pickers").find_files() end,
        },
        {
          icon = " ",
          key = "r",
          desc = "Find Recent files",
          action = function() require("plugins.core.telescope.pickers").recent_files() end,
        },
        {
          icon = " ",
          key = "o",
          desc = "Find Old files",
          action = function() require("plugins.core.telescope.pickers").old_files() end,
        },
        {
          icon = " ",
          key = "d",
          desc = "Find Directories",
          action = function() require("plugins.core.telescope.pickers").find_directories() end,
        },
        {
          icon = "󰚰 ",
          key = "g",
          desc = "View Git Status",
          action = function() require("plugins.core.telescope.pickers").git_status() end,
        },
        {
          icon = " ",
          key = "b",
          desc = "View Git Branch",
          action = function() require("plugins.core.telescope.pickers").git_branches() end,
        },
        {
          icon = " ",
          key = "l",
          desc = "View Git Log",
          action = function() require("plugins.core.telescope.pickers").git_commits() end,
        },
        { icon = "󰊢 ", key = "n", desc = "Open Neogit", action = function() require("neogit").open() end },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
    },

    input = {
      enabled = true,
      win = {
        keys = {
          i_ctrl_n = { "<C-n>", "hist_down", mode = "i" },
          i_ctrl_p = { "<C-p>", "hist_up", mode = "i" },
          i_meta_bs = { "<M-BS>", "<c-s-w>", mode = "i", expr = true },
          i_esc = { "<Esc>", "cancel", mode = "i" },
          i_ctrl_c = { "<C-C>", "cancel", mode = "i" },
        },
      },
    },

    notifier = { enabled = true },

    picker = {
      enabled = true, -- Use Snacks picker for vim.ui.select
      win = {
        input = {
          keys = {
            ["<Tab>"] = { "list_down", mode = "i" },
            ["<S-Tab>"] = { "list_up", mode = "i" },
            ["<M-BS>"] = { "<c-s-w>", mode = "i", expr = true },
            ["<Esc>"] = { "cancel", mode = "i" },
            ["<C-a>"] = false, -- Prefer insert-mode keymap
            ["<C-e>"] = false, -- Prefer insert-mode keymap
            ["<C-b>"] = false, -- Prefer insert-mode keymap
            ["<C-f>"] = false, -- Prefer insert-mode keymap
            ["<C-u>"] = false, -- Prefer insert-mode keymap
          },
        },
      },
    },

    quickfile = { enabled = true },

    scratch = {
      autowrite = false, -- Prevent untimely scratch file creation
      win = {
        keys = {
          ["delete"] = {
            "<C-q>",
            function(self)
              if vim.fn.confirm("Do you want to delete the scratch file definitely?", "&Yes\n&No") == 1 then
                local fname = vim.api.nvim_buf_get_name(self.buf)
                vim.cmd([[close]]) -- Close the scratch buffer
                vim.fn.delete(fname) -- Delete the scratch file
              end
            end,
            desc = "delete",
          },
        },
      },
      win_by_ft = {
        lua = {
          keys = {
            ["source"] = {
              "<C-CR>",
              function(self)
                local command = "luajit"
                local fname = vim.api.nvim_buf_get_name(self.buf)
                local res = vim.system({ command, fname }, { text = true }):wait()
                if res.code ~= 0 then
                  Snacks.notify.error(res.stderr or "Unknown error.")
                else
                  Snacks.notify(res.stdout)
                end
              end,
              desc = "source",
            },
          },
        },
        python = {
          keys = {
            ["source"] = {
              "<C-CR>",
              function(self)
                local command = "python"
                local fname = vim.api.nvim_buf_get_name(self.buf)
                local res = vim.system({ command, fname }, { text = true }):wait()
                if res.code ~= 0 then
                  Snacks.notify.error(res.stderr or "Unknown error.")
                else
                  Snacks.notify(res.stdout)
                end
              end,
              desc = "source",
            },
          },
        },
      },
    },

    scroll = { enabled = true },

    words = { enabled = true },

    zen = {
      toggles = { dim = false },
      win = { width = 125 }, -- Support line-length up until 120
    },

    styles = {
      notification = { wo = { wrap = true } }, -- Don't truncate notifications
      notification_history = { wo = { number = false, relativenumber = false } },
      zen = { wo = { number = false, relativenumber = false, signcolumn = "yes" } },
    },
  },
}
