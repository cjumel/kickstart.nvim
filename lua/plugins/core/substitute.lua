-- substitute.nvim
--
-- substitute.nvim is a plugin aiming to provide new operator motions to make it easy to perform quick substitutions
-- and exchange. It completes nicely builtin operators like commenting with `gc`, with very natural and useful new
-- operations.

return {
  "gbprod/substitute.nvim",
  keys = function()
    local exchange = require("substitute.exchange")
    local substitute = require("substitute")
    local substitute_range = require("substitute.range")

    return {
      -- In the following, I don't implement "current-line" variations of the keymaps (like "goc" for "Overwrite
      -- current line") similarly to what's done with "gc" & "gcc", as a "c" operator-pending text-object is defined
      -- for the current line characterwise in nvim-various-textobjs, which provides this behavior out of the box.

      -- Overwrite: like paste, but as an operator and without yanking the replaced text
      { "go", substitute.operator, desc = "Overwrite" },
      { "go", substitute.visual, mode = "x", desc = "Overwrite" },

      -- Substitute: replace some target within a range
      { "gs", substitute_range.operator, desc = "Substitute" },
      { "gs", substitute_range.visual, mode = "x", desc = "Substitute" },

      -- Substitute with register: replace some target within a range with the content of the default register
      {
        "gS",
        function() substitute_range.operator({ register = "0", auto_apply = true }) end,
        desc = "Substitute with register",
      },
      {
        "gS",
        function() substitute_range.visual({ register = "0", auto_apply = true }) end,
        mode = "x",
        desc = "Substitute with register",
      },

      -- Exchange: swap two targets (I don't use the builtin "ge", so let's use it here)
      { "ge", exchange.operator, desc = "Exchange" },
      { "ge", exchange.visual, mode = "x", desc = "Exchange" },
    }
  end,
  opts = {},
}
