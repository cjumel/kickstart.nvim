-- Hop
--
-- Hop is a plugin enabling fast in-file navigation.

return {
  "smoka7/hop.nvim",
  keys = function()
    local hop = require("hop")
    local hint = require("hop.hint")

    local before_cursor = hint.HintDirection.BEFORE_CURSOR
    local after_cursor = hint.HintDirection.AFTER_CURSOR
    local end_ = hint.HintPosition.END

    return {
      -- Buitlin "s" keymap is equivalent to "cl"
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
      { "<leader>j", "<cmd> HopLineStartAC <cr>", mode = { "n", "x" }, desc = "Downward line start hop" },
      { "<leader>J", "<cmd> HopVerticalAC <cr>", mode = { "n", "x" }, desc = "Downward vertical hop" },
      { "<leader>k", "<cmd> HopLineStartBC <cr>", mode = { "n", "x" }, desc = "Upward line start hop" },
      { "<leader>K", "<cmd> HopVerticalBC <cr>", mode = { "n", "x" }, desc = "Upward vertical hop" },
      -- In operator-pending mode, make line-related keymaps act linewise, like builtin operators like "y", "d", etc.
      { "<leader>j", "V<cmd> HopLineStartAC <cr>", mode = { "o" }, desc = "Downward line start hop" },
      { "<leader>J", "V<cmd> HopVerticalAC <cr>", mode = { "o" }, desc = "Downward vertical hop" },
      { "<leader>k", "V<cmd> HopLineStartBC <cr>", mode = { "o" }, desc = "Upward line start hop" },
      { "<leader>K", "V<cmd> HopVerticalBC <cr>", mode = { "o" }, desc = "Upward vertical hop" },
    }
  end,
  opts = {
    keys = "hgjfkdlsmqyturieozpabvn",
    uppercase_labels = true,
  },
}
