--- Output the existing ToggleTerm terminals.
---@param only_opened boolean Whether to restrict the output terminals to the currently opened ones.
---@return Terminal[]
local function get_terms(only_opened)
  local terminal = require("toggleterm.terminal")

  local terms = terminal.get_all(true)
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

local M = {}

function M.toggle()
  local toggleterm = require("toggleterm")

  local terms = get_terms(false)
  if #terms == 0 then
    toggleterm.toggle(get_new_term_id(), nil, nil, "horizontal")
  else
    select_term_and_run(function(term) term:toggle() end, { prompt = "Select a terminal to toggle: " })
  end
end

function M.toggle_all()
  local toggleterm = require("toggleterm")
  toggleterm.toggle_all()
end

function M.new_terminal()
  local toggleterm = require("toggleterm")
  toggleterm.toggle(get_new_term_id(), nil, nil, "horizontal")
end

function M.new_terminal_in_vertical_split()
  local toggleterm = require("toggleterm")
  toggleterm.toggle(get_new_term_id(), nil, nil, "vertical")
end

function M.change_name()
  select_term_and_run(
    function(term) vim.cmd(term.id .. "ToggleTermSetName") end,
    { prompt = "Select a terminal to rename: " }
  )
end

function M.send_line()
  select_term_and_run(
    function(term) require("toggleterm").send_lines_to_terminal("single_line", true, { args = term.id }) end,
    { prompt = "Select a terminal to send to: ", only_opened = true }
  )
end

function M.run_file_in_repl()
  local toggleterm = require("toggleterm")

  select_term_and_run(function(term)
    -- Get a user-friendly path of the current file (relative to the cwd if in it or absolute)
    --  Truncating the home directory with "~" doesn't work for some of the commands below
    local path = vim.fn.expand("%:p:.")

    local line
    if vim.bo.filetype == "lua" then
      line = [[dofile("]] .. path .. [[")]]
    elseif vim.bo.filetype == "python" then
      line = [[exec(open("]] .. path .. [[").read())]]
    else
      error("Unsupported filetype: " .. vim.bo.filetype)
    end

    toggleterm.exec(line, term.id)
  end, { prompt = "Select a terminal to run the file in: ", only_opened = true })
end

function M.send_selection()
  local toggleterm = require("toggleterm")

  select_term_and_run(function(term)
    local visual_mode = require("visual_mode")
    local lines = visual_mode.get_lines({ trim_indent = true })
    toggleterm.exec(table.concat(lines, "\n"), term.id)
  end, { prompt = "Select a terminal to send to: ", only_opened = true })
end

return M
