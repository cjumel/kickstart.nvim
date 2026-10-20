-- [[ Defaults ]]

---@type nvim_config.MasonPackageVersions Mapping of Mason packages and their versions to install.
vim.g.mason_package_versions = {}

---@type nvim_config.LanguageServers Mapping from language server name in nvim-spconfig to its configuration. Set to false to disable a default language server.
vim.g.language_servers = {}

---@type nvim_config.FormattersByFiletype Mapping from filetype to a list of formatter names.
vim.g.formatters_by_ft = {}

---@type nvim_config.LintersByFiletype Mapping from filetype to a list of linter names.
vim.g.linters_by_ft = {}

---@type nvim_config.DisableFormatOnSave Determine when to disable format on save, globally or per-buffer.
vim.g.disable_format_on_save = false

---@type nvim_config.CommitConvention The convention to use for git commit messages.
vim.g.commit_convention = "conventional_commits"

---@type nvim_config.AnnotationConventionByFt The convention to use for annotations, like docstrings.
vim.g.annotation_convention_by_ft = {}

-- [[ Examples ]]

-- Biome project setup
-- Uncomment this section in a project-local .nvim.lua (or integrate it in the relevant settings directly), then run
-- :InstallAll to install Biome and have it setup as formatter in the relevant file types. This requires a Biome
-- workspace to be setup.

-- vim.g.mason_package_versions = vim.tbl_extend("force", vim.g.mason_package_versions or {}, {
--   biome = "2.5.14",
-- })
-- vim.g.language_servers = vim.tbl_deep_extend("force", vim.g.language_servers or {}, {
--   biome = {
--     filetypes = { "javascript", "json", "typescript" },
--     config = {
--       -- To enable also outside of workspaces:
--       -- workspace_required = false,
--       -- root_dir = function(bufnr, on_dir) on_dir(vim.fs.root(bufnr, { ".git" }) or vim.fn.getcwd()) end,
--     },
--   },
--   jsonls = {
--     config = {
--       init_options = {
--         provideFormatter = false,
--       },
--     },
--   },
--   ts_ls = {
--     config = {
--       on_attach = function(client)
--         client.server_capabilities.documentFormattingProvider = false
--         client.server_capabilities.documentRangeFormattingProvider = false
--       end,
--     },
--   },
-- })
--
-- -- HACK: for some reason, when opening a file which starts the biome LSP for the first time, biome's features are not
-- -- available until the buffer is reloaded or another file is opened
--
-- -- Biome needs a buffer reload the first time it starts.
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "typescript",
--   once = true,
--   callback = function()
--     vim.defer_fn(function() vim.cmd("edit") end, 1000)
--   end,
-- })
