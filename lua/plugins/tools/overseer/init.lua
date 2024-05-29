-- overseer.nvim
--
-- A task runner and job management plugin for Neovim.

return {
  "stevearc/overseer.nvim",
  keys = function()
    local overseer = require("overseer")
    return {
      { "<leader>oo", function() overseer.toggle() end, desc = "[O]verseer: toggle" },
      { "<leader>or", function() overseer.run_template({}, overseer.open) end, desc = "[O]verseer: [R]un" },
      { "<leader>ob", function() overseer.run_template({}) end, desc = "[O]verseer: [B]ackground run" },
      { "<leader>os", function() overseer.run_template({ name = "shell" }) end, desc = "[O]verseer: [S]hell" },
      {
        "<leader>ol",
        function()
          local tasks = overseer.list_tasks({ recent_first = true })
          if vim.tbl_isempty(tasks) then
            vim.notify("No tasks found", vim.log.levels.WARN)
          else
            overseer.run_action(tasks[1], "restart")
          end
        end,
        desc = "[O]verseer: rerun [L]ast task",
      },
    }
  end,
  opts = {
    form = {
      win_opts = {
        winblend = 0, -- Shell float window colors are messed up with transparency
      },
    },
    templates = { "shell" },
    task_list = {
      min_height = 0.25,
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
    default_template_prompt = "always", -- Always ask for parameters there are any
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
