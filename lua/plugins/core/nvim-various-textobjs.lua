-- nvim-various-textobjs
--
-- Provide a bundle of convenient rule-based textobjects to complete the builtin and treesitter ones.

return {
  "chrisgrieser/nvim-various-textobjs",
  keys = function()
    local textobjs = require("various-textobjs")
    local charwise_textobjs = require("various-textobjs.charwise-textobjs")

    -- Implement smarter versions of builtin `gx` keymap for normal mode, but specific to URLs and with lookahead or
    -- buffer-wide search
    -- This is taken from https://github.com/chrisgrieser/nvim-various-textobjs?tab=readme-ov-file#smarter-gx

    --- Open the URL under the cursor or with lookahead.
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
      -- [[ Text objects ]]
      { "ai", function() textobjs.indentation("outer", "outer") end, mode = { "x", "o" }, desc = "an indentation" },
      { "ii", function() textobjs.indentation("inner", "inner") end, mode = { "x", "o" }, desc = "inner indentation" },
      { "I", textobjs.restOfIndentation, mode = { "x", "o" }, desc = "Rest of indentation" },
      { "as", function() textobjs.subword("outer") end, mode = { "x", "o" }, desc = "a subword" },
      { "is", function() textobjs.subword("inner") end, mode = { "x", "o" }, desc = "inner subword" },
      { "C", textobjs.toNextClosingBracket, mode = { "x", "o" }, desc = "Next right bracket" },
      { "Q", textobjs.toNextQuotationMark, mode = { "x", "o" }, desc = "Next quotation mark" },
      { "gG", textobjs.entireBuffer, mode = { "x", "o" }, desc = "Entire buffer" },
      { "g$", textobjs.nearEoL, mode = { "x", "o" }, desc = "Near end of line" },
      { "-", function() textobjs.lineCharacterwise("inner") end, mode = { "x", "o" }, desc = "Line characterwise" },
      { "av", function() textobjs.value("outer") end, mode = { "x", "o" }, desc = "a key-value pair value" },
      { "iv", function() textobjs.value("inner") end, mode = { "x", "o" }, desc = "inner key-value pair value" },
      { "ak", function() textobjs.key("outer") end, mode = { "x", "o" }, desc = "a key-value pair key" },
      { "ik", function() textobjs.key("inner") end, mode = { "x", "o" }, desc = "inner key-value pair key" },
      { "gx", textobjs.url, mode = { "x", "o" }, desc = "URL" },
      -- [[ Other ]]
      { "gx", open_cursor_url, mode = { "n" }, desc = "Open URL under cursor" },
      { "gX", open_any_url, mode = { "n" }, desc = "Open any URL in buffer" },
    }
  end,
}
