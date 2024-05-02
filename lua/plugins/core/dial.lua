-- dial.nvim
--
-- Dial is an enhanced increment/decrement plugin. It is simple of use and can be really extensively configured.

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
        augend.integer.alias.decimal,
        augend.constant.alias.bool,
      },
    })

    config.augends:on_filetype({
      lua = {
        augend.integer.alias.decimal,
        augend.constant.alias.bool,
        augend.constant.new({ elements = { "==", "~=" }, word = false }),
        augend.constant.new({ elements = { "if", "elseif", "else" } }),
      },
      markdown = {
        augend.integer.alias.decimal,
        augend.misc.alias.markdown_header,
        augend.constant.new({ elements = { "🎯", "⏳", "✅", "❌" } }),
      },
      python = {
        augend.integer.alias.decimal,
        augend.constant.new({ elements = { "True", "False" } }),
        augend.constant.new({ elements = { "==", "!=" }, word = false }),
        augend.constant.new({ elements = { "if", "elif", "else" } }),
      },
    })
  end,
}
