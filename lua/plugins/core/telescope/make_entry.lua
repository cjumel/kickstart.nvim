-- Custom entry maker, tailored specifically for a custom directory picker. The vast majority of this code is directly
-- taken from `telescope.make_entry`.

local M = {}

local handle_entry_index = function(opts, t, k)
  local override = ((opts or {}).entry_index or {})[k]
  if not override then
    return
  end

  local val, save = override(t, opts)
  if save then
    rawset(t, k, val)
  end
  return val
end

local lookup_keys = {
  ordinal = 1,
  value = 1,
  filename = 1,
  cwd = 2,
}

function M.gen_from_dir(opts)
  local utils = require("telescope.utils")

  opts = opts or {}

  ---@diagnostic disable-next-line: undefined-field
  local cwd = opts.cwd or vim.loop.cwd()
  if cwd ~= nil then
    cwd = utils.path_expand(cwd)
  end

  local mt_file_entry = {}

  mt_file_entry.cwd = cwd

  mt_file_entry.display = function(entry)
    local hl_group, icon
    local display = utils.transform_path(opts, entry.value)

    -- Custom part: always use a directory icon & highlight group
    icon = ""
    display = icon .. " " .. display
    hl_group = "Directory"

    return display, { { { 0, #icon }, hl_group } }
  end

  mt_file_entry.__index = function(t, k)
    local override = handle_entry_index(opts, t, k)
    if override then
      return override
    end

    local raw = rawget(mt_file_entry, k)
    if raw then
      return raw
    end

    if k == "path" then
      local retpath = require("plenary.path"):new({ t.cwd, t.value }):absolute()
      ---@diagnostic disable-next-line: undefined-field
      if not vim.loop.fs_access(retpath, "R", function() end) then
        retpath = t.value
      end
      return retpath
    end

    return rawget(t, rawget(lookup_keys, k))
  end

  return function(line) return setmetatable({ line }, mt_file_entry) end
end

return M
