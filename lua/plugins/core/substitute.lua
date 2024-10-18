-- substitute.nvim
--
-- substitute.nvim is a plugin aiming to provide new operator motions to make it easy to perform quick substitutions
-- and exchange. It completes nicely builtin operators, like toggle comment (with the "gc" keymap), with very natural
-- and useful new operations.

return {
  "gbprod/substitute.nvim",
  keys = {
    -- In the following, all operators are available with the current line characterwise text object with the "c" key
    --  out-of-the-box, thanks to the "line characterwise" text-object defined in nvim-various-textobjects. However,
    --  this behavior can be overwritten for more control in the following mappings.

    -- Overwrite: like paste, but as an operator and without yanking the replaced text
    -- I use this operator quite a lot, and I don't find it really related to substitution, so I'm not putting this
    --  keymap in the "gs" prefix
    -- For this keymap, I'm overwriting the "line" version to make it compatible with both characterwise and linewise
    --  register contents without having to bother about text indentation
    { "go", function() require("substitute").operator() end, desc = "Overwrite" },
    { "goc", function() require("substitute").line({ modifiers = { "reindent" } }) end, desc = "Overwrite line" },
    { "go", function() require("substitute").visual() end, mode = "x", desc = "Overwrite" },

    -- Substitute: substitute every instance of a target within a range
    { "gss", function() require("substitute.range").operator() end, desc = "Substitute" },
    { "gss", function() require("substitute.range").visual() end, mode = "x", desc = "Substitute" },

    -- Substitute by register: substitute every instance of a target within a range by the main register content
    {
      "gsr",
      function() require("substitute.range").operator({ register = "0", auto_apply = true }) end,
      desc = "Substitute by register",
    },
    {
      "gsr",
      function() require("substitute.range").visual({ register = "0", auto_apply = true }) end,
      mode = "x",
      desc = "Substitute by register",
    },

    -- Exchange: substitute two targets with one another
    { "gse", function() require("substitute.exchange").operator() end, desc = "Exchange" },
    { "gse", function() require("substitute.exchange").visual() end, mode = "x", desc = "Exchange" },
  },
  opts = {},
}
