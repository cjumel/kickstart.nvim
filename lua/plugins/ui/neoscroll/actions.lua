local M = {}

function M.c_u() require("neoscroll").ctrl_u({ duration = 250 }) end
function M.c_d() require("neoscroll").ctrl_d({ duration = 250 }) end
function M.c_b() require("neoscroll").ctrl_b({ duration = 450 }) end
function M.c_f() require("neoscroll").ctrl_f({ duration = 450 }) end

function M.c_y() require("neoscroll").scroll(-5, { move_cursor = false, duration = 100 }) end
function M.c_e() require("neoscroll").scroll(5, { move_cursor = false, duration = 100 }) end

function M.zt() require("neoscroll").zt({ half_win_duration = 250 }) end
function M.zz() require("neoscroll").zz({ half_win_duration = 250 }) end
function M.zb() require("neoscroll").zb({ half_win_duration = 250 }) end

return M
