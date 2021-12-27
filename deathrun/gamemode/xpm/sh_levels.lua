
-- Object
XPM.levels = {}

-- Register a new level
function XPM.RegisterLevel(xp)
	local i = #XPM.levels
	XPM.levels[i+1] = {level = i + 1, xp = xp}
end

-- Valid level check
function XPM.IsValidLevel(level)
	return util.tobool(XPM.levels[level])
end

-- Prepare for 100 lines of level code :C
-- Edit: Lol, nvm
for i = 1, 200 do
	if (i < 5) then
		XPM.RegisterLevel(i * 1000, i)
	else
		XPM.RegisterLevel((i * 500) + XPM.levels[i-1].xp , i)
	end
end

-- i is defined as level
