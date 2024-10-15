-- lualine.nvim
--
-- A blazing fast and customizable status bar plugin for Neovim written in Lua. lualine.nvim has integrations with many
-- popular plugins and can be further customized manually while remaining quite simple, making it a great choice for any
-- configuration.

local lualine_extensions = require("plugins.ui.lualine.extensions")
local lualine_sections = require("plugins.ui.lualine.sections")
local theme = require("theme")

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  priority = 100, -- Main UI stuff should be loaded first
  init = function()
    -- Don't show Neovim mode in status line as it is redundant with Lualine's onw feature
    --  This can be re-enabled in the `config` for status lines missing the corresponding feature, with the custom
    --  parameter `_keep_showmode`
    vim.opt.showmode = false
  end,
  opts = theme.make_opts("lualine", {
    options = {
      icons_enabled = true,
      theme = "auto",
      component_separators = "",
      section_separators = "",
      globalstatus = true, -- Use a single global status line for all splits (precedes `vim.o.laststatus`)
      refresh = { statusline = 50 }, -- Decrease refresh rate to make modules more responsive (e.g. Harpoon's)
    },
    sections = lualine_sections.default,
    extensions = lualine_extensions.build_extensions(lualine_sections.default),
  }),
  config = function(_, opts)
    require("lualine").setup(opts)

    if opts._keep_showmode then
      vim.opt.showmode = true -- Show Neovim status in status line
    end
  end,
}
