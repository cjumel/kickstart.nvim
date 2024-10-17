-- nvim-treesitter-context
--
-- nvim-teesitter-context is a lightweight plugin to show code context, using Treesitter. It is very handy to explore
-- very large files with a complex structure, as it provides very detailed insights on the current context while not
-- opening new windows or navigating in the code.

return {
  "nvim-treesitter/nvim-treesitter-context",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = { "BufNewFile", "BufReadPre" }, -- Lazy-loading on keys doesn't work for some reason
  opts = {
    enable = false, -- Keep it disable by default
  },
  config = function(_, opts)
    local ts_context = require("treesitter-context")

    ts_context.setup(opts)

    -- Create buffer-specific keymaps
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function()
        vim.keymap.set("n", "<leader>vc", ts_context.toggle, { desc = "[V]iew: [C]ontext", buffer = true })
        vim.keymap.set("n", "gP", function()
          -- Plugin needs to be enabled for the `go_to_context` action to work
          local is_disabled = not ts_context.enabled()
          if is_disabled then
            ts_context.enable()
          end

          ts_context.go_to_context()

          -- If plugin was initially disabled, re-disable it
          if is_disabled then
            ts_context.disable()
          end
        end, { desc = "Go to context parent node", buffer = true })
      end,
      group = vim.api.nvim_create_augroup("NvimTreesitterContextKeymaps", { clear = true }),
    })
  end,
}
