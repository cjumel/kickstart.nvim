-- overseer.nvim
--
-- Overseer is a task runner and job management plugin for Neovim. It enables to run any kind of job (build, test,
-- formatting, etc.) very easily & taking into account the project context (e.g. only suggest a `make` job if there is
-- a `Makefile` & suggest the `make` commands based on it).

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
    dap = false, -- When true, this lazy-load nvim-dap but I don't use it with Overseer
    task_list = {
      direction = "bottom", -- Instead of on the left-hand-side
      min_height = 0.25,
      -- Disable bindings conflicting with window navigation
      bindings = { ["<C-h>"] = false, ["<C-j>"] = false, ["<C-k>"] = false, ["<C-l>"] = false },
    },
    task_editor = {
      bindings = {
        i = {
          ["<CR>"] = "Submit",
          ["<C-j>"] = "Next",
          ["<C-k>"] = "Prev",
          ["<C-c>"] = "Cancel",
          ["<Tab>"] = false, -- Disable to let Copilot work
        },
        n = {
          ["<CR>"] = "Submit",
          ["<C-i>"] = "Next",
          ["<C-o>"] = "Prev",
          ["<ESC>"] = "Cancel",
          ["?"] = "ShowHelp",
        },
      },
    },
    default_template_prompt = "always", -- Always ask for parameters if there are any
  },
  config = function(_, opts)
    local overseer = require("overseer")

    overseer.setup(opts)

    -- Register custom templates
    local templates = require("plugins.tools.overseer.templates")
    for _, template in ipairs(templates) do
      overseer.register_template(template)
    end
  end,
}
