return {
  "gbprod/substitute.nvim",
  depencencies = { "gbprod/yanky.nvim" },
  keys = {
    -- Overwrite: like the paste operator but without yanking the overwritten text
    { "go", function() require("substitute").operator() end, desc = "Overwrite" },
    { "go", function() require("substitute").visual() end, mode = "x", desc = "Overwrite" },
    -- Substitute in range: replace occurrences of a target in a range
    { "gs", function() require("substitute.range").operator() end, desc = "Substitute in range" },
    { "gs", function() require("substitute.range").visual() end, mode = "x", desc = "Substitute in range" },
    -- Modify in range: update occurrences of a target in a range
    {
      "gm",
      function() require("substitute.range").operator({ prompt_current_text = true }) end,
      desc = "Modify in range",
    },
    {
      "gm",
      function() require("substitute.range").visual({ prompt_current_text = true }) end,
      mode = "x",
      desc = "Modify in range",
    },
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
