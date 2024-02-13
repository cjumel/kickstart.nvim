local ls = require("luasnip")

local i = ls.insert_node
local s = ls.snippet

local fmt = require("luasnip.extras.fmt").fmt

local show_conds = require("luasnip.extras.conditions.show")
local custom_show_conds = require("plugins.core.luasnip.show_conds")

return {
  s("link", fmt("[{}]({})", { i(1, "name"), i(2, "url") })),
  s(
    {
      trig = "code-block",
      show_condition = custom_show_conds.line_begin * show_conds.line_end,
    },
    fmt(
      [[
	```{}
	{}
	```
      ]],
      { i(1, "shell"), i(2, "code") }
    )
  ),
  s(
    {
      trig = "toggle-block",
      show_condition = custom_show_conds.line_begin * show_conds.line_end,
    },
    fmt(
      [[
	<details>
	    <summary>{}</summary>
	    {}
	</details>
      ]],
      { i(1, "Summary"), i(2, "Content") }
    )
  ),
}
