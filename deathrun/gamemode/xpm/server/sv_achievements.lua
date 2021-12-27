
util.AddNetworkString("achievements.data")
util.AddNetworkString("achievements.chattext")

function XPM.SendAchievements(ply)
	net.Start("achievements.data")
		net.WriteTable(ply.PlayerData["achievements"])
	net.Send(ply)
end

-- Print to chat
function XPM.ChatText(...)
	local args = {...}

	net.Start("achievements.chattext")
		net.WriteTable(args)
	net.Broadcast()
end-- Print to chat

-- Unlock an achievement
function XPM.Unlock(ply, achvid)
	if not (ply) or not (ply:IsValid()) then return end
	if not (XPM.IsValid(achvid)) then return end
	if (XPM.IsUnlocked(ply, achvid)) then return end
	
	local data = XPM.GetData(achvid)
	
	if (ply.PlayerData) and (ply.PlayerData["achievements"]) then
		table.insert(ply.PlayerData["achievements"], achvid)
		
		-- Notify
		
		XPM.ChatText(color_white, "Player ", Color(255, 255, 0), ply:Name(), color_white, " earned the achievement ", Color(255, 255, 0), data.name, color_white, ".")
	
		umsg.Start("achievements.unlock", ply)
			umsg.String(XPM.list[achvid].name)
			umsg.String(XPM.list[achvid].desc)
			umsg.Short(1)
		umsg.End()
		
		XPM.SendAchievements(ply)
		
		-- XP
		ply:AddXP(XPM.list[achvid].reward)
		
		database.Query([[INSERT INTO player_achievements (steamid, achievement) Values(']]..ply:SteamID()..[[', ']]..achvid..[[')]])
	end
end

-- Add a stat thingie
function XPM.AddStat(ply, stat, value, save)
	if not (ply) or not (ply:IsValid()) then return end
	if not (XPM.IsValidStat(stat)) then return end
	save = save or false
	
	if (ply.PlayerData) and (ply.PlayerData["stats"]) then
		if (ply.PlayerData["stats"][stat]) then
			ply.PlayerData["stats"][stat] = ply.PlayerData["stats"][stat] + value
		else
			ply.PlayerData["stats"][stat] = value
		end
	end
	
	if (save) then
		XPM.SaveStats(ply)
	end
end

-- Get a stat
function XPM.GetStat(ply, stat)
	if not (ply) or not (ply:IsValid()) then return end
	if not (XPM.IsValidStat(stat)) then return end
	
	if (ply.PlayerData) and (ply.PlayerData["stats"]) and (ply.PlayerData["stats"][stat]) then
		return (ply.PlayerData["stats"][stat] or 0)
	end
	
	return 0
end

-- Save all stats
function XPM.SaveStats(ply)
	if (ply.PlayerData) and (ply.PlayerData["stats"]) then
		local stats = util.TableToJSON(ply.PlayerData["stats"])
		
		database.Query([[UPDATE player_stats SET stats = ']]..stats..[[' WHERE steamid = ']]..ply:SteamID()..[[']])
	end
end