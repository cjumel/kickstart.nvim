-- nvim-various-textobjs
--
-- Bundle of more than two dozen new textobjects for Neovim.

return {
  "chrisgrieser/nvim-various-textobjs",
  keys = {
    {
      "as",
      function()
        require("various-textobjs").subword("outer")
      end,
      mode = { "x", "o" },
      desc = "a subword",
    },
    {
      "is",
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
      "aq",
      function()
        require("various-textobjs").anyQuote("outer")
      end,
      mode = { "x", "o" },
      desc = "a quote",
    },
    {
      "iq",
      function()
        require("various-textobjs").anyQuote("inner")
      end,
      mode = { "x", "o" },
      desc = "inner quote",
    },
    {
      "gm",
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
      "`", -- Just below $
      function()
        require("various-textobjs").nearEoL()
      end,
      mode = { "x", "o" },
      desc = "Near end of line",
    },
    {
      "-",
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
    {
      "aQ",
      function()
        require("various-textobjs").pyTripleQuotes("outer")
      end,
      mode = { "x", "o" },
      desc = "a Python triple quote",
    },
    {
      "iQ",
      function()
        require("various-textobjs").pyTripleQuotes("inner")
      end,
      mode = { "x", "o" },
      desc = "inner Python triple quote",
    },
  },
}
