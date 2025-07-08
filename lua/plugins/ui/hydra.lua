-- Hydra.nvim
--
-- This plugin provides a Neovim implementation of the famous Emacs Hydra package. It makes possible to define sub-menus
-- in Neovim, to make a set of actions a lot simpler to use than through regular keymaps, as there's no need to repeat
-- the common prefix in between the actions.

return {
  "nvimtools/hydra.nvim",
  keys = {
    { "<leader>d", desc = "[D]ebug menu" },
    { "<leader>h", desc = "[H]unk menu", mode = { "n", "v" } },
    { "<leader>m", desc = "[M]erge conflict menu" },
    { "<leader>n", desc = "[N]avigate menu" },
    { "<leader>,", desc = "Window menu" },
  },
  opts = {
    invoke_on_body = true,
    hint = { float_opts = { border = "rounded" } }, -- Improve visibility in transparent backgrounds
  },
  config = function(_, opts)
    local Hydra = require("hydra")
    Hydra.setup(opts)

    -- Scan the Hydra configs directory to setup Hydras
    local config_dir_path = vim.fn.stdpath("config") .. "/lua/plugins/ui/hydra/configs"
    local config_file_paths = vim.split(vim.fn.glob(config_dir_path .. "/*"), "\n")
    for _, config_file_path in ipairs(config_file_paths) do
      local config_file_path_split = vim.split(config_file_path, "/")
      local config_name = config_file_path_split[#config_file_path_split]:gsub("%.lua$", "")
      local config = require("plugins.ui.hydra.configs." .. config_name)
      Hydra(config)
    end
  end,
}
