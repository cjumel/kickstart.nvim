local ls = require("luasnip")
local show_conds = require("luasnip.extras.conditions.show")

local custom_conds = require("plugins.core.luasnip.conditions")

local i = ls.insert_node
local c = ls.choice_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

local is_in_empty_line = custom_conds.line_begin * show_conds.line_end

return {
  s({ trig = ".json", show_condition = is_in_empty_line }, { i(1, "name"), t(".json") }),
  s({ trig = ".json", show_condition = -custom_conds.line_begin }, { t(".json") }),

  s({ trig = ".lua", show_condition = is_in_empty_line }, {
    c(1, {
      sn(nil, { i(1, "name"), t(".lua") }),
      t("init.lua"),
      t("temp.lua"),
    }),
  }),
  s({ trig = ".lua", show_condition = -is_in_empty_line }, { t(".lua") }),

  s({ trig = ".md", show_condition = is_in_empty_line }, {
    c(1, {
      sn(nil, { i(1, "name"), t(".md") }),
      t("README.md"),
      t("NOTES.md"),
      t("TODO.md"),
    }),
  }),
  s({ trig = ".md", show_condition = -custom_conds.line_begin }, { t(".md") }),

  s({ trig = ".py", show_condition = is_in_empty_line }, {
    c(1, {
      sn(nil, { i(1, "name"), t(".py") }),
      t("__init__.py"),
      t("temp.py"),
    }),
  }),
  s({ trig = ".py", show_condition = -is_in_empty_line }, { t(".py") }),

  s({ trig = ".sh", show_condition = is_in_empty_line }, { i(1, "name"), t(".sh") }),
  s({ trig = ".sh", show_condition = -custom_conds.line_begin }, { t(".sh") }),

  s({ trig = ".toml", show_condition = is_in_empty_line }, { i(1, "name"), t(".toml") }),
  s({ trig = ".toml", show_condition = -custom_conds.line_begin }, { t(".toml") }),

  s({ trig = ".yaml", show_condition = is_in_empty_line }, {
    c(1, {
      sn(nil, { i(1, "name"), t(".yaml") }),
      sn(nil, { i(1, "name"), t(".yml") }),
    }),
  }),
  s({ trig = ".yaml", show_condition = -custom_conds.line_begin }, { c(1, { t(".yaml"), t(".yml") }) }),

  s({ trig = ".zsh", show_condition = is_in_empty_line }, { i(1, "name"), t(".zsh") }),
  s({ trig = ".zsh", show_condition = -custom_conds.line_begin }, { t(".zsh") }),
}
