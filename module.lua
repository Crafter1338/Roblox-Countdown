----Contact:-------------------
--  Crafter1338 (discord)
-------------------------------
local Countdown = {}
Countdown.__index = Countdown

local function addLeadingZero(s)
	s = (s:len() == 1 and "0"..s) or s
	return s
end

local function format(seconds)
	seconds = math.clamp(seconds, 0, math.huge)
	local minutes = math.floor(seconds/60)
	seconds -= minutes*60
	return addLeadingZero(tostring(minutes))..":"..addLeadingZero(tostring(seconds))
end

function Countdown.new(maxTime : number, ...)
	local startWithMax = ({...})[1] or true
	local self = {}
	self.MaxTime = maxTime
	self.TimeRemaining = {
		unix   = ((startWithMax == true and 0) or 1)*maxTime,
		format = format(self.MaxTime)
	}
	self.Finished = Instance.new("BindableEvent")
	self.Updated  = Instance.new("BindableEvent")

	setmetatable(self, Countdown)
	return self
end

function Countdown:Start(...)
	local args = {...}
	if self.PauseThread then
		task.cancel(self.PauseThread)
	end

	self.Thread = task.spawn(function()
		self.StartTick = args[1] or os.time()
		while task.wait() do
			local currentSeconds = os.time() - self.StartTick
			local remainder 	 = self.MaxTime - currentSeconds

			if remainder < 0 then
				self.TimeRemaining = {
					unix   = 0,
					format = format(0)
				}
				self.Updated:Fire()
				self.Finished:Fire() 

				return
			end
			if remainder ~= self.TimeRemaining.unix then
				self.TimeRemaining = {
					unix   = remainder,
					format = format(remainder)
				}
				self.Updated:Fire()

				continue
			end

			self.TimeRemaining = {
				unix   = remainder,
				format = format(remainder)
			}
		end
	end)
end

function Countdown:Stop()
	task.cancel(self.Thread)
	self.Finished:Fire()
end

function Countdown:Continue()
	task.cancel(self.PauseThread)
	self:Start(self.StartTick)
end

function Countdown:Pause()
	task.cancel(self.Thread)
	self.PauseThread = task.spawn(function()
		local distance = os.time() - self.StartTick

		while task.wait() do
			self.StartTick = os.time() - distance
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