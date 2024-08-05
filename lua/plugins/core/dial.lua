-- dial.nvim
--
-- dial.nvim is an enhanced increment/decrement plugin. It is simple of use and can be really extensively configured,
-- for instance to increment/decrement custom patterns or emojis, e.g. to mark todo items as "in progress" or "done". I
-- find it really useful for small but cool filetype-specific additions.

return {
  "monaqa/dial.nvim",
  keys = {
    { "<C-a>", function() require("dial.map").manipulate("increment", "normal") end, mode = "n", desc = "Increment" },
    { "<C-a>", function() require("dial.map").manipulate("increment", "visual") end, mode = "v", desc = "Increment" },
    { "<C-x>", function() require("dial.map").manipulate("decrement", "normal") end, mode = "n", desc = "Decrement" },
    { "<C-x>", function() require("dial.map").manipulate("decrement", "visual") end, mode = "v", desc = "Decrement" },
  },
  config = function(_, _)
    local augend = require("dial.augend")
    local config = require("dial.config")

    config.augends:register_group({
      default = {
        augend.constant.new({ elements = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" }, word = false }),
        augend.constant.new({ elements = { "true", "false" } }),
        augend.constant.new({ elements = { "True", "False" } }),
      },
    })

    config.augends:on_filetype({
      lua = {
        augend.constant.new({ elements = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" }, word = false }),
        augend.constant.new({ elements = { "true", "false" } }),
        augend.constant.new({ elements = { "==", "~=" }, word = false }),
      },
      markdown = {
        augend.constant.new({ elements = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" }, word = false }),
        augend.constant.new({ elements = { "true", "false" } }),
        augend.constant.new({ elements = { "True", "False" } }),
        augend.misc.alias.markdown_header,
        augend.constant.new({ elements = { "- [ ]", "- [x]" }, word = false }),
        augend.constant.new({ elements = { "- \\[ \\]", "- \\[x\\]" }, word = false }), -- After mdformat formatting
        -- Todomojis: todo items with emojis
        --  🎯 (:dart:) -> todo
        --  ⌛ (:hourglass:) -> in progress
        --  ✅ (:white_check_mark:) -> done
        --  ❌ (:x:) -> cancelled
        augend.constant.new({ elements = { "🎯", "⌛", "✅", "❌" } }),
      },
      python = {
        augend.constant.new({ elements = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" }, word = false }),
        augend.constant.new({ elements = { "True", "False" } }),
        augend.constant.new({ elements = { "==", "!=" }, word = false }),
      },
    })
  end,
}
