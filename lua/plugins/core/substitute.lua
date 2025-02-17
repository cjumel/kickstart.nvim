-- substitute.nvim
--
-- substitute.nvim is a plugin aiming to provide new operator motions to make it easy to perform quick substitutions
-- and exchange. It completes nicely builtin operators, like toggle comment (with the "gc" keymap), with very natural
-- and useful new operations.

return {
  "gbprod/substitute.nvim",
  keys = {
    -- Paste: paste operator, to paste over a target, but without yanking the target text
    { "gp", function() require("substitute").operator() end, desc = "Paste" },
    { "gp", function() require("substitute").visual() end, mode = "x", desc = "Paste" },
    { "gpc", function() require("substitute").line({ modifiers = { "reindent" } }) end, desc = "Paste on line" },

    -- Overwrite: overwrite every instance of a target within a target range
    { "go", function() require("substitute.range").operator() end, desc = "Overwrite" },
    { "go", function() require("substitute.range").visual() end, mode = "x", desc = "Overwrite" },
    {
      "gO",
      function() require("substitute.range").operator({ register = "0", auto_apply = true }) end,
      desc = "Overwrite by register",
    },
    {
      "gO",
      function() require("substitute.range").visual({ register = "0", auto_apply = true }) end,
      mode = "x",
      desc = "Overwrite by register",
    },

    -- Swap: swap together two targets
    { "gs", function() require("substitute.exchange").operator() end, desc = "Swap" },
    { "gs", function() require("substitute.exchange").visual() end, mode = "x", desc = "Swap" },
  },
  opts = {},
}
