-- lualine.nvim
--
-- A blazing fast and customizable status bar written in Lua.

local extensions = require("plugins.ui.lualine.extensions")
local sections = require("plugins.ui.lualine.sections")
local theme = require("theme")

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  priority = 100, -- Main UI stuff should be loaded first
  init = function()
    -- Don't show Neovim mode in status line as it is redundant with Lualine's onw feature
    -- This can be re-enabled in the `config` for status lines missing the corresponding feature, with the custom
    -- parameter `_keep_showmode`
    vim.opt.showmode = false
  end,
  opts = theme.make_opts("lualine", {
    options = {
      icons_enabled = true,
      theme = "auto",
      component_separators = "",
      section_separators = "",
      globalstatus = true, -- Use a single global status line for all splits (precedes `vim.o.laststatus`)
    },
    sections = sections.default,
    extensions = extensions.build_extensions(sections.default),
  }),
  config = function(_, opts)
    local lualine = require("lualine")

    lualine.setup(opts)

    if opts._keep_showmode then
      vim.opt.showmode = true -- Show Neovim status in status line
    end
  end,
}
