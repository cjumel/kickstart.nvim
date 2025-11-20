return {
  "gbprod/substitute.nvim",
  depencencies = { "gbprod/yanky.nvim" },
  keys = {
    -- Overwrite: like the paste operator but without yanking the overwritten text
    { "go", function() require("substitute").operator() end, desc = "Overwrite" },
    { "go", function() require("substitute").visual() end, mode = "x", desc = "Overwrite" },
    -- Overwrite in range: overwrite all occurrences of a target in a range
    {
      "gO",
      function() require("substitute.range").operator({ register = "0", auto_apply = true }) end,
      desc = "Overwrite in range",
    },
    {
      "gO",
      function() require("substitute.range").visual({ register = "0", auto_apply = true }) end,
      mode = "x",
      desc = "Overwrite in range",
    },
    -- Substitute: update occurrences of a target in a range
    {
      "gs",
      function() require("substitute.range").operator({ prompt_current_text = true }) end,
      desc = "Substitute (prefilled)",
    },
    {
      "gs",
      function() require("substitute.range").visual({ prompt_current_text = true }) end,
      mode = "x",
      desc = "Substitute (prefilled)",
    },
    -- Substitute (not prefilled): replace occurrences of a target in a range
    { "gS", function() require("substitute.range").operator() end, desc = "Substitute (not prefilled)" },
    { "gS", function() require("substitute.range").visual() end, mode = "x", desc = "Substitute (not prefilled)" },
    -- Exchange: swap two targets
    { "ge", function() require("substitute.exchange").operator() end, desc = "Exchange" },
    { "ge", function() require("substitute.exchange").visual() end, mode = "x", desc = "Exchange" },
  },
  opts = function()
    return {
      on_substitute = require("yanky.integration").substitute(), -- yanky.nvim integration
    }
  end,
}
