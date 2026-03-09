local ls = require("luasnip")
local ls_conds = require("luasnip.extras.conditions")
local snippet_conds = require("config.snippets.conditions")

local s = ls.snippet
local t = ls.text_node

local local_conds = {
  make_file_not_exist = function(filename)
    return ls_conds.make_condition(function()
      local oil = require("oil")
      local dir_path = oil.get_current_dir()
      if dir_path == nil then
        return error("Could not get current directory from oil.nvim")
      end
      return vim.fn.filereadable(dir_path .. filename) == 0
    end)
  end,
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

local special_file_snippets = {
  -- Lua
  s({
    trig = "init.lua",
    show_condition = snippet_conds.empty_line * local_conds.make_file_not_exist("init.lua") * local_conds.lua_project,
  }, { t("init.lua") }),

  -- Markdown
  s({
    trig = "CONTRIBUTING.md",
    show_condition = snippet_conds.empty_line * local_conds.make_file_not_exist("CONTRIBUTING.md") * local_conds.cwd,
  }, { t("CONTRIBUTING.md") }),
  s({
    trig = "README.md",
    show_condition = snippet_conds.empty_line * local_conds.make_file_not_exist("README.md"),
  }, { t("README.md") }),
  s({
    trig = "TODO.md",
    show_condition = snippet_conds.empty_line * local_conds.make_file_not_exist("TODO.md"),
  }, { t("TODO.md") }),

  -- Python
  s({
    trig = "__init__.py",
    show_condition = snippet_conds.empty_line
      * local_conds.make_file_not_exist("__init__.py")
      * local_conds.python_project
      * -local_conds.cwd,
  }, { t("__init__.py") }),
  s({
    trig = "__main__.py",
    show_condition = snippet_conds.empty_line
      * local_conds.make_file_not_exist("__main__.py")
      * local_conds.python_project
      * -local_conds.cwd,
  }, { t("__main__.py") }),
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
