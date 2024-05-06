local ls = require("luasnip")
local ls_show_conditions = require("luasnip.extras.conditions.show")

local custom_conditions = require("plugins.core.luasnip.conditions")

local i = ls.insert_node
local c = ls.choice_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

return {
  s(
    { trig = ".json", show_condition = custom_conditions.line_begin * ls_show_conditions.line_end },
    { i(1), t(".json") }
  ),
  s({ trig = ".json", show_condition = -custom_conditions.line_begin * ls_show_conditions.line_end }, { t(".json") }),

  s({ trig = ".lua", show_condition = custom_conditions.line_begin * ls_show_conditions.line_end }, {
    c(1, {
      sn(nil, { i(1), t(".lua") }),
      t("init.lua"),
      t("temp.lua"),
    }),
  }),
  s({ trig = ".lua", show_condition = -custom_conditions.line_begin * ls_show_conditions.line_end }, { t(".lua") }),

  s({ trig = ".md", show_condition = custom_conditions.line_begin * ls_show_conditions.line_end }, {
    c(1, {
      sn(nil, { i(1), t(".md") }),
      t("README.md"),
      t("NOTES.md"),
      t("TODO.md"),
    }),
  }),
  s({ trig = ".md", show_condition = -custom_conditions.line_begin * ls_show_conditions.line_end }, { t(".md") }),

  s({ trig = ".py", show_condition = custom_conditions.line_begin * ls_show_conditions.line_end }, {
    c(1, {
      sn(nil, { i(1), t(".py") }),
      t("__init__.py"),
      t("temp.py"),
    }),
  }),
  s({ trig = ".py", show_condition = -custom_conditions.line_begin * ls_show_conditions.line_end }, { t(".py") }),

  s({ trig = ".sh", show_condition = custom_conditions.line_begin * ls_show_conditions.line_end }, { i(1), t(".sh") }),
  s({ trig = ".sh", show_condition = -custom_conditions.line_begin * ls_show_conditions.line_end }, { t(".sh") }),

  s(
    { trig = ".toml", show_condition = custom_conditions.line_begin * ls_show_conditions.line_end },
    { i(1), t(".toml") }
  ),
  s({ trig = ".toml", show_condition = -custom_conditions.line_begin * ls_show_conditions.line_end }, { t(".toml") }),

  s({ trig = ".yaml", show_condition = custom_conditions.line_begin * ls_show_conditions.line_end }, {
    c(1, {
      sn(nil, { i(1), t(".yaml") }),
      sn(nil, { i(1), t(".yml") }),
    }),
  }),
  s({ trig = ".yaml", show_condition = -custom_conditions.line_begin * ls_show_conditions.line_end }, {
    c(1, {
      t(".yaml"),
      t(".yml"),
    }),
  }),

  s(
    { trig = ".zsh", show_condition = custom_conditions.line_begin * ls_show_conditions.line_end },
    { i(1), t(".zsh") }
  ),
  s({ trig = ".zsh", show_condition = -custom_conditions.line_begin * ls_show_conditions.line_end }, { t(".zsh") }),
}
