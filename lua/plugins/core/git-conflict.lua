return {
  "akinsho/git-conflict.nvim",
  event = { "BufReadPre" },
  opts = {
    default_mappings = false, -- Keymaps are implemented in Hydra.nvim and below
    disable_diagnostics = true,
  },
  config = function(_, opts)
    local git_conflict = require("git-conflict")
    git_conflict.setup(opts)

    vim.api.nvim_create_autocmd("User", {
      pattern = "GitConflictDetected",
      callback = function(event)
        local map = require("config.utils").get_buffer_map_function(event.buf)

        map("n", "<leader>cb", function() git_conflict.choose("both") end, { desc = "[C]onflict: choose [B]oth" })
        map("n", "<leader>cn", function() git_conflict.choose("none") end, { desc = "[C]onflict: choose [N]one" })
        map("n", "<leader>co", function() git_conflict.choose("ours") end, { desc = "[C]onflict: choose [O]urs" })
        map("n", "<leader>ct", function() git_conflict.choose("theirs") end, { desc = "[C]onflict: choose [T]heirs" })
        map({ "n", "x", "o" }, "]x", function() git_conflict.find_next("ours") end, { desc = "Next conflict" })
        map({ "n", "x", "o" }, "[x", function() git_conflict.find_prev("ours") end, { desc = "Previous conflict" })
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = "GitConflictResolved",
      callback = function(event)
        local unmap = require("config.utils").get_buffer_unmap_function(event.buf)

        unmap("n", "<leader>cb")
        unmap("n", "<leader>cn")
        unmap("n", "<leader>co")
        unmap("n", "<leader>ct")

        unmap({ "n", "x", "o" }, "]b")
        unmap({ "n", "x", "o" }, "[b")
        unmap({ "n", "x", "o" }, "]o")
        unmap({ "n", "x", "o" }, "[o")
        unmap({ "n", "x", "o" }, "]t")
        unmap({ "n", "x", "o" }, "[t")
      end,
    })
  end,
}
