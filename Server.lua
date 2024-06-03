local module = require(script.Timer)
local timer = module.new()
timer:Start(100)

timer.Updated.Event:Connect(function()
    print(timer.Time.Format)
end)

timer.Finished.Event:Connect(function()
    print("Timer finished!")
end)
