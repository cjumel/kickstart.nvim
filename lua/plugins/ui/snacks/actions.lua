local M = {}

M.scratch = {}

M.scratch.select = function(opts) -- Based on Snacks.scratch.select
  opts = opts or {}
  local all = opts.all or false
  local items = Snacks.scratch.list()
  local selection_items = {}
  local widths = all and { 0, 0, 0, 0 } or { 0, 0, 0 }
  local cwd = all and nil or vim.fn.fnamemodify(vim.fn.getcwd(), ":p:~")
  for _, item in ipairs(items) do
    if all or (item.cwd and vim.fn.fnamemodify(item.cwd, ":p:~") == cwd) then
      item.cwd = (all and item.cwd) and vim.fn.fnamemodify(item.cwd, ":p:~") .. "  " or ""
      item.icon = item.icon or Snacks.util.icon(item.ft, "filetype")
      item.name = item.count > 1 and item.name .. " " .. item.count or item.name
      item.branch = item.branch and ("   %s"):format(item.branch) or ""
      if all then
        widths[1] = math.max(widths[1], vim.api.nvim_strwidth(item.cwd))
        widths[2] = math.max(widths[2], vim.api.nvim_strwidth(item.icon))
        widths[3] = math.max(widths[3], vim.api.nvim_strwidth(item.name))
        widths[4] = math.max(widths[4], vim.api.nvim_strwidth(item.branch))
      else
        widths[1] = math.max(widths[1], vim.api.nvim_strwidth(item.icon))
        widths[2] = math.max(widths[2], vim.api.nvim_strwidth(item.name))
        widths[3] = math.max(widths[3], vim.api.nvim_strwidth(item.branch))
      end
      table.insert(selection_items, item)
    end
  end
  if vim.tbl_isempty(items) then
    vim.notify("No scratch file found", vim.log.levels.WARN)
    return
  end
  vim.ui.select(selection_items, {
    prompt = all and "Scratch files (all)" or "Scratch files",
    format_item = function(item)
      local parts = all and { item.cwd, item.icon, item.name, item.branch } or { item.icon, item.name, item.branch }
      for i, part in ipairs(parts) do
        parts[i] = part .. string.rep(" ", widths[i] - vim.api.nvim_strwidth(part))
      end
      return table.concat(parts, " ")
    end,
  }, function(selected)
    if selected then
      Snacks.scratch.open({ icon = selected.icon, file = selected.file, name = selected.name, ft = selected.ft })
    end
  end)
end

M.scratch.open = function()
  vim.ui.input({ prompt = "Filetype" }, function(filetype)
    if filetype then
      local items = Snacks.scratch.list()
      local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:~")
      local item_names = {}
      for _, item in ipairs(items) do
        if item.ft == filetype and item.cwd and vim.fn.fnamemodify(item.cwd, ":p:~") == cwd then
          table.insert(item_names, item.name)
        end
      end
      local default_base_name = filetype:sub(1, 1):upper() .. filetype:sub(2) .. " file"
      local count = 0
      local suffix = ""
      local default_name = default_base_name
      while vim.tbl_contains(item_names, default_name) do
        count = count + 1
        suffix = " " .. count
        default_name = default_base_name .. suffix
      end
      vim.ui.input({ prompt = "Name", default = default_name }, function(name)
        if name then
          Snacks.scratch.open({ ft = filetype, name = name })
        end
      end)
    end
  end)
end

M.scratch.open_with_filetype = function()
  local items = Snacks.scratch.list()
  local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:~")
  local item_names = {}
  for _, item in ipairs(items) do
    if item.ft == vim.bo.filetype and item.cwd and vim.fn.fnamemodify(item.cwd, ":p:~") == cwd then
      table.insert(item_names, item.name)
    end
  end
  local default_base_name = vim.bo.filetype:sub(1, 1):upper() .. vim.bo.filetype:sub(2) .. " file"
  local count = 0
  local suffix = ""
  local default_name = default_base_name
  while vim.tbl_contains(item_names, default_name) do
    count = count + 1
    suffix = " " .. count
    default_name = default_base_name .. suffix
  end
  vim.ui.input({ prompt = "Name", default = default_name }, function(name)
    if name then
      Snacks.scratch.open({ name = name })
    end
  end)
end

M.scratch.open_note = function()
  Snacks.scratch.open({
    ft = "markdown",
    name = "Note",
  })
end

M.scratch.open_last = function()
  local items = Snacks.scratch.list()
  local selected = items[1] -- Items are ordered with last opened first
  Snacks.scratch.open({ icon = selected.icon, file = selected.file, name = selected.name, ft = selected.ft })
end

return M
