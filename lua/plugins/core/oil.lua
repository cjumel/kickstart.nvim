return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false, -- Required to be used as default file explorer
  keys = {
    { "-", function() require("oil").open() end, desc = "Open parent directory" },
    { "g-", function() require("oil").open(vim.fn.getcwd()) end, desc = "Open current working directory" },
  },
  opts = {
    win_options = { number = false, relativenumber = false }, -- Disable line-numbering in Oil buffers
    cleanup_delay_ms = 0, -- Cleanup the Oil buffer right away to avoid jumping back to it with <C-o> and <C-i>
    lsp_file_methods = {
      timeout_ms = 5000, -- Default, 1000, often times out
      autosave_changes = true,
    },
    keymaps = {
      -- Since Oil can be used as an actual editable buffer, to edit files quickly and optionally in batch, let's not
      --  overwrite any keymap which could be useful for editing files, to still be able to use features like macros
      --  (with "q"), visual block edition (with "<C-v>") or decrementing (with "<C-x>") for instance

      -- Main actions
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["<CR>"] = "actions.select",
      ["g?"] = "actions.show_help",
      ["gx"] = "actions.open_external",

      -- Oil buffer actions
      ["<localleader>d"] = {
        function() -- Function taken from Oil recipes
          DETAIL = not DETAIL
          if DETAIL then
            require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
          else
            require("oil").set_columns({ "icon" })
          end
        end,
        desc = "Toggle [D]etails",
      },
      ["<localleader>h"] = { "actions.toggle_hidden", desc = "Toggle [H]idden files" },
      ["<localleader>p"] = { "actions.preview", desc = "Toggle [P]review" },
      ["<localleader>r"] = { "actions.refresh", desc = "[R]efresh" },
      ["<localleader>s"] = { "actions.change_sort", desc = "Change [S]ort" },
    },
    use_default_keymaps = false,
    view_options = { is_always_hidden = function(name, _) return name == ".." end },
  },
  config = function(_, opts)
    require("oil").setup(opts)

    -- Use same highlight groups for hidden and non-hidden items in Oil buffers
    vim.api.nvim_set_hl(0, "OilDirHidden", { link = "OilDir" })
    vim.api.nvim_set_hl(0, "OilSocketHidden", { link = "OilSocket" })
    vim.api.nvim_set_hl(0, "OilLinkHidden", { link = "OilLink" })
    vim.api.nvim_set_hl(0, "OilOrphanLinkHidden", { link = "OilOrphanLink" })
    vim.api.nvim_set_hl(0, "OilLinkTargetHidden", { link = "OilLinkTarget" })
    vim.api.nvim_set_hl(0, "OilOrphanLinkTargetHidden", { link = "OilOrphanLinkTarget" })
    vim.api.nvim_set_hl(0, "OilFileHidden", { link = "OilFile" })
  end,
}
