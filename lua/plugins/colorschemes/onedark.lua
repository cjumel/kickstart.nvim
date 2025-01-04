-- OneDark.nvim
--
-- Dark and light themes based on Atom One Dark & Atom One Light themes written in Lua.

return {
  "navarasu/onedark.nvim",
  cond = require("theme").onedark_enabled or false,
  priority = 1000, -- Main UI stuff should be loaded first
  opts = vim.tbl_deep_extend("force", {
    transparent = true,
  }, require("theme").onedark_opts or {}),
  config = function(_, opts)
    require("onedark").setup(opts) -- Must be called before loading the color scheme
    vim.cmd.colorscheme("onedark")
  end,
}
