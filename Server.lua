local module = require(script.Timer)
local timer = module.new()
timer:Start(100)

timer.Updated:Connect(function()
    print(timer.Time.Format)
end)

timer.Finished:Connect(function()
    print("Timer done!")
end)
