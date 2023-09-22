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
      desc = "[S]earch 2 keys with Hop",
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
      desc = "[f] vim key with Hop",
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
      desc = "[F] vim key with Hop",
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
      desc = "[t] vim key with Hop",
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
      desc = "[T] vim key with Hop",
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
      desc = "[w] vim key with Hop",
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
      desc = "[b] vim key with Hop",
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
      desc = "[e] vim key with Hop",
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
      desc = "[ge] vim keys with Hop",
    },
    {
      "<leader>j",
      function()
        require("hop").hint_lines({
          direction = require("hop.hint").HintDirection.AFTER_CURSOR,
        })
      end,
      mode = { "n", "x", "o" },
      desc = "[j] vim key with Hop",
    },
    {
      "<leader>k",
      function()
        require("hop").hint_lines({
          direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
        })
      end,
      mode = { "n", "x", "o" },
      desc = "[k] vim key with Hop",
    },
  },
  opts = {
    keys = "hgjfkdlsmqyturieozpabvn",
    uppercase_labels = true,
  },
}
