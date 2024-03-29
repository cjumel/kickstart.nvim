-- nvim-various-textobjs
--
-- Provide a bundle of convenient rule-based textobjects to complete the builtin and treesitter
-- ones.

return {
  "chrisgrieser/nvim-various-textobjs",
  keys = {
    -- as/is overwrite the builtin outer/inner sentence text objects (useless when writing code)
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
      "gr", -- gb & gc are taken by comments.nvim
      function()
        require("various-textobjs").toNextClosingBracket()
      end,
      mode = { "x", "o" },
      desc = "Next right bracket",
    },
    {
      "gq",
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
      "gn",
      function()
        require("various-textobjs").nearEoL()
      end,
      mode = { "x", "o" },
      desc = "Near end of line",
    },
    {
      -- Only exception to the "g" prefix convention, because "-" is very convenient (accessible
      -- & only one key stroke), and `gl` would conflict with other keymaps
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
      "gu",
      function()
        require("various-textobjs").url()
      end,
      mode = { "x", "o" },
      desc = "URL",
    },
  },
}
