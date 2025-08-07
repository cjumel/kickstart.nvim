-- nvim-autopairs
--
-- A super powerful autopair plugin for Neovim that supports multiple characters.

return {
  "windwp/nvim-autopairs",
  dependencies = { "hrsh7th/nvim-cmp" },
  lazy = true, -- Lazy-loading on a custom `InsertEnter` event is defined in `./plugin/autocmds.lua`
  opts = {
    disable_filetype = { "snacks_picker_input", "grug-far" },
  },
  config = function(_, opts)
    local autopairs = require("nvim-autopairs")
    autopairs.setup(opts)

    -- Set up automatic parenthesis insertion when completing a function
    local cmp = require("cmp")
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
