-- Complete biome LSP setup to support:
--  - unsafe check fixes
--  - formatting/check fixing the entire project (e.g. after a batch edition when format-on-save is not enabled)

return {
  name = "biome",
  condition = {
    callback = function(_)
      if vim.fn.executable("biome") == 0 then
        return false
      end
      local ts_utils = require("config.lang_utils.typescript")
      return ts_utils.is_project()
    end,
  },
  generator = function(_, cb)
    local overseer = require("overseer")
    local base_template = {
      params = {
        args = {
          type = "list",
          delimiter = " ",
          optional = true,
          default = {},
        },
      },
    }
    cb({
      overseer.wrap_template(base_template, {
        name = "biome format --write <file>",
        tags = { "FORMAT" },
        priority = 1,
        condition = { filetype = "typescript" },
        builder = function(params)
          return {
            cmd = { "biome", "format", "--write" },
            args = vim.list_extend({ vim.fn.expand("%:p:.") }, params.args),
          }
        end,
      }),
      overseer.wrap_template(base_template, {
        name = "biome format --write",
        tags = { "FORMAT" },
        priority = 2,
        builder = function(params)
          return {
            cmd = { "biome", "format", "--write" },
            args = params.args,
          }
        end,
      }),
      overseer.wrap_template(base_template, {
        name = "biome check --write <file>",
        tags = { "CHECK" },
        priority = 1,
        condition = { filetype = "typescript" },
        builder = function(params)
          return {
            cmd = { "biome", "check", "--write" },
            args = vim.list_extend({ vim.fn.expand("%:p:.") }, params.args),
          }
        end,
      }),
      overseer.wrap_template(base_template, {
        name = "biome check --write --unsafe <file>",
        tags = { "CHECK" },
        priority = 2,
        condition = { filetype = "typescript" },
        builder = function(params)
          return {
            cmd = { "biome", "check", "--write", "--unsafe" },
            args = vim.list_extend({ vim.fn.expand("%:p:.") }, params.args),
          }
        end,
      }),
      overseer.wrap_template(base_template, {
        name = "biome check --write",
        tags = { "CHECK" },
        priority = 3,
        builder = function(params)
          return {
            cmd = { "biome", "check", "--write" },
            args = params.args,
          }
        end,
      }),
      overseer.wrap_template(base_template, {
        name = "biome check --write --unsafe",
        tags = { "CHECK" },
        priority = 4,
        builder = function(params)
          return {
            cmd = { "biome", "check", "--write", "--unsafe" },
            args = params.args,
          }
        end,
      }),
    })
  end,
}
