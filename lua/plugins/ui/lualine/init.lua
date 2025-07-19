-- lualine.nvim
--
-- A blazing fast and easy to configure neovim statusline plugin written in pure lua.

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  priority = 100, -- Main UI stuff should be loaded first
  opts = function()
    local extension_utils = require("plugins.ui.lualine.extension_utils")
    local preset_sections = require("plugins.ui.lualine.preset_sections")
    local opts = vim.tbl_deep_extend("force", {
      options = {
        component_separators = "",
        section_separators = "",
        globalstatus = true, -- Better single global status line for all splits
      },
      sections = preset_sections.default,
      tabline = { lualine_y = { "tabs" } },
    }, ThemeConfig.lualine_opts or {})
    opts.extensions = extension_utils.build_extensions(opts.sections)
    return opts
  end,
  config = function(_, opts)
    require("lualine").setup(opts)
    if ThemeConfig.lualine_callback then -- Additional theme options setting
      ThemeConfig.lualine_callback()
    end
  end,
}
