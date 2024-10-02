-- OneDark.nvim
--
-- Dark and light themes based on Atom One Dark & Atom One Light themes written in Lua.

return {
  "navarasu/onedark.nvim",
  cond = require("theme").get_field("onedark", "enabled", false),
  priority = 1000, -- Main UI stuff should be loaded first
  opts = require("theme").make_opts("onedark", {
    transparent = true, -- Don't set a background color
  }),
  config = function(_, opts)
    local onedark = require("onedark")

    onedark.setup(opts)
    vim.cmd.colorscheme("onedark") -- Setup must be called before loading the color scheme
  end,
}
