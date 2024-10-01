local conds = require("plugins.core.luasnip.conditions")
local ls = require("luasnip")

local c = ls.choice_node
local i = ls.insert_node
local r = ls.restore_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

return {

  s({
    trig = "bold",
    docstring = "`**..**`",
  }, {
    t("**"), -- Using asterix is more robust than underscores as it works also within words & is preferred by Prettier
    i(1),
    t("**"),
  }),

  s({
    trig = "bold-italic",
    docstring = "`**_.._**`",
  }, {
    t("**_"), -- Using asterix is more robust than underscores as it works also within words & is preferred by Prettier
    i(1),
    t("_**"),
  }),

  s({
    trig = "header",
    show_condition = conds.empty_line,
    docstring = [[
Multiple-choice snippet:
- `# ..`
- `## ..`
- `### ..`
- `#### ..`
- `##### ..`]],
  }, {
    c(1, {
      sn(nil, { t("# "), r(1, "content", i(nil)) }),
      sn(nil, { t("## "), r(1, "content") }),
      sn(nil, { t("### "), r(1, "content") }),
      sn(nil, { t("#### "), r(1, "content") }),
      sn(nil, { t("##### "), r(1, "content") }),
    }),
  }),

  s({
    trig = "italic",
    docstring = "`_.._`",
  }, {
    t("_"),
    i(1),
    t("_"),
  }),

  s({
    trig = "link",
    docstring = "`[..](..)`",
  }, {
    t("["),
    i(1, "name"),
    t("]("),
    i(2, "link"),
    t(")"),
  }),

  s({
    trig = "quote-block",
    show_condition = conds.empty_line,
    docstring = [[
Multiple-choice snippet:
- `> ..`
- `>> ..`
- `>>> ..`]],
  }, {
    c(1, {
      sn(nil, { t("> "), r(1, "content", i(nil)) }),
      sn(nil, { t(">> "), r(1, "content") }),
      sn(nil, { t(">>> "), r(1, "content") }),
    }),
  }),

  s({
    trig = "code-block",
    show_condition = conds.empty_line,
    docstring = [[
\`\`\`..
..
\`\`\`]],
  }, {
    t("```"),
    c(1, { i(nil), t("shell", "python") }),
    t({ "", "" }),
    i(2),
    t({ "", "```" }),
  }),
}
