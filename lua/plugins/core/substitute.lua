-- substitute.nvim
--
-- Plugin aiming to provide new operator motions to make it very easy to perform quick substitutions and exchange.

return {
  "gbprod/substitute.nvim",
  keys = function()
    local exchange = require("substitute.exchange")
    local substitute = require("substitute")
    local substitute_range = require("substitute.range")

    return {
      -- Overwrite: like paste, but as an operator and without yanking the replaced text
      { "go", substitute.operator, desc = "Overwrite" },
      { "go", substitute.visual, mode = "x", desc = "Overwrite" },
      { "goc", substitute.line, desc = "Overwrite current line" },
      -- Substitute: replace some target within a range
      { "gs", substitute_range.operator, desc = "Substitute" },
      { "gs", substitute_range.visual, mode = "x", desc = "Substitute" },
      { "gsc", function() substitute_range.operator({ range = "%" }) end, desc = "Substitute in current buffer" },
      {
        "gsc",
        function() substitute_range.visual({ range = "%" }) end,
        mode = "x",
        desc = "Substitute in current buffer",
      },
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
      {
        "gSc",
        function() substitute_range.operator({ register = "0", auto_apply = true, range = "%" }) end,
        desc = "Substitute with register in current buffer",
      },
      {
        "gSc",
        function() substitute_range.visual({ register = "0", auto_apply = true, range = "%" }) end,
        mode = "x",
        desc = "Substitute with register in current buffer",
      },
      -- Exchange: swap two targets
      -- I don't use builtin "ge", it can be replaced with Hop's equivalent or with "F" so let's remap it here
      { "ge", exchange.operator, desc = "Exchange" },
      { "ge", exchange.visual, mode = "x", desc = "Exchange" },
      { "gec", exchange.line, desc = "Exchange current line" },
    }
  end,
  opts = {},
}
