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
      ft = "*",
    },
    {
      "is",
      function()
        require("various-textobjs").subword("inner")
      end,
      mode = { "x", "o" },
      desc = "inner subword",
      ft = "*",
    },
    {
      "C",
      function()
        require("various-textobjs").toNextClosingBracket()
      end,
      mode = { "x", "o" },
      desc = "Next closing bracket",
      ft = "*",
    },
    {
      "Q",
      function()
        require("various-textobjs").toNextQuotationMark()
      end,
      mode = { "x", "o" },
      desc = "Next quotation mark",
      ft = "*",
    },
    {
      "aG",
      function()
        require("various-textobjs").multiCommentedLines()
      end,
      mode = { "x", "o" },
      desc = "a multi-line comment",
      ft = "*",
    },
    {
      "iG",
      function()
        require("various-textobjs").multiCommentedLines()
      end,
      mode = { "x", "o" },
      desc = "inner multi-line comment",
      ft = "*",
    },
    {
      "aA",
      function()
        require("various-textobjs").entireBuffer()
      end,
      mode = { "x", "o" },
      desc = "an entire buffer",
      ft = "*",
    },
    {
      "iA",
      function()
        require("various-textobjs").entireBuffer()
      end,
      mode = { "x", "o" },
      desc = "inner entire buffer",
      ft = "*",
    },
    {
      "a-",
      function()
        require("various-textobjs").lineCharacterwise("outer")
      end,
      mode = { "x", "o" },
      desc = "a line characterwise",
      ft = "*",
    },
    {
      "i-",
      function()
        require("various-textobjs").lineCharacterwise("inner")
      end,
      mode = { "x", "o" },
      desc = "inner line characterwise",
      ft = "*",
    },
    {
      "av",
      function()
        require("various-textobjs").value("outer")
      end,
      mode = { "x", "o" },
      desc = "a key-value pair value",
      ft = "*",
    },
    {
      "iv",
      function()
        require("various-textobjs").value("inner")
      end,
      mode = { "x", "o" },
      desc = "inner key-value pair value",
      ft = "*",
    },
    {
      "ak",
      function()
        require("various-textobjs").key("outer")
      end,
      mode = { "x", "o" },
      desc = "a key-value pair key",
      ft = "*",
    },
    {
      "ik",
      function()
        require("various-textobjs").key("inner")
      end,
      mode = { "x", "o" },
      desc = "inner key-value pair key",
      ft = "*",
    },
  },
}
