-- Hydra.nvim
--
-- This is the Neovim implementation of the famous Emacs Hydra package, to create custom submodes and menus.

return {
  "nvimtools/hydra.nvim",
  keys = function()
    local hydra_heads = require("plugins.ui.hydra.heads")
    return hydra_heads.get_keys()
  end,
  opts = {
    invoke_on_body = true,
  },
  config = function(_, opts)
    local Hydra = require("hydra")
    Hydra.setup(opts)

    local hydra_heads = require("plugins.ui.hydra.heads")
    for _, config in ipairs(hydra_heads.get_configs()) do
      Hydra(config)
    end
  end,
}
