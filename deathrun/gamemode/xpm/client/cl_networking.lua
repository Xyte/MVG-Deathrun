
-- Default
hook.Add("Think", "onPlayerValid", function()
	if (LocalPlayer():IsValid()) then
		LocalPlayer().PlayerData = {}
	
		-- xp
		LocalPlayer().PlayerData["level"] = 0
		LocalPlayer().PlayerData["xp"] = 0
		LocalPlayer().PlayerData["achievements"] = {}
		
		RunConsoleCommand("_senddata")
		
		hook.Remove("Think", "onPlayerValid")
	end
end)

-- XP
usermessage.Hook("player.level", function(um)
	if not (LocalPlayer().PlayerData) then LocalPlayer().PlayerData = {} end
	if not (LocalPlayer().PlayerData["xp"]) then LocalPlayer().PlayerData["xp"] = 0 end
	if not (LocalPlayer().PlayerData["level"]) then LocalPlayer().PlayerData["level"] = 0 end
	-- xp
	LocalPlayer().PlayerData["level"] = um:ReadShort()
	LocalPlayer().PlayerData["xp"] = um:ReadLong()
end)

usermessage.Hook("player.time", function(um)
	LocalPlayer().PlayerData["time"] = um:ReadLong()
end)

net.Receive("achievements.data", function()
	if not (LocalPlayer().PlayerData) then LocalPlayer().PlayerData = {} end
	if not (LocalPlayer().PlayerData["achievements"]) then LocalPlayer().PlayerData["achievements"] = {} end
	
	LocalPlayer().PlayerData["achievements"] = net.ReadTable()
end)