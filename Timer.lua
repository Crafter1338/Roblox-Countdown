----Contact:-------------------
--  This is a module script
--  Crafter1338 (Discord, Twitter)
-------------------------------
local function simpleFormatFunction(Timer, Remainder)
	local function addZeros(s) return (s:len() == 1 and "0"..s) or s end
	Remainder = math.ceil(Remainder)
	Remainder = math.clamp(Remainder, 0, math.huge)
	local minutes = math.floor(Remainder/60)
	Remainder -= minutes*60

	return addZeros(tostring(minutes))..":"..addZeros(tostring(Remainder))
end
local RunService = game:GetService("RunService")

local Timer = {}
Timer.__index = Timer

function Timer.new(FormatFunction) FormatFunction = FormatFunction or simpleFormatFunction
	local self			= setmetatable({}, Timer)
	self.FormatFunction = FormatFunction
	self.IsRunning 	    = false
	self.IsPaused       = false
	self.Time 			= {Seconds = 0, Format = "nil"}
	self.Runtime		= 0

	self._INTERNAL_Finished = Instance.new("BindableEvent")
	self._INTERNAL_Updated  = Instance.new("BindableEvent")
	self.Finished   = self._INTERNAL_Finished.Event
	self.Updated    = self._INTERNAL_Updated.Event

	return self
end

function Timer:Start(StartTime : number, EndTime : number, Multiplier : number, ...)
	if self.RunThread then self.RunThread:Disconnect() end
	local args 	= ({...})
	EndTime 	= EndTime or 0
	Multiplier 	= Multiplier or 1

	self.EndTime    = EndTime
	self.StartTime  = StartTime
	self.Multiplier = Multiplier
	self.IsRunning  = true
	self.Runtime 	= args[1] or 0
	
	self.RunThread = RunService.Heartbeat:Connect(function(d)
		if not self.IsPaused then
			self.Runtime += d
		end
	end)
	
	task.spawn(function()
		while self.IsRunning == true and task.wait() do
			local seconds = (self.EndTime > self.StartTime and math.abs(self.Runtime*self.Multiplier)) or (self.StartTime - math.abs(self.Runtime*self.Multiplier))

			local e = false
			if self.EndTime > self.StartTime then
				if seconds >= self.EndTime then
					self.Time = {Seconds = self.EndTime, Format = self.FormatFunction(self, self.EndTime)}
					e = true
				end
			else
				if seconds <= self.EndTime then
					self.Time = {Seconds = self.EndTime, Format = self.FormatFunction(self, self.EndTime)}
					e = true
				end
			end

			if e then 
				self.IsRunning = false
				self._INTERNAL_Updated:Fire()
				self._INTERNAL_Finished:Fire()

				return
			end

			if self.FormatFunction(self, seconds) ~= self.Time.Format then
				self.Time = {Seconds = seconds, Format = self.FormatFunction(self, seconds)}
				self._INTERNAL_Updated:Fire()

				continue
			end

			self.Time = {Seconds = seconds, Format = self.FormatFunction(self, seconds)}
		end
	end)
end

function Timer:Pause(Time)
	if self.IsRunning == false then return end
	Time = Time or 0
	self.RunThread:Disconnect()

	self.IsRunning = false
	self.IsPaused = true
	
	if Time ~= 0 then
		task.delay(Time + 0.001, function() self:Resume() end)
	end
end

function Timer:Resume()
	if self.IsRunning == true then return end
	if self.IsPaused  == false then return end

	print(self.Runtime)
	self.IsPaused = false
	self:Start(self.StartTime, self.EndTime, self.Multiplier, self.Runtime)
end


function Timer:ChangeTime(Delta : number)
	if self.IsRunning == false then return end
	self.Runtime += Delta
end

function Timer:Stop()
	if self.IsRunning == false then return end

	self.IsRunning = false
	self.Time = (self.EndTime > self.StartTime and {Seconds = self.EndTime, Format = self.FormatFunction(self, self.EndTime)}) or {Seconds = 0, Format = self.FormatFunction(self, 0)}

	self._INTERNAL_Finished:Fire()
end

return Timer
