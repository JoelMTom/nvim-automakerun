local float_window = require("automakerun.ui.float-window")

local Amr ={}

Amr.__index = Amr

function Amr.new()
  local self = setmetatable({
    build_window = nil,
    run_window = nil,
    default_tasks_json = nil,
    task_filename = nil,
    build_filename = nil,
  }, Amr)

  return self
end

function Amr:setup(opts)
  print(vim.inspect(opts))
  --[[ self.default_json  = opts.default_json or ""
  self.task_filename = opts.task_filename or "tasks.json"
  self.build_filename =  opts.build_filename or "build.log"
  self.build_window = float_window.new(self.build_filename) ]]
end

function Amr:open()
  self.build_window:open()
end

function Amr:close()
  self.build_window:close()
end

return Amr.new()
