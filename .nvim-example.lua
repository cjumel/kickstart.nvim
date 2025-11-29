vim.g.disable_conventional_commit_snippets = false
vim.g.disable_gitmoji_snippets = false

vim.g.formatters_by_ft = {} -- e.g., { python = { "ruff_organize_imports" }}
vim.g.formatter_to_mason_name = {} -- e.g., { ruff_organize_imports = "ruff" }
vim.g.disable_format_on_save_on_fts = {} -- e.g., "*" or { "python" }
vim.g.disable_format_on_save_on_files = {} -- e.g., { "TODO.md" } (note that special characters like "." or "-" need to be escaped with a preceding "%")

vim.g.linters_by_ft = {} -- e.g., { python = { "ruff" } }
vim.g.linter_to_mason_name = {}
vim.g.disable_lint_on_fts = {} -- e.g., "*" or { "python" }
vim.g.disable_lint_on_files = {} -- e.g., { "TODO.md" } (note that special characters like "." or "-" need to be escaped with a preceding "%")

vim.g.documentation_convention_by_ft = {} -- e.g., { python = "google_docstrings" }
