-- toggleterm.nvim
--
-- A neovim plugin to persist and toggle multiple terminals during an editing session.

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
  cmd = {
    "ToggleTermLuajit",
    "ToggleTermLuajitVertical",
    "ToggleTermPython",
    "ToggleTermPythonVertical",
  },
  keys = {
    {
      "<leader>tt",
      function()
        require("toggleterm").toggle_all()
      end,
      desc = "[T]oggleTerm: [T]oggle",
    },
    {
      "<leader>th",
      function()
        require("toggleterm").toggle(next_id(), nil, nil, "horizontal")
      end,
      desc = "[T]oggleTerm: new [H]orizontal terminal",
    },
    {
      "<leader>tv",
      function()
        require("toggleterm").toggle(next_id(), nil, nil, "vertical")
      end,
      desc = "[T]oggleTerm: new [V]ertical terminal",
    },
    {
      "<leader>t",
      function()
        require("toggleterm").send_lines_to_terminal("visual_selection", false, {})
      end,
      mode = "v",
      desc = "[T]oggleTerm: send visual selection",
    },
    {
      "<leader>T",
      function()
        require("toggleterm").send_lines_to_terminal("visual_lines", false, {})
      end,
      mode = "v",
      desc = "[T]oggleTerm: send visual lines",
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
  config = function(_, opts)
    local toggleterm = require("toggleterm")
    toggleterm.setup(opts)

    vim.api.nvim_create_user_command("ToggleTermLuajit", function()
      vim.cmd(next_id() .. "TermExec cmd=luajit direction=horizontal")
    end, { desc = "ToggleTerm LuaJIT console" })
    vim.api.nvim_create_user_command("ToggleTermLuajitVertical", function()
      vim.cmd(next_id() .. "TermExec cmd=luajit direction=vertical")
    end, { desc = "ToggleTerm LuaJIT vertical console" })
    vim.api.nvim_create_user_command("ToggleTermPython", function()
      vim.cmd(next_id() .. "TermExec cmd=python direction=horizontal")
    end, { desc = "ToggleTerm Python console" })
    vim.api.nvim_create_user_command("ToggleTermPythonVertical", function()
      vim.cmd(next_id() .. "TermExec cmd=python direction=vertical")
    end, { desc = "ToggleTerm Python vertical console" })
  end,
}
