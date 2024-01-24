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
      "aG",
      function()
        require("various-textobjs").multiCommentedLines()
      end,
      mode = { "x", "o" },
      desc = "a multi-line comment",
    },
    {
      "iG",
      function()
        require("various-textobjs").multiCommentedLines()
      end,
      mode = { "x", "o" },
      desc = "inner multi-line comment",
    },
    {
      "aA",
      function()
        require("various-textobjs").entireBuffer()
      end,
      mode = { "x", "o" },
      desc = "an entire buffer",
    },
    {
      "iA",
      function()
        require("various-textobjs").entireBuffer()
      end,
      mode = { "x", "o" },
      desc = "inner entire buffer",
    },
    {
      "a-",
      function()
        require("various-textobjs").lineCharacterwise("outer")
      end,
      mode = { "x", "o" },
      desc = "a line characterwise",
    },
    {
      "i-",
      function()
        require("various-textobjs").lineCharacterwise("inner")
      end,
      mode = { "x", "o" },
      desc = "inner line characterwise",
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
