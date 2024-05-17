-- nvim-web-devicons
--
-- A Lua for of vim-devicons, providing icons as well as colors for each icon.

return {
  "nvim-tree/nvim-web-devicons",
  lazy = true,
  opts = {
    override_by_filename = {
      [".env.example"] = { -- Values taken from nvim-web-devicons except for name
        icon = "",
        color = "#faf743",
        cterm_color = "227",
        name = "EnvExample",
      },
    },
  },
}
