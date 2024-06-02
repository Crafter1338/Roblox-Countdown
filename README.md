<a name="readme-top"></a>

<!-- ABOUT THE PROJECT -->
## About The Project
<details>
  <summary>Contents</summary>
  <ol>
	<!--<li><a href="#introduction">Introduction</a></li>-->
  	<li><a href="#constructor-functions">Constructor Functions</a></li>
  	<li><a href="#properties">Properties</a></li>
   	<li><a href="#methods-inherited-from-countdown">Methods</a></li>
	<li><a href="#events">Events</a></li>
	<li><a href="#format-functions">Format Functions</a></li>
	<li><a href="#contributing">Contributing</a></li>
	<li><a href="#contact">Contact</a></li>
  </ol>
</details>

This is an object oriented countdown module for Roblox. <br>
The main module is <a href="Countdown.lua">Countdown.lua</a> and some pre-done formatting functions are stored in the <a href="FormatFunctions.lua">FormatFunctions.lua</a>

## Constructor Functions
### Countdown.newSimple() ⇾ *`Countdown object`*
| Parameter | Description |
| --- | --- |
| **Time** `number` | Starting Time to count down from|

**Example:** Creating a countdown object
```lua
local Countdown = require(ServerStorage.ModuleScripts.Countdown)
local CountdownObject = Countdown.newSimple(10)
-- Creates a countdown object with a 10 seconds timer.
```

### Countdown.newAdvanced() ⇾ *`Countdown object`*
| Parameters | Description |
| --- | --- |
| **Time** `number` | Starting Time to count down from|
| **FormatFunction** `function` | A [custom format function](#format-functions)|
| **IsMillis** `bool`| If `true` Then the preciser time function `tick()` will be used|

**Example:** Creating an advanced countdown object
```lua
local Countdown = require(ServerStorage.ModuleScripts.Countdown)
local FormatFunctions = require(ServerStorage.ModuleScripts.FormatFunctions)
local FormatFunction = FormatFunctions.MinSecMillis
local CountdownObject = Countdown.newAdvanced(10, FormatFunction, true)
-- Creates a countdown object with a 10 seconds timer and
-- a custom format function that uses ms precision.
```



## Properties
### .TimeRemaining
TimeRemaining keeps track of the time remaining untill the countdown is done. TimeRemaining stores that data in two different ways, *`TimeRemaining.format`* and *`TimeRemaining.unix`*.

#### TimeRemaining.format
`TimeRemaining.format` stores the formatted string of time remaining. *`string`* <br>

**Example:** Update a StringValue's value using `TimeRemaining.format` <br>
```lua
local Countdown = require(ServerStorage.ModuleScripts.Countdown)
local CountdownObject = Countdown.newSimple(10) -- Creates a countdown object with a 10 seconds timer.
local StringValue = workspace.StringValue
CountdownObject:Start() -- Starts counting down.

CountdownObject.Updated.Event:Connect(function()
    StringValue.Value = CountdownObject.TimeRemaining.format -- Set StringValue's value to the formatted time remaining.
end)
```

#### TimeRemaining.unix
`TimeRemaining.unix` stores the unformatted number of secconds remaining. *`number`* <br>

**Example:** Update a NumberValues's value using `TimeRemaining.unix` <br>
```lua
local Countdown = require(ServerStorage.ModuleScripts.Countdown)
local CountdownObject = Countdown.newSimple(10) -- Creates a countdown object with a 10 seconds timer.
local NumberValue = workspace.NumberValue
CountdownObject:Start() -- Starts counting down.

CountdownObject.Updated.Event:Connect(function()
    NumberValue.Value = CountdownObject.TimeRemaining.unix -- Set NumberValue's value to the unformatted number of seconds remaining.
end)
```
___



## Methods inherited from Countdown
### Countdown:Start() ⇾ *`void`*
Starts the counting down by a countdown object

#### Code Example
Starting a countdown object
```lua
local Countdown = require(ServerStorage.ModuleScripts.Countdown)
local CountdownObject = Countdown.newSimple(10) -- Creates a countdown object with a 10 seconds timer.

CountdownObject:Start() -- Starts the countdown object.
```
___

### Countdown:Stop() ⇾ *`void`*
Stops and halts any further counting down by the countdown object.

#### Code Example
Stopping a countdown object
```lua
local Countdown = require(ServerStorage.ModuleScripts.Countdown)
local CountdownObject = Countdown.newSimple(10) -- Creates a countdown object with a 10 seconds timer.

CountdownObject:Stop() -- Stops the countdown object.
```

___
### Countdown:Restart() ⇾ *`void`*
Sets the countdown object's time remaining to the time that has last been set by either the used <a href = "#constructor-functions">constructor function</a> or the <a href = "#countdownsettimenewtime--number--void">:SetTime()</a> method

#### Code Example

Restarting a countdown object
```lua
local Countdown = require(ServerStorage.ModuleScripts.Countdown)
local CountdownObject = Countdown.newSimple(10) -- Creates a countdown object with a 10 seconds timer.

CountdownObject:Start() -- Starts the countdown object.
wait(1)
CountdownObject:Stop() -- Stops the countdown object.
wait(1)
CountdownObject:Restart() -- Restarts the countdown object.
```
___

### Countdown:Pause() ⇾ *`void`*
Temporary suspends a countdown object
#### Code Example

Pausing the countdown object

```lua
local Countdown = require(ServerStorage.ModuleScripts.Countdown)
local CountdownObject = Countdown.newSimple(10) -- Creates a countdown object with a 10 seconds timer.

CountdownObject:Start() -- Starts the countdown object.
wait(1)
CountdownObject:Pause() -- Pauses the countdown object.
```
___

### Countdown:Continue() ⇾ *`void`*
Continues a suspended countdown object where it was left off previously

#### Code Example

Continuing a suspended countdown object

```lua
local Countdown = require(ServerStorage.ModuleScripts.Countdown)
local CountdownObject = Countdown.newSimple(10) -- Creates a countdown object with a 10 seconds timer.

CountdownObject:Start() -- Starts the countdown object.
wait(1)
CountdownObject:Pause() -- Pauses the countdown object.
wait(3)
CountdownObject:Continue() -- Continues a paused countdown object where it left previously.
```
___

### Countdown:SetTime(newTime : number) ⇾ *`void`*
Sets the time of the countdown object to a `newTime`.

| Parameter | Description |
| --- | --- |
| **newTime:** `number` | The set of a time for the countdown object |

#### Code Examples

Changing the time of the countdown while it's **running**:
```lua
local Countdown = require(ServerStorage.ModuleScripts.Countdown)
local CountdownObject = Countdown.newSimple(10)

CountdownObject:SetTime(20) -- The timer will have 20s remaining.
```

Changing the time of the countdown while it's **paused**:
```lua
local Countdown = require(ServerStorage.ModuleScripts.Countdown)
local CountdownObject = Countdown.newSimple(10)

CountdownObject:SetTime(20) -- The timer will have 20s remaining.
CountdownObject:Pause()
task.wait(5)
CountdownObject:Continue() -- The timer will continue with 20s since it was paused before waiting 5s.
```
___

### Countdown:ChangeTime() ⇾ *`void`*
Changes current countdown time by `deltaTime`

| Parameter | Description |
| --- | --- |
| **deltaTime:** `number` | Adds/subtracts deltaTime from the remaining time |

**Example:** Changing the current time of a countdown object by 50s
```lua
local Countdown = require(ServerStorage.ModuleScripts.Countdown)
local CountdownObject = Countdown.newSimple(10)

CountdownObject:ChangeTime(50) -- Add 50s to the remaining time.
CountdownObject:ChangeTime(-50) -- Subtract 50s from the remaining time.
```
___

<!-- LIST OF EVENTS -->
## Events

### .Updated
Updated is a bindable event that fires each time the countdown object is updated.

#### Examples

```lua
local Countdown = require(ServerStorage.ModuleScripts.Countdown)
local CountdownObject = Countdown.newSimple(10) -- Creates a countdown object with a 10 seconds timer.
local StringValue = workspace.StringValue
CountdownObject:Start() -- Starts counting down.

CountdownObject.Updated.Event:Connect(function()
    StringValue.Value = CountdownObject.TimeRemaining.format -- Set StringValue's value to the formatted time remaining.
end)
```

```lua
local Countdown = require(ServerStorage.ModuleScripts.Countdown)
local CountdownObject = Countdown.newSimple(10) -- Creates a countdown object with a 10 seconds timer.
CountdownObject:Start() -- Starts counting down.

CountdownObject.Updated.Event:Connect(function()
    print(CountdownObject.TimeRemaining.format)
end)
```

### .Finished
Finished is a bindable event that fires whenever the countdown object finishes or is being stopped.

**Example:** Print 'Finished' whenever the countdown object Finishes <br>

```lua
local Countdown = require(ServerStorage.ModuleScripts.Countdown)
local CountdownObject = Countdown.newSimple(10) -- Creates a countdown object with 10 seconds as its startTime.

CountdownObject.Finished.Event:Connect(function()
    print("Finished!")
end)
```
___



## Format Functions
You can use format functions in the [Countdown.newAdvanced()](#constructor-functions) Constructor as explained in that section

| Argument | Description |
| --- | --- |
| **CountdownObject:** `Countdown object` | The Countdown inheriting object that calls the function |
| **remainder:** `number` | TimeRemaining.unix of said object |

### Function Format
```lua
local function format(CountdownObject, remainder)
    local s = "formatted string"

    return s
end
```

### Examples
```lua
local function format(CountdownObject, remainder)
    local s = toString(remainder)

    return s
end

local count = require("game.ServerStorage.Countdown").newAdvanced(100, format, false)
count:Start()
```

In [FormatFunctions.lua](FormatFunctions.lua) you can see more examples of functions. <br>
You can use them by doing the following:

```lua
local FormatFunctions = require("game.ServerStorage.FormatFunctions")
local format = FormatFunctions.MinSecMillis

local count = require("game.ServerStorage.Countdown").newAdvanced(100, format, true)
count:Start()
```

In this example the counter will also count milliseconds and therefore also update every millisecond (or as fast as possible)


___
<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


<!-- CONTACT -->
## Contact

Crafter1338 - [@Crafter1338](https://twitter.com/Crafter1338)
Project Link: [https://github.com/Crafter1338/Roblox-Countdown](https://github.com/Crafter1338/Roblox-Countdown)

ThatOneBacon2 - [@ThatOneBaconRBX](https://x.com/ThatOneBaconRBX)

<p align="right">(<a href="#readme-top">to top</a>)</p>
