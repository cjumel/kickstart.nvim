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
      "a<Tab>",
      function() require("various-textobjs").indentation("outer", "outer") end,
      mode = { "x", "o" },
      desc = "an indentation",
    },
    {
      "i<Tab>",
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
      "gx",
      function() require("various-textobjs").url() end,
      mode = { "x", "o" },
      desc = "URL",
    },

    -- Forward-only text-objects
    --  These text-objects are only implemented in operator-pending mode, to avoid overriding the corresponding keys
    --  in visual mode as their might be conflicts
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

    -- Normal mode keymaps
    -- Open the URL under the cursor or with lookahead
    --  This is taken from https://github.com/chrisgrieser/nvim-various-textobjs?tab=readme-ov-file#smarter-gx
    {
      "gx",
      function()
        require("various-textobjs").url() -- Select the URL under the cursor or with lookahead
        local url_found = vim.fn.mode():find("v")
        if not url_found then
          return
        end
        vim.cmd.normal({ '"zy', bang = true }) -- Retrieve the URL with the z-register as intermediary
        local url = vim.fn.getreg("z")
        vim.ui.open(url)
      end,
      mode = "n",
      desc = "Open URL under cursor",
    },
    -- Find all URLs in the current buffer and prompt the user to select one to open
    --  This is taken from https://github.com/chrisgrieser/nvim-various-textobjs?tab=readme-ov-file#smarter-gx
    {
      "gX",
      function()
        -- Find all URLs in the current buffer
        local url_pattern = require("various-textobjs.charwise-textobjs").urlPattern
        local buf_text = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
        local urls = {}
        for url in buf_text:gmatch(url_pattern) do
          if not vim.tbl_contains(urls, url) then -- Avoid duplicates
            table.insert(urls, url)
          end
        end
        if #urls == 0 then
          return
        end

        -- Select an URL & open it
        vim.ui.select(urls, { prompt = "Select URL:" }, function(choice)
          if choice then
            vim.ui.open(choice)
          end
        end)
      end,
      mode = "n",
      desc = "Open any URL in buffer",
    },
  },
}
