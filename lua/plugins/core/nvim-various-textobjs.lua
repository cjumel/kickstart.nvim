-- nvim-various-textobjs
--
-- nvim-various-textobjs provides a bundle of new simple rule-based text-objects, to complete builtin text objects as
-- well as the ones implemented by Treesitter in nvim-treesitter-textobjects. It is a very nice and customizable
-- addition for anyone who likes using text objects like me.

return {
  "chrisgrieser/nvim-various-textobjs",
  keys = {
    -- a/i text-objects
    {
      "aq",
      function() require("various-textobjs").anyQuote("outer") end,
      mode = { "x", "o" },
      desc = "a quote",
    },
    {
      "iq",
      function() require("various-textobjs").anyQuote("inner") end,
      mode = { "x", "o" },
      desc = "inner quote",
    },
    {
      "as",
      function() require("various-textobjs").subword("outer") end,
      mode = { "x", "o" },
      desc = "a subword",
    },
    {
      "is",
      function() require("various-textobjs").subword("inner") end,
      mode = { "x", "o" },
      desc = "inner subword",
    },
    {
      "ak",
      function() require("various-textobjs").key("outer") end,
      mode = { "x", "o" },
      desc = "a key in key-value pair",
    },
    {
      "ik",
      function() require("various-textobjs").key("inner") end,
      mode = { "x", "o" },
      desc = "inner key in key-value pair",
    },
    {
      "av",
      function() require("various-textobjs").value("outer") end,
      mode = { "x", "o" },
      desc = "a value in key-value pair",
    },
    {
      "iv",
      function() require("various-textobjs").value("inner") end,
      mode = { "x", "o" },
      desc = "inner value in key-value pair",
    },
    {
      "ai",
      function() require("various-textobjs").indentation("outer", "outer") end,
      mode = { "x", "o" },
      desc = "an indentation",
    },
    {
      "ii",
      function() require("various-textobjs").indentation("inner", "inner") end,
      mode = { "x", "o" },
      desc = "inner indentation",
    },

    -- Simple text-objects
    {
      "gG",
      function() require("various-textobjs").entireBuffer() end,
      mode = { "x", "o" },
      desc = "Entire buffer",
    },
    {
      "ga", -- "gu" & "gU" are taken by casing operators, "gw" by a format operator (see `:h gw`)
      function() require("various-textobjs").url() end,
      mode = { "x", "o" },
      desc = "Web address",
    },

    -- Forward-only text-objects
    -- These text-objects are only implemented in operator-pending mode, to avoid overriding the corresponding keys in
    --  visual mode as their might be conflicts
    {
      "c",
      function() require("various-textobjs").lineCharacterwise("inner") end,
      mode = "o",
      desc = "Current line characterwise",
    },
    {
      "r",
      function() require("various-textobjs").toNextClosingBracket() end,
      mode = "o",
      desc = "Next right-hand-side bracket",
    },
    {
      "q",
      function() require("various-textobjs").toNextQuotationMark() end,
      mode = "o",
      desc = "Next quotation mark",
    },
    {
      "o",
      function() require("various-textobjs").nearEoL() end,
      mode = "o",
      desc = "One character before EOL",
    },
    {
      "p",
      function() require("various-textobjs").restOfParagraph() end,
      mode = "o",
      desc = "Rest of paragraph",
    },
    {
      "<Tab>",
      function() require("various-textobjs").restOfIndentation() end,
      mode = "o",
      desc = "Rest of indentation",
    },
  },
}
