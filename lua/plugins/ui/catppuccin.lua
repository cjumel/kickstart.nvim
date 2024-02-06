-- Catppuccin
--
-- Catppuccin is a color scheme compatible with many tools, including neovim, and defining
-- different tones from light to dark.

return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000, -- Main UI stuff should be loaded first
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
