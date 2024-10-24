local custom_conds = require("plugins.core.luasnip.conditions")
local ls = require("luasnip")
local ls_conds = require("luasnip.extras.conditions")
local path_utils = require("path_utils")

local c = ls.choice_node
local d = ls.dynamic_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

local function make_file_extension_condition(extension)
  return ls_conds.make_condition(function()
    return not vim.tbl_isempty(vim.fs.find(function(name, _) return name:match(".*%." .. extension .. "$") end, {
      type = "file",
      path = require("oil").get_current_dir(),
      upward = true, -- Search in the current directory and its ancestors
      stop = path_utils.get_project_root(),
    }))
  end)
end

local function make_filename_condition(filename)
  return ls_conds.make_condition(function()
    local oil = require("oil")
    local dir_path = oil.get_current_dir()
    if dir_path == nil then
      return false
    end
    return vim.fn.filereadable(dir_path .. filename) == 0
  end)
end

local function make_dynamic_file_index_node(base_name, extension)
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

local function make_dynamic_file_date_node(base_name, extension)
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

return {
  -- JSON
  s({
    trig = ".json",
    show_condition = custom_conds.non_empty_line_end * make_file_extension_condition("json"),
  }, { t(".json") }),

  -- Lua
  s({
    trig = ".lua",
    show_condition = custom_conds.non_empty_line_end * make_file_extension_condition("lua"),
  }, { t(".lua") }),
  s({
    trig = "init.lua",
    show_condition = (custom_conds.empty_line * make_file_extension_condition("lua") * make_filename_condition(
      "init.lua"
    )),
  }, { t("init.lua") }),
  s({
    trig = "temp-<idx>.lua",
    show_condition = custom_conds.empty_line * make_file_extension_condition("lua"),
  }, { t("temp"), d(1, make_dynamic_file_index_node("temp", ".lua")), t(".lua") }),

  -- Markdown
  s({
    trig = ".md",
    show_condition = custom_conds.non_empty_line_end,
  }, { t(".md") }),
  s({
    trig = "NOTES.md",
    show_condition = custom_conds.empty_line * make_filename_condition("NOTES.md"),
  }, { t("NOTES.md") }),
  s({
    trig = "README.md",
    show_condition = custom_conds.empty_line * make_filename_condition("README.md"),
  }, { t("README.md") }),
  s({
    trig = "TODO.md",
    show_condition = custom_conds.empty_line * make_filename_condition("TODO.md"),
  }, { t("TODO.md") }),
  s({
    trig = "notes-<date>.md",
    show_condition = custom_conds.empty_line,
  }, { t("notes"), d(1, make_dynamic_file_date_node("notes", ".md")), t(".md") }),

  -- Python
  s({
    trig = ".py",
    show_condition = custom_conds.non_empty_line_end * make_file_extension_condition("py"),
  }, { t(".py") }),
  s({
    trig = "__init__.py",
    show_condition = custom_conds.empty_line * make_file_extension_condition("py") * make_filename_condition(
      "__init__.py"
    ),
  }, { t("__init__.py") }),
  s({
    trig = "temp-<idx>.py",
    show_condition = custom_conds.empty_line * make_file_extension_condition("py"),
  }, { t("temp"), d(1, make_dynamic_file_index_node("temp", ".py")), t(".py") }),

  -- Shell
  s({
    trig = ".sh",
    show_condition = custom_conds.non_empty_line_end * make_file_extension_condition("sh"),
  }, { t(".sh") }),

  -- TOML
  s({
    trig = ".toml",
    show_condition = custom_conds.non_empty_line_end * make_file_extension_condition("toml"),
  }, { t(".toml") }),

  -- Text
  s({
    trig = ".txt",
    show_condition = custom_conds.non_empty_line_end * make_file_extension_condition("txt"),
  }, { t(".txt") }),

  -- Typset
  s({
    trig = ".typ",
    show_condition = custom_conds.non_empty_line_end * make_file_extension_condition("typ"),
  }, { t(".typ") }),

  -- YAML
  s({
    trig = ".yaml",
    show_condition = custom_conds.non_empty_line_end * make_file_extension_condition("yaml"),
  }, { c(1, { t(".yaml"), t(".yml") }) }),

  -- Zshell
  s({
    trig = ".zsh",
    show_condition = custom_conds.non_empty_line_end * make_file_extension_condition("zsh"),
  }, { t(".zsh") }),

  -- Special files
  s({
    trig = ".gitignore",
    show_condition = custom_conds.empty_line * make_filename_condition(".gitignore") * ls_conds.make_condition(
      function() return path_utils.get_git_root(require("oil").get_current_dir()) ~= nil end
    ),
  }, { t(".gitignore") }),
}
