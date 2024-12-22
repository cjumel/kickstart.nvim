-- substitute.nvim
--
-- substitute.nvim is a plugin aiming to provide new operator motions to make it easy to perform quick substitutions
-- and exchange. It completes nicely builtin operators, like toggle comment (with the "gc" keymap), with very natural
-- and useful new operations.

return {
  "gbprod/substitute.nvim",
  keys = {
    -- In the following, all operators are available with the current line characterwise text object with the "c" key
    -- out-of-the-box, thanks to the "line characterwise" text-object defined in nvim-various-textobjects

    -- Overwrite: like paste, but as an operator and without yanking the replaced text
    { "go", function() require("substitute").operator() end, desc = "Overwrite" },
    { "go", function() require("substitute").visual() end, mode = "x", desc = "Overwrite" },
    -- For this keymap, I'm overwriting the "line" version to make it compatible with both characterwise and linewise
    -- register contents without having to bother about text indentation
    { "goc", function() require("substitute").line({ modifiers = { "reindent" } }) end, desc = "Overwrite line" },

    -- Substitute: substitute every instance of a target within a range
    { "gs", function() require("substitute.range").operator() end, desc = "Substitute" },
    { "gs", function() require("substitute.range").visual() end, mode = "x", desc = "Substitute" },

    -- Exchange: substitute two targets with one another
    -- This overwrite the builtin "ge" keymap, which corresponds to "end of word" backward, but I don't use it much
    { "ge", function() require("substitute.exchange").operator() end, desc = "Exchange" },
    { "ge", function() require("substitute.exchange").visual() end, mode = "x", desc = "Exchange" },
  },
  opts = {},
}
