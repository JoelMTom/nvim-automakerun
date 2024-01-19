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
  local row = 0
  local col = vim.api.nvim_win_get_height(0)
  local width = vim.api.nvim_win_get_width(0)
  local height = vim.fn.floor(35/100 * col)

  local config = {
    relative = "win",
    height = height,
    width = width,
    anchor = "SW",
    -- row = 5,
    -- col = 0,
    style = "minimal",
    border = "rounded",
    title = title,
    title_pos = left,
    bufpos = {col, row}
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
  if window ~= nil and vim.api.nvim_win_is_valid(window) then
    vim.api.nvim_win_close(window, true)
  end
  if buffer ~= nil and vim.api.nvim_buf_is_valid(buffer) then
    vim.api.nvim_buf_delete(buffer, { force = true })
  else
    return
  end
end

return float_window
