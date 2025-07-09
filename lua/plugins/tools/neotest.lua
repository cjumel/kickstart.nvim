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
      "<leader>xr",
      function() require("neotest").run.run({ strategy = vim.g.neotest_dap and "dap" or nil }) end,
      desc = "Test: [R]un test",
    },
    {
      "<leader>xf",
      function() require("neotest").run.run({ vim.fn.expand("%"), strategy = vim.g.neotest_dap and "dap" or nil }) end,
      desc = "Test: run [F]ile test",
    },
    {
      "<leader>xa",
      function() require("neotest").run.run({ suite = true, strategy = vim.g.neotest_dap and "dap" or nil }) end,
      desc = "Test: run [A]ll tests",
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
    {
      "<leader>xd",
      function()
        if not vim.g.neotest_dap then
          require("nvim-dap") -- Lazy-load nvim-dap if needed
          vim.g.neotest_dap = true
          vim.notify("Neotest DAP enabled", vim.log.levels.INFO, { title = "Neotest" })
        else
          vim.g.neotest_dap = false
          vim.notify("Neotest DAP disabled", vim.log.levels.INFO, { title = "Neotest" })
        end
      end,
      desc = "Test: toggle [D]AP",
    },
  },
  opts = function()
    return {
      adapters = {
        require("neotest-python"),
      },
    }
  end,
  config = function(_, opts)
    require("neotest").setup(opts)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("NeotestKeymaps", { clear = true }),
      pattern = { "neotest-output-panel", "neotest-summary" },
      callback = function() vim.keymap.set("n", "q", "<cmd>:q<CR>", { desc = "Close", buffer = true }) end,
    })
  end,
}
