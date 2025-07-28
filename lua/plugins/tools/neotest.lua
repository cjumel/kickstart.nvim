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
      "<leader>xs",
      function() require("neotest").summary.toggle() end,
      desc = "Test: toggle [S]ummary",
    },
    {
      "<leader>xo",
      function()
        require("neotest").output.open({
          enter = true,
          open_win = function() vim.cmd("split | resize 15") end,
        })
      end,
      desc = "Test: open [O]utput",
    },
    {
      "<leader>xt",
      function()
        vim.ui.input({ promp = "Additional arguments" }, function(input)
          if input == nil then
            return
          end
          local opts = {}
          if vim.bo.filetype == "oil" then
            table.insert(opts, require("oil").get_current_dir())
          end
          if input ~= "" then
            opts.extra_args = vim.split(input, " ")
          end
          require("neotest").run.run(opts)
        end)
      end,
      desc = "Test: [T]est",
    },
    {
      "<leader>xf",
      function()
        vim.ui.input({ promp = "Additional arguments" }, function(input)
          if input == nil then
            return
          end
          local opts = { vim.fn.expand("%") }
          if input ~= "" then
            opts.extra_args = vim.split(input, " ")
          end
          require("neotest").run.run(opts)
        end)
      end,
      desc = "Test: test [F]ile",
    },
    {
      "<leader>xa",
      function()
        vim.ui.input({ promp = "Additional arguments" }, function(input)
          if input == nil then
            return
          end
          local opts = { suite = true }
          if input ~= "" then
            opts.extra_args = vim.split(input, " ")
          end
          require("neotest").run.run(opts)
        end)
      end,
      desc = "Test: test [A]ll",
    },
    {
      "<leader>xl",
      function() require("neotest").run.run_last() end,
      desc = "Test: rerun [L]ast test",
    },
  },
  opts = function()
    return {
      adapters = {
        require("neotest-python"),
      },
      consumers = {
        notify_and_update_last_task_status = function(client)
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
              vim.notify(
                "SUCCESS: " .. passed .. "/" .. total .. " tests passed.",
                vim.log.levels.INFO,
                { title = "Neotest" }
              )
            else
              vim.g.last_task_status = "failure"
              vim.notify(
                "FAILURE: " .. passed .. "/" .. total .. " tests passed.",
                vim.log.levels.ERROR,
                { title = "Neotest" }
              )
            end
            require("lualine").refresh({ place = { "statusline" } })
          end
        end,
      },
      summary = {
        open = "botright vsplit | vertical resize 30",
      },
    }
  end,
}
