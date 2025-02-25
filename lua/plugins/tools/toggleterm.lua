-- toggleterm.nvim
--
-- A Neovim plugin to persist and interact with multiple terminals during an editing session. This plugin improves the
-- builtin terminal feature, and, while this feature is a bit redundant with terminal multiplexer features (lime tmux),
-- toggleterm.nvim adds an additional layer of interactivity, making it very nice to hide or show a terminal window, or
-- send command or text to it.

return {
  "akinsho/toggleterm.nvim",
  keys = function()
    --- Output the existing ToggleTerm terminals.
    ---@param only_opened boolean Whether to restrict the output terminals to the currently opened ones.
    ---@return Terminal[]
    local function get_terms(only_opened)
      local terms = require("toggleterm.terminal").get_all(true)
      if only_opened then
        terms = vim.tbl_filter(function(term) return term:is_open() end, terms)
      end
      return terms
    end

    --- Select a ToggleTerm terminal among the existing ones, and run a callback on it.
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

    --- Get a new, unused ToggleTerm terminal identifier.
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
          if #get_terms(false) == 0 then
            require("toggleterm").toggle(get_new_term_id(), nil, nil, "horizontal")
          else
            select_term_and_run(function(term) term:toggle() end, { prompt = "Select a terminal to toggle: " })
          end
        end,
        desc = "[T]erminal: toggle",
      },
      { "<leader>ta", function() require("toggleterm").toggle_all() end, desc = "[T]erminal: toggle [A]ll" },
      {
        "<leader>ts",
        function() require("toggleterm").toggle(get_new_term_id(), nil, nil, "horizontal") end,
        desc = "[T]erminal: new terminal in [S]plit",
      },
      {
        "<leader>tv",
        function() require("toggleterm").toggle(get_new_term_id(), nil, nil, "vertical") end,
        desc = "[T]erminal: new terminal in [V]ertical split",
      },
      {
        "<leader>tn",
        function()
          select_term_and_run(
            function(term) vim.cmd(term.id .. "ToggleTermSetName") end,
            { prompt = "Select a terminal to rename: " }
          )
        end,
        desc = "[T]erminal: change terminal [N]ame",
      },
      {
        "<leader>t",
        function()
          select_term_and_run(function(term)
            local lines = require("visual_mode").get_lines({ trim_indent = true })
            require("toggleterm").exec(table.concat(lines, "\n"), term.id)
          end, { prompt = "Select a terminal to send to: ", only_opened = true })
        end,
        mode = "x",
        desc = "[T]erminal: send selection",
      },
      {
        "<leader>tr",
        function()
          select_term_and_run(function(term)
            local path = vim.fn.expand("%:p:.") -- Truncating the home directory with "~" doesn't always work
            if vim.bo.filetype == "lua" then
              require("toggleterm").exec([[dofile("]] .. path .. [[")]], term.id)
            elseif vim.bo.filetype == "python" then
              require("toggleterm").exec([[exec(open("]] .. path .. [[").read())]], term.id)
            else
              error("Unsupported filetype: " .. vim.bo.filetype)
            end
          end, { prompt = "Select a terminal to run the file in: ", only_opened = true })
        end,
        ft = { "lua", "python" },
        desc = "[T]erminal: [R]un file in REPL",
      },
    }
  end,
  opts = {
    size = function(term)
      if term.direction == "horizontal" then
        return vim.o.lines * 0.3
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
  },
}
