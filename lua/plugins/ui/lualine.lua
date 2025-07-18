-- lualine.nvim
--
-- A blazing fast and easy to configure neovim statusline plugin written in pure lua.

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  priority = 100, -- Main UI stuff should be loaded first
  opts = function()
    local lualine_config = require("config.lualine")
    local opts = vim.tbl_deep_extend("force", {
      options = {
        component_separators = "",
        section_separators = "",
        globalstatus = true, -- Better single global status line for all splits
      },
      sections = lualine_config.preset_sections.default,
      tabline = { lualine_y = { "tabs" } },
    }, Theme.lualine_opts or {})
    opts.extensions = lualine_config.build_extensions(opts.sections)
    return opts
  end,
  config = function(_, opts)
    require("lualine").setup(opts)
    if Theme.lualine_callback then -- Additional theme options setting
      Theme.lualine_callback()
    end
  end,
}
