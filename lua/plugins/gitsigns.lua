-- gitsigns.nvim
--
-- Super fast git decorations and utilities implemented purely in Lua, which make it and fugitive
-- perfect for a complete git integration.

return {
  "lewis6991/gitsigns.nvim",
  opts = {
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
    on_attach = function(bufnr)
      -- Use keymaps very similar to gitsigns and kickstart defaults

      -- Navigation (don't override Fugitive keymaps)
      vim.keymap.set({ "n", "v" }, "[g", function()
        if vim.wo.diff then
          return "]c"
        end
        vim.schedule(function()
          require("gitsigns").next_hunk()
        end)
        return "<Ignore>"
      end, { expr = true, buffer = bufnr, desc = "Next Git hunk" })
      vim.keymap.set({ "n", "v" }, "]g", function()
        if vim.wo.diff then
          return "[c"
        end
        vim.schedule(function()
          require("gitsigns").prev_hunk()
        end)
        return "<Ignore>"
      end, { expr = true, buffer = bufnr, desc = "Previous Git hunk" })

      -- Actions
      vim.keymap.set(
        "n",
        "<leader>gp",
        require("gitsigns").preview_hunk,
        { buffer = bufnr, desc = "[G]it [P]review hunk" }
      )
      vim.keymap.set(
        "n",
        "<leader>ga",
        require("gitsigns").stage_hunk,
        { buffer = bufnr, desc = "[G]it [A]dd hunk" }
      )
      vim.keymap.set("v", "<leader>ga", function()
        require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { buffer = bufnr, desc = "[G]it [A]dd lines" })
      vim.keymap.set(
        "n",
        "<leader>gA",
        require("gitsigns").stage_buffer,
        { buffer = bufnr, desc = "[G]it [A]dd buffer" }
      )
      vim.keymap.set(
        "n",
        "<leader>gu",
        require("gitsigns").undo_stage_hunk,
        { buffer = bufnr, desc = "[G]it [U]ndo 'add hunk'" }
      )
      vim.keymap.set(
        "n",
        "<leader>gr",
        require("gitsigns").reset_hunk,
        { buffer = bufnr, desc = "[G]it [R]eset hunk" }
      )
      vim.keymap.set("v", "<leader>gr", function()
        require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { buffer = bufnr, desc = "[G]it [R]eset lines" })
      vim.keymap.set(
        "n",
        "<leader>gR",
        require("gitsigns").reset_buffer,
        { buffer = bufnr, desc = "[G]it [R]eset buffer" }
      )
      vim.keymap.set(
        "n",
        "<leader>gd",
        require("gitsigns").toggle_deleted,
        { buffer = bufnr, desc = "[G]it toggle [D]eleted" }
      )

      -- Text object
      vim.keymap.set(
        { "o", "x" },
        "ig",
        ":<C-U>Gitsigns select_hunk<CR>",
        { buffer = bufnr, desc = "inner git hunk" }
      )
      vim.keymap.set(
        { "o", "x" },
        "ag",
        ":<C-U>Gitsigns select_hunk<CR>",
        { buffer = bufnr, desc = "a git hunk" }
      )
    end,
  },
}
