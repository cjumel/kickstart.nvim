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

        map("n", "<leader>cb", function() git_conflict.choose("both") end, { desc = "[C]onflict: [C]hoose [B]oth" })
        map("n", "<leader>cn", function() git_conflict.choose("none") end, { desc = "[C]onflict: [C]hoose [N]one" })
        map("n", "<leader>co", function() git_conflict.choose("ours") end, { desc = "[C]onflict: [C]hoose [O]urs" })
        map("n", "<leader>ct", function() git_conflict.choose("theirs") end, { desc = "[C]onflict: [C]hoose [T]heirs" })

        local function next_conflict_base() git_conflict.find_next("base") end
        local function prev_conflict_base() git_conflict.find_prev("base") end
        map({ "n", "x", "o" }, "]b", next_conflict_base, { desc = "Next conflict [B]ase side" })
        map({ "n", "x", "o" }, "[b", prev_conflict_base, { desc = "Previous conflict [B]ase side" })
        local function next_conflict_ours() git_conflict.find_next("ours") end
        local function prev_conflict_ours() git_conflict.find_prev("ours") end
        map({ "n", "x", "o" }, "]o", next_conflict_ours, { desc = "Next conflict [O]urs side" })
        map({ "n", "x", "o" }, "[o", prev_conflict_ours, { desc = "Previous conflict [O]urs side" })
        local function next_conflict_theirs() git_conflict.find_next("theirs") end
        local function prev_conflict_theirs() git_conflict.find_prev("theirs") end
        map({ "n", "x", "o" }, "]t", next_conflict_theirs, { desc = "Next conflict [T]heirs side" })
        map({ "n", "x", "o" }, "[t", prev_conflict_theirs, { desc = "Previous conflict [T]heirs side" })
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
