-- overseer.nvim
--
-- A task runner and job management plugin for Neovim.

local commands = require("plugins.tools.overseer.commands")
local templates = require("plugins.tools.overseer.templates")

return {
  "stevearc/overseer.nvim",
  cmd = commands,
  keys = {
    {
      "<leader>or",
      function()
        require("overseer").run_template()
      end,
      desc = "[O]verseer: [R]un",
    },
    {
      "<leader>os",
      function()
        require("overseer").run_template({ name = "shell" })
      end,
      desc = "[O]verseer: [S]hell",
    },
    {
      "<leader>oo",
      function()
        require("overseer").toggle()
      end,
      desc = "[O]verseer: toggle",
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

      vim.api.nvim_create_user_command(template._user_command, function(args)
        overseer.run_template({
          name = template.name,
          -- Pass the optional command arguments contained in `args.args` to the builder function
          -- as `params.args`. The arguments are passed as a string, which can be empty or contain
          -- white spaces to separate different arguments or trailing white spaces.
          params = { args = args.args },
        })
      end, {
        desc = template.desc or template.name,
        -- Specify the number of arguments the command accepts. The default is 0.
        -- See `:h command-nargs` for more information.
        nargs = template._user_command_nargs,
      })
    end
  end,
}
