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
      "<leader>tt",
      function() require("neotest").summary.toggle() end,
      desc = "[T]est: toggle summary",
    },
    {
      "<leader>tp",
      function() require("neotest").output.open({ enter = true }) end,
      desc = "[T]est: [P]review output",
    },
    {
      "<leader>tr",
      function() require("neotest").run.run() end,
      desc = "[T]est: [R]un",
    },
    {
      "<leader>tR",
      function()
        vim.ui.input({ promp = "Additional arguments" }, function(input)
          if input == nil then
            return
          end
          require("neotest").run.run({ extra_args = input ~= "" and vim.split(input, " ") or nil })
        end)
      end,
      desc = "[T]est: [R]un with parameters",
    },
    {
      "<leader>tf",
      function() require("neotest").run.run({ vim.fn.expand("%") }) end,
      desc = "[T]est: run [F]ile",
    },
    {
      "<leader>tF",
      function()
        vim.ui.input({ promp = "Additional arguments" }, function(input)
          if input == nil then
            return
          end
          require("neotest").run.run({
            vim.fn.expand("%"),
            extra_args = input ~= "" and vim.split(input, " ") or nil,
          })
        end)
      end,
      desc = "[T]est: run [F]ile with parameters",
    },
    {
      "<leader>ta",
      function()
        local opts
        if vim.bo.filetype == "oil" then
          opts = { require("oil").get_current_dir() }
        else
          opts = { suite = true }
        end
        require("neotest").run.run(opts)
      end,
      desc = "[T]est: run [A]ll",
    },
    {
      "<leader>tA",
      function()
        vim.ui.input({ promp = "Additional arguments" }, function(input)
          if input == nil then
            return
          end
          local opts
          if vim.bo.filetype == "oil" then
            opts = { require("oil").get_current_dir() }
          else
            opts = { suite = true }
          end
          opts.extra_args = input ~= "" and vim.split(input, " ") or nil
          require("neotest").run.run(opts)
        end)
      end,
      desc = "[T]est: run [A]ll with parameters",
    },
    {
      "<leader>tl",
      function() require("neotest").run.run_last() end,
      desc = "[T]est: run [L]ast",
    },
  },
  opts = function()
    return {
      adapters = {
        require("neotest-python"),
      },
      consumers = {
        notify = function(client)
          client.listeners.run = function()
            vim.notify("Running tests...", vim.log.levels.INFO, { title = "Neotest", icon = "" })
          end
          client.listeners.results = function(_, results, partial)
            if partial then
              return
            end
            local passed, failed, skipped = 0, 0, 0
            for _, r in pairs(results) do
              if r.status == "passed" then
                passed = passed + 1
              elseif r.status == "failed" then
                failed = failed + 1
              elseif r.status == "skipped" then
                skipped = skipped + 1
              else
                error("Unknown test status: " .. r.status)
              end
            end
            local message, level
            if passed > 0 or failed > 0 then
              level = failed == 0 and vim.log.levels.INFO or vim.log.levels.ERROR
              local status = failed == 0 and "SUCCESS" or "FAILURE"
              message = string.format("%s: %d/%d tests passed", status, passed, passed + failed)
              if skipped > 0 then
                message = message .. string.format(", %d skipped", skipped)
              end
            else
              level = vim.log.levels.INFO
              message = "No tests found"
              if skipped > 0 then
                message = message .. string.format(" (%d tests skipped)", skipped)
              end
            end
            vim.notify(message, level, { title = "Neotest", icon = "" })
          end
        end,
      },
      output = {
        open_on_run = false, -- When enabled, the output window is open without being focused making it kind of useless
      },
      summary = {
        open = "botright vsplit | vertical resize 30",
      },
    }
  end,
}
