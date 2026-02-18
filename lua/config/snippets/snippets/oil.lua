local ls = require("luasnip")
local ls_conds = require("luasnip.extras.conditions")
local snippet_conds = require("config.snippets.conditions")

local d = ls.dynamic_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

local local_conds = {
  cwd = ls_conds.make_condition(function()
    local oil = require("oil")
    local dir_path = oil.get_current_dir()
    if dir_path == nil then
      return false
    end
    return vim.fn.fnamemodify(dir_path, ":p") == vim.fn.fnamemodify(vim.fn.getcwd(), ":p")
  end),
  lua_project = ls_conds.make_condition(function()
    local lua_utils = require("config.lang_utils.lua")
    return lua_utils.is_project()
  end),
  python_project = ls_conds.make_condition(function()
    local python_utils = require("config.lang_utils.python")
    return python_utils.is_project()
  end),
}
local snippets = {}

-- [[ Special files ]]

---@param filename string
---@return table
local function get_file_exist_condition(filename)
  return ls_conds.make_condition(function()
    local oil = require("oil")
    local dir_path = oil.get_current_dir()
    if dir_path == nil then
      return false
    end
    return vim.fn.filereadable(dir_path .. filename) == 1
  end)
end

---@param base_name string
---@param extension string
---@return function
local function get_dynamic_file_index_node(base_name, extension)
  return function(_)
    local oil = require("oil")
    local dir_path = oil.get_current_dir()
    if dir_path == nil then
      return sn(nil, {})
    end
    if vim.fn.filereadable(dir_path .. base_name .. extension) == 0 then
      return sn(nil, {})
    end
    for i = 1, 99 do
      local suffix = "_" .. tostring(i)
      if vim.fn.filereadable(dir_path .. base_name .. suffix .. extension) == 0 then
        return sn(nil, { t(suffix) })
      end
    end
    return sn(nil, {})
  end
end

---@param base_name string
---@param extension string
---@return function
local function get_dynamic_file_date_node(base_name, extension)
  return function(_)
    local oil = require("oil")
    local dir_path = oil.get_current_dir()
    if dir_path == nil then
      return sn(nil, {})
    end
    local date = os.date("%Y-%m-%d")
    local suffix = "_" .. date -- Format suitable for alphanumeric order
    if vim.fn.filereadable(dir_path .. base_name .. suffix .. extension) == 0 then
      return sn(nil, { t(suffix) })
    end
    for i = 1, 99 do
      suffix = "_" .. date .. "_" .. tostring(i)
      if vim.fn.filereadable(dir_path .. base_name .. suffix .. extension) == 0 then
        return sn(nil, { t(suffix) })
      end
    end
    return sn(nil, {})
  end
end

local special_file_snippets = {
  -- Lua
  s({
    trig = "init.lua",
    show_condition = snippet_conds.empty_line * -get_file_exist_condition("init.lua") * local_conds.lua_project,
  }, { t("init.lua") }),
  s(
    { trig = "temp.lua", show_condition = snippet_conds.empty_line * local_conds.lua_project },
    { t("temp"), d(1, get_dynamic_file_index_node("temp", ".lua")), t(".lua") }
  ),

  -- Markdown
  s({
    trig = "CONTRIBUTING.md",
    show_condition = snippet_conds.empty_line * -get_file_exist_condition("CONTRIBUTING.md") * local_conds.cwd,
  }, { t("CONTRIBUTING.md") }),
  s(
    { trig = "notes.md", show_condition = snippet_conds.empty_line },
    { t("notes"), d(1, get_dynamic_file_index_node("notes", ".md")), t(".md") }
  ),
  s({
    trig = "notes-<date>.md",
    show_condition = snippet_conds.empty_line,
    priority = 999, -- Default is 1000
  }, { t("notes"), d(1, get_dynamic_file_date_node("notes", ".md")), t(".md") }),
  s({
    trig = "README.md",
    show_condition = snippet_conds.empty_line * -get_file_exist_condition("README.md"),
  }, { t("README.md") }),
  s({
    trig = "TODO.md",
    show_condition = snippet_conds.empty_line * -get_file_exist_condition("TODO.md") * local_conds.cwd,
  }, { t("TODO.md") }),

  -- Python
  s({
    trig = "__init__.py", -- FIXME:
    show_condition = snippet_conds.empty_line
      * -get_file_exist_condition("__init__.py")
      * local_conds.python_project
      * -local_conds.cwd,
  }, { t("__init__.py") }),
  s(
    { trig = "temp.py", show_condition = snippet_conds.empty_line * local_conds.python_project },
    { t("temp"), d(1, get_dynamic_file_index_node("temp", ".py")), t(".py") }
  ),
}
snippets = vim.list_extend(snippets, special_file_snippets)

-- [[ Extensions ]]

local extensions = { -- Can be an array with a priority
  "json",
  "jsonc",
  "jsonl",
  "lua",
  "md",
  { "proto", 999 }, -- Default priority is 1000
  "py",
  "rs",
  "sh",
  "toml",
  "ts",
  "txt",
  "typ",
  "yaml",
  "yml",
  "zsh",
}
for _, extension_data in ipairs(extensions) do
  local snippet
  if type(extension_data) == "table" then
    assert(#extension_data == 2)
    snippet = s(
      { trig = "." .. extension_data[1], priority = extension_data[2], show_condition = snippet_conds.line_end },
      { t("." .. extension_data[1]) }
    )
  else
    snippet = s({ trig = "." .. extension_data, show_condition = snippet_conds.line_end }, { t("." .. extension_data) })
  end
  table.insert(snippets, snippet)
end

return snippets
