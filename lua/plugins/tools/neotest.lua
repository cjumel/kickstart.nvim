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
    return {
      adapters = { require("neotest-python") },
      consumers = {
        notify = function(client)
          client.listeners.results = function(_, results, partial)
            if partial then
              return
            end
            local total = 0
            local passed = 0
            for _, r in pairs(results) do
              total = total + 1
              if r.status == "passed" then
                passed = passed + 1
              end
            end
            if passed == total then
              vim.notify(
                "SUCCESS: " .. passed .. "/" .. total .. " tests passed.",
                vim.log.levels.INFO,
                { title = "Neotest" }
              )
            else
              vim.notify(
                "FAILURE: " .. passed .. "/" .. total .. " tests passed.",
                vim.log.levels.ERROR,
                { title = "Neotest" }
              )
            end
          end
        end,
        last_task_status = function(client)
          client.listeners.starting = function()
            vim.g.last_task_status = "in progress"
            require("lualine").refresh({ place = { "statusline" } })
          end
          client.listeners.results = function(_, results, partial)
            if partial then
              return
            end
            local total = 0
            local passed = 0
            for _, r in pairs(results) do
              total = total + 1
              if r.status == "passed" then
                passed = passed + 1
              end
            end
            if passed == total then
              vim.g.last_task_status = "success"
            else
              vim.g.kast_task_status = "error"
            end
            require("lualine").refresh({ place = { "statusline" } })
          end
        end,
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
