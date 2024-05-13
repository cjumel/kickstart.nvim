-- OneDark.nvim
--
-- Theme for Neovim based on Atom One Dark theme written in lua with TreeSitter syntax highlight.

local utils = require("utils")

return {
  "navarasu/onedark.nvim",
  lazy = utils.theme.get_lazyness("onedark"),
  priority = 1000, -- Main UI stuff should be loaded first
  opts = utils.theme.make_opts("onedark", {
    transparent = true,
  }),
  config = function(_, opts)
    local onedark = require("onedark")
    onedark.setup(opts)
    onedark.load()
  end,
}
