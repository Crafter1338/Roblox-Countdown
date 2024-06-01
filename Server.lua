local module = require(script.Countdown)

local count = module.new(160)
count:Start()

count.Updated.Event:Connect(function()
	  print(count.TimeRemaining.unix)
end)

count.Finished.Event:Connect(function()
    print("Countdown finished!")
end)
