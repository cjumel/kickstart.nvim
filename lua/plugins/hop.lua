-- Hop
--
-- Hop is a plugin enabling fast in-file navigation.

return {
  "smoka7/hop.nvim",
  keys = {
    {
      "s",
      function()
        require("hop").hint_char2()
      end,
      mode = { "n", "x", "o" },
      desc = "[S]earch 2 key patterns (Hop)",
    },
    {
      "f",
      function()
        require("hop").hint_char1({
          direction = require("hop.hint").HintDirection.AFTER_CURSOR,
          current_line_only = true,
        })
      end,
      mode = { "n", "x", "o" },
      desc = "[f]-key style search (Hop)",
    },
    {
      "F",
      function()
        require("hop").hint_char1({
          direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
          current_line_only = true,
        })
      end,
      mode = { "n", "x", "o" },
      desc = "[F]-key style search (Hop)",
    },
    {
      "t",
      function()
        require("hop").hint_char1({
          direction = require("hop.hint").HintDirection.AFTER_CURSOR,
          current_line_only = true,
          hint_offset = -1,
        })
      end,
      mode = { "n", "x", "o" },
      desc = "[t]-key style search (Hop)",
    },
    {
      "T",
      function()
        require("hop").hint_char1({
          direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
          current_line_only = true,
          hint_offset = 1,
        })
      end,
      mode = { "n", "x", "o" },
      desc = "[T]-key style search (Hop)",
    },
    {
      "<leader>w",
      function()
        require("hop").hint_words({
          direction = require("hop.hint").HintDirection.AFTER_CURSOR,
          current_line_only = true,
        })
      end,
      mode = { "n", "x", "o" },
      desc = "[w]-key style search (Hop)",
    },
    {
      "<leader>b",
      function()
        require("hop").hint_words({
          direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
          current_line_only = true,
        })
      end,
      mode = { "n", "x", "o" },
      desc = "[b]-key style search (Hop)",
    },
    {
      "<leader>e",
      function()
        require("hop").hint_words({
          hint_position = require("hop.hint").HintPosition.END,
          direction = require("hop.hint").HintDirection.AFTER_CURSOR,
          current_line_only = true,
        })
      end,
      mode = { "n", "x", "o" },
      desc = "[e]-key style search (Hop)",
    },
    {
      "<leader>ge",
      function()
        require("hop").hint_words({
          hint_position = require("hop.hint").HintPosition.END,
          direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
          current_line_only = true,
        })
      end,
      mode = { "n", "x", "o" },
      desc = "[ge]-keys style search (Hop)",
    },
    {
      "<leader>j",
      "<cmd> HopLineAC <cr>",
      mode = { "n", "x" },
      desc = "[j]-key style search (Hop)",
    },
    {
      "<leader>k",
      "<cmd> HopLineBC <cr>",
      mode = { "n", "x" },
      desc = "[k]-key style search (Hop)",
    },
    -- Make <leader>j and <leader>k work linewise in operator pending mode
    {
      "<leader>j",
      "V<cmd> HopLineAC <cr>",
      mode = { "o" },
      desc = "[j]-key style search (Hop)",
    },
    {
      "<leader>k",
      "V<cmd> HopLineBC <cr>",
      mode = { "o" },
      desc = "[k]-key style search (Hop)",
    },
  },
  opts = {
    keys = "hgjfkdlsmqyturieozpabvn",
    uppercase_labels = true,
  },
}
