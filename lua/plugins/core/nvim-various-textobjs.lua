-- nvim-various-textobjs
--
-- Provide a bundle of convenient rule-based textobjects to complete the builtin and treesitter
-- ones.

return {
  "chrisgrieser/nvim-various-textobjs",
  keys = function()
    local textobjs = require("various-textobjs")
    local mode = { "x", "o" }
    return {
      { "as", function() textobjs.subword("outer") end, mode = mode, desc = "a subword" },
      { "is", function() textobjs.subword("inner") end, mode = mode, desc = "inner subword" },
      { "gr", textobjs.toNextClosingBracket, mode = mode, desc = "Next right bracket" },
      { "gq", textobjs.toNextQuotationMark, mode = mode, desc = "Next quotation mark" },
      { "gm", textobjs.multiCommentedLines, mode = mode, desc = "Multi-line comment" },
      { "gG", textobjs.entireBuffer, mode = mode, desc = "Entire buffer" },
      { "gn", textobjs.nearEoL, mode = mode, desc = "Near end of line" },
      { "gl", function() textobjs.lineCharacterwise("inner") end, mode = mode, desc = "Line characterwise" },
      { "av", function() textobjs.value("outer") end, mode = mode, desc = "a key-value pair value" },
      { "iv", function() textobjs.value("inner") end, mode = mode, desc = "inner key-value pair value" },
      { "ak", function() textobjs.key("outer") end, mode = mode, desc = "a key-value pair key" },
      { "ik", function() textobjs.key("inner") end, mode = mode, desc = "inner key-value pair key" },
      { "gu", textobjs.url, mode = mode, desc = "URL" },
    }
  end,
}
