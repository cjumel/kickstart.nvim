local conds = require("config.snippets.conditions")
local ls = require("luasnip")
local ls_conds = require("luasnip.extras.conditions")
local ls_show_conds = require("luasnip.extras.conditions.show")

local d = ls.dynamic_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

--- Output a Luasnip condition for file extensions. This condition is true if it exists at least one file with the same
--- extension in the Oil directory, or any parent of this directly up until the current working directory.
---@param extension string The file extension.
---@return table
local function make_file_extension_condition(extension)
  return ls_conds.make_condition(function()
    return not vim.tbl_isempty(vim.fs.find(function(name, _)
      -- Exclude the special case of custom Neovim config files, as it doesn't mean there will be other Lua files
      return name:match(".*%." .. extension .. "$") and name ~= ".nvim.lua"
    end, {
      type = "file",
      path = require("oil").get_current_dir(),
      upward = true, -- Search in the current directory and its ancestors
      stop = vim.fn.getcwd(),
    }))
  end)
end

--- Output a Luasnip condition for file names. This condition is true if no file with the same name exists in the Oil
--- directory.
---@param filename string The file name (including the extension).
---@return table
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

--- Output a function creating a Luasnip snippet node for a dynamic file index. The index is an empty string if no file
--- with the base name and extension already exists, otherwise, it is a string with "_" and the first index which makes
--- the combination of base name, index and extension a non-existing file.
---@param base_name string The base name of the file (without the extension).
---@param extension string The file extension.
---@return function
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

--- Output a function creating a Luasnip snippet node for a dynamic file date. The date is made of a raw date string,
--- if no file with the base name and extension already exists, otherwise, it is concatenated with a string with "_" and
--- the first index which makes the combination of base name, date (with index) and extension a non-existing file.
---@param base_name string The base name of the file (without the extension).
---@param extension string The file extension.
---@return function
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

-- When typing a trigger with a "." prefix, the "." is not part of the trigger, but it is replaced by the snippet.
-- Consequently, to enforce the line begin condition, we actually need a prefix condition instead, and to enforce the
-- non-line-begin condition, we also need a non-prefix condition.
local dot_prefix_condition = conds.prefix(".")

return {
  s({
    trig = ".json",
    show_condition = -dot_prefix_condition
      * -conds.line_begin
      * ls_show_conds.line_end
      * make_file_extension_condition("json"),
  }, { t(".json") }),

  s({
    trig = ".lua",
    show_condition = -dot_prefix_condition
      * -conds.line_begin
      * ls_show_conds.line_end
      * make_file_extension_condition("lua"),
  }, { t(".lua") }),
  s({
    trig = "init.lua",
    show_condition = conds.line_begin
      * ls_show_conds.line_end
      * make_file_extension_condition("lua")
      * make_filename_condition("init.lua"),
  }, { t("init.lua") }),
  s({
    trig = "temp.lua",
    show_condition = conds.line_begin * ls_show_conds.line_end * make_file_extension_condition("lua"),
  }, { t("temp"), d(1, make_dynamic_file_index_node("temp", ".lua")), t(".lua") }),

  s({
    trig = ".md",
    show_condition = -dot_prefix_condition * -conds.line_begin * ls_show_conds.line_end,
  }, { t(".md") }),
  s({
    trig = "notes-<date>.md",
    show_condition = conds.line_begin * ls_show_conds.line_end,
  }, { t("notes"), d(1, make_dynamic_file_date_node("notes", ".md")), t(".md") }),
  s({
    trig = "README.md",
    show_condition = conds.line_begin * ls_show_conds.line_end * make_filename_condition("README.md"),
  }, { t("README.md") }),
  s({
    trig = "TODO.md",
    show_condition = conds.line_begin * ls_show_conds.line_end * make_filename_condition("TODO.md"),
  }, { t("TODO.md") }),

  s({
    trig = ".py",
    show_condition = -dot_prefix_condition
      * -conds.line_begin
      * ls_show_conds.line_end
      * make_file_extension_condition("py"),
  }, { t(".py") }),
  s({
    trig = "__init__.py",
    show_condition = conds.prefix("_") -- The snippet is triggered after the first "_"
      * ls_show_conds.line_end
      * make_file_extension_condition("py")
      * make_filename_condition("__init__.py"),
  }, { t("__init__.py") }),
  s({
    trig = "temp.py",
    show_condition = conds.line_begin * ls_show_conds.line_end * make_file_extension_condition("py"),
  }, { t("temp"), d(1, make_dynamic_file_index_node("temp", ".py")), t(".py") }),

  s({
    trig = ".rs",
    show_condition = -dot_prefix_condition
      * -conds.line_begin
      * ls_show_conds.line_end
      * make_file_extension_condition("rs"),
  }, { t(".rs") }),
  s({
    trig = "temp.rs",
    show_condition = conds.line_begin * ls_show_conds.line_end * make_file_extension_condition("rs"),
  }, { t("temp"), d(1, make_dynamic_file_index_node("temp", ".rs")), t(".rs") }),

  s({
    trig = ".sh",
    show_condition = -dot_prefix_condition
      * -conds.line_begin
      * ls_show_conds.line_end
      * make_file_extension_condition("sh"),
  }, { t(".sh") }),

  s({
    trig = ".toml",
    show_condition = -dot_prefix_condition
      * -conds.line_begin
      * ls_show_conds.line_end
      * make_file_extension_condition("toml"),
  }, { t(".toml") }),

  s({
    trig = ".txt",
    show_condition = -dot_prefix_condition
      * -conds.line_begin
      * ls_show_conds.line_end
      * make_file_extension_condition("txt"),
  }, { t(".txt") }),

  s({
    trig = ".typ",
    show_condition = -dot_prefix_condition
      * -conds.line_begin
      * ls_show_conds.line_end
      * make_file_extension_condition("typ"),
  }, { t(".typ") }),

  s({
    trig = ".yaml",
    show_condition = -dot_prefix_condition
      * -conds.line_begin
      * ls_show_conds.line_end
      * make_file_extension_condition("yaml"),
  }, { t(".yaml") }),
  s({
    trig = ".yml",
    show_condition = -dot_prefix_condition
      * -conds.line_begin
      * ls_show_conds.line_end
      * make_file_extension_condition("yml"),
  }, { t(".yml") }),

  s({
    trig = ".zsh",
    show_condition = -dot_prefix_condition
      * -conds.line_begin
      * ls_show_conds.line_end
      * make_file_extension_condition("zsh"),
  }, { t(".zsh") }),
}
