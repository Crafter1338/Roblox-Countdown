----THIS IS A MODULE SCRIPT----
----Contact:-------------------
--  Crafter1338 (discord, Twitter)
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
	self.Finished   = Instance.new("BindableEvent")
	self.Updated    = Instance.new("BindableEvent")
	self.TimeFunc	= (IsMillis == true and tick) or os.time
	self.FormatFunc = FormatFunction

	setmetatable(self, Countdown)
	return self
end

function Countdown:Start(...)
	local StartTick = ({...})[1] or self.TimeFunc()
	if self.IsRunning == true then task.cancel(self.RunThread) end
	if self.IsPaused == true then task.cancel(self.PauseThread); self.IsPaused = false end

	self.IsRunning = true
	self.RunThread = task.spawn(function()
		self.StartTick = StartTick
		while task.wait() do
			local currentSeconds = self.TimeFunc() - self.StartTick
			local remainder 	 = self.MaxTime - currentSeconds

			if remainder < 0 then
				self.TimeRemaining = {
					unix   = 0,
					format = self.FormatFunc(self, 0)
				}
				self.Updated:Fire(); self.Finished:Fire() 
				return
			end
			if remainder ~= self.TimeRemaining.unix then
				self.TimeRemaining = {
					unix   = remainder,
					format = self.FormatFunc(self, remainder)
				}
				self.Updated:Fire()
				continue
			end

			self.TimeRemaining = {
				unix   = remainder,
				format =  self.FormatFunc(self, remainder)
			}
		end
	end)
end

function Countdown:Restart()
	self:Start()
end

function Countdown:Stop()
	if self.IsRunning then
		task.cancel(self.RunThread)
		self.Finished:Fire()
	end
end

function Countdown:Continue()
	if self.IsPaused then
		task.cancel(self.PauseThread)
		self:Start(self.StartTick)
	end
end

function Countdown:Pause()
	if self.IsRunning == true then task.cancel(self.RunThread); self.IsPaused = false end
	if self.IsPaused == true then return end

	self.PauseThread = task.spawn(function()
		local distance = self.TimeFunc() - self.StartTick

		while task.wait() do
			self.StartTick = self.TimeFunc() - distance
		end
	end)
end

function Countdown:SetTime(t : number)
	self.MaxTime  = t
	self.Startick = self.TimeFunc()
	task.spawn(function()
		while self.IsRunning == false do
			self.Startick = self.TimeFunc()
		end
	end)
end

function Countdown:ChangeTime(delta)
	self.StartTick += delta
end

function Countdown:Destroy()
	setmetatable(self, nil)
	self = nil
end

return Countdown