-- Neotest
--
-- An extensible framework for interacting with tests within NeoVim.

return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python",
  },
  keys = {
    {
      "<leader>xx",
      function() require("neotest").summary.toggle() end,
      desc = "Test: toggle summary",
    },
    {
      "<leader>xo",
      function() require("neotest").output_panel.toggle() end,
      desc = "Test: toggle [O]utput panel",
    },
    {
      "<leader>xt",
      function()
        local opts = {}
        if vim.bo.filetype == "oil" then
          table.insert(opts, require("oil").get_current_dir())
        end
        require("neotest").run.run(opts)
      end,
      desc = "Test: [T]est",
    },
    {
      "<leader>xf",
      function() require("neotest").run.run({ vim.fn.expand("%") }) end,
      desc = "Test: test [F]ile",
    },
    {
      "<leader>xa",
      function() require("neotest").run.run({ suite = true }) end,
      desc = "Test: test [A]ll",
    },
    {
      "<leader>xl",
      function() require("neotest").run.run_last() end,
      desc = "Test: rerun [L]ast test",
    },
    {
      "<leader>xs",
      function() require("neotest").run.stop() end,
      desc = "Test: [S]top test",
    },
  },
  opts = function()
    local neotest_config = require("config.neotest")
    local neotest_python = require("neotest-python")
    return {
      adapters = { neotest_python },
      consumers = {
        notify = neotest_config.custom_consumers.notify,
        last_task_status = neotest_config.custom_consumers.last_task_status,
      },
    }
  end,
  config = function(_, opts)
    require("neotest").setup(opts)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("NeotestKeymaps", { clear = true }),
      pattern = { "neotest-output-panel", "neotest-summary" },
      callback = function()
        vim.keymap.set("n", "q", "<cmd>:q<CR>", { desc = "Close", buffer = true })
        vim.opt_local.wrap = false
      end,
    })
  end,
}
