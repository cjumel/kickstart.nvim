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
      desc = "Search 2 characters hop",
      ft = "*",
    },
    -- For f, F, t & T, don't specify a filetype to completly override the builtin keymaps
    {
      "f",
      function()
        require("hop").hint_char1({
          direction = require("hop.hint").HintDirection.AFTER_CURSOR,
          current_line_only = true,
        })
      end,
      mode = { "n", "x", "o" },
      desc = "Find character hop",
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
      desc = "Find character hop backward",
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
      desc = "Till character hop",
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
      desc = "Till character hop backward",
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
      desc = "[W]ord hop",
      ft = "*",
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
      desc = "[B]ackward word hop",
      ft = "*",
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
      desc = "[E]nd of word hop",
      ft = "*",
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
      desc = "[E]nd of word hop backward",
      ft = "*",
    },
    {
      "<leader>j",
      "<cmd> HopLineStartAC <cr>",
      mode = { "n", "x" },
      desc = "Downward line start hop",
      ft = "*",
    },
    { -- linewise in operator pending mode
      "<leader>j",
      "V<cmd> HopLineStartAC <cr>",
      mode = { "o" },
      desc = "Downward line start hop",
      ft = "*",
    },
    {
      "<leader>J",
      "<cmd> HopVerticalAC <cr>",
      mode = { "n", "x" },
      desc = "Downward vertical hop",
      ft = "*",
    },
    { -- linewise in operator pending mode
      "<leader>J",
      "V<cmd> HopVerticalAC <cr>",
      mode = { "o" },
      desc = "Downward vertical hop",
      ft = "*",
    },
    {
      "<leader>k",
      "<cmd> HopLineStartBC <cr>",
      mode = { "n", "x" },
      desc = "Upward line start hop",
      ft = "*",
    },
    { -- linewise in operator pending mode
      "<leader>k",
      "V<cmd> HopLineStartBC <cr>",
      mode = { "o" },
      desc = "Upward line start hop",
      ft = "*",
    },
    {
      "<leader>K",
      "<cmd> HopVerticalBC <cr>",
      mode = { "n", "x" },
      desc = "Upward vertical hop",
      ft = "*",
    },
    { -- linewise in operator pending mode
      "<leader>K",
      "V<cmd> HopVerticalBC <cr>",
      mode = { "o" },
      desc = "Upward vertical hop",
      ft = "*",
    },
  },
  opts = {
    keys = "hgjfkdlsmqyturieozpabvn",
    uppercase_labels = true,
  },
}
