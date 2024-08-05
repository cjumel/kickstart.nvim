-- substitute.nvim
--
-- substitute.nvim is a plugin aiming to provide new operator motions to make it easy to perform quick substitutions
-- and exchange. It completes nicely builtin operators, like toggle comment (with the "gc" keymap), with very natural
-- and useful new operations.

return {
  "gbprod/substitute.nvim",
  keys = {
    -- In the following, all operators are available with the current line characterwise text object with the "c"
    --  key out-of-the-box

    -- Overwrite: like paste, but as an operator and without yanking the replaced text
    { "go", function() require("substitute").operator() end, desc = "Overwrite" },
    { "go", function() require("substitute").visual() end, mode = "x", desc = "Overwrite" },

    -- Substitute by register: replace every instance of a target within a range by the register content
    {
      "gs",
      function() require("substitute.range").operator({ register = "0", auto_apply = true }) end,
      desc = "Substitute by register",
    },
    {
      "gs",
      function() require("substitute.range").visual({ register = "0", auto_apply = true }) end,
      mode = "x",
      desc = "Substitute by register",
    },

    -- Substitute with prompt: replace every instance of a target within a range with an arbitrary string
    { "gS", function() require("substitute.range").operator() end, desc = "Substitute with prompt" },
    { "gS", function() require("substitute.range").visual() end, mode = "x", desc = "Substitute with prompt" },

    -- Exchange: swap two targets
    --  The builtin "ge" keymap is "end of word backwards", but I don't use it, which is why I'm replacing it here
    { "ge", function() require("substitute.exchange").operator() end, desc = "Exchange" },
    { "ge", function() require("substitute.exchange").visual() end, mode = "x", desc = "Exchange" },
  },
  opts = {},
}
