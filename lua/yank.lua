local M = {}

local function yank_with_notification(item)
  if item == nil then
    vim.notify("Nothing to yank", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg('"', item)
  vim.notify('Yanked to register `"`:\n```\n' .. item .. "\n```")
end
M.with_notification = yank_with_notification

function M.send_to_clipboard()
  local yanked = vim.fn.getreg('"')
  vim.fn.setreg("+", yanked)
  vim.notify("Yanked sent to register `+`:\n```\n" .. yanked .. "\n```")
end

function M.toggle_sync_with_clipboard()
  if not vim.tbl_contains(vim.opt.clipboard, "unnamedplus") then
    vim.opt.clipboard:append("unnamedplus")
    vim.notify("Register and clipboard sync enabled")
  else
    vim.opt.clipboard:remove("unnamedplus")
    vim.notify("Register and clipboard sync disabled")
  end
end

local function get_file_path(mods)
  local path = nil
  if vim.bo.buftype == "" then -- Regular buffer
    path = vim.fn.expand("%")
    return vim.fn.fnamemodify(path, mods)
  elseif vim.bo.filetype == "oil" then
    local oil = require("oil")
    path = oil.get_current_dir()
    if path ~= nil then
      path = path:gsub("/$", "") -- Remove the "/" prefix if it exists (necessary to get the tail with `mods`)
      return vim.fn.fnamemodify(path, mods)
    end
  end
end

local function yank_file_path()
  local file_path = get_file_path(":~:.")
  yank_with_notification(file_path)
end
M.file_path = yank_file_path

local function yank_full_file_path()
  local full_file_path = get_file_path(":~")
  yank_with_notification(full_file_path)
end
M.full_file_path = yank_full_file_path

local function yank_file_name()
  local file_name = get_file_path(":t")
  yank_with_notification(file_name)
end
M.file_name = yank_file_name

local function yank_buffer_content()
  local bufnr = vim.api.nvim_get_current_buf()
  local buflines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local buffer_content = table.concat(buflines, "\n")
  yank_with_notification(buffer_content)
end
M.buffer_content = yank_buffer_content

local function yank_all_buffer_contents()
  local lines = {}
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if
      vim.api.nvim_buf_is_valid(bufnr)
      and vim.api.nvim_buf_is_loaded(bufnr)
      and vim.api.nvim_buf_get_name(bufnr) ~= ""
      and vim.api.nvim_get_option_value("buftype", { buf = bufnr }) == ""
    then
      local bufpath = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":p:~:.")
      if not bufpath:match("^~/.nvim%-scratch/") then
        local buflines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        vim.list_extend(lines, { "File `" .. bufpath .. "`:", "```" .. vim.bo[bufnr].filetype })
        vim.list_extend(lines, buflines)
        vim.list_extend(lines, { "```", "" })
      end
    end
  end
  local all_buffer_contents = table.concat(lines, "\n")
  yank_with_notification(all_buffer_contents)
end
M.all_buffer_contents = yank_all_buffer_contents

return M
