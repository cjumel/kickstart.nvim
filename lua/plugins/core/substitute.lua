-- substitute.nvim
--
-- substitute.nvim is a plugin aiming to provide new operator motions to make it easy to perform quick substitutions
-- and exchange. It completes nicely builtin operators like commenting with `gc`, with very natural and useful new
-- operations.

return {
  "gbprod/substitute.nvim",
  keys = {
    -- In the following, I don't implement "current-line" variations of the keymaps (like "goc" for "Overwrite
    -- current line") similarly to what's done with "gc" & "gcc", as a "c" operator-pending text-object is defined
    -- for the current line characterwise in nvim-various-textobjs, which provides this behavior out of the box.

    -- Overwrite: like paste, but as an operator and without yanking the replaced text
    { "go", function() require("substitute").operator() end, desc = "Overwrite" },
    { "go", function() require("substitute").visual() end, mode = "x", desc = "Overwrite" },

    -- Substitute: replace some target within a range
    { "gs", function() require("substitute.range").operator() end, desc = "Substitute" },
    { "gs", function() require("substitute.range").visual() end, mode = "x", desc = "Substitute" },

    -- Substitute with register: replace some target within a range with the content of the default register
    {
      "gS",
      function() require("substitute.range").operator({ register = "0", auto_apply = true }) end,
      desc = "Substitute with register",
    },
    {
      "gS",
      function() require("substitute.range").visual({ register = "0", auto_apply = true }) end,
      mode = "x",
      desc = "Substitute with register",
    },

    -- Exchange: swap two targets (I don't use the builtin "ge", so let's use it here)
    { "ge", function() require("substitute.exchange").operator() end, desc = "Exchange" },
    { "ge", function() require("substitute.exchange").visual() end, mode = "x", desc = "Exchange" },
  },
  opts = {},
}
