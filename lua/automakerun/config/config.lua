local utils = require("automakerun.utils")

local config = {}

config.__index = config

function config.new(filename, default_tasks)
  local self = setmetatable({
    filename = filename,
    default_tasks = default_tasks,
    buffer = nil,
    tasks = nil,
  }, config)
  return self
end

function config:openfile()
  local buffer = vim.fn.bufadd(self.filename)
  vim.fn.bufload(buffer)
  self.buffer = buffer
  return buffer
end

function config:write_file()
  local lines = vim.json.encode(self.tasks)
  vim.api.nvim_buf_set_lines(self.buffer, 0, -1, false, {lines})
  vim.api.nvim_buf_call(self.buffer, function ()
    vim.api.nvim_cmd({
      cmd = "write",
      args = { self.filename }
    }, { output = false })
  end)
end

function config:readfile()
  if self.tasks ~= nil then
    return self.tasks
  end

  local lines = vim.api.nvim_buf_get_lines(self.buffer, 0, -1, false)

  if #lines == 1 and lines[1] == ""  then
    self.tasks = self.default_tasks
    self:write_file()
    return self.tasks
  end

  local data = utils.concate_strings(lines, "")
  self.tasks = vim.json.decode(data)

end

return config.new()
