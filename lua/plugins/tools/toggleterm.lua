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

    --- Select a terminal and run an action on it.
    ---@param action_name string Name of the action to display in the prompt.
    ---@param action function Action to run on the selected terminal.
    ---@return nil
    local function select_term_and_run(action_name, action)
      local terminals = terms.get_all(true)
      if #terminals == 0 then
        vim.notify("No terminal opened, yet", vim.log.levels.INFO)
      elseif #terminals == 1 then
        action(terminals[1])
      else
        vim.ui.select(terminals, {
          prompt = "Select a terminal to " .. action_name .. ": ",
          format_item = function(term)
            local s = term.id .. ": " .. term:_display_name()
            if term:is_open() then
              s = s .. " (open)"
            end
            return s
          end,
        }, function(_, idx) action(terminals[idx]) end)
      end
    end

    --- Get a new terminal id that is not already used.
    ---@return number
    local function get_new_term_id()
      local all = terms.get_all(true)
      for index, term in pairs(all) do
        if index ~= term.id then
          return index
        end
      end
      return #all + 1
    end

    return {
      {
        "<leader>tt",
        function()
          select_term_and_run("toggle", function(term) term:toggle() end)
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
          select_term_and_run("rename", function(term) vim.cmd(term.id .. "ToggleTermSetName") end)
        end,
        desc = "[T]erm: toggle [A]ll terminals",
      },
      {
        "<leader>t",
        function()
          local lines = utils.visual.get_lines({ trim_ws = true })
          select_term_and_run("send lines to", function(term) toggleterm.exec(table.concat(lines, "\n"), term.id) end)
        end,
        mode = "v",
        desc = "[T]erm: send selection",
      },
      {
        "<leader>T",
        function()
          local lines = utils.visual.get_lines({ trim_ws = false })
          select_term_and_run("send lines to", function(term) toggleterm.exec(table.concat(lines, "\n"), term.id) end)
        end,
        mode = "v",
        desc = "[T]erm: send selection with indentations",
      },
    }
  end,
  opts = {
    size = function(term) -- Define relative size for horizontal and vertical splits
      if term.direction == "horizontal" then
        return vim.o.lines * 0.3
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.5
      else
        return 20
      end
    end,
  },
}
