local snippets = {}

local conventional_commits_snipets = require("plugins.core.luasnip.generic-snippets.commits.conventional_commits")
vim.list_extend(snippets, conventional_commits_snipets)

local gitmoji_snipets = require("plugins.core.luasnip.generic-snippets.commits.gitmoji")
vim.list_extend(snippets, gitmoji_snipets)

return snippets
