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
    { "<leader><BS>", function() Snacks.bufdelete.delete() end, desc = "Delete buffer" },

    -- Gitbrowse
    { "<leader>gr", function() Snacks.gitbrowse.open() end, desc = "[G]it: open [R]epository" },

    -- Notifier
    { "<leader>n", function() Snacks.notifier.show_history() end, desc = "[N]otifications" },

    -- Picker
    { "<leader>l", function() Snacks.picker.lines() end, desc = "Search [L]ines" },

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
          icon = " ",
          key = "d",
          desc = "Find Directories",
          action = function() require("plugins.core.telescope.pickers").find_directories() end,
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

    notifier = { enabled = true },

    picker = {
      enabled = true,
      win = {
        input = {
          keys = {
            ["<Tab>"] = { "list_down", mode = { "n", "i" } },
            ["<S-Tab>"] = { "list_up", mode = { "n", "i" } },
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
              vim.ui.select(
                { "yes", "no" },
                { prompt = "Do you want to delete the scratch file definitely?" },
                function(item)
                  if item == "yes" then
                    local fname = vim.api.nvim_buf_get_name(self.buf)
                    vim.cmd([[close]]) -- Close the scratch buffer
                    vim.fn.delete(fname) -- Delete the scratch file
                  end
                end
              )
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
