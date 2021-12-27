local meta = FindMetaTable("Player")
if not (meta) then return end

-- Get a XP
function meta:GetXP()
	if (self.PlayerData) and (self.PlayerData["xp"]) then
		return tonumber(self.PlayerData["xp"])
	end
	
	return 0
end

-- Add XP
function meta:AddXP(amount)
	if (self.PlayerData) and (self.PlayerData["xp"]) then
	
		if (XPM.GetPlayerPerk(self) == "perk_bhop") then
			amount = amount * 2
		end
		
		self.PlayerData["xp"] = self:GetXP() + amount
		self:CalculateLevel()
		
		database.Query([[UPDATE player_data SET xp = ']]..self:GetXP()..[[' WHERE steamid = ']]..self:SteamID()..[[']])
	end
end

-- Add XP
function meta:SetXP(amount)
	if (self.PlayerData) and (self.PlayerData["xp"]) then
		database.Query([[UPDATE player_data SET xp = ']]..amount..[[' WHERE steamid = ']]..self:SteamID()..[[']])
		
		self.PlayerData["xp"] = amount
	
		self:CalculateLevel()
	end
end

-- Get a level
function meta:GetLevel()
	if (self.PlayerData) and (self.PlayerData["level"]) then
		return self.PlayerData["level"]
	end
	
	return 0
end

-- Set a level
function meta:SetLevel(level)
	if (self.PlayerData) then
		self.PlayerData["level"] = level
	end
end

-- Add a level
function meta:AddLevel(level)
	if (self.PlayerData) and (self.PlayerData["level"]) then
		self.PlayerData["level"] = self:GetLevel() + level
	end
end

-- Set the level of someone based on their XP
function meta:CalculateLevel()
	local playerxp = self:GetXP()
	local playerlevel = self:GetLevel()
	
	for k, v in pairs(table.Reverse(XPM.levels)) do
		if (v.xp <= playerxp) then
			if not (playerlevel == v.level) then
				if (k == 0) then
					self:SetLevel(0)
				else
					self:SetLevel(v.level)
				end
			
				hook.Call("OnLevelUp", GAMEMODE, self)
			end
			
			break
		end
	end
	
	-- Network it
	umsg.Start("player.level", self)
		umsg.Short(self:GetLevel())
		umsg.Long(self:GetXP())
	umsg.End()
end

-- Some achievements shit
local levelachv = {}
levelachv[5] = "achv_level5"
levelachv[10] = "achv_level10"
levelachv[15] = "achv_level15"
levelachv[20] = "achv_level20"
levelachv[25] = "achv_level25"
levelachv[30] = "achv_level30"
levelachv[35] = "achv_level35"
levelachv[40] = "achv_level40"
levelachv[45] = "achv_level45"
levelachv[50] = "achv_level50"
levelachv[60] = "achv_level60"
levelachv[70] = "achv_level70"
levelachv[80] = "achv_level80"
levelachv[90] = "achv_level90"
levelachv[90] = "achv_level99"
levelachv[100] = "achv_level100"
levelachv[200] = "achv_level200"

-- Called when you leave up
hook.Add("OnLevelUp", "DrawShit", function(ply)
	local items = XPM.GetLevelReward(ply:GetLevel())
	ply:SetNWInt("level", ply:GetLevel())

	for k, v in pairs(items) do
		if not (table.HasValue(ply.PlayerData["items"], v)) then
			table.insert(ply.PlayerData["items"], v)
		end
	end
	
	for k, v in pairs(levelachv) do
		if (ply:GetLevel() >= k) then	
			XPM.Unlock(ply, v)
		end
	end
	
	if (ply.PreventJoined) then
		ply:ChatPrint("Level up!")
	end
	
	if not (ply.PreventJoined) then
		ply.PreventJoined = true
	end
end)
