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
      desc = "Hop: [S]earch with 2 keys",
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
      desc = "Hop: [f] key",
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
      desc = "Hop: [F] key",
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
      desc = "Hop: [t] key",
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
      desc = "Hop: [T] key",
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
      desc = "Hop: [w] key",
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
      desc = "Hop: [b] key",
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
      desc = "Hop: [e] key",
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
      desc = "Hop: [ge] keys",
    },
    {
      "<leader>j",
      "<cmd> HopLineAC <cr>",
      mode = { "n", "x" },
      desc = "Hop: [j] key",
    },
    {
      "<leader>k",
      "<cmd> HopLineBC <cr>",
      mode = { "n", "x" },
      desc = "Hop: [k] key",
    },
    -- Make <leader>j and <leader>k work linewise in operator pending mode
    {
      "<leader>j",
      "V<cmd> HopLineAC <cr>",
      mode = { "o" },
      desc = "Hop: [j] key",
    },
    {
      "<leader>k",
      "V<cmd> HopLineBC <cr>",
      mode = { "o" },
      desc = "Hop: [k] key",
    },
  },
  opts = {
    keys = "hgjfkdlsmqyturieozpabvn",
    uppercase_labels = true,
  },
}
