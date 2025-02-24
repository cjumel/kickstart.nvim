-- substitute.nvim
--
-- substitute.nvim is a plugin aiming to provide new operator motions to make it easy to perform quick substitutions
-- and exchange. It completes nicely builtin operators, like toggle comment (with the "gc" keymap), with very natural
-- and useful new operations.

return {
  "gbprod/substitute.nvim",
  depencencies = { "gbprod/yanky.nvim" },
  keys = {
    -- Overwrite: like paste, but as an operator and without yanking the replaced text
    { "go", function() require("substitute").operator() end, desc = "Overwrite" },
    { "go", function() require("substitute").visual() end, mode = "x", desc = "Overwrite" },

    -- Substitute: substitute every instance of a target within a range
    { "gs", function() require("substitute.range").operator() end, desc = "Substitute" },
    { "gs", function() require("substitute.range").visual() end, mode = "x", desc = "Substitute" },
    {
      "gS",
      function() require("substitute.range").operator({ register = "0", auto_apply = true }) end,
      desc = "Substitute by register",
    },
    {
      "gS",
      function() require("substitute.range").visual({ register = "0", auto_apply = true }) end,
      mode = "x",
      desc = "Substitute by register",
    },

    -- Exchange: swap two targets
    { "g=", function() require("substitute.exchange").operator() end, desc = "Exchange" },
    { "g=", function() require("substitute.exchange").visual() end, mode = "x", desc = "Exchange" },
  },
  opts = function()
    return {
      on_substitute = require("yanky.integration").substitute(), -- yanky.nvim integration
    }
  end,
}
