-- toggleterm.nvim
--
-- A neovim plugin to persist and interact with (hide, send code, etc.) multiple terminals during
-- an editing session.

-- Following function is taken from toggleterm/terminal.lua

--- Get the next available id based on the next number in the sequence that
--- hasn't already been allocated e.g. in a list of {1,2,5,6} the next id should
--- be 3 then 4 then 7
---@return integer
local function next_id()
  local all = require("toggleterm.terminal").get_all(true)
  for index, term in pairs(all) do
    if index ~= term.id then
      return index
    end
  end
  return #all + 1
end

return {
  "akinsho/toggleterm.nvim",
  keys = {
    {
      "<leader>tt",
      function()
        require("toggleterm").toggle_all()
      end,
      desc = "[T]oggleTerm: [T]oggle",
    },
    {
      "<leader>tn",
      function()
        require("toggleterm").toggle(next_id(), nil, nil, "horizontal")
      end,
      desc = "[T]oggleTerm: [N]ew terminal",
    },
    {
      "<leader>tv",
      function()
        require("toggleterm").toggle(next_id(), nil, nil, "vertical")
      end,
      desc = "[T]oggleTerm: new terminal in [V]ertical split",
    },
    {
      "<leader>tl",
      function()
        require("toggleterm").send_lines_to_terminal(
          "single_line",
          true, -- wether to trim spaces or not
          { args = vim.v.count }
        )
      end,
      desc = "[T]oggleTerm: send [L]ine (trimmed)",
    },
    -- Send lines with "visual_selection" mode doesn't work in visual line mode so we need to
    -- define keymaps with "visual_lines" mode as well
    {
      "<leader>ts",
      function()
        require("toggleterm").send_lines_to_terminal(
          "visual_selection",
          true, -- wether to trim spaces or not
          { args = vim.v.count }
        )
      end,
      mode = "v",
      desc = "[T]oggleTerm: send [S]election (trimmed)",
    },
    {
      "<leader>tS",
      function()
        require("toggleterm").send_lines_to_terminal(
          "visual_selection",
          false, -- wether to trim spaces or not
          { args = vim.v.count }
        )
      end,
      mode = "v",
      desc = "[T]oggleTerm: send [S]election (not trimmed)",
    },
    {
      "<leader>tl",
      function()
        require("toggleterm").send_lines_to_terminal(
          "visual_lines",
          true, -- wether to trim spaces or not
          { args = vim.v.count }
        )
      end,
      mode = "v",
      desc = "[T]oggleTerm: send [L]ines (trimmed)",
    },
    {
      "<leader>tL",
      function()
        require("toggleterm").send_lines_to_terminal(
          "visual_lines",
          false, -- wether to trim spaces or not
          { args = vim.v.count }
        )
      end,
      mode = "v",
      desc = "[T]oggleTerm: send [L]ines (not trimmed)",
    },
  },
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
    persist_size = false,
  },
}
