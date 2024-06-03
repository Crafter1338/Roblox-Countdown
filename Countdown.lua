----THIS IS A MODULE SCRIPT----
----Contact:-------------------
--  Crafter1338 (Discord, Twitter)
-------------------------------
local function simpleFormatFunction(Timer, Remainder)
	local function addZeros(s) return (s:len() == 1 and "0"..s) or s end
	Remainder = math.round(Remainder)
	Remainder = math.clamp(Remainder, 0, math.huge)
	local minutes = math.floor(Remainder/60)
	Remainder -= minutes*60

	return addZeros(tostring(minutes))..":"..addZeros(tostring(Remainder))
end

local Timer = {}
Timer.__index = Timer

function Timer.CreateFormatFunction(Format : string)

end

function Timer.new(FormatFunction) FormatFunction = FormatFunction or simpleFormatFunction
	local self			= setmetatable({}, Timer)
	self.FormatFunction = FormatFunction
	self.IsRunning 	    = false
	self.IsPaused       = false
	self.Time 			= {Seconds = 0, Format = "nil"}

	self._INTERNAL_Finished = Instance.new("BindableEvent")
	self._INTERNAL_Updated  = Instance.new("BindableEvent")
	self.Finished   = self._INTERNAL_Finished.Event
	self.Updated    = self._INTERNAL_Updated.Event

	return self
end

function Timer:Start(StartTime : number, EndTime : number, Multiplier : number, ...)
	if self.RunThread then task.cancel(self.RunThread) end
	local args 	= ({...})
	EndTime 	= EndTime or 0
	Multiplier 	= Multiplier or 1

	self.EndTime   = EndTime
	self.StartTime = StartTime
	self.Multiplier= Multiplier
	self.IsRunning = true

	self.RunThread = task.spawn(function()
		self.StartUnix = (args[1] or os.time())
		while self.IsRunning == true do
			local runTime = os.time() - self.StartUnix
			local seconds = (self.EndTime > self.StartTime and math.abs(runTime*self.Multiplier)) or (self.StartTime - math.abs(runTime*self.Multiplier))

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

			if seconds ~= self.Time.Seconds then
				self.Time = {Seconds = seconds, Format = self.FormatFunction(self, seconds)}
				print(self.Time.Seconds)
				self._INTERNAL_Updated:Fire()

				continue
			end

			self.Time = {Seconds = seconds, Format = self.FormatFunction(self, seconds)}
			task.wait()
		end
	end)
end

function Timer:Pause()
	if self.IsRunning == false then return end
	if self.PauseThread then task.cancel(self.PauseThread) end
	task.cancel(self.RunThread)

	self.IsRunning = false
	self.IsPaused = true

	local pauseUnix = os.time()
	local startUnix = self.StartUnix
	self.PauseThread = task.spawn(function()
		while self.IsPaused == true do
			local pauseTime = os.time() - pauseUnix
			self.StartUnix  = startUnix + pauseTime
			task.wait()
		end
	end)
end

function Timer:Resume()
	if self.IsRunning == true then return end
	if self.IsPaused  == false then return end
	if self.PauseThread then task.cancel(self.PauseThread) end

	self.IsPaused = false

	self:Start(self.StartTime, self.EndTime, self.Multiplier, self.StartUnix)
end


function Timer:ChangeTime(Delta : number)
	if self.IsRunning == false then return end
	self.StartUnix += Delta
end

function Timer:Stop()
	if self.IsRunning == false then return end

	self.IsRunning = false
	self.Time = (self.EndTime > self.StartTime and {Seconds = self.EndTime, Format = self.FormatFunction(self, self.EndTime)}) or {Seconds = 0, Format = self.FormatFunction(self, 0)}

	self._INTERNAL_Finished:Fire()
end

return Timer