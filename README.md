<a name="readme-top"></a>

<!-- ABOUT THE PROJECT -->
## About The Project
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li><a href="#list-of-properties">List of Properties</a></li>
    <li><a href="#list-of-methods">List of Methods</a></li>
    <li><a href="#list-of-events">List of Events</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>

This is an OOP based Countdown module for Roblox. <br>
Copy the code into a roblox module script or use the <a href="loadstringModule.lua">loadstring module</a>.

<!-- LIST OF PROPERTIES -->
## Properties

### TimeRemaining

TimeRemaining holds the value of how much time it'll take until the countdown object is finished. TimeRemaining can share its value in two different ways, *`TimeRemaining.format`* and *`TimeRemaining.unix`*.

#### TimeRemaining.format

`TimeRemaining.format` gives out a string value that's about how much time is remaining. 

##### Code Samples

Constantly updating a stringvalue to keep `TimeRemaining.format`
```lua
local Countdown = Require(ServerStorage.ModuleScripts.Countdown)
local CountDownObject = Countdown.newSimple(10) -- Creates a countdown object with 10 seconds as its startTime.
local StringValue = workspace.StringValue
CountDownObject:Start() -- Starts the countdown object.

function TimeRemainingFormat()
  StringValue.Value = CountdownObject.TimeRemaining.format -- The StringValue instance's value is set to being the string version of TimeRemaining. This causes the string value to have a value that looks like this: '01:20'
  wait(1)
end
CountDownObject.Updated.Event:Connect(TimeRemainingFormat)
```
#### TimeRemaining.unix

`TimeRemaining.unix` gives out a number value that's about how much time is remaining.

##### Code Samples
Constantly updating a numbervalue to keep `TimeRemaining.unix`
```lua
local Countdown = Require(ServerStorage.ModuleScripts.Countdown)
local CountDownObject = Countdown.newSimple(10) -- Creates a countdown object with 10 seconds as its startTime.
local NumberValue = workspace.NumberValue
CountDownObject:Start() -- Starts the countdown object.

function TimeRemainingUnix()
  StringValue.Value = CountdownObject.TimeRemaining.unix -- The NumberValue instance's value is set to being the number version of TimeRemaining. This causes the number value to have a value that looks like this: '10'
  wait(1)
end
CountDownObject.Updated.Event:Connect(TimeRemainingUnix)
```
___

<!-- LIST OF METHODS -->
## Methods
### Countdown.newSimple() : *`number`*
Creates a countdown object with a startTime of `maxTime`, but in a simplified way. 

| Parameter | Description |
| --- | --- |
| **maxTime:** `number` | The starting point of the countdown object|

** Code Samples **

Creating a countdown object
```lua
local Countdown = Require(ServerStorage.ModuleScripts.Countdown)
local CountDownObject = Countdown.newSimple(10) -- Creates a countdown object with 10 seconds as its startTime.
```
___

### Countdown.newAdvanced() : *`number`*,*`functon`*,*`bool`*
Creates a countdown object with a startTime of `maxTime`, but in an advanced way. 

| Parameters | Description |
| --- | --- |
| **maxTime:** `number` | The starting point of the countdown object|
| **FormatFunction:** `function` | The function that formats information for the countdown object|
| **IsMillis:** `bool`| If `true` then milliseconds will be formatted|

#### Code Samples

Creating an advanced countdown object
```lua
local Countdown = Require(ServerStorage.ModuleScripts.Countdown)
local CountDownObject = Countdown.newAdvanced(10,FormatFunction,true) -- Creates a countdown object with 10 seconds as its startTime, a formatfunction, and a true booleon for the IsMillis argument.
```
___

### Countdown:Start() : *`void`*
Activates and runs the countdown object

#### Code Samples

Starting a countdown object
```lua
local Countdown = Require(ServerStorage.ModuleScripts.Countdown)
local CountDownObject = Countdown.newSimple(10) -- Creates a countdown object with 10 seconds as its startTime.

CountDownObject:Start() -- Starts the countdown object.
```
___

### Countdown:Stop() : *`void`*
Stops and puts the countdown object in a dead state.

#### Code Samples

Stopping a countdown object
```lua
local Countdown = Require(ServerStorage.ModuleScripts.Countdown)
local CountDownObject = Countdown.newSimple(10) -- Creates a countdown object with 10 seconds as its startTime.

CountDownObject:Stop() -- Stops the countdown object from running anymore.
```
___
### Countdown:Restart() : *`void`*
Restarts the countdown object from being in a dead state to being back in a running state.

#### Code Samples

Restarting a countdown object
```lua
local Countdown = Require(ServerStorage.ModuleScripts.Countdown)
local CountDownObject = Countdown.newSimple(10) -- Creates a countdown object with 10 seconds as its startTime.

CountDownObject:Start() -- Starts the countdown object.
wait(1)
CountDownObject:Stop() -- Stops the countdown object from running anymore.
wait(1)
CountDownObject:Restart() -- Restarts the countdown object.
```
___

### Countdown:Pause(): *`void`*
Temporary suspends a countdown object
#### Code Samples

Pausing the countdown object

```lua
local Countdown = Require(ServerStorage.ModuleScripts.Countdown)
local CountDownObject = Countdown.newSimple(10) -- Creates a countdown object with 10 seconds as its startTime.

CountDownObject:Start() -- Starts the countdown object.
wait(1)
CountDownObject:Pause() -- Pauses the countdown object from running, putting it in a suspended state.
```
___

### Countdown:Continue(): *`void`*
Continues a suspended countdown object where it was left off previously

#### Code Samples

Continuing a suspended countdown object

```lua
local Countdown = Require(ServerStorage.ModuleScripts.Countdown)
local CountDownObject = Countdown.newSimple(10) -- Creates a countdown object with 10 seconds as its startTime.

CountDownObject:Start() -- Starts the countdown object.
wait(1)
CountDownObject:Pause() -- Pauses the countdown object from running, putting it in a suspended state.
wait(3)
CountDownObject:Continue() -- Continues a suspended countdown object where it was left off previously
```
___

### Countdown:SetTime(newTime : number)
Sets the time of the countdown object to a `newTime`.

| Parameter | Description |
| --- | --- |
| **newTime:** `number` | The set of a time for the countdown object |

#### Code Samples

Setting a new time for the countdown object

```lua
local Countdown = Require(ServerStorage.ModuleScripts.Countdown)
local CountDownObject = Countdown.newSimple(10) -- Creates a countdown object with 10 seconds as its startTime.

CountDownObject:SetTime(20) -- This changed the new maxTime to become 20 seconds, instead of 10.
```
___

### Countdown:ChangeTime(): *`number`*
Changes current countdown time by `deltaTime`

| Parameter | Description |
| --- | --- |
| **deltaTime:** `number` | the time in between frames |

#### Code Samples

Changing the current time of a countdown object by deltaTime

```lua
local Countdown = Require(ServerStorage.ModuleScripts.Countdown)
local CountDownObject = Countdown.newSimple(10) -- Creates a countdown object with 10 seconds as its startTime.

CountDownObject:ChangeTime(delta) -- Changes the time of the countdown object by using deltaTime.
```
___

<!-- LIST OF EVENTS -->
## Events

### .Finished

> [!IMPORTANT]
> You must have a countdown object in order to use this event!

.Finished is a bindable event that fires whenever the countdown object finished.

#### Code Samples

Prints 'Yipee' whenever the countdown object finished 

```lua
local Countdown = Require(ServerStorage.ModuleScripts.Countdown)
local CountDownObject = Countdown.newSimple(10) -- Creates a countdown object with 10 seconds as its startTime.

CountDownObject.Finished.Event:Connect(function()
  print("Yipee)
end)
```
___

### .Updated

> [!IMPORTANT]
> You must have a countdown object in order to use this event!

.Updated is a bindable event that fires each time the countdown object is updated.

#### Code Samples

Constantly updating a stringvalue to keep `TimeRemaining.format`
```lua
local Countdown = Require(ServerStorage.ModuleScripts.Countdown)
local CountDownObject = Countdown.newSimple(10) -- Creates a countdown object with 10 seconds as its startTime.
local StringValue = workspace.StringValue
CountDownObject:Start() -- Starts the countdown object.

function TimeRemainingFormat()
  StringValue.Value = CountdownObject.TimeRemaining.format -- The StringValue instance's value is set to being the string version of TimeRemaining. This causes the string value to have a value that looks like this: '01:20'
  wait(1)
end
CountDownObject.Updated.Event:Connect(TimeRemainingFormat)
```
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
