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
    },
    {
      "<leader>j",
      "<cmd> HopLineStartAC <cr>",
      mode = { "n", "x" },
      desc = "Downward line start jump",
    },
    { -- linewise in operator pending mode
      "<leader>j",
      "V<cmd> HopLineStartAC <cr>",
      mode = { "o" },
      desc = "Downward line start jump",
    },
    {
      "<leader>J",
      "<cmd> HopVerticalAC <cr>",
      mode = { "n", "x" },
      desc = "Downward vertical jump",
    },
    { -- linewise in operator pending mode
      "<leader>J",
      "V<cmd> HopVerticalAC <cr>",
      mode = { "o" },
      desc = "Downward vertical jump",
    },
    {
      "<leader>k",
      "<cmd> HopLineStartBC <cr>",
      mode = { "n", "x" },
      desc = "Upward line start jump",
    },
    { -- linewise in operator pending mode
      "<leader>k",
      "V<cmd> HopLineStartBC <cr>",
      mode = { "o" },
      desc = "Upward line start jump",
    },
    {
      "<leader>K",
      "<cmd> HopVerticalBC <cr>",
      mode = { "n", "x" },
      desc = "Upward vertical jump",
    },
    { -- linewise in operator pending mode
      "<leader>K",
      "V<cmd> HopVerticalBC <cr>",
      mode = { "o" },
      desc = "Upward vertical jump",
    },
  },
  opts = {
    keys = "hgjfkdlsmqyturieozpabvn",
    uppercase_labels = true,
  },
}
