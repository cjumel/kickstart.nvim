local conds = require("plugins.core.luasnip.conditions")
local ls = require("luasnip")
local ls_show_conds = require("luasnip.extras.conditions.show")

local c = ls.choice_node
local d = ls.dynamic_node
local i = ls.insert_node
local r = ls.restore_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

return {

  s({
    trig = "bold",
    desc = "`**..**`",
  }, {
    t("**"), -- Using asterix is more robust than underscores as it works also within words & is preferred by Prettier
    i(1),
    t("**"),
  }),

  s({
    trig = "bold-italic",
    desc = "`**_.._**`",
  }, {
    t("**_"), -- Using asterix is more robust than underscores as it works also within words & is preferred by Prettier
    i(1),
    t("_**"),
  }),

  s({
    trig = "code-block",
    show_condition = conds.line_begin * ls_show_conds.line_end,
    desc = [[
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

  s({
    trig = "date",
    desc = [[
Multiple-choice snippet:
- `<%Y>-<%m>-<%d>` (ISO 8601)
- `<%d>/<%m>/<%Y>` (French)]],
  }, {
    d(
      1,
      function(_)
        return sn(nil, {
          c(1, {
            sn(nil, { t(os.date("%Y-%m-%d")), i(1) }),
            sn(nil, { t(os.date("%d/%m/%Y")), i(1) }),
          }),
        })
      end
    ),
  }),

  s({
    trig = "header",
    show_condition = conds.line_begin * ls_show_conds.line_end,
    desc = [[
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
    desc = "`_.._`",
  }, {
    t("_"),
    i(1),
    t("_"),
  }),

  s({
    trig = "link",
    desc = "`[..](..)`",
  }, {
    t("["),
    i(1, "name"),
    t("]("),
    i(2, "link"),
    t(")"),
  }),

  s({
    trig = "quote-block",
    show_condition = conds.line_begin * ls_show_conds.line_end,
    desc = [[
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
    trig = "strikethrough",
    desc = "~..~",
  }, {
    t("~"),
    i(1),
    t("~"),
  }),

  s({
    trig = "time",
    desc = [[
Multiple-choice snippet:
- `<%H>:<%M>` (ISO 8601)
- `<%H>h<%M>` (French)]],
  }, {
    d(
      1,
      function(_)
        return sn(nil, {
          c(1, {
            sn(nil, { t(os.date("%H:%M")), i(1) }),
            sn(nil, { t(os.date("%Hh%M")), i(1) }),
          }),
        })
      end
    ),
  }),
}
