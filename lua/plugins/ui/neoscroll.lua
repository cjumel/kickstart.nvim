-- Neoscroll
--
-- A smooth scrolling Neovim plugin written in Lua.

return {
  "karb94/neoscroll.nvim",
  event = "VeryLazy",
  opts = {},
  config = function(_, opts)
    require("neoscroll").setup(opts)

    -- Add support for scrolling with <C-a>
    local t = {} -- Syntax: t[keys] = {function, {function arguments}}
    t["<C-a>"] = { "scroll", { "-0.10", "false", "100" } }
    require("neoscroll.config").set_mappings(t)
  end,
}
