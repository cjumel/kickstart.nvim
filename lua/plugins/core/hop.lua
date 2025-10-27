return {
  "smoka7/hop.nvim",
  keys = {
    {
      "s", -- Buitlin "s" keymap is equivalent to "cl" and I find it pretty much useless
      function() require("hop").hint_char2({ multi_windows = true }) end,
      mode = { "n", "x", "o" },
      desc = "2-character search and jump",
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
      desc = "Find character forward and jump",
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
      desc = "Find character backward and jump",
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
      desc = "Till character forward jump",
    },
    {
      "T",
      function()
        require("hop").hint_char1({
          direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
          current_line_only = true,
          hint_offset = 1, -- Due to this offset, we can't setup a single bidirecionnal "t/T" keymap
        })
      end,
      mode = { "n", "x", "o" },
      desc = "Till character backward jump",
    },
    {
      "<M-w>",
      function() require("hop").hint_words({ current_line_only = true }) end,
      mode = { "n", "x", "o" },
      desc = "Word jump",
    },
    {
      "<M-e>",
      function()
        require("hop").hint_words({
          hint_position = require("hop.hint").HintPosition.END,
          current_line_only = true,
        })
      end,
      mode = { "n", "x", "o" },
      desc = "End of word jump",
    },
    {
      "<M-t>",
      function() require("hop").hint_camel_case({ current_line_only = true }) end,
      mode = { "n", "x", "o" },
      desc = "Token jump",
    },
    -- In operator-pending mode, let's make line-related keymaps act linewise, like builtin operations such as "yj"
    { "<M-j>", "<cmd>HopLineStartAC<CR>", mode = { "n", "x" }, desc = "Downward line jump" },
    { "<M-j>", "V<cmd>HopLineStartAC<CR>", mode = { "o" }, desc = "Downward line jump" },
    { "<M-k>", "<cmd>HopLineStartBC<CR>", mode = { "n", "x" }, desc = "Upward line jump" },
    { "<M-k>", "V<cmd>HopLineStartBC<CR>", mode = { "o" }, desc = "Upward line jump" },
  },
  opts = {
    keys = "hgjfkdlsmqyturieozpabvn",
    uppercase_labels = true, -- Make labels stand-out more
  },
}
