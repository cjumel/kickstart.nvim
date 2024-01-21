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
      desc = "[S]earch 2 characters & jump",
      ft = "*",
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
      desc = "[F]ind 1 character & jump",
      ft = "*",
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
      desc = "[F]ind 1 character backward & jump",
      ft = "*",
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
      desc = "[T]ill 1 character jump",
      ft = "*",
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
      desc = "[T]ill 1 character backward jump",
      ft = "*",
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
      desc = "[W]ord jump",
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
      desc = "[B]ackward word jump",
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
      desc = "[E]nd of word jump",
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
      desc = "[E]nd of word backward jump",
      ft = "*",
    },
    {
      "<leader>j",
      "<cmd> HopLineStartAC <cr>",
      mode = { "n", "x" },
      desc = "Downward line start jump",
      ft = "*",
    },
    { -- linewise in operator pending mode
      "<leader>j",
      "V<cmd> HopLineStartAC <cr>",
      mode = { "o" },
      desc = "Downward line start jump",
      ft = "*",
    },
    {
      "<leader>J",
      "<cmd> HopVerticalAC <cr>",
      mode = { "n", "x" },
      desc = "Downward vertical jump",
      ft = "*",
    },
    { -- linewise in operator pending mode
      "<leader>J",
      "V<cmd> HopVerticalAC <cr>",
      mode = { "o" },
      desc = "Downward vertical jump",
      ft = "*",
    },
    {
      "<leader>k",
      "<cmd> HopLineStartBC <cr>",
      mode = { "n", "x" },
      desc = "Upward line start jump",
      ft = "*",
    },
    { -- linewise in operator pending mode
      "<leader>k",
      "V<cmd> HopLineStartBC <cr>",
      mode = { "o" },
      desc = "Upward line start jump",
      ft = "*",
    },
    {
      "<leader>K",
      "<cmd> HopVerticalBC <cr>",
      mode = { "n", "x" },
      desc = "Upward vertical jump",
      ft = "*",
    },
    { -- linewise in operator pending mode
      "<leader>K",
      "V<cmd> HopVerticalBC <cr>",
      mode = { "o" },
      desc = "Upward vertical jump",
      ft = "*",
    },
  },
  opts = {
    keys = "hgjfkdlsmqyturieozpabvn",
    uppercase_labels = true,
  },
}
