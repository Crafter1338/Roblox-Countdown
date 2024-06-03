----THIS IS A MODULE SCRIPT----
----Contact:-------------------
--  Crafter1338 (Discord, Twitter)
-------------------------------
local module = {}

local function addZeros(s) return (s:len() == 1 and "0"..s) or s end
function module.MinSec(timer, remainder)
	remainder = math.round(remainder)
	remainder = math.clamp(remainder, 0, math.huge)
	local minutes = math.floor(remainder/60)
	remainder -= minutes*60

	return addZeros(tostring(minutes))..":"..addZeros(tostring(remainder))
end

function module.HourMinSec(timer, remainder)
	remainder = math.round(remainder)
	remainder = math.clamp(remainder, 0, math.huge)
	local hours = math.floor(remainder/60/60)
	remainder -= hours*60*60
	local minutes = math.floor(remainder/60)
	remainder -= minutes*60

	return addZeros(tostring(hours))..":"..addZeros(tostring(minutes))..":"..addZeros(tostring(remainder))
end

return module
