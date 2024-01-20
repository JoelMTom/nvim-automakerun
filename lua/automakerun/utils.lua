local M = {}

function M.concate_strings(strings, delim)
  local res = ""
  for _, value in pairs(strings) do
    res = res .. value .. delim
  end
  return res
end

return M
