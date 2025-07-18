-- Hydra.nvim
--
-- This is the Neovim implementation of the famous Emacs Hydra package, to create custom submodes and menus.

return {
  "nvimtools/hydra.nvim",
  keys = function()
    local hydra_config = require("config.hydra")
    return hydra_config.get_keys()
  end,
  opts = {
    invoke_on_body = true,
  },
  config = function(_, opts)
    local Hydra = require("hydra")
    Hydra.setup(opts)

    local hydra_config = require("config.hydra")
    for _, config in ipairs(hydra_config.get_configs()) do
      Hydra(config)
    end
  end,
}
