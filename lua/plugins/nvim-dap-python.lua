-- nvim-dap-python
--
-- Python integration of nimv-dap. This plugins defines a few configurations and some functions
-- to make debugging Python code easier.

return {
  "mfussenegger/nvim-dap-python",
  lazy = true,
  init = function()
    local nmap = function(keys, func, desc)
      if desc then
        desc = "[D]ebug: [P]ython " .. desc
      end
      vim.keymap.set("n", keys, func, { desc = desc })
    end

    -- Run Python
    nmap("<leader>dpr", function()
      require("dap").run({
        type = "python",
        request = "launch",
        name = "Run file",
        program = "${file}",
        console = "integratedTerminal",
      })
    end, "[R]un")

    -- Test with Pytest
    nmap("<leader>dpt", function()
      require("dap-python").test_method({ test_runner = "pytest" })
    end, "[T]est method")
    nmap("<leader>dpT", function()
      require("dap").run({
        type = "python",
        request = "launch",
        name = "Test file",
        module = "pytest",
        args = { "${file}" },
        console = "integratedTerminal",
      })
    end, "[T]est file")
  end,
  config = function()
    require("dap-python").setup(
      "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python",
      { include_configs = false, console = "integratedTerminal" }
    )
  end,
}
