return {
  "chrisgrieser/nvim-various-textobjs",
  keys = {
    -- a/i text-objects
    {
      "aq",
      function() require("various-textobjs").anyQuote("outer") end,
      mode = { "x", "o" },
      desc = "quote",
    },
    {
      "iq",
      function() require("various-textobjs").anyQuote("inner") end,
      mode = { "x", "o" },
      desc = "inner quote",
    },
    {
      "at",
      function() require("various-textobjs").subword("outer") end,
      mode = { "x", "o" },
      desc = "token",
    },
    {
      "it",
      function() require("various-textobjs").subword("inner") end,
      mode = { "x", "o" },
      desc = "inner token",
    },
    {
      "ak",
      function() require("various-textobjs").key("outer") end,
      mode = { "x", "o" },
      desc = "key in key-value pair",
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
      desc = "value in key-value pair",
    },
    {
      "iv",
      function() require("various-textobjs").value("inner") end,
      mode = { "x", "o" },
      desc = "inner value in key-value pair",
    },
    {
      "a<Tab>",
      function() require("various-textobjs").indentation("outer", "outer") end,
      mode = { "x", "o" },
      desc = "indentation",
    },
    {
      "i<Tab>",
      function() require("various-textobjs").indentation("inner", "inner") end,
      mode = { "x", "o" },
      desc = "inner indentation",
    },

    -- Simple text-objects
    {
      "c",
      function() require("various-textobjs").lineCharacterwise("inner") end,
      mode = "o",
      desc = "Current line characterwise",
    },
    {
      "gG",
      function() require("various-textobjs").entireBuffer() end,
      mode = { "v", "o" },
      desc = "Entire buffer",
    },
    {
      "gf",
      function() require("various-textobjs").filepath() end,
      mode = "o",
      desc = "File path",
    },
    {
      "gu",
      function() require("various-textobjs").url() end,
      mode = "o",
      desc = "URL",
    },

    -- Forward-only text-objects
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
