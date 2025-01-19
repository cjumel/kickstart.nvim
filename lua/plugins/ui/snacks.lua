-- snacks.nvim
--
-- Meta plugin providing a collection of small quality-of-life plugins for Neovim. All these plugigns work very nicely
-- out-of-the-box, with great default behaviors, and bring many UI improvements as well as new cool atomic features.

local custom_telescope_builtin = require("custom.telescope.builtin")

return {
  "folke/snacks.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  priority = 500, -- Main UI stuff should be loaded first (but after the colorscheme)
  lazy = false,
  keys = {
    { "<leader>n", function() require("snacks").notifier.show_history() end, desc = "[N]otifications" },
    { "<leader>z", function() require("snacks").zen() end, desc = "[Z]en mode" },
    { "<leader><BS>", function() require("snacks").bufdelete() end, desc = "Delete buffer" },
    { "<leader>gr", function() require("snacks").gitbrowse() end, desc = "[G]it: open [R]epository" },
    {
      "<leader>;",
      function() require("snacks").scratch.open({ name = "Note", ft = "markdown" }) end,
      desc = "Scratch note",
    },
    { "<leader>.", function() require("snacks").scratch.open() end, desc = "Scratch file" },
    { "<leader>=", function() require("snacks").scratch.select() end, desc = "Select scratch" },
  },
  opts = {
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      sections = {
        { section = "header" },
        { icon = " ", key = "c", desc = "Current directory", action = function() require("oil").open() end },
        { icon = "󰊢 ", key = "n", desc = "Neogit", action = function() require("neogit").open() end },
        { icon = "󰚰 ", key = "g", desc = "Find Git Status Files", action = custom_telescope_builtin.git_status },
        { icon = " ", key = "f", desc = "Find Files", action = custom_telescope_builtin.find_files },
        { icon = " ", key = "d", desc = "Find Directories", action = custom_telescope_builtin.find_directories },
        { icon = " ", key = "r", desc = "Find Recent files", action = custom_telescope_builtin.recent_files },
        { icon = " ", key = "o", desc = "Find Old files", action = custom_telescope_builtin.old_files },
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
              "<M-CR>",
              function(self)
                local command = "luajit"
                local fname = vim.api.nvim_buf_get_name(self.buf)
                local res = vim.system({ command, fname }, { text = true }):wait()
                if res.code ~= 0 then
                  require("snacks").notify.error(res.stderr or "Unknown error.")
                else
                  require("snacks").notify(res.stdout)
                end
              end,
              desc = "source",
            },
          },
        },
        python = {
          keys = {
            ["source"] = {
              "<M-CR>",
              function(self)
                local command = "python"
                local fname = vim.api.nvim_buf_get_name(self.buf)
                local res = vim.system({ command, fname }, { text = true }):wait()
                if res.code ~= 0 then
                  require("snacks").notify.error(res.stderr or "Unknown error.")
                else
                  require("snacks").notify(res.stdout)
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
