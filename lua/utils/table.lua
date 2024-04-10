local M = {}

--- Concatenate any number of arrays together.
---@param arrays table<table> An array containing the arrays to concatenate.
---@return table
M.concat_arrays = function(arrays)
  local result = {}

  for _, array in ipairs(arrays) do
    for _, value in ipairs(array) do
      table.insert(result, value)
    end
  end

  return result
end

--- Concatenate any number of dictionaries together.
--- Dictionaries are processed in order, so if some keys are shared, the latest value encountered
--- will take precedence.
---@param dictionaries table<table<string, any>> An array containing the dictionaries to concatenate.
---@return table<string, any>
M.concat_dicts = function(dictionaries)
  local result = {}

  for _, dictionary in ipairs(dictionaries) do
    for key, value in pairs(dictionary) do
      result[key] = value
    end
  end

  return result
end

--- Check if a target is in an array values.
---@param target any The target to check.
---@param array table The array to check.
---@return boolean
M.is_in_array = function(target, array)
  for _, value in ipairs(array) do
    if target == value then
      return true
    end
  end
  return false
end

--- Check if a target is in a dictionary keys.
---@param target any The target to check.
---@param dict table The dictionary to check.
---@return boolean
M.is_in_dict_keys = function(target, dict)
  for key, _ in pairs(dict) do
    if target == key then
      return true
    end
  end
  return false
end

--- Check if a target is in a dictionary values.
---@param target any The target to check.
---@param dict table The dictionary to check.
---@return boolean
M.is_in_dict_values = function(target, dict)
  for _, value in pairs(dict) do
    if target == value then
      return true
    end
  end
  return false
end

--- Filter out target values from an input array.
---@param array table An array to filter.
---@param targets table The target values to filter out from the array.
---@return table
M.filter_out_array = function(array, targets)
  local result = {}

  for _, value in ipairs(array) do
    if not M.is_in_array(value, targets) then
      table.insert(result, value)
    end
  end

  return result
end

--- Trim leading and trailing white spaces from all strings in an array.
---@param array string[] The array of strings to trim.
---@return string[] result A copy of the input array where all strings have been trimmed.
function M.trim_ws_in_array(array)
  local result = {}

  for _, value in ipairs(array) do
    value = value:gsub("^%s+", ""):gsub("%s+$", "")
    table.insert(result, value)
  end

  return result
end

return M
