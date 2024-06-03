# Roblox-Timer Module
A simple yet professional module for all your timer based needs.

## Constructor
#### Timer.New(FormatFunction)
|  Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `FormatFunction` | `function` | **Optional.** Custom [formatting function](#formatfunction) |

|  Return Type | Description                |
| :-------- | :------------------------- |
| `timer object` | timer object inheriting all the [methods](#methods) from the module |

```lua
local TimerObject = require(script.TimerObject)
local timer = TimerObject.new()

timer:Start(100)
timer.Updated:Connect(function()
    print(timer.Time.Format)
end)
```

## FormatFunction
The FormatFunction gets passed the following arguments:
|  Argument | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `timer` | `timer object` |   |
| `remainder` | `number` | Time left to reach [EndTime](#properties) (in seconds) |

Your function has to return a `string` which will then be seen in Timer.Time.Format
If you don't pass your own custom function, the function down below will be used.

```lua
local TimerObject = require(script.TimerObject)
local function timerFunction(timer, remainder)
	local function addZeros(s) return (s:len() == 1 and "0"..s) or s end
	Remainder = math.round(Remainder)
	Remainder = math.clamp(Remainder, 0, math.huge)
	local minutes = math.floor(Remainder/60)
	Remainder -= minutes*60

	return addZeros(tostring(minutes))..":"..addZeros(tostring(Remainder))
end

local timer = TimerObject.new(timerFunction)

timer:Start(100)
timer.Updated:Connect(function()
    print(timer.Time.Format)
end)
```


## Properties
#### Booleans
| Name | Description                |
| :-------- | :------------------------- |
| `timer.IsRunning` | Is true while the [timer object](#constructor) is running |
| `timer.IsPaused` | Is true while the [timer object](#constructor) is paused |

#### timer.Time
| Index | Type     | Description                       |
| :-------- | :------- | :-------------------------------- |
| `Time.Seconds`      | `number` | Id of item to fetch |
| `Time.Format`      | `string` | Formatted version of Seconds ([FormatFunction](#formatfunction)) |


## Methods
#### timer:Start(StartTime, EndTime, Multiplier)
Starts the timer.
| Parameter | Type     | Description                | Default                |
| :-------- | :------- | :------------------------- | :------------------------- |
| `StartTime` | `number` | **Required**. The Time, the Timer will count down/up from | No default|
| `EndTime` | `number` | **Optional**. The Time, the Timer will count down/up to |0|
| `Multiplier` | `number` | **Optional**. A Multiplier for the timer speed (x seconds timer per 1s) |1|

`StartTime` and `EndTime` are in seconds
```lua
local TimerObject = require(script.TimerObject)
local timer = TimerObject.new()

timer:Start(100, 90)
```


#### timer:Stop()
Stops the timer. It can't be resumed. To restart it, start it again.
```lua
local TimerObject = require(script.TimerObject)
local timer = TimerObject.new()

timer:Start(10) --timer has to be running to get stopped
timer:Stop()
```

#### timer:Pause()
Pauses the timer. It can be resumed by calling `timer:Resume()`.
```lua
local TimerObject = require(script.TimerObject)
local timer = TimerObject.new()

timer:Start(10) --timer has to be running to get paused
timer:Pause()
```

#### timer:Resume()
Resumes the timer. It continues where it left.
```lua
local TimerObject = require(script.TimerObject)
local timer = TimerObject.new()

timer:Start(10) --timer has to be running to get paused
timer:Pause()   --timer has to be paused to resume it
timer:Resume()
```

#### timer:ChangeTime(Delta)
Changes the timers.Time by delta (either adding or subtracting)
| Parameter | Type     | Description                |
| :-------- | :------- | :------------------------- |
| `Delta` | `number` | **Required**. The Time, the Timer increase/decrease by |

```lua
local TimerObject = require(script.TimerObject)
local timer = TimerObject.new()

timer:Start(10)         --timer has to be started to get its time changed
timer:ChangeTime(100)   --timer will now be 100s longer
```


## Events

#### timer.Updated
Fires whenever the timer.Time.Seconds changes
```lua
local TimerObject = require(script.TimerObject)
local timer = TimerObject.new()

timer:Start(100)
timer.Updated:Connect(function()
    print(timer.Time.Format)
end)
```

#### timer.Finished
Fires whenever the timer reaches its `EndTime`
```lua
local TimerObject = require(script.TimerObject)
local timer = TimerObject.new()

timer:Start(10)
timer.Finished:Connect(function()
    print("Timer finished!")
end)
```

```lua
local TimerObject = require(script.TimerObject)
local timer = TimerObject.new()

timer:Start(10)
timer.Finished:Wait()
print("We can also WAIT until the events get fired")
```

