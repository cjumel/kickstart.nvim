-- Additional keywords for GitHub Flavored Markdown

local conds = require("config.snippets.conditions")
local ls = require("luasnip")
local ls_show_conds = require("luasnip.extras.conditions.show")

local c = ls.choice_node
local i = ls.insert_node
local r = ls.restore_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

return {
  s({
    trig = "@me",
    desc = [[
`@cjumel`
(GitHub Flavored Markdown)]],
  }, { t("@cjumel") }),

  s({
    trig = "checkbox",
    show_condition = conds.line_begin,
    desc = [[
Multiple-choice snippet:
- `- [ ] …` (todo)
- `- [-] …` (WIP)
- `- [x] …` (done)
- `- [/] …` (cancelled)
(GitHub Flavored Markdown)]],
  }, {
    c(1, {
      sn(nil, { t("- [ ] "), r(1, "content", i(nil)) }),
      sn(nil, { t("- [-] "), r(1, "content") }),
      sn(nil, { t("- [x] "), r(1, "content") }),
      sn(nil, { t("- [/] "), r(1, "content") }),
    }),
  }),

  s({
    trig = "toggle-block",
    show_condition = conds.line_begin * ls_show_conds.line_end,
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
