local ls = require("luasnip")
local snippet_conds = require("config.snippets.conditions")

local c = ls.choice_node
local d = ls.dynamic_node
local i = ls.insert_node
local r = ls.restore_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

return {
  s({ trig = "bold", desc = "`**…**`" }, { t("**"), i(1), t("**") }),
  s({ trig = "bold-italic", desc = "`**_…_**`" }, { t("**_"), i(1), t("_**") }),

  s({
    trig = "callout",
    show_condition = snippet_conds.line_begin * snippet_conds.line_end,
    desc = [[Available keywords:
- `NOTE`
- `TIP`
- `HELP`
- `IMPORTANT`
- `WARNING`
- `DANGER`
- `EXAMPLE`
- `TLDR`]],
  }, {
    t("> [!"),
    c(1, {
      sn(nil, { t("NOTE"), i(1) }),
      sn(nil, { t("TIP"), i(1) }),
      sn(nil, { t("HELP"), i(1) }),
      sn(nil, { t("IMPORTANT"), i(1) }),
      sn(nil, { t("WARNING"), i(1) }),
      sn(nil, { t("DANGER"), i(1) }),
      sn(nil, { t("EXAMPLE"), i(1) }),
      sn(nil, { t("TLDR"), i(1) }),
    }),
    t({ "]", ">", "> " }),
    i(2),
  }),

  s({
    trig = "code-block",
    show_condition = snippet_conds.line_begin * snippet_conds.line_end,
    desc = [[
\`\`\`…
…
\`\`\`]],
  }, { t("```"), c(1, { i(nil), t("bash") }), t({ "", "" }), i(2), t({ "", "```" }) }),

  s({
    trig = "date",
    desc = [[Choices:
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
    show_condition = snippet_conds.line_begin * snippet_conds.line_end,
    desc = [[
Multiple-choice snippet:
- `# …`
- `## …`
- `### …`
- `#### …`
- `##### …`]],
  }, {
    c(1, {
      sn(nil, { t("# "), r(1, "content", i(nil)) }),
      sn(nil, { t("## "), r(1, "content") }),
      sn(nil, { t("### "), r(1, "content") }),
      sn(nil, { t("#### "), r(1, "content") }),
      sn(nil, { t("##### "), r(1, "content") }),
    }),
  }),

  s({ trig = "italic", desc = "`_…_`" }, { t("_"), i(1), t("_") }),

  s({ trig = "link", desc = "`[…](…)`" }, { t("["), i(1, "name"), t("]("), i(2, "link"), t(")") }),

  s({
    trig = "quote-block",
    show_condition = snippet_conds.line_begin * snippet_conds.line_end,
    desc = [[
Multiple-choice snippet:
- `> …`
- `>> …`
- `>>> …`]],
  }, {
    c(1, {
      sn(nil, { t("> "), r(1, "content", i(nil)) }),
      sn(nil, { t(">> "), r(1, "content") }),
      sn(nil, { t(">>> "), r(1, "content") }),
    }),
  }),

  s({ trig = "strikethrough", desc = "~…~" }, { t("~"), i(1), t("~") }),

  s({
    trig = "time",
    desc = [[Choices:
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

  -- [[ GitHub Flavored Markdown ]]

  s({
    trig = "checkbox",
    show_condition = snippet_conds.line_begin,
    desc = [[
Multiple-choice snippet:
- `- [ ] …` (todo)
- `- [x] …` (done)
- `- [-] …` (WIP)
- `- [o] …` (blocked)
- `- [/] …` (cancelled)
(GitHub Flavored Markdown)]],
  }, {
    c(1, {
      sn(nil, { t("- [ ] "), r(1, "content", i(nil)) }),
      sn(nil, { t("- [x] "), r(1, "content") }),
      sn(nil, { t("- [-] "), r(1, "content") }),
      sn(nil, { t("- [o] "), r(1, "content") }),
      sn(nil, { t("- [/] "), r(1, "content") }),
    }),
  }),

  s({
    trig = "toggle-block",
    show_condition = snippet_conds.line_begin * snippet_conds.line_end,
    desc = [[
`<details>`
`<summary>…<\summary>`

`…`

`<\details>`
(GitHub Flavored Markdown)]],
  }, {
    t({ "<details>", "<summary>" }),
    i(1, "Summary"),
    t({ "</summary>", "", "" }), -- Line break after the summary is important for some blocks like code-blocks
    i(2, "Content"),
    t({ "", "", "</details>" }),
  }),
}
