return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python",
  },
  keys = function()
    ---@return string[]|nil
    local function get_args()
      local args_string = vim.fn.input("Arguments")
      return args_string ~= "" and vim.split(args_string, " +") or nil
    end
    return {
      { "<leader>tt", function() require("neotest").summary.toggle() end, desc = "[T]est: toggle summary window" },
      { "<leader>tp", function() require("neotest").output.open() end, desc = "[T]est: [P]review output" },
      {
        "<leader>tr",
        function() require("neotest").run.run({ vim.bo.filetype == "oil" and require("oil").get_current_dir() or nil }) end,
        desc = "[T]est: [R]un",
      },
      {
        "<leader>tR",
        function()
          require("neotest").run.run({
            vim.bo.filetype == "oil" and require("oil").get_current_dir() or nil,
            extra_args = get_args(),
          })
        end,
        desc = "[T]est: [R]un with arguments",
      },
      { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "[T]est: [D]ebug" },
      {
        "<leader>tD",
        function() require("neotest").run.run({ strategy = "dap", extra_args = get_args() }) end,
        desc = "[T]est: [D]ebug with arguments",
      },
      { "<leader>tf", function() require("neotest").run.run({ vim.fn.expand("%") }) end, desc = "[T]est: run [F]ile" },
      {
        "<leader>tF",
        function() require("neotest").run.run({ vim.fn.expand("%"), extra_args = get_args() }) end,
        desc = "[T]est: run [F]ile with arguments",
      },
      { "<leader>ta", function() require("neotest").run.run({ suite = true }) end, desc = "[T]est: run [A]ll" },
      {
        "<leader>tA",
        function() require("neotest").run.run({ suite = true, extra_args = get_args() }) end,
        desc = "[T]est: run [A]ll with arguments",
      },
      { "<leader>tl", function() require("neotest").run.run_last() end, desc = "[T]est: run [L]ast" },
    }
  end,
  opts = function()
    return {
      adapters = { require("neotest-python") },
      consumers = {
        notify = function(client)
          client.listeners.run = function()
            vim.notify("Starting tests", vim.log.levels.INFO, { title = "Neotest", icon = "" })
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
      summary = {
        mappings = { expand = "<Tab>", jumpto = "<CR>", output = "p" },
        open = "botright vsplit | vertical resize 30",
      },
    }
  end,
}
