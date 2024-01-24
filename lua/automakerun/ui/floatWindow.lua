local utils = require("automakerun.utils")

--@class floatWindow
--@field buffer number | nil
--@field window number | nil
--@field filename string | nil

local floatWindow = {}

floatWindow.__index = floatWindow

--@return floatWindow
function floatWindow.new(filename)
  local self = setmetatable({
    buffer = nil,
    window = nil,
    filename = filename,
  }, floatWindow)

  return self
end

--@param title string
--@return table
local function get_window_config(title)
  local row = 0
  local col = vim.api.nvim_win_get_height(0)
  local width = vim.api.nvim_list_uis()[1].width
  local height = vim.fn.floor(35/100 * col)

  local config = {
    relative = "win",
    height = height,
    width = width,
    anchor = "SW",
    style = "minimal",
    border = "rounded",
    title = title,
    title_pos = left,
    bufpos = {col, row}
  }
  return config
end

--@return window_buffer number
--@return window_id number
function floatWindow:open()
  local window_buffer = vim.api.nvim_create_buf(false, true)
  local window_id = vim.api.nvim_open_win(window_buffer, true, get_window_config(self.filename))

  self.buffer = window_buffer
  self.window = window_id

  return window_buffer, window_id
end

function floatWindow:close()
  local window = self.window
  local buffer = self.buffer
  if window ~= nil and vim.api.nvim_win_is_valid(window) then
    vim.api.nvim_win_close(window, true)
    self.window = nil
  end
  if buffer ~= nil and vim.api.nvim_buf_is_valid(buffer) then
    vim.api.nvim_buf_delete(buffer, { force = true })
    self.buffer = nil
  else
    return
  end
end

function floatWindow:toggle()
  if self.window == nil and self.buffer == nil then
    self:open()
    local buffer = vim.fn.bufadd(self.filename)
    vim.fn.bufload(buffer)
    vim.api.nvim_buf_set_lines(self.buffer, 0, -1, true, {})
    local channel = vim.api.nvim_open_term(self.buffer, {})
    local buffer_data = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)
    local data = string.gsub(utils.concateStrings(buffer_data, "\n"), "\r ", "\n\r")
    data = string.gsub(data, "^ *", "\r")
    data = string.gsub(data, "\r *", "\r")
    vim.api.nvim_chan_send(channel, data)
    return
  end
  self:close()
end

function floatWindow:runCmd(command, args, saveBuffer)
  local buffer = vim.fn.bufadd(self.filename)
  vim.fn.bufload(buffer)
  self:close()
  self:open()
  vim.api.nvim_buf_call(self.buffer, function()
    local cmd = command .. " " .. utils.concateStrings(args, " ")
    cmd = "echo " .. "\"" .. cmd .. "\"" .. " & " .. cmd .. "\n"
    -- vim.api.nvim_buf_set_lines(buffer, -1, -1, false, {cmd})
    vim.fn.termopen(cmd, {
      stdout_buffered = true,
      on_stdout = function(_, data)
        vim.api.nvim_buf_set_lines(buffer, -1, -1, false, data)
      end,
      stderr_buffered = true,
      on_stderr = function(_, data)
        vim.api.nvim_buf_set_lines(buffer, -1, -1, false, data)
      end,
      stdin = "pipe",
      on_exit = function()
        if saveBuffer then
          vim.api.nvim_buf_call(buffer, function()
            vim.api.nvim_cmd({
              cmd = "write",
              args = { self.filename }
            }, { output = false })
          end)
        end
        if buffer ~= nil and vim.api.nvim_buf_is_valid(buffer) then
          vim.api.nvim_buf_delete(buffer, { force = true })
        end
      end
    })
  end)
end

return floatWindow
