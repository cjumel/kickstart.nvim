-- Hop
--
-- Hop is a plugin enabling fast in-file navigation.

return {
  "smoka7/hop.nvim",
  keys = {
    {
      "s", -- Buitlin `s` is equivalent to `cl` & is pretty much useless
      function()
        require("hop").hint_char2({})
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
      "<leader>E",
      function()
        require("hop").hint_words({
          hint_position = require("hop.hint").HintPosition.END,
          direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
          current_line_only = true,
        })
      end,
      mode = { "n", "x", "o" },
      desc = "[e]-key style search backward (Hop)",
    },
    {
      "<leader>j",
      "<cmd> HopLineStartAC <cr>",
      mode = { "n", "x" },
      desc = "Search down for line starts (Hop)",
    },
    { -- linewise in operator pending mode
      "<leader>j",
      "V<cmd> HopLineStartAC <cr>",
      mode = { "o" },
      desc = "Search down for line starts (Hop)",
    },
    {
      "<leader>J",
      "<cmd> HopVerticalAC <cr>",
      mode = { "n", "x" },
      desc = "Search down vertically (Hop)",
    },
    { -- linewise in operator pending mode
      "<leader>J",
      "V<cmd> HopVerticalAC <cr>",
      mode = { "o" },
      desc = "Search down vertically (Hop)",
    },
    {
      "<leader>k",
      "<cmd> HopLineStartBC <cr>",
      mode = { "n", "x" },
      desc = "Search up for line starts (Hop)",
    },
    { -- linewise in operator pending mode
      "<leader>k",
      "V<cmd> HopLineStartBC <cr>",
      mode = { "o" },
      desc = "Search up for line starts (Hop)",
    },
    {
      "<leader>K",
      "<cmd> HopVerticalBC <cr>",
      mode = { "n", "x" },
      desc = "Search up vertically (Hop)",
    },
    { -- linewise in operator pending mode
      "<leader>K",
      "V<cmd> HopVerticalBC <cr>",
      mode = { "o" },
      desc = "Search up vertically (Hop)",
    },
  },
  opts = {
    keys = "hgjfkdlsmqyturieozpabvn",
    uppercase_labels = true,
  },
}
