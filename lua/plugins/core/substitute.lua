-- substitute.nvim
--
-- substitute.nvim is a plugin aiming to provide new operator motions to make it easy to perform quick substitutions
-- and exchange.

return {
  "gbprod/substitute.nvim",
  depencencies = { "gbprod/yanky.nvim" },
  keys = {
    -- Overwrite, like the paste operator but without yanking the overwritten text
    { "go", function() require("substitute").operator() end, desc = "Overwrite" },
    { "go", function() require("substitute").visual() end, mode = "x", desc = "Overwrite" },
    -- Substitute a target in a range
    { "gs", function() require("substitute.range").operator() end, desc = "Substitute in range" },
    { "gs", function() require("substitute.range").visual() end, mode = "x", desc = "Substitute in range" },
    -- Move two targets, replacing one with the other
    { "gm", function() require("substitute.exchange").operator() end, desc = "Move" },
    { "gm", function() require("substitute.exchange").visual() end, mode = "x", desc = "Move" },
  },
  opts = function()
    return {
      on_substitute = require("yanky.integration").substitute(), -- yanky.nvim integration
    }
  end,
}
