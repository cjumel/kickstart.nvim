-- nvim-dap-ui
--
-- A UI for nvim-dap which provides a good out of the box configuration.

return {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
  },
  keys = {
    {
      "<leader>dd",
      function()
        require("dapui").toggle()
      end,
      ft = "python",
      desc = "[D]ebug: toggle [D]ebug UI",
    },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup({
      layouts = {
        {
          elements = {
            -- Vertical elements are displayed bottom to top
            {
              id = "scopes",
              size = 0.3,
            },
            {
              id = "watches",
              size = 0.3,
            },
            {
              id = "breakpoints",
              size = 0.3,
            },
            {
              id = "repl",
              size = 0.1,
            },
          },
          position = "right",
          size = 30,
        },
        {
          elements = {

            {
              id = "console",
              size = 1.0,
            },
          },
          position = "bottom",
          size = 10,
        },
      },
      mappings = {
        edit = "e",
        expand = { "<CR>", "<2-LeftMouse>", "<tab>" },
        open = "o",
        remove = "d",
        repl = "r",
        toggle = "t",
      },
    })

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
  end,
}
