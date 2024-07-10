-- nvim-various-textobjs
--
-- nvim-various-textobjs provides a bundle of new simple rule-based text-objects, to complete builtin text objects as
-- well as the ones implemented by Treesitter in `nvim-treesitter-textobjects`. It is a very nice and customizable
-- addition for anyone who likes using text objects.

return {
  "chrisgrieser/nvim-various-textobjs",
  keys = function()
    local textobjs = require("various-textobjs")
    local charwise_textobjs = require("various-textobjs.charwise-textobjs")

    --- Open the URL under the cursor or with lookahead.
    -- This is taken from https://github.com/chrisgrieser/nvim-various-textobjs?tab=readme-ov-file#smarter-gx.
    ---@return nil
    local function open_cursor_url()
      textobjs.url() -- Select the URL under the cursor or with lookahead
      local url_found = vim.fn.mode():find("v")
      if not url_found then
        return
      end
      vim.cmd.normal({ '"zy', bang = true }) -- Retrieve the URL with the z-register as intermediary
      local url = vim.fn.getreg("z")
      vim.ui.open(url)
    end

    --- Find all URLs in the current buffer and prompt the user to select one to open.
    -- This is taken from https://github.com/chrisgrieser/nvim-various-textobjs?tab=readme-ov-file#smarter-gx.
    ---@return nil
    local function open_any_url()
      -- Find all URLs in the current buffer
      local url_pattern = charwise_textobjs.urlPattern
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
    end

    return {
      -- a/i text-objects
      { "aq", function() textobjs.anyQuote("outer") end, mode = { "x", "o" }, desc = "a quote" },
      { "iq", function() textobjs.anyQuote("inner") end, mode = { "x", "o" }, desc = "inner quote" },
      { "as", function() textobjs.subword("outer") end, mode = { "x", "o" }, desc = "a subword" },
      { "is", function() textobjs.subword("inner") end, mode = { "x", "o" }, desc = "inner subword" },
      { "ak", function() textobjs.key("outer") end, mode = { "x", "o" }, desc = "a key in key-value pair" },
      { "ik", function() textobjs.key("inner") end, mode = { "x", "o" }, desc = "inner key in key-value pair" },
      { "av", function() textobjs.value("outer") end, mode = { "x", "o" }, desc = "a value in key-value pair" },
      { "iv", function() textobjs.value("inner") end, mode = { "x", "o" }, desc = "inner value in key-value pair" },
      { "a<Tab>", function() textobjs.indentation("outer", "outer") end, mode = { "x", "o" }, desc = "an indentation" },
      {
        "i<Tab>",
        function() textobjs.indentation("inner", "inner") end,
        mode = { "x", "o" },
        desc = "inner indentation",
      },

      -- Simple text-objects
      { "gG", textobjs.entireBuffer, mode = { "x", "o" }, desc = "Entire buffer" },
      { "gx", textobjs.url, mode = { "x", "o" }, desc = "URL" },

      -- Forward-only text-objects
      --  These text-objects are only implemented in operator-pending mode, to avoid overriding the corresponding keys
      --  in visual mode as their might be conflicts
      { "c", function() textobjs.lineCharacterwise("inner") end, mode = "o", desc = "Current line characterwise" },
      { "r", textobjs.toNextClosingBracket, mode = "o", desc = "Next right-hand-side bracket" },
      { "q", textobjs.toNextQuotationMark, mode = "o", desc = "Next quotation mark" },
      { "o", textobjs.nearEoL, mode = "o", desc = "One character before EOL" },
      { "p", textobjs.restOfParagraph, mode = "o", desc = "Rest of paragraph" },
      { "<Tab>", textobjs.restOfIndentation, mode = "o", desc = "Rest of indentation" },

      -- Normal mode keymaps
      { "gx", open_cursor_url, mode = "n", desc = "Open URL under cursor" },
      { "gX", open_any_url, mode = "n", desc = "Open any URL in buffer" },
    }
  end,
}
