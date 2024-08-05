-- Hop
--
-- Hop provides Neovim motions on speed. It adds many simple but powerful features to simplify navigating in a file
-- using only the keyboard. I find this plugin essential in my workflow, especially since I don't use counts as, using
-- an azerty keyboard, typing numbers is far from the home row and requires the use of the shift key at the same time.

return {
  "smoka7/hop.nvim",
  keys = {
    -- Buitlin "s" keymap is equivalent to "cl" and is pretty much useless
    {
      "s",
      function() require("hop").hint_char2({}) end,
      mode = { "n", "x", "o" },
      desc = "Search 2 characters hop",
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
    },
    {
      "<leader>s",
      function()
        require("hop").hint_camel_case({
          direction = require("hop.hint").HintDirection.AFTER_CURSOR,
          current_line_only = true,
        })
      end,
      mode = { "n", "x", "o" },
      desc = "[S]ubword hop",
    },
    {
      "<leader>S",
      function()
        require("hop").hint_camel_case({
          direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
          current_line_only = true,
        })
      end,
      mode = { "n", "x", "o" },
      desc = "[S]ubword hop backward",
    },
    -- In operator-pending mode, let's make line-related keymaps act linewise, like builtin operators like "y" or "d"
    { "<leader>j", "<cmd>HopLineStartAC<CR>", mode = { "n", "x" }, desc = "Downward line start hop" },
    { "<leader>j", "V<cmd>HopLineStartAC<CR>", mode = { "o" }, desc = "Downward line start hop" },
    { "<leader>k", "<cmd>HopLineStartBC<CR>", mode = { "n", "x" }, desc = "Upward line start hop" },
    { "<leader>k", "V<cmd>HopLineStartBC<CR>", mode = { "o" }, desc = "Upward line start hop" },
  },
  opts = {
    keys = "hgjfkdlsmqyturieozpabvn",
    uppercase_labels = true, -- Make labels stand-out more and be more readable
  },
}
