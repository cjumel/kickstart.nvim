-- Setup custom file types

-- Map some filenames unknown to Neovim to the relevant filetype
local filetype_by_filename = {
  [".env.example"] = "sh", -- same as `.env`
  [".env.test"] = "sh", -- same as `.env`
  [".env.test.example"] = "sh", -- same as `.env`
  [".ideavimrc"] = "vim",
  [".markdownlintrc"] = "json", -- could also be "ini"
  [".prettierignore"] = "conf", -- auto-detected by nvim
  [".prettierrc"] = "yaml", -- could also be "json"
  [".shellcheckrc"] = "conf", -- auto-detected by nvim
  [".stow-global-ignore"] = "conf", -- auto-detected by nvim
  [".stow-local-ignore"] = "conf", -- auto-detected by nvim
  [".vimiumrc"] = "vim",
  [".yamlfmt"] = "yaml",
  [".yamllint"] = "yaml",
  ["ignore"] = "conf", -- auto-detected by nvim
  ["ripgreprc"] = "conf", -- auto-detected by nvim
}
vim.filetype.add({ filename = filetype_by_filename })

-- Map some filenames unkown (or not well known) to Neovim/nvim-web-devicons to the relevant icon data
-- Icon data are taken from existing filenames with `:lua print(require("nvim-web-devicons").get_icon_colors("name"))`
local icons = {
  [".env.example"] = { icon = "", color = "#faf743", cterm_color = "227", name = ".env" },
  [".env.test"] = { icon = "", color = "#faf743", cterm_color = "227", name = ".env" },
  [".env.test.example"] = { icon = "", color = "#faf743", cterm_color = "227", name = ".env" },
  [".ideavimrc"] = { icon = "", color = "#019833", cterm_color = 28, name = "vim" },
  [".markdownlintrc"] = { icon = "", color = "#cbcb41", cterm_color = 185, name = "json" },
  [".prettierignore"] = { icon = "", color = "#6d8086", cterm_color = 66, name = "conf" },
  [".shellcheckrc"] = { icon = "", color = "#6d8086", cterm_color = 66, name = "conf" },
  [".stow-global-ignore"] = { icon = "", color = "#6d8086", cterm_color = 66, name = "conf" },
  [".stow-local-ignore"] = { icon = "", color = "#6d8086", cterm_color = 66, name = "conf" },
  [".vimiumrc"] = { icon = "", color = "#019833", cterm_color = 28, name = "vim" },
  [".yamlfmt"] = { icon = "", color = "#6d8086", cterm_color = 66, name = "yaml" },
  [".yamllint"] = { icon = "", color = "#6d8086", cterm_color = 66, name = "yaml" },
  ["ignore"] = { icon = "", color = "#6d8086", cterm_color = 66, name = "conf" },
  ["ripgreprc"] = { icon = "", color = "#6d8086", cterm_color = 66, name = "conf" },
  ["tmux-pre-tpm.conf"] = { icon = "", color = "#14ba19", cterm_color = "34", name = "tmux.conf" },
  ["tmux-post-tpm.conf"] = { icon = "", color = "#14ba19", cterm_color = "34", name = "tmux.conf" },
}
require("nvim-web-devicons").set_icon(icons)

-- List filetypes associated with temporary buffers (typically plugin ones)
-- This is also updated by plugins in their `init` function
vim.g.temporary_filetypes = {
  "", -- No buffer opened
}
