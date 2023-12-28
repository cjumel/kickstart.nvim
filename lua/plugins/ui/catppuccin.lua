-- Catppuccin
--
-- Catppuccin is a color scheme compatible with many tools, including neovim, and defining
-- different tones from light to dark.

return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000, -- Main UI stuff should be loaded first
  keys = {
    {
      "<leader>,t",
      function()
        local opts = require("catppuccin").options
        opts.transparent_background = not opts.transparent_background
        if vim.o.background == "dark" then
          opts.flavour = "mocha"
        else
          opts.flavour = "latte"
        end
        require("catppuccin").setup(opts)
        vim.cmd.colorscheme("catppuccin")
        -- For an unknown reason, this function changes the status line, so we need to reset it
        vim.o.laststatus = 3 -- Use a global status line & a thin line to separate splits
      end,
      desc = "Settings: toggle [T]ransparency",
    },
  },
  opts = {
    flavour = "mocha", -- latte, frappe, macchiato, mocha
    background = {
      light = "latte",
      dark = "mocha",
    },
    transparent_background = true,
    integrations = { -- add highlight groups for popular plugins
      harpoon = true,
      hop = true,
      mason = true,
      noice = true,
      notify = true,
      overseer = true,
      lsp_trouble = true,
      which_key = true,
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts) -- setup must be called before loading
    vim.cmd.colorscheme("catppuccin")

    -- Integration for nvim-dap
    local sign = vim.fn.sign_define
    sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
    sign(
      "DapBreakpointCondition",
      { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }
    )
    sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
  end,
}
