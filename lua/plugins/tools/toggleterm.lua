-- toggleterm.nvim
--
-- A neovim plugin to persist and interact with (hide, send code, etc.) multiple terminals during
-- an editing session.

return {
  "akinsho/toggleterm.nvim",
  keys = function()
    local toggleterm = require("toggleterm")
    local terms = require("toggleterm.terminal")

    local utils = require("utils")

    --- Select a terminal and run a callback on it.
    ---@param callback function Action to run on the selected terminal.
    ---@param opts table Options for the selection.
    ---@return nil
    local function select_term_and_run(callback, opts)
      opts = opts or {}
      local prompt = opts.prompt or "Select a terminal: "
      local only_opened = opts.only_opened or false

      local terminals = terms.get_all(true)
      if only_opened then
        terminals = vim.tbl_filter(function(term) return term:is_open() end, terminals)
      end

      if #terminals == 0 then
        if only_opened then
          vim.notify("No terminal is opened", vim.log.levels.INFO)
        else
          vim.notify("No terminal found", vim.log.levels.INFO)
        end
      elseif #terminals == 1 then
        callback(terminals[1])
      else
        vim.ui.select(terminals, {
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
          callback(terminals[idx])
        end)
      end
    end

    --- Get a new, unused terminal identifier.
    ---@return number
    local function get_new_term_id()
      local all = terms.get_all(true) -- Result is sorted by term.id
      if #all == 0 then
        return 1
      end
      return all[#all].id + 1
    end

    return {
      {
        "<leader>tt",
        function()
          select_term_and_run(function(term) term:toggle() end, { prompt = "Select a terminal to toggle: " })
        end,
        desc = "[T]erm: toggle [T]erminal",
      },
      { "<leader>ta", toggleterm.toggle_all, desc = "[T]erm: toggle [A]ll terminals" },
      {
        "<leader>tn",
        function() toggleterm.toggle(get_new_term_id(), nil, nil, "horizontal") end,
        desc = "[T]erm: [N]ew term",
      },
      {
        "<leader>tv",
        function() toggleterm.toggle(get_new_term_id(), nil, nil, "vertical") end,
        desc = "[T]erm: new term in [V]split",
      },
      {
        "<leader>tr",
        function()
          select_term_and_run(
            function(term) vim.cmd(term.id .. "ToggleTermSetName") end,
            { prompt = "Select a terminal to rename: " }
          )
        end,
        desc = "[T]erm: toggle [A]ll terminals",
      },
      {
        "<leader>t",
        function()
          local opts = vim.g.toggleterm_send_lines_last_opts -- Re-use the last options set by the user, if any
          local lines = utils.visual.get_lines(opts)
          select_term_and_run(
            function(term) toggleterm.exec(table.concat(lines, "\n"), term.id) end,
            { prompt = "Select a terminal to send to: ", only_opened = true }
          )
        end,
        mode = "v",
        desc = "[T]erm: send selection",
      },
      {
        "<leader>T",
        function()
          -- Lines cannot be fetched in the `vim.ui.select` callback, so we fetch them here & apply the options later
          local lines = utils.visual.get_lines()

          vim.ui.select(
            { "None", "Trim global indentation", "Trim leading whitespaces" },
            { prompt = "Select options: " },
            function(choice)
              local opts = {}
              if choice == "Trim global indentation" then
                opts.trim_indent = true
                lines = utils.visual.trim_lines_indent(lines)
              elseif choice == "Trim leading whitespaces" then
                opts.trim_ws = true
                lines = utils.visual.trim_lines_ws(lines)
              end
              vim.g.toggleterm_send_lines_last_opts = opts

              select_term_and_run(
                function(term) toggleterm.exec(table.concat(lines, "\n"), term.id) end,
                { prompt = "Select a terminal to send to: ", only_opened = true }
              )
            end
          )
        end,
        mode = "v",
        desc = "[T]erm: send selection with options",
      },
    }
  end,
  opts = {
    size = function(term) -- Define relative size for horizontal and vertical splits
      if term.direction == "horizontal" then
        return vim.o.lines * 0.25
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.5
      else
        return 20
      end
    end,
  },
}
