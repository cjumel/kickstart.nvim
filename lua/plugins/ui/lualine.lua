-- lualine.nvim
--
-- A blazing fast and customizable status bar plugin for Neovim written in Lua. lualine.nvim has integrations with many
-- popular plugins and can be further customized manually while remaining quite simple, making it a great choice for any
-- configuration.

local custom_lualine = require("custom.lualine")
local theme = require("theme")

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  priority = 100, -- Main UI stuff should be loaded first
  init = function()
    vim.opt.showmode = false -- Don't show mode in status line
  end,
  opts = vim.tbl_deep_extend("force", {
    options = {
      component_separators = "",
      section_separators = "",
      disabled_filetypes = { "snacks_dashboard" },
      globalstatus = true, -- Use a single global status line for all splits (precedes `vim.o.laststatus`)
    },
    sections = custom_lualine.preset_sections.default,
    extensions = custom_lualine.build_extensions(custom_lualine.preset_sections.default),
  }, theme.lualine_opts or {}),
  config = function(_, opts)
    require("lualine").setup(opts)

    if theme.lualine_callback then -- Additional theme options setting
      theme.lualine_callback()
    end
  end,
}
