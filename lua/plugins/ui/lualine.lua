-- lualine.nvim
--
-- A blazing fast and customizable status bar plugin for Neovim written in Lua. lualine.nvim has integrations with many
-- popular plugins and can be further customized manually while remaining quite simple, making it a great choice for any
-- configuration.

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  priority = 100, -- Main UI stuff should be loaded first
  init = function()
    vim.opt.showmode = false -- Don't show mode in status line
  end,
  opts = function()
    local lualine_extensions = require("plugins.ui.lualine.extensions")
    local lualine_sections = require("plugins.ui.lualine.sections")

    return vim.tbl_deep_extend("force", {
      options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = "",
        section_separators = "",
        globalstatus = true, -- Use a single global status line for all splits (precedes `vim.o.laststatus`)
      },
      sections = lualine_sections.default,
      extensions = lualine_extensions.build_extensions(lualine_sections.default),
    }, require("theme").lualine_opts or {})
  end,
  config = function(_, opts)
    require("lualine").setup(opts)

    if require("theme").lualine_post_setup then
      require("theme").lualine_post_setup()
    end
  end,
}
