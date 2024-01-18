local float_window = {}

float_window.__index = float_window

function float_window.new(filename)
  local self = setmetatable({
    buffer = nil,
    window = nil,
    filename = filename,
  }, float_window)

  return self
end

local function get_window_config(title)
  local height = 20
  local width = vim.api.nvim_win_get_width

  local config = {
    realtive = "editor",
    height = height,
    width = width,
    anchor = "SE",
    row = 0,
    col = 0,
    style = "minimal",
    border = "rounded",
    title = title,
    title_pos = left,
  }
  return config
end

function float_window:open()
  local window_buffer = vim.api.nvim_create_buf(false, true)
  local window_id = vim.api.nvim_open_win(window_buffer, true, get_window_config(self.filename))

  self.buffer = window_buffer
  self.window = window_id

  return window_buffer, window_id
end

function float_window:close()
  local window = self.window
  local buffer = self.buffer
  if window ~= nil and vim.api.nvim_win_is_valid(float_window.buffer) then
    vim.api.nvim_win_close(window, true)
  end
  if buffer ~= nil and vim.api.nvim_buf_is_valid(buffer) then
    vim.api.nvim_buf_delete(buffer, { force = true })
  end
end

return float_window
