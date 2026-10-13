return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false, -- Lazy-loading is not supported for this plugin
  config = function()
    local config_data = require("config.data")
    local filetypes = {}
    for _, parser in ipairs(config_data.treesitter_parsers) do
      for _, filetype in ipairs(vim.treesitter.language.get_filetypes(parser)) do
        filetypes[filetype] = true
      end
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = vim.tbl_keys(filetypes),
      callback = function()
        vim.treesitter.start() -- Enable highlighting
        -- Enable indentation only if it's available, to preserve nvim's builtin indentation otherwise
        local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
        if lang and #vim.treesitter.query.get_files(lang, "indents") > 0 then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
