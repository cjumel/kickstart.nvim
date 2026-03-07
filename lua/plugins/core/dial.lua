return {
  "monaqa/dial.nvim",
  keys = {
    { "<C-a>", function() require("dial.map").manipulate("increment", "normal") end, mode = "n", desc = "Increment" },
    { "<C-a>", function() require("dial.map").manipulate("increment", "visual") end, mode = "v", desc = "Increment" },
    { "<C-x>", function() require("dial.map").manipulate("decrement", "normal") end, mode = "n", desc = "Decrement" },
    { "<C-x>", function() require("dial.map").manipulate("decrement", "visual") end, mode = "v", desc = "Decrement" },
  },
  config = function()
    local augend = require("dial.augend")
    local config = require("dial.config")

    config.augends:register_group({
      default = {
        augend.integer.alias.decimal,
        augend.constant.alias.bool,
        augend.constant.alias.Bool,
        augend.constant.new({ elements = { "==", "!=" }, word = false }),
      },
    })

    config.augends:on_filetype({
      lua = {
        augend.integer.alias.decimal,
        augend.constant.alias.bool,
        augend.constant.alias.Bool,
        augend.constant.new({ elements = { "==", "~=" }, word = false }),
      },
      markdown = {
        augend.integer.alias.decimal,
        augend.constant.alias.bool,
        augend.constant.alias.Bool,
        augend.constant.new({ elements = { "==", "!=" }, word = false }),
        augend.misc.alias.markdown_header,
        augend.constant.new({ elements = { "- [ ] ", "- [x] ", "- [-] ", "- [o] ", "- [/] " }, word = false }),
      },
    })
  end,
}
