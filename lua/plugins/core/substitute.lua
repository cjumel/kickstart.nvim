return {
  "gbprod/substitute.nvim",
  dependencies = { "gbprod/yanky.nvim" },
  keys = {
    -- Overwrite: overwrite a target with the clipboard content
    { "go", function() require("substitute").operator() end, desc = "Overwrite" },
    { "go", function() require("substitute").visual() end, mode = "x", desc = "Overwrite" },
    -- Substitute: substitute occurrences of a target in a range (prefilled)
    {
      "gss",
      function() require("substitute.range").operator({ prompt_current_text = true }) end,
      desc = "Substitute: substitute (prefilled)",
    },
    {
      "gss",
      function() require("substitute.range").visual({ prompt_current_text = true }) end,
      mode = "x",
      desc = "Substitute: substitute (prefilled)",
    },
    -- Replace: replace occurrences of a target in a range (not prefilled)
    { "gsr", function() require("substitute.range").operator() end, desc = "Substitute: replace" },
    { "gsr", function() require("substitute.range").visual() end, mode = "x", desc = "Substitute: replace" },
    -- Orverwrite (range): overwrite occurrences of a target in a range with the clipboard content
    {
      "gso",
      function() require("substitute.range").operator({ register = "0", auto_apply = true }) end,
      desc = "Substitute: overwrite (range)",
    },
    {
      "gso",
      function() require("substitute.range").visual({ register = "0", auto_apply = true }) end,
      mode = "x",
      desc = "Substitute: overwrite (range)",
    },
    -- Exchange: swap two targets together
    { "gse", function() require("substitute.exchange").operator() end, desc = "Substitute: exchange" },
    { "gse", function() require("substitute.exchange").visual() end, mode = "x", desc = "Substitute: exchange" },
  },
  opts = function() return { on_substitute = require("yanky.integration").substitute() } end,
}
