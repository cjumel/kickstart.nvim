local custom_conditions = require("plugins.core.luasnip.conditions")
local ls = require("luasnip")

local c = ls.choice_node
local i = ls.insert_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

return {

  -- [[ Vanilla Markdown ]]

  -- Within-text snippets
  -- For italic, bold & bold-italic, using asterix is more robust than underscores as it works also within words
  s("italic", { t("*"), i(1), t("*") }),
  s("bold", { t("**"), i(1), t("**") }),
  s("bold-italic", { t("***"), i(1), t("***") }),
  s("link", { t("["), i(1, "name"), t("]("), i(2, "url"), t(")") }),

  -- Block snippets
  s({ trig = "header", show_condition = custom_conditions.empty_line }, {
    c(1, {
      sn(nil, { t("# "), i(1) }),
      sn(nil, { t("## "), i(1) }),
      sn(nil, { t("### "), i(1) }),
      sn(nil, { t("#### "), i(1) }),
      sn(nil, { t("##### "), i(1) }),
    }),
  }),
  s({ trig = "quote-block", show_condition = custom_conditions.empty_line }, {
    c(1, {
      sn(nil, { t("> "), i(1) }),
      sn(nil, { t(">> "), i(1) }),
      sn(nil, { t(">>> "), i(1) }),
    }),
  }),
  s({ trig = "code-block", show_condition = custom_conditions.empty_line }, {
    t("```"),
    c(1, { i(nil), t("shell", "python") }),
    t({ "", "" }),
    i(2),
    t({ "", "```" }),
  }),

  -- [[ GitHub Flavored Markdown ]]

  s("@me", { t("@clementjumel"), i(1) }),
  s({ trig = "checkbox", show_condition = custom_conditions.line_begin }, {
    c(1, {
      sn(nil, { t("- [ ] "), i(1) }),
      sn(nil, { t("- [x] "), i(1) }),
    }),
  }),
  s({ trig = "toggle-block", show_condition = custom_conditions.empty_line }, {
    t({ "<details>", "<summary>" }),
    i(1, "Summary"),
    t({ "</summary>", "", "" }), -- Line break after the summary is important for some blocks like code-blocks
    i(2, "Content"),
    t({ "", "", "</details>" }),
  }),

  -- [[ Custom Markdown ]]

  -- Todomojis: todo items with emojis
  --  🎯 (:dart:) -> todo
  --  ⌛ (:hourglass:) -> in progress
  --  ✅ (:white_check_mark:) -> done
  --  ❌ (:x:) -> cancelled
  s({ trig = "todomoji", show_condition = custom_conditions.line_begin }, {
    c(1, {
      sn(nil, { t("- 🎯 "), i(1) }),
      sn(nil, { t("- ⌛ "), i(1) }),
      sn(nil, { t("- ✅ "), i(1) }),
      sn(nil, { t("- ❌ "), i(1) }),
    }),
  }),
  s({ trig = "todomoji", show_condition = -custom_conditions.line_begin }, {
    c(1, {
      sn(nil, { t("🎯"), i(1) }),
      sn(nil, { t("⌛"), i(1) }),
      sn(nil, { t("✅"), i(1) }),
      sn(nil, { t("❌"), i(1) }),
    }),
  }),
}
