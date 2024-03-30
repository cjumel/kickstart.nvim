-- overseer.nvim
--
-- A task runner and job management plugin for Neovim.

return {
  "stevearc/overseer.nvim",
  keys = {
    {
      "<leader>oo",
      function() require("overseer").toggle() end,
      desc = "[O]verseer: toggle",
    },
    {
      "<leader>or",
      function()
        require("overseer").run_template({
          prompt = "allow", -- Only ask for parameters when some are required
        })
      end,
      desc = "[O]verseer: [R]un",
    },
    {
      "<leader>op",
      function()
        require("overseer").run_template({
          prompt = "always", -- Always ask for parameters when some are available
        })
      end,
      desc = "[O]verseer: run with [P]arameter",
    },
    {
      "<leader>ol",
      function()
        local overseer = require("overseer")
        local tasks = overseer.list_tasks({ recent_first = true })
        if vim.tbl_isempty(tasks) then
          vim.notify("No tasks found", vim.log.levels.WARN)
        else
          overseer.run_action(tasks[1], "restart")
        end
      end,
      desc = "[O]verseer: run [L]ast task",
    },
  },
  opts = {
    form = {
      win_opts = {
        winblend = 0, -- Shell float window colors are messed up with transparency
      },
    },
    templates = { "shell" },
    task_list = {
      direction = "bottom",
      bindings = {
        -- Disable bindings conflicting with window navigation
        ["<C-h>"] = false,
        ["<C-j>"] = false,
        ["<C-k>"] = false,
        ["<C-l>"] = false,
      },
    },
    task_editor = {
      bindings = {
        i = {
          ["<CR>"] = "Submit",
          ["<C-j>"] = "Next",
          ["<C-k>"] = "Prev",
          -- Disable bindings conflicting with copilot
          ["<Tab>"] = false,
          ["<S-Tab>"] = false,
        },
        n = {
          ["<CR>"] = "Submit",
          ["<ESC>"] = "Cancel",
          ["?"] = "ShowHelp",
          -- Disable bindings conflicting with copilot
          ["<Tab>"] = false,
          ["<S-Tab>"] = false,
        },
      },
    },
  },
  config = function(_, opts)
    local overseer = require("overseer")

    overseer.setup(opts)

    local templates = require("plugins.tools.overseer.templates")
    for _, template in ipairs(templates) do
      overseer.register_template(template)
    end
  end,
}
