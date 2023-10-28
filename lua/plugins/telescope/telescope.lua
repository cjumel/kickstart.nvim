-- telescope.nvim
--
-- Gaze deeply into unknwn regions of your code with powerful and blazing fast fuzzy finding
-- tools.

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "nvim-telescope/telescope-fzf-native.nvim",
    "nvim-treesitter/nvim-treesitter",
    "folke/trouble.nvim",
  },
  keys = {
    -- General
    {
      "<leader>fr",
      function()
        require("telescope.builtin").resume()
      end,
      desc = "[F]ind: [R]esume",
    },

    -- Find files
    {
      "<leader>ff",
      function()
        require("telescope.builtin").find_files({
          find_command = { "rg", "--files", "--hidden" },
        })
      end,
      desc = "[F]ind: [F]iles",
    },
    {
      "<leader>fa",
      function()
        require("telescope.builtin").find_files({
          find_command = { "rg", "--files", "--hidden" },
          follow = true,
          no_ignore = true,
        })
      end,
      desc = "[F]ind: [A]ll files",
    },
    {
      "<leader>fo",
      function()
        require("telescope.builtin").oldfiles()
      end,
      desc = "[F]ind: [O]ld files",
    },
    {
      "<leader>fc",
      function()
        require("telescope.builtin").git_status()
      end,
      desc = "[F]ind: [C]hanged files",
    },
    {
      "<leader>fb",
      function()
        require("telescope.builtin").buffers()
      end,
      desc = "[F]ind: [B]uffers",
    },
    {
      "<leader>fg",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "[F]ind: by [G]rep",
    },
    {
      "<leader>fw",
      function()
        require("telescope.builtin").grep_string()
      end,
      desc = "[F]ind: [W]ord under the cursor",
    },

    -- Git-related
    {
      "<leader>gb",
      function()
        local opts = require("telescope.themes").get_dropdown({
          initial_mode = "normal",
          layout_config = {
            anchor = "N", -- Anchor to the top of the screen
            width = 0.8,
          },
        })
        require("telescope.builtin").git_branches(opts)
      end,
      desc = "[G]it: [B]ranches",
    },
    {
      "<leader>gl",
      function()
        local opts = require("telescope.themes").get_dropdown({
          initial_mode = "normal",
          layout_config = {
            anchor = "N", -- Anchor to the top of the screen
            width = 0.8,
          },
        })
        require("telescope.builtin").git_commits(opts)
      end,
      desc = "[G]it: [L]og",
    },

    -- Vim- or Neovim-related
    {
      "<leader><leader>",
      function()
        local opts = require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        })

        -- Simplify the display of commands with only name & description
        local displayer = require("telescope.pickers.entry_display").create({
          separator = "▏",
          items = {
            { width = 0.33 },
            { remaining = true },
          },
        })
        local make_display = function(entry)
          return displayer({
            { entry.name, "TelescopeResultsIdentifier" },
            entry.definition,
          })
        end
        local entry_maker = function(entry)
          return {
            name = entry.name,
            bang = entry.bang,
            nargs = entry.nargs,
            complete = entry.complete,
            definition = entry.definition,
            --
            value = entry,
            valid = true,
            ordinal = entry.name,
            display = make_display,
          }
        end
        opts.entry_maker = entry_maker

        require("telescope.builtin").commands(opts)
      end,
      desc = "[ ] Find fuzzily in commands",
    },
    {
      "<leader>:",
      function()
        require("telescope.builtin").command_history(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end,
      desc = "[:] Find fuzzily in command history",
    },
    {
      "<leader>/",
      function()
        require("telescope.builtin").current_buffer_fuzzy_find(
          require("telescope.themes").get_dropdown({
            winblend = 10,
            previewer = false,
          })
        )
      end,
      desc = "[/] Find fuzzily in buffer",
    },
    {
      "<leader>fk",
      function()
        require("telescope.builtin").keymaps()
      end,
      desc = "[F]ind: [K]eymaps",
    },
    {
      "<leader>fh",
      function()
        require("telescope.builtin").help_tags()
      end,
      desc = "[F]ind: [H]elp tags",
    },
  },
  init = function()
    vim.api.nvim_create_user_command("GitStashList", function()
      local opts = require("telescope.themes").get_dropdown({
        initial_mode = "normal",
        layout_config = {
          anchor = "N", -- Anchor to the top of the screen
          width = 0.8,
        },
      })
      require("telescope.builtin").git_stash(opts)
    end, { desc = "Git stash list" })
  end,
  config = function()
    local actions = require("telescope.actions")
    local trouble = require("trouble.providers.telescope")
    require("telescope").setup({
      defaults = {
        mappings = {
          n = {
            ["="] = actions.select_default,
            ["<c-t>"] = trouble.open_with_trouble,
          },
          i = {
            ["<c-t>"] = trouble.open_with_trouble,
          },
        },
        -- vimgrep_arguments is used for live_grep and grep_string
        vimgrep_arguments = {
          "rg",
          "--color=never", -- must not be removed
          "--no-heading", -- must not be removed
          "--with-filename", -- must not be removed
          "--line-number", -- must not be removed
          "--column", -- must not be removed
          "--smart-case",
          "--hidden",
        },
        file_ignore_patterns = {
          ".git/",
        },
        layout_config = {
          horizontal = {
            preview_width = 0.5,
          },
        },
      },
    })

    -- Enable telescope fzf native, if installed
    pcall(require("telescope").load_extension, "fzf")
  end,
}
