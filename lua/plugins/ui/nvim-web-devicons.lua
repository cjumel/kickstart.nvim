-- nvim-web-devicons
--
-- A Lua fork of vim-devicons, providing icons as well as colors for each icon, in both dark and light modes. This
-- plugin is a very standard plugin to use, as it is used by many other plugins, to provide many user-friendly and
-- customizable icons out-of-the-box.

return {
  "nvim-tree/nvim-web-devicons",
  lazy = true, -- Only used by many plugins as a dpendency
  opts = {
    -- Map some filenames unkown (or not well known) to nvim-web-devicons to the relevant icon data. Icon data are taken
    --  from existing filenames with `:lua print(require("nvim-web-devicons").get_icon_colors("name"))`.
    override_by_filename = {
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
    },
  },
}
