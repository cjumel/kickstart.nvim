return {
  "gbprod/substitute.nvim",
  depencencies = { "gbprod/yanky.nvim" },
  keys = {
    -- Overwrite, like the paste operator but without yanking the overwritten text
    { "go", function() require("substitute").operator() end, desc = "Overwrite" },
    { "go", function() require("substitute").visual() end, mode = "x", desc = "Overwrite" },
    -- Substitute a target in a range
    {
      "gs",
      function() require("substitute.range").operator({ prompt_current_text = true }) end,
      desc = "Substitute in range (prefilled)",
    },
    {
      "gs",
      function() require("substitute.range").visual({ prompt_current_text = true }) end,
      mode = "x",
      desc = "Substitute in range (prefilled)",
    },
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
