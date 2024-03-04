-- nvim-various-textobjs
--
-- Provide a bundle of convenient rule-based textobjects to complete the builtin and treesitter
-- ones.

return {
  "chrisgrieser/nvim-various-textobjs",
  keys = {
    {
      "as", -- Overwrite outer sentence builtin text object (useless when writing code)
      function()
        require("various-textobjs").subword("outer")
      end,
      mode = { "x", "o" },
      desc = "a subword",
    },
    {
      "is", -- Overwrite inner sentence builtin text object (useless when writing code)
      function()
        require("various-textobjs").subword("inner")
      end,
      mode = { "x", "o" },
      desc = "inner subword",
    },
    {
      "C",
      function()
        require("various-textobjs").toNextClosingBracket()
      end,
      mode = { "x", "o" },
      desc = "Next closing bracket",
    },
    {
      "Q",
      function()
        require("various-textobjs").toNextQuotationMark()
      end,
      mode = { "x", "o" },
      desc = "Next quotation mark",
    },
    {
      "gm", -- Similar to ag/ig in multi-line mode
      function()
        require("various-textobjs").multiCommentedLines()
      end,
      mode = { "x", "o" },
      desc = "Multi-line comment",
    },
    {
      "gG", -- Combine gg and G
      function()
        require("various-textobjs").entireBuffer()
      end,
      mode = { "x", "o" },
      desc = "Entire buffer",
    },
    {
      "`", -- Builtin is a register key useless in visual/object modes; just below $ (EOL)
      function()
        require("various-textobjs").nearEoL()
      end,
      mode = { "x", "o" },
      desc = "Near end of line",
    },
    {
      "-", -- Builtin is quivalent to j in visual/object modes
      function()
        require("various-textobjs").lineCharacterwise("inner") -- "outer" is useless
      end,
      mode = { "x", "o" },
      desc = "Line characterwise",
    },
    {
      "av",
      function()
        require("various-textobjs").value("outer")
      end,
      mode = { "x", "o" },
      desc = "a key-value pair value",
    },
    {
      "iv",
      function()
        require("various-textobjs").value("inner")
      end,
      mode = { "x", "o" },
      desc = "inner key-value pair value",
    },
    {
      "ak",
      function()
        require("various-textobjs").key("outer")
      end,
      mode = { "x", "o" },
      desc = "a key-value pair key",
    },
    {
      "ik",
      function()
        require("various-textobjs").key("inner")
      end,
      mode = { "x", "o" },
      desc = "inner key-value pair key",
    },
  },
}
