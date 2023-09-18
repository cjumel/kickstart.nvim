-- nvim-dap
--
-- Neovim implemetation of the Debug Adapter Protocol (DAP).

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "mfussenegger/nvim-dap-python",
  },
  lazy = true,
  init = function()
    local nmap = function(keys, func, desc)
      if desc then
        desc = "[D]ebug: " .. desc
      end
      vim.keymap.set("n", keys, func, { desc = desc })
    end

    -- Debugging setup
    nmap("<leader>dr", function()
      require("dap").run_last()
    end, "[R]erun")
    nmap("<leader>db", function()
      require("dap").toggle_breakpoint()
    end, "[B]reakpoint")
    nmap("<leader>dc", function()
      require("dap").continue()
    end, "[C]ontinue")

    -- State inspection
    nmap("<leader>dK", function()
      require("dap.ui.widgets").hover()
    end, "[K] hover")
    nmap("<leader>do", function()
      require("dap").repl.open()
    end, "[O]pen console")
  end,
}
