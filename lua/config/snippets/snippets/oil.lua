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
  get_file_exist_condition = function(filename)
    return ls_conds.make_condition(function()
      local oil = require("oil")
      local dir_path = oil.get_current_dir()
      if dir_path == nil then
        return false
      end
      return vim.fn.filereadable(dir_path .. filename) == 1
    end)
  end,
  lua_project = ls_conds.make_condition(function()
    local lua_utils = require("config.lang_utils.lua")
    return lua_utils.is_project()
  end),
  python_project = ls_conds.make_condition(function()
    local python_utils = require("config.lang_utils.python")
    return python_utils.is_project()
  end),
  rust_project = ls_conds.make_condition(function()
    local rust_utils = require("config.lang_utils.rust")
    return rust_utils.is_project()
  end),
}

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

local M = {
  s({
    trig = "init.lua",
    show_condition = snippet_conds.line_begin * snippet_conds.line_end * -local_conds.get_file_exist_condition(
      "init.lua"
    ) * local_conds.lua_project,
  }, { t("init.lua") }),
  s({
    trig = "temp.lua",
    show_condition = snippet_conds.line_begin * snippet_conds.line_end * local_conds.lua_project,
  }, { t("temp"), d(1, get_dynamic_file_index_node("temp", ".lua")), t(".lua") }),

  s({
    trig = "notes-<date>.md",
    show_condition = snippet_conds.line_begin * snippet_conds.line_end,
  }, { t("notes"), d(1, get_dynamic_file_date_node("notes", ".md")), t(".md") }),
  s({
    trig = "CONTRIBUTING.md",
    show_condition = snippet_conds.line_begin * snippet_conds.line_end * -local_conds.get_file_exist_condition(
      "CONTRIBUTING.md"
    ) * local_conds.cwd,
  }, { t("CONTRIBUTING.md") }),
  s({
    trig = "README.md",
    show_condition = snippet_conds.line_begin * snippet_conds.line_end * -local_conds.get_file_exist_condition(
      "README.md"
    ),
  }, { t("README.md") }),
  s({
    trig = "TODO.md",
    show_condition = snippet_conds.line_begin * snippet_conds.line_end * -local_conds.get_file_exist_condition(
      "TODO.md"
    ) * local_conds.cwd,
  }, { t("TODO.md") }),

  s({
    trig = "init.py",
    show_condition = snippet_conds.line_begin * snippet_conds.line_end * -local_conds.get_file_exist_condition(
      "__init__.py"
    ) * local_conds.python_project * -local_conds.cwd,
  }, { t("__init__.py") }),
  s({
    trig = "temp.py",
    show_condition = snippet_conds.line_begin * snippet_conds.line_end * local_conds.python_project,
  }, { t("temp"), d(1, get_dynamic_file_index_node("temp", ".py")), t(".py") }),

  s({
    trig = "temp.rs",
    show_condition = snippet_conds.line_begin * snippet_conds.line_end * local_conds.rust_project,
  }, { t("temp"), d(1, get_dynamic_file_index_node("temp", ".rs")), t(".rs") }),
}

local extensions = {
  "json",
  "jsonc",
  "jsonl",
  "lua",
  "md",
  "proto",
  "py",
  "rs",
  "sh",
  "toml",
  "txt",
  "typ",
  "yaml",
  "yml",
  "zsh",
}
for _, extension in ipairs(extensions) do
  local snippet = s({ trig = "." .. extension, show_condition = snippet_conds.line_end }, { t("." .. extension) })
  table.insert(M, snippet)
end

return M
