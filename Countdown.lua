----THIS IS A MODULE SCRIPT----
----Contact:-------------------
--  Crafter1338 (Discord, Twitter)
-------------------------------
local Countdown = {}
Countdown.__index = Countdown

local function simpleFormat(self, remainder)
	local function addZeros(s) return (s:len() == 1 and "0"..s) or s end

	remainder = math.round(remainder)
	remainder = math.clamp(remainder, 0, math.huge)
	local minutes = math.floor(remainder/60)
	remainder -= minutes*60

	return addZeros(tostring(minutes))..":"..addZeros(tostring(remainder))
end

function Countdown.newSimple(maxTime : number)
	return Countdown.newAdvanced(maxTime, simpleFormat, false)
end

function Countdown.newAdvanced(maxTime : number, FormatFunction, IsMillis : boolean)
	local self = {}
	local startWithMax = true

	self.MaxTime = maxTime
	self.TimeRemaining = {
		unix   = ((startWithMax == true and 0) or 1)*maxTime,
		format = FormatFunction(self, self.MaxTime)
	}
	self.IsPaused   = false
	self.IsRunning  = false
	self._Finished  = Instance.new("BindableEvent")
	self._Updated   = Instance.new("BindableEvent")
	self.Finished   = self._Finished.Event
	self.Updated    = self._Updated.Event
	self.TimeFunc	= (IsMillis == true and tick) or os.time
	self.FormatFunc = FormatFunction

	setmetatable(self, Countdown)
	return self
end

function Countdown:Start(...)
	local StartTick = ({...})[1] or self.TimeFunc()
	if self.IsRunning == true then task.cancel(self.RunThread) end
	if self.IsPaused == true then task.cancel(self.PauseThread); self.IsPaused = false end

	while StartTick == self.TimeFunc() do wait() end

	self.IsRunning = true
	self.StartTick = StartTick + 1
	self.RunThread = task.spawn(function()
		while task.wait() do
			local currentSeconds = self.TimeFunc() - self.StartTick
			local remainder 	 = self.MaxTime - currentSeconds

			if remainder < 0 then
				self.TimeRemaining = {
					unix   = 0,
					format = self.FormatFunc(self, 0)
				}
				self._Updated:Fire(); self._Finished:Fire() 
				return
			end
			if remainder ~= self.TimeRemaining.unix then
				self.TimeRemaining = {
					unix   = remainder,
					format = self.FormatFunc(self, remainder)
				}
				self._Updated:Fire()
				continue
			end

			self.TimeRemaining = {
				unix   = remainder,
				format =  self.FormatFunc(self, remainder)
			}
		end
	end)
end

print(test)

function Countdown:Restart()
	self:Start()
end

function Countdown:Stop()
	if self.IsRunning then
		task.cancel(self.RunThread)
		self.TimeRemaining = {
			unix   = 0,
			format = self.FormatFunc(self, 0)
		}
		self._Updated:Fire()
		self._Finished:Fire()
	end
end

function Countdown:Continue()
	if self.IsPaused then
		task.cancel(self.PauseThread)
		self:Start(self.StartTick)
	end
end

function Countdown:Pause()
	if self.IsPaused == true then return end
	if self.IsRunning == true then task.cancel(self.RunThread); self.IsRunning = false end
	self.IsPaused = true

	self.PauseThread = task.spawn(function()
		local distance = self.TimeFunc() - self.StartTick

		while task.wait() do
			self.StartTick = self.TimeFunc() - distance
		end
	end)
end

function Countdown:SetTime(t : number)
	self.MaxTime  = t
	self:Start()
end

function Countdown:ChangeTime(delta)
	self.StartTick += delta
end

function Countdown:Destroy()
	setmetatable(self, nil)
	self = nil
end

return Countdown