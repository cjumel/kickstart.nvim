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
      desc = "[D]ebug: toggle UI",
    },
    {
      "<leader>dr",
      function()
        require("dapui").open({ reset = true })
      end,
      ft = "python",
      desc = "[D]ebug: [R]eset UI",
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
              size = 0.25,
            },
            {
              id = "watches",
              size = 0.25,
            },
            {
              id = "breakpoints",
              size = 0.25,
            },
            {
              id = "repl",
              size = 0.25,
            },
          },
          position = "left",
          size = 40,
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
