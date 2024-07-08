local ls = require("luasnip")
local ls_show_conditions = require("luasnip.extras.conditions.show")

local custom_conditions = require("plugins.core.luasnip.conditions")

local c = ls.choice_node
local i = ls.insert_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

return {
  s("link", { t("["), i(1, "name"), t("]("), i(2, "url"), t(")") }),
  s({ trig = "code-block", show_condition = custom_conditions.line_begin * ls_show_conditions.line_end }, {
    t("```"),
    c(1, { i(nil), t("shell") }),
    t({ "", "" }),
    i(2),
    t({ "", "```" }),
  }),
  s({ trig = "toggle-block", show_condition = custom_conditions.line_begin * ls_show_conditions.line_end }, {
    t({ "<details>", "<summary>" }),
    i(1, "Summary"),
    t({ "</summary>", "", "" }), -- Line break after the summary is important for some blocks like code-blocks
    i(2, "Content"),
    t({ "", "", "</details>" }),
  }),

  -- Custom convention for emojis representing todo-items
  s({ trig = "todo-list-item", show_condition = custom_conditions.line_begin }, {
    c(1, {
      sn(nil, { t("- 🎯 "), i(1) }), -- :dart: -> todo
      sn(nil, { t("- ⌛ "), i(1) }), -- :hourglass: -> in progress
      sn(nil, { t("- ✅ "), i(1) }), -- :white_check_mark: -> done
      sn(nil, { t("- ❌ "), i(1) }), -- :x: -> cancelled
    }),
  }),
  s({ trig = "todo-item", show_condition = -custom_conditions.line_begin }, {
    c(1, {
      sn(nil, { t("🎯"), i(1) }), -- :dart: -> todo
      sn(nil, { t("⌛"), i(1) }), -- :hourglass: -> in progress
      sn(nil, { t("✅"), i(1) }), -- :white_check_mark: -> done
      sn(nil, { t("❌"), i(1) }), -- :x: -> cancelled
    }),
  }),
}
