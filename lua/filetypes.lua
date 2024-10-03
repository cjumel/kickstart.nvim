-- Define filetype-related variables, to customize and complete filetypes known by Neovim. These tables can be updated
-- in the future to support more and more custom filetypes.

local M = {}

-- Map some filenames unknown to Neovim to the relevant filetype
M.filetype_by_filename = {
  [".env.example"] = "sh", -- same as `.env`
  [".env.test"] = "sh", -- same as `.env`
  [".env.test.example"] = "sh", -- same as `.env`
  [".ideavimrc"] = "vim",
  [".markdownlintrc"] = "json", -- could also be "ini"
  [".prettierignore"] = "conf", -- auto-detected by nvim
  [".shellcheckrc"] = "conf", -- auto-detected by nvim
  [".stow-global-ignore"] = "conf", -- auto-detected by nvim
  [".stow-local-ignore"] = "conf", -- auto-detected by nvim
  [".vimiumrc"] = "vim",
  ["ignore"] = "conf", -- auto-detected by nvim
  ["ripgreprc"] = "conf", -- auto-detected by nvim
}

-- Map some filenames unkown (or not well known) to nvim-web-devicons to the relevant icon data. In general, this table
--  should be updated whenever the `M.filetype_by_filename` table is updated. Icon data are taken from existing
--  filenames with `:lua print(require("nvim-web-devicons").get_icon_colors("name"))`.
M.icon_by_filename = {
  [".env.example"] = { icon = "", color = "#faf743", cterm_color = "227", name = ".env" },
  [".env.test"] = { icon = "", color = "#faf743", cterm_color = "227", name = ".env" },
  [".env.test.example"] = { icon = "", color = "#faf743", cterm_color = "227", name = ".env" },
  [".ideavimrc"] = { icon = "", color = "#019833", cterm_color = 28, name = "vim" },
  [".markdownlintrc"] = { icon = "", color = "#cbcb41", cterm_color = 185, name = "json" },
  [".shellcheckrc"] = { icon = "", color = "#6d8086", cterm_color = 66, name = "conf" },
  [".stow-global-ignore"] = { icon = "", color = "#6d8086", cterm_color = 66, name = "conf" },
  [".stow-local-ignore"] = { icon = "", color = "#6d8086", cterm_color = 66, name = "conf" },
  [".vimiumrc"] = { icon = "", color = "#019833", cterm_color = 28, name = "vim" },
  ["ignore"] = { icon = "", color = "#6d8086", cterm_color = 66, name = "conf" },
  ["ripgreprc"] = { icon = "", color = "#6d8086", cterm_color = 66, name = "conf" },
  ["tmux-pre-tpm.conf"] = { icon = "", color = "#14ba19", cterm_color = "34", name = "tmux.conf" },
  ["tmux-post-tpm.conf"] = { icon = "", color = "#14ba19", cterm_color = "34", name = "tmux.conf" },
}

-- List filetypes associated with temporary buffers (typically plugin ones, not related to an actual file)
M.temporary_filetypes = {
  "", -- No buffer opened
  "copilot-chat",
  "dap-repl",
  "dapui_breakpoints",
  "dapui_console",
  "dapui_scopes",
  "dapui_watches",
  "gitcommit",
  "lazy",
  "lspinfo",
  "mason",
  "NeogitCommitMessage",
  "NeogitCommitPopup",
  "NeogitCommitView",
  "NeogitPopup",
  "NeogitRebasePopup",
  "NeogitResetPopup",
  "NeogitStatus",
  "oil",
  "TelescopePrompt",
  "toggleterm",
  "trouble",
  "undotree",
}

return M
