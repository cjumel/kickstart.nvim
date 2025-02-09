-- Hop
--
-- Hop provides Neovim motions on speed. It adds many simple but powerful features to simplify navigating in a file
-- using only the keyboard. I find this plugin essential in my workflow, especially since I don't use counts as, using
-- an azerty keyboard, typing numbers is far from the home row and requires the use of the shift key at the same time.

return {
  "smoka7/hop.nvim",
  keys = {
    {
      "s", -- Buitlin "s" keymap is equivalent to "cl" and is pretty much useless
      function() require("hop").hint_char2({}) end,
      mode = { "n", "x", "o" },
      desc = "Search character jump",
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
      desc = "Find character jump",
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
      desc = "Find character jump backward",
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
      desc = "Till character jump",
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
      desc = "Till character jump backward",
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
      desc = "[E]nd of word jump backward",
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
      desc = "[S]ubword jump",
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
      desc = "[S]ubword jump backward",
    },
    -- In operator-pending mode, let's make line-related keymaps act linewise, like builtin operators like "y" or "d"
    { "<leader>j", "<cmd>HopLineStartAC<CR>", mode = { "n", "x" }, desc = "Downward line jump" },
    { "<leader>j", "V<cmd>HopLineStartAC<CR>", mode = { "o" }, desc = "Downward line jump" },
    { "<leader>k", "<cmd>HopLineStartBC<CR>", mode = { "n", "x" }, desc = "Upward line jump" },
    { "<leader>k", "V<cmd>HopLineStartBC<CR>", mode = { "o" }, desc = "Upward line jump" },
  },
  opts = {
    keys = "hgjfkdlsmqyturieozpabvn",
    uppercase_labels = true, -- Make labels stand-out more
  },
}
