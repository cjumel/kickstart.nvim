-- toggleterm.nvim
--
-- toggleterm.nvim is a Neovim plugin to persist and interact with multiple terminals during an editing session. It
-- provides several improvements over the builtin terminal integration, which make it a really nice addition to Neovim,
-- while being quite simple.

return {
  "akinsho/toggleterm.nvim",
  keys = function()
    --- Output the existing terminals.
    ---@param only_opened boolean Whether to restrict the terminal to the opened ones.
    ---@return Terminal[]
    local function get_terms(only_opened)
      local terms = require("toggleterm.terminal").get_all(true)
      if only_opened then
        terms = vim.tbl_filter(function(term) return term:is_open() end, terms)
      end
      return terms
    end

    --- Select a terminal and run a callback on it.
    ---@param callback function Action to run on the selected terminal.
    ---@param opts table Options for the selection.
    ---@return nil
    local function select_term_and_run(callback, opts)
      opts = opts or {}
      local prompt = opts.prompt or "Select a terminal: "
      local only_opened = opts.only_opened or false

      local terms = get_terms(only_opened)
      if #terms == 0 then
        if only_opened then
          vim.notify("No terminal is opened", vim.log.levels.INFO)
        else
          vim.notify("No terminal found", vim.log.levels.INFO)
        end
      elseif #terms == 1 then
        callback(terms[1])
      else
        vim.ui.select(terms, {
          prompt = prompt,
          format_item = function(term)
            local display = term.id .. ": " .. term:_display_name()
            if not only_opened and term:is_open() then
              display = display .. " (open)"
            end
            return display
          end,
        }, function(_, idx)
          if idx == nil then -- The user canceled the selection
            return
          end
          callback(terms[idx])
        end)
      end
    end

    --- Get a new, unused terminal identifier.
    ---@return number
    local function get_new_term_id()
      local terms = get_terms(false)
      if #terms == 0 then
        return 1
      end
      return terms[#terms].id + 1
    end

    return {
      {
        "<leader>tt",
        function()
          local terms = get_terms(false)
          if #terms == 0 then
            require("toggleterm").toggle(get_new_term_id(), nil, nil, "horizontal")
          else
            select_term_and_run(function(term) term:toggle() end, { prompt = "Select a terminal to toggle: " })
          end
        end,
        desc = "[T]erminal: toggle",
      },
      {
        "<leader>ta",
        function() require("toggleterm").toggle_all() end,
        desc = "[T]erminal: toggle [A]ll",
      },
      {
        "<leader>tx",
        function() require("toggleterm").toggle(get_new_term_id(), nil, nil, "horizontal") end,
        desc = "[T]erminal: new in horizontal split",
      },
      {
        "<leader>tv",
        function() require("toggleterm").toggle(get_new_term_id(), nil, nil, "vertical") end,
        desc = "[T]erminal: new in [V]ertical split",
      },
      {
        "<leader>tn",
        function()
          select_term_and_run(
            function(term) vim.cmd(term.id .. "ToggleTermSetName") end,
            { prompt = "Select a terminal to name: " }
          )
        end,
        desc = "[T]erminal: [N]ame",
      },
      {
        "<leader>tr",
        function()
          select_term_and_run(function(term)
            local path = vim.fn.expand("%:p") -- Absolute current file path
            -- Make the path more user-friendly (relative to the cwd if in it, or absolute)
            --  Truncating the home directory with "~" doesn't work for some of the commands below
            path = vim.fn.fnamemodify(path, ":p:.")

            local line
            if vim.bo.filetype == "lua" then
              line = [[dofile("]] .. path .. [[")]]
            elseif vim.bo.filetype == "python" then
              line = [[exec(open("]] .. path .. [[").read())]]
            else
              error("Unsupported filetype: " .. vim.bo.filetype)
            end

            require("toggleterm").exec(line, term.id)
          end, { prompt = "Select a terminal to run in: ", only_opened = true })
        end,
        ft = { "lua", "python" },
        desc = "[T]erminal: [R]un file in shell",
      },
      {
        "<leader>t",
        function()
          select_term_and_run(function(term)
            local lines = require("visual_mode").get_lines({ trim_indent = true })
            require("toggleterm").exec(table.concat(lines, "\n"), term.id)
          end, { prompt = "Select a terminal to send to: ", only_opened = true })
        end,
        mode = "v",
        desc = "[T]erminal: send selection",
      },
    }
  end,
  opts = {
    size = function(term) -- Define relative size for horizontal and vertical splits
      if term.direction == "horizontal" then
        return vim.o.lines * 0.25
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
  },
}
