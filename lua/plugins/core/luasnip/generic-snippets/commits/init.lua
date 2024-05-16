local snippets = {}

local conventional_commits_snippets = require("plugins.core.luasnip.generic-snippets.commits.conventional_commits")
vim.list_extend(snippets, conventional_commits_snippets)

local gitmoji_snippets = require("plugins.core.luasnip.generic-snippets.commits.gitmoji")
vim.list_extend(snippets, gitmoji_snippets)

local wip_snippets = require("plugins.core.luasnip.generic-snippets.commits.wip")
vim.list_extend(snippets, wip_snippets)

return snippets
