return {
  "danymat/neogen",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  keys = { { "<leader>i", function() require("neogen").generate() end, desc = "[I]ntroduce documentation" } },
  opts = function()
    local i = require("neogen.types.template").item

    local base_opts = {
      snippet_engine = "luasnip",
      enable_placeholders = false,
      languages = {
        python = {
          template = {
            -- Define a google docstrings template without parameter types (see neogen.templates.google_docstrings for
            -- the original version)
            google_docstrings_custom = {
              { nil, '"""$1"""', { no_results = true, type = { "class", "func" } } },
              { nil, '"""$1', { no_results = true, type = { "file" } } },
              { nil, "", { no_results = true, type = { "file" } } },
              { nil, "$1", { no_results = true, type = { "file" } } },
              { nil, '"""', { no_results = true, type = { "file" } } },
              { nil, "", { no_results = true, type = { "file" } } },

              { nil, "# $1", { no_results = true, type = { "type" } } },

              { nil, '"""$1' },
              { i.HasParameter, "", { type = { "func" } } },
              { i.HasParameter, "Args:", { type = { "func" } } },
              { i.Parameter, "    %s: $1", { type = { "func" } } }, -- Modified
              { { i.Parameter, i.Type }, "    %s: $1", { required = i.Tparam, type = { "func" } } },
              { i.ArbitraryArgs, "    %s: $1", { type = { "func" } } },
              { i.Kwargs, "    %s: $1", { type = { "func" } } },
              { i.ClassAttribute, "    %s: $1", { before_first_item = { "", "Attributes: " } } },
              { i.HasReturn, "", { type = { "func" } } },
              { i.HasReturn, "Returns:", { type = { "func" } } },
              { i.HasReturn, "    $1", { type = { "func" } } },
              { i.HasYield, "", { type = { "func" } } },
              { i.HasYield, "Yields:", { type = { "func" } } },
              { i.HasYield, "    $1", { type = { "func" } } },
              { i.HasThrow, "", { type = { "func" } } },
              { i.HasThrow, "Raises:", { type = { "func" } } },
              { i.Throw, "    %s: $1", { type = { "func" } } },
              { nil, '"""' },
            },
          },
        },
      },
    }

    local new_opts = { languages = {} }
    for ft, documentation_convention in pairs(MetaConfig.documentation_convention_by_ft or {}) do
      new_opts.languages[ft] = { template = { annotation_convention = documentation_convention } }
    end

    return vim.tbl_deep_extend("force", base_opts, new_opts)
  end,
}
