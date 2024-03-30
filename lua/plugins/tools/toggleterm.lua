-- toggleterm.nvim
--
-- A neovim plugin to persist and interact with (hide, send code, etc.) multiple terminals during
-- an editing session.

local utils = require("utils")

--- Get the next available terminal id based on the next number in the sequence that
--- hasn't already been allocated e.g. in a list of {1,2,5,6} the next id should
--- be 3 then 4 then 7
--- This function is taken from the `toggleterm.terminal` module.
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

--- Send buffer lines to terminal, depending on the current mode.
--- This function is based on the `toggleterm.send_lines_to_terminal` function, with some new
--- features and some simplifications.
---@param opts table<string, any>
---@param cmd_data table<string, any>
local function send_lines_to_terminal(opts, cmd_data)
  local api = vim.api
  local fn = vim.fn

  local toggleterm = require("toggleterm")
  local toggleterm_utils = require("toggleterm.utils")

  opts = opts or {}
  local trim_spaces = opts.trim_spaces or false
  local trim_empty_lines = opts.trim_empty_lines or false
  local add_trailing_empty_line = opts.add_trailing_empty_line or false

  local id = tonumber(cmd_data.args) or 1

  -- Detect the selection type depending on the current mode
  local mode = vim.fn.mode()
  local selection_type
  if mode == "v" then
    selection_type = "visual_selection"
  elseif mode == "V" then
    selection_type = "visual_lines"
  else
    selection_type = "single_line"
  end

  vim.validate({
    selection_type = { selection_type, "string" },
    trim_spaces = { trim_spaces, "boolean" },
    trim_empty_lines = { trim_empty_lines, "boolean" },
    add_trailing_empty_line = { add_trailing_empty_line, "boolean" },
    terminal_id = { id, "number" },
  })

  local current_window = api.nvim_get_current_win() -- save current window

  local lines = {}
  -- Beginning of the selection: line number, column number
  local start_line, start_col
  if selection_type == "single_line" then
    start_line, start_col = unpack(api.nvim_win_get_cursor(0))
    table.insert(lines, fn.getline(start_line))
  else
    local res = toggleterm_utils.get_line_selection("visual")
    start_line, start_col = unpack(res.start_pos)
    if selection_type == "visual_lines" then
      lines = res.selected_lines
    elseif selection_type == "visual_selection" then
      lines = toggleterm_utils.get_visual_selection(res, true)
    end
  end

  if not lines or not next(lines) then
    return
  end

  if trim_empty_lines then
    lines = utils.table.filter_out_array(lines, { "" })
  end
  if add_trailing_empty_line then
    lines = utils.table.concat_arrays({ lines, { "" } })
  end

  if not trim_spaces then
    toggleterm.exec(table.concat(lines, "\n"))
  else
    for _, line in ipairs(lines) do
      local l = trim_spaces and line:gsub("^%s+", ""):gsub("%s+$", "") or line
      toggleterm.exec(l, id)
    end
  end

  -- Jump back with the cursor where we were at the beginning of the selection
  api.nvim_set_current_win(current_window)
  api.nvim_win_set_cursor(current_window, { start_line, start_col })
end

return {
  "akinsho/toggleterm.nvim",
  cmd = {
    "ToggleTermLuajit",
    "ToggleTermPython",
    "ToggleTermPoetryPython",
    "ToggleTermIPython",
  },
  keys = {
    {
      "<leader>tt",
      function() require("toggleterm").toggle_all() end,
      desc = "[T]erm: toggle",
    },
    {
      "<leader>tn",
      function() require("toggleterm").toggle(next_id(), nil, nil, "horizontal") end,
      desc = "[T]erm: [N]ew term",
    },
    {
      "<leader>tv",
      function() require("toggleterm").toggle(next_id(), nil, nil, "vertical") end,
      desc = "[T]erm: new term in [V]split",
    },
    {
      "<leader>ts",
      function()
        local opts = {}
        if vim.fn.mode() ~= "n" then
          opts.trim_empty_lines = true
          opts.add_trailing_empty_line = true
        end
        send_lines_to_terminal(opts, { args = vim.v.count })
      end,
      mode = { "n", "v" },
      desc = "[T]erm: [S]end line/selection",
    },
    {
      "<leader>td",
      function()
        local opts = { trim_spaces = true }
        if vim.fn.mode() ~= "n" then
          opts.trim_empty_lines = true
          opts.add_trailing_empty_line = true
        end
        send_lines_to_terminal(opts, { args = vim.v.count })
      end,
      mode = { "n", "v" },
      desc = "[T]erm: send [D]eindented line/selection",
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
    require("toggleterm").setup(opts)

    vim.api.nvim_create_user_command(
      "ToggleTermLuajit",
      function() vim.cmd("TermExec cmd='luajit'") end,
      { desc = "Launch a LuaJIT console in ToggleTerm" }
    )

    -- Start a Python console without any virtual environment (even if one is activated when
    -- starting Neovim)
    vim.api.nvim_create_user_command(
      "ToggleTermPython",
      function() vim.cmd("TermExec cmd='python'") end,
      { desc = "Launch a Python console in ToggleTerm" }
    )
    -- Start a Python console with a Poetry environment (requires a Poetry environment to be set up)
    vim.api.nvim_create_user_command(
      "ToggleTermPoetryPython",
      function() vim.cmd("TermExec cmd='poetry run python'") end,
      { desc = "Launch a Python console with the Poetry environment in ToggleTerm" }
    )
    -- Start an IPython console; if Neovim is started with a virtual environment activated & IPython
    -- is installed in it, use this IPython, otherwise use the system-wide IPython with no virtual
    -- environment
    vim.api.nvim_create_user_command("ToggleTermIPython", function()
      -- Start IPython with --no-autoindent to avoid messing with indents when sending code from
      -- a buffer
      vim.cmd("TermExec cmd='ipython --no-autoindent'")
    end, { desc = "Launch an IPython console in ToggleTerm" })
  end,
}
