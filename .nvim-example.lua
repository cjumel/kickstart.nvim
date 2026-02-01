---@type nvim_config.LanguageServers Mapping from language server name in nvim-spconfig to its configuration. Set to false to disable a default language server.
vim.g.language_servers = {}

---@type nvim_config.FormattersByFiletype Mapping from filetype to a list of formatter names.
vim.g.formatters_by_ft = {}
---@type nvim_config.FormatterToMasonName Mapping from formatter name in conform.nvim to its name in Mason, or false if it doesn't have a Mason package.
vim.g.formatter_to_mason_name = {}

---@type nvim_config.LintersByFiletype Mapping from filetype to a list of linter names.
vim.g.linters_by_ft = {}
---@type nvim_config.LinterToMasonName Mapping from linter name in nvim-lint to its name in Mason, or false if it doesn't have a Mason package.
vim.g.linter_to_mason_name = {}

vim.g.disable_format_on_save_on_fts = {} -- e.g., "*" or { "python" }
vim.g.disable_format_on_save_on_files = {} -- e.g., { "TODO.md" } (note that special characters like "." or "-" need to be escaped with a preceding "%")

vim.g.disable_lint_on_fts = {} -- e.g., "*" or { "python" }
vim.g.disable_lint_on_files = {} -- e.g., { "TODO.md" } (note that special characters like "." or "-" need to be escaped with a preceding "%")

---@type nvim_config.GitCommitConvention The convention to use for git commit messages.
vim.g.git_commit_convention = "conventional_commits"

vim.g.documentation_convention_by_ft = {} -- e.g., { python = "google_docstrings" }
