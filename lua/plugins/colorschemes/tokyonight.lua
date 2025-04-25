-- Tokyo Night
--
-- Clean, dark and light Neovim themes written in Lua and ported from the Visual Studio Code TokyoNight theme. This
-- plugin comes with many features and integrations, like LSP or Treesitter support. The Tokyo Night theme is also
-- available for many tools other than Neovim, making it one of the most popular color schemes out there.

return {
  "folke/tokyonight.nvim",
  cond = Metaconfig.enable_all_plugins or Theme.tokyonight_enabled or false,
  priority = 1000, -- Main UI stuff should be loaded first
  opts = {
    style = Theme.tokyonight_style or "night",
    transparent = true,
  },
  config = function(_, opts)
    require("tokyonight").setup(opts) -- Must be called before loading the color scheme
    vim.cmd.colorscheme("tokyonight")
  end,
}
