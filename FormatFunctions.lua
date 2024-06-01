----THIS IS A MODULE SCRIPT----
----Contact:-------------------
--  Crafter1338 (discord, Twitter)
-------------------------------
local module = {}

local function addZeros(s) return (s:len() == 1 and "0"..s) or s end

function module.MinSec(counter, remainder)
	remainder = math.round(remainder)
	remainder = math.clamp(remainder, 0, math.huge)
	local minutes = math.floor(remainder/60)
	remainder -= minutes*60

	return addZeros(tostring(minutes))..":"..addZeros(tostring(remainder))
end

function module.HourMinSec(counter, remainder)
	remainder = math.round(remainder)
	remainder = math.clamp(remainder, 0, math.huge)
	local hours = math.floor(remainder/60/60)
	remainder -= hours*60*60
	local minutes = math.floor(remainder/60)
	remainder -= minutes*60

	return addZeros(tostring(hours))..":"..addZeros(tostring(minutes))..":"..addZeros(tostring(remainder))
end

function module.MinSecMillis(counter, remainder)
	if counter.IsMillis == false then counter:SetIsMillis(true) end
	
	remainder = math.clamp(remainder, 0, math.huge)
	local minutes = math.floor(remainder/60)
	remainder -= minutes*60
	local seconds = math.floor(remainder)
	remainder *= 1000
	remainder -= seconds*1000
	local milliseconds = math.round(remainder)

	return addZeros(tostring(minutes))..":"..addZeros(tostring(seconds))..":"..milliseconds
end

return module