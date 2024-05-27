-- Hop
--
-- Hop provides Neovim motions on speed. It adds many simple but powerful features to simplify navigating in a file
-- using only the keyboard. I find this plugin essential in my workflow, especially since I don't use counts as, using
-- an azerty keyboard, typing numbers is far from the home row and requires the use of the shift key at the same time.
--
-- There are many alternatives to Hop, I tried some but Hop remained my favorite:
--  - flash.nvim is a more sophisticated alternative with cool features like Treesitter nodes or remote operations,
--    however I prefer the basic features of Hop and I find the more sophisticated features of flash.nvim not to be
--    essential
--  - leap.nvim is another more sophisticated alternative, also with cool features like Treesitter nodes or remote
--    operations, but it is focused on a single 2-character jump keymap, and I'm not a fan of this philosophy as it
--    always require to read some characters before jumping whereas in Hop, some keymaps don't require to read
--    characters beforehand (like word- or line-start jumps)

return {
  "smoka7/hop.nvim",
  keys = function()
    local hop = require("hop")
    local hint = require("hop.hint")

    local before_cursor = hint.HintDirection.BEFORE_CURSOR
    local after_cursor = hint.HintDirection.AFTER_CURSOR
    local end_ = hint.HintPosition.END

    return {
      -- Buitlin "s" keymap is equivalent to "cl" and is pretty much useless
      { "s", hop.hint_char2, mode = { "n", "x", "o" }, desc = "Search 2 characters hop" },
      {
        "f",
        function() hop.hint_char1({ direction = after_cursor, current_line_only = true }) end,
        mode = { "n", "x", "o" },
        desc = "Find character hop",
      },
      {
        "F",
        function() hop.hint_char1({ direction = before_cursor, current_line_only = true }) end,
        mode = { "n", "x", "o" },
        desc = "Find character hop backward",
      },
      {
        "t",
        function() hop.hint_char1({ direction = after_cursor, current_line_only = true, hint_offset = -1 }) end,
        mode = { "n", "x", "o" },
        desc = "Till character hop",
      },
      {
        "T",
        function() hop.hint_char1({ direction = before_cursor, current_line_only = true, hint_offset = 1 }) end,
        mode = { "n", "x", "o" },
        desc = "Till character hop backward",
      },
      {
        "<leader>w",
        function() hop.hint_words({ direction = after_cursor, current_line_only = true }) end,
        mode = { "n", "x", "o" },
        desc = "[W]ord hop",
      },
      {
        "<leader>b",
        function() hop.hint_words({ direction = before_cursor, current_line_only = true }) end,
        mode = { "n", "x", "o" },
        desc = "[B]ackward word hop",
      },
      {
        "<leader>e",
        function() hop.hint_words({ hint_position = end_, direction = after_cursor, current_line_only = true }) end,
        mode = { "n", "x", "o" },
        desc = "[E]nd of word hop",
      },
      {
        "<leader>E",
        function() hop.hint_words({ hint_position = end_, direction = before_cursor, current_line_only = true }) end,
        mode = { "n", "x", "o" },
        desc = "[E]nd of word hop backward",
      },
      {
        "<leader>s",
        function() hop.hint_camel_case({ direction = after_cursor, current_line_only = true }) end,
        mode = { "n", "x", "o" },
        desc = "[S]ubword hop",
      },
      {
        "<leader>S",
        function() hop.hint_camel_case({ direction = before_cursor, current_line_only = true }) end,
        mode = { "n", "x", "o" },
        desc = "[S]ubword hop backward",
      },
      -- In operator-pending mode, let's make line-related keymaps act linewise, like builtin operators like "y" or "d"
      { "<leader>j", "<cmd>HopLineStartAC<CR>", mode = { "n", "x" }, desc = "Downward line start hop" },
      { "<leader>j", "V<cmd>HopLineStartAC<CR>", mode = { "o" }, desc = "Downward line start hop" },
      { "<leader>k", "<cmd>HopLineStartBC<CR>", mode = { "n", "x" }, desc = "Upward line start hop" },
      { "<leader>k", "V<cmd>HopLineStartBC<CR>", mode = { "o" }, desc = "Upward line start hop" },
    }
  end,
  opts = {
    keys = "hgjfkdlsmqyturieozpabvn",
    uppercase_labels = true, -- Make labels stand-out more and be more readable
  },
}
