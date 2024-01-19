local float_window = require("automakerun.ui.float-window")

local Amr ={}

Amr.__index = Amr

function Amr.new()
  local self = setmetatable({
    task_filename = nil,
    build_filename = nil,
    build_window = nil,
    run_window = nil,
    default_tasks_json = nil,
  }, Amr)

  return self
end

function Amr:setup(opts)
  Amr.default_json  = opts.default_json
  Amr.task_filename = opts.task_filename
  Amr.build_filename =  opts.build_filename
  Amr.build_window = float_window.new(self.build_filename)
  Amr.run_window = float_window.new("run")
end

function Amr:open()
  Amr.build_window:open()
end

function Amr:close()
  Amr.build_window:close()
end

function Amr:run()
  Amr.run_window:open()
end

return Amr.new()
