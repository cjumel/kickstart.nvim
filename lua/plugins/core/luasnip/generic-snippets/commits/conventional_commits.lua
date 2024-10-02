local conds = require("plugins.core.luasnip.conditions")
local ls = require("luasnip")

local i = ls.insert_node
local c = ls.choice_node
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node

-- Names are taken from https://www.conventionalcommits.org/en/v1.0.0/#specification, but descriptions are a mix from
--  the Gitmoji equivalent, in https://gitmoji.dev/, and a Conventional Commits cheat sheet, in
--  https://kapeli.com/cheat_sheets/Conventional_Commits.docset/Contents/Resources/Documents/index
local conventional_commits_data = {
  { name = "build", desc = "Add or update the build system or external dependencies." },
  { name = "chore", desc = "Other changes." },
  { name = "ci", desc = "Add or update CI configuration files and scripts." },
  { name = "docs", desc = "Add or update documentation." },
  { name = "feat", desc = "Introduce new features." },
  { name = "fix", desc = "Fix a bug." },
  { name = "perf", desc = "Improve performance." },
  { name = "refactor", desc = "Refactor code." },
  { name = "revert", desc = "Revert a previous commit." },
  { name = "style", desc = "Update the style of the code." },
  { name = "test", desc = "Add, update, or pass tests." },
}

local snippets = {}
for _, conventional_commit_data in ipairs(conventional_commits_data) do
  table.insert(
    snippets,
    s({
      trig = conventional_commit_data.name,
      show_condition = conds.line_begin,
      desc = conventional_commit_data.desc
        .. " (Conventional Commits)\n\nMultiple-choice snippet:\n- `"
        .. conventional_commit_data.name
        .. ": ..`\n- `"
        .. conventional_commit_data.name
        .. "(..): ..` (with scope)\n- `"
        .. conventional_commit_data.name
        .. "!: ..` (with breaking change)\n- `"
        .. conventional_commit_data.name
        .. "(..)!: ..` (with scope and breaking change)",
    }, {
      c(1, {
        sn(nil, { t(conventional_commit_data.name .. ": "), i(1) }),
        sn(nil, { t(conventional_commit_data.name .. "("), i(1), t("): ") }), -- With scope
        sn(nil, { t(conventional_commit_data.name .. "!: "), i(1) }), -- With breaking change
        sn(nil, { t(conventional_commit_data.name .. "("), i(1), t(")!: ") }), -- With scope & breaking change
      }),
    })
  )
end

return snippets
