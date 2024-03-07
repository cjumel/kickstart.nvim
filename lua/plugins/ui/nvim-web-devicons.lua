-- Nvim-web-devicons
--
-- A lua fork of vim-devicons. This plugin provides the same icons as well as colors for each icon.

-- The sole purpose of defining a configuration for this plugin is to change the default icon,
-- to fix the find directories keymap of Telescope, which compute the default icon for directory
-- entries.

return {
  "nvim-web-devicons",
  lazy = true,
  opts = {},
  config = function(_, opts)
    require("nvim-web-devicons").setup(opts)

    -- Dynamically set the default icon with the right color, which depends on the color-scheme
    local directory_hl = vim.api.nvim_get_hl_by_name("Directory", true)
    local direcotry_fg = string.format("#%06x", directory_hl["foreground"])
    require("nvim-web-devicons").set_default_icon("", direcotry_fg)
  end,
}
