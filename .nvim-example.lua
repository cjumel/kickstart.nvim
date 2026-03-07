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

---@type nvim_config.DisableFormatOnSave Determine when to disable format on save, globally or per-buffer.
vim.g.disable_format_on_save = false

---@type nvim_config.CommitConvention The convention to use for git commit messages.
vim.g.commit_convention = "conventional_commits"

---@type nvim_config.AnnotationConventionByFt The convention to use for annotations, like docstrings.
vim.g.annotation_convention_by_ft = {}
