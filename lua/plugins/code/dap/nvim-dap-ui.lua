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
      desc = "[D]ebug: toggle UI",
      ft = "python",
    },
    {
      "<leader>dr",
      function()
        require("dapui").open({ reset = true })
      end,
      desc = "[D]ebug: [R]eset UI",
      ft = "python",
    },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup({
      layouts = {
        -- Vertical section
        -- Let's only remove the "stacks" element, add the repl at the bottom (elements are
        -- displayed bottom to top), and move the section on the right
        {
          elements = {
            {
              id = "repl",
              size = 0.25,
            },
            {
              id = "scopes",
              size = 0.25,
            },
            {
              id = "breakpoints",
              size = 0.25,
            },
            {
              id = "watches",
              size = 0.25,
            },
          },
          position = "right",
          size = 40,
        },
        -- Horizontal section
        -- Let's remove the repl to make more room for the console
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
