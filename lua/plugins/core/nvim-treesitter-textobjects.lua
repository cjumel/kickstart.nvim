return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = "VeryLazy",
  opts = {
    select = { lookahead = true }, -- Automatically jump forward to text-object if not on one
    move = { set_jumps = true }, -- Set jumps in the jumplist
  },
  config = function(_, opts)
    require("nvim-treesitter-textobjects").setup(opts)

    local select = require("nvim-treesitter-textobjects.select")
    local move = require("nvim-treesitter-textobjects.move")

    local function textobject(lhs, query, desc)
      vim.keymap.set({ "x", "o" }, lhs, function() select.select_textobject(query, "textobjects") end, { desc = desc })
    end
    local function motion(lhs, method, query, desc)
      vim.keymap.set({ "n", "x", "o" }, lhs, function() method(query, "textobjects") end, { desc = desc })
    end

    textobject("aa", "@parameter.outer", "argument")
    textobject("ia", "@parameter.inner", "inner argument")
    textobject("ac", "@class.outer", "class definition")
    textobject("ic", "@class.inner", "inner class definition")
    textobject("af", "@call.outer", "function call")
    textobject("if", "@call.inner", "inner function call")
    textobject("ag", "@comment.outer", "comment") -- "g" like builtin "gc" operator
    textobject("ig", "@comment.inner", "inner comment") -- "g" like builtin "gc" operator
    textobject("ai", "@conditional.outer", "if/else if/else statement")
    textobject("ii", "@conditional.inner", "inner if/else if/else statement")
    textobject("al", "@loop.outer", "loop")
    textobject("il", "@loop.inner", "inner loop")
    textobject("am", "@function.outer", "method definition")
    textobject("im", "@function.inner", "inner method definition")
    textobject("ar", "@return.outer", "return statement")
    textobject("ir", "@return.inner", "inner return statement")
    textobject("a=", "@assignment.outer", "assignment")
    textobject("i=", "@assignment.inner", "inner assignment")
    textobject("gl", "@assignment.lhs", "Left-hand side of assignment")
    textobject("gr", "@assignment.rhs", "Right-hand side of assignment")

    motion("]c", move.goto_next_start, "@class.outer", "Next class definition start")
    motion("[c", move.goto_previous_start, "@class.outer", "Previous class definition start")
    motion("]C", move.goto_next_end, "@class.outer", "Next class definition end")
    motion("[C", move.goto_previous_end, "@class.outer", "Previous class definition end")
    motion("]g", move.goto_next_start, "@comment.outer", "Next comment")
    motion("[g", move.goto_previous_start, "@comment.outer", "Previous comment")
    motion("]m", move.goto_next_start, "@function.outer", "Next function definition start")
    motion("[m", move.goto_previous_start, "@function.outer", "Previous function definition start")
    motion("]M", move.goto_next_end, "@function.outer", "Next function definition end")
    motion("[M", move.goto_previous_end, "@function.outer", "Previous function definition end")
  end,
}
