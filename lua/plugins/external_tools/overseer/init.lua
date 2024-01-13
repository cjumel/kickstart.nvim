-- overseer.nvim
--
-- A task runner and job management plugin for Neovim.

-- ISSUE: the shell template doesn't respect transparency, see
-- https://github.com/stevearc/overseer.nvim/issues/255

local commands = require("plugins.external_tools.overseer.commands")
local templates = require("plugins.external_tools.overseer.templates")

return {
  "stevearc/overseer.nvim",
  cmd = commands,
  keys = {
    {
      "<leader>oo",
      function()
        require("overseer").toggle()
      end,
      desc = "[O]verseer: Toggle",
    },
    {
      "<leader>os",
      function()
        require("overseer").run_template({ name = "shell" })
      end,
      desc = "[O]verseer: [S]hell",
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
    templates = { "shell" },
    task_list = {
      direction = "bottom",
      bindings = {
        -- Disable bindings conflicting with window navigation keymaps
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
          ["<Tab>"] = false,
          ["<S-Tab>"] = false,
          ["<C-n>"] = "Next",
          ["<C-p>"] = "Prev",
        },
        n = {
          ["<CR>"] = "Submit",
          ["<Tab>"] = false,
          ["<S-Tab>"] = false,
          ["q"] = "Cancel",
          ["<ESC>"] = "Cancel",
          ["?"] = "ShowHelp",
        },
      },
    },
  },
  config = function(_, opts)
    local overseer = require("overseer")

    overseer.setup(opts)

    for _, template in ipairs(templates) do
      overseer.register_template(template)

      vim.api.nvim_create_user_command(template._user_command, function()
        overseer.run_template({ name = template.name })
      end, { desc = template.desc or template.name })
    end
  end,
}
