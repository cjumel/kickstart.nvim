return {
  "gbprod/substitute.nvim",
  dependencies = { "gbprod/yanky.nvim" },
  keys = {
    { "<leader>p", function() require("substitute").operator() end, desc = "[P]aste operator (no yank)" },
    { "<leader>p", function() require("substitute").visual() end, mode = "x", desc = "[P]aste operator (no yank)" },
    {
      "<leader>rr",
      function() require("substitute.range").operator() end,
      desc = "[R]eplace: [R]eplace in range",
    },
    {
      "<leader>rr",
      function() require("substitute.range").visual() end,
      mode = "x",
      desc = "[R]eplace: [R]eplace in range",
    },
    {
      "<leader>rs",
      function() require("substitute.range").operator({ prompt_current_text = true }) end,
      desc = "[R]eplace: [S]ubstitute in range (prefilled)",
    },
    {
      "<leader>rs",
      function() require("substitute.range").visual({ prompt_current_text = true }) end,
      mode = "x",
      desc = "[R]eplace: [S]ubstitute in range (prefilled)",
    },
    {
      "<leader>ro",
      function() require("substitute.range").operator({ register = "0", auto_apply = true }) end,
      desc = "[R]eplace: [O]verwrite in range",
    },
    {
      "<leader>ro",
      function() require("substitute.range").visual({ register = "0", auto_apply = true }) end,
      mode = "x",
      desc = "[R]eplace: [O]verwrite in range",
    },
    {
      "<leader>re",
      function() require("substitute.exchange").operator() end,
      desc = "[R]eplace: [E]xchange targets",
    },
    {
      "<leader>re",
      function() require("substitute.exchange").visual() end,
      mode = "x",
      desc = "[R]eplace: [E]xchange targets",
    },
  },
  opts = function() return { on_substitute = require("yanky.integration").substitute() } end,
}
