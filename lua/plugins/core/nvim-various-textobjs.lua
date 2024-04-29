-- nvim-various-textobjs
--
-- Provide a bundle of convenient rule-based textobjects to complete the builtin and treesitter ones.

return {
  "chrisgrieser/nvim-various-textobjs",
  keys = function()
    local textobjs = require("various-textobjs")
    local charwise_textobjs = require("various-textobjs.charwise-textobjs")

    -- Implement a smarter "gx" keymap for normal mode, with nvim-various-textobjs lookahead
    -- This is adapted from: https://github.com/chrisgrieser/nvim-various-textobjs?tab=readme-ov-file#smarter-gx

    --- Open the provided URL in the system's default application.
    ---@param url string The URL to open.
    ---@return nil
    local function open_url(url)
      local opener
      if vim.fn.has("macunix") == 1 then
        opener = "open"
      elseif vim.fn.has("linux") == 1 then
        opener = "xdg-open"
      elseif vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1 then
        opener = "start"
      end
      local open_command = string.format("%s '%s' >/dev/null 2>&1", opener, url)
      vim.fn.system(open_command)
    end

    --- Find all URLs in the current buffer and prompt the user to select one to open.
    ---@return nil
    local function open_any_url()
      -- Find all URLs in the current buffer
      local url_pattern = charwise_textobjs.urlPattern
      local buf_text = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
      local urls = {}
      for url in buf_text:gmatch(url_pattern) do
        if not vim.tbl_contains(urls, url) then
          table.insert(urls, url)
        end
      end
      if #urls == 0 then
        return
      end
      -- Select an URL & open it
      vim.ui.select(urls, { prompt = "Select URL:" }, function(choice)
        if choice then
          open_url(choice)
        end
      end)
    end

    --- Open an URL under the cursor or with lookahead using the system's default application.
    ---@return nil
    local function smart_gx()
      textobjs.url() -- Select an URL
      local url_found = vim.fn.mode():find("v")
      if url_found then
        -- Retrieve the URL with the z-register as intermediary
        vim.cmd.normal({ '"zy', bang = true })
        local url = vim.fn.getreg("z")
        open_url(url)
      else
        open_any_url()
      end
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
      { "gm", textobjs.multiCommentedLines, mode = { "x", "o" }, desc = "Multi-line comment" },
      { "gG", textobjs.entireBuffer, mode = { "x", "o" }, desc = "Entire buffer" },
      { "g$", textobjs.nearEoL, mode = { "x", "o" }, desc = "Near end of line" },
      { "-", function() textobjs.lineCharacterwise("inner") end, mode = { "x", "o" }, desc = "Line characterwise" },
      { "av", function() textobjs.value("outer") end, mode = { "x", "o" }, desc = "a key-value pair value" },
      { "iv", function() textobjs.value("inner") end, mode = { "x", "o" }, desc = "inner key-value pair value" },
      { "ak", function() textobjs.key("outer") end, mode = { "x", "o" }, desc = "a key-value pair key" },
      { "ik", function() textobjs.key("inner") end, mode = { "x", "o" }, desc = "inner key-value pair key" },
      { "gx", textobjs.url, mode = { "x", "o" }, desc = "URL" },
      -- [[ Other ]]
      { "gx", smart_gx, mode = { "n" }, desc = "Open URL under cursor" },
      { "gX", open_any_url, mode = { "n" }, desc = "Open any URL in buffer" },
    }
  end,
}
