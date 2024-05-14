-- substitute.nvim
--
-- Plugin aiming to provide new operator motions to make it very easy to perform quick substitutions and exchange.

return {
  "gbprod/substitute.nvim",
  keys = function()
    local exchange = require("substitute.exchange")
    local range = require("substitute.range")
    local substitute = require("substitute")

    local overwrite_range_opts = {
      register = "0", -- Replacement is taken from the default register
      auto_apply = true,
    }

    return {
      { "gp", substitute.operator, desc = "Paste over" },
      { "gpc", substitute.line, desc = "Paste over current line" },
      { "gp", substitute.visual, mode = "x", desc = "Paste over" },
      { "go", function() range.operator(overwrite_range_opts) end, desc = "Overwrite" },
      {
        "goc",
        function() range.operator(vim.tbl_deep_extend("force", overwrite_range_opts, { range = "%" })) end,
        desc = "Overwrite in current buffer",
      },
      { "go", function() range.visual_range(overwrite_range_opts) end, mode = "x", desc = "Overwrite" },
      { "gs", range.operator, desc = "Substitute" },
      { "gsc", function() range.operator({ range = "%" }) end, desc = "Substitute in current buffer" },
      { "gs", range.visual_range, mode = "x", desc = "Substitute" },
      -- I don't use builtin "ge", it can be replaced with Hop's equivalent or with "F" so let's remap it here
      { "ge", exchange.operator, desc = "Exchange" },
      { "gec", exchange.line, desc = "Exchange current line" },
      { "ge", exchange.visual, mode = "x", desc = "Exchange" },
    }
  end,
  opts = {},
}
