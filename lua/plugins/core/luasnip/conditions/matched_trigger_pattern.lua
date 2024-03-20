-- A matched trigger is considered to be everything after the last white space or punctuation mark
-- in the line before cursor (this is true as long as the matched trigger doesn't have white spaces
-- or punctuation marks itself, which is a good assumption as `nvim-cmp` doesn't take them into
-- account when completing).
local separator_pattern = "[%s%p]"

-- In the following pattern, the first capturing group captures greedily everything until a
-- separator is found (since it's greedy, it will capture everything until the last occurence)
return "(.*)" .. separator_pattern .. "(.*)$"
