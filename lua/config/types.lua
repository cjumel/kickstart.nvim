---@meta

---@class ThemeConfig
---@field background "dark" | "light" The background of the theme.
---@field colorscheme_name string? Name of the colorscheme to apply.
---@field colorscheme_opts table? Options of the colorscheme to apply.
---@field option_callback function? Callback function called with the options.
---@field lualine_opts table? Options for the lualine statusline plugin.

---@class nvim_config.MasonConfig
---@field name string The name of the package in Mason.
---@field version string The version of the package to install.

---@alias nvim_config.MasonPackages nvim_config.MasonConfig[]

---@class nvim_config.LanguageServerConfig
---@field filetypes string[] The filetypes triggering this language server, for language server lazy-loading.
---@field config? vim.lsp.Config The configuration to pass to the language server when setting it up.
---@field mason? string The name of the language server in Mason, when different from the name in nvim-lspconfig.

---@alias nvim_config.LanguageServers table<string, nvim_config.LanguageServerConfig|false>

---@alias nvim_config.FormattersByFiletype table<string, conform.FiletypeFormatter>

---@alias nvim_config.LintersByFiletype table<string, string[]>

---@alias nvim_config.DisableFormatOnSave boolean | function(bufnr: number) -> boolean

---@alias nvim_config.CommitConvention "conventional_commits" |  "gitmoji" | false

---@alias nvim_config.AnnotationConventionByFt table<string, string>

---@alias nvim_config.DisableDeprecationWarnings boolean

---@alias nvim_config.EnableGhCopilotPlugins boolean
