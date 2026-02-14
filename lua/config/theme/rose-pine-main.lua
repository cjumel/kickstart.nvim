---@type ThemeConfig
local default_theme_config = require("config.theme.default")

---@type ThemeConfig
return {
  background = "dark",
  colorscheme_name = "rose-pine",
  colorscheme_opts = { variant = "main" },
  option_callback = function()
    vim.opt.showmode = true -- Show mode in status line
  end,
  lualine_opts = {
    sections = default_theme_config.lualine_opts.sections,
  },
}
