local meta = FindMetaTable("Player")
if not (meta) then return end

function meta:LoadAccount()
	if not (self:IsValid()) then return end
	local steamid = self:SteamID()
	
	-- stats
	self.PlayerData = {}
	self.PlayerData["items"] = {}
	self.PlayerData["achievements"] = {}
	self.PlayerData["stats"] = {}
	self.PlayerData["xp"] = 0
	self.PlayerData["perk"] = "perk_bhop"

	-- Forgive me
	self:SetNWString("perk", self.PlayerData["perk"])
	
	-- items
	database.Query([[SELECT items FROM player_store WHERE steamid = ']]..steamid..[[']], function(data)
		if (data) then
			for k, v in pairs(data) do
				table.insert(self.PlayerData["items"], v.items)
			end
		end
	end)
	
	-- Achievements
	database.Query([[SELECT achievement FROM player_achievements WHERE steamid = ']]..steamid..[[']], function(data)
		for k, v in pairs(data) do
			table.insert(self.PlayerData["achievements"], v.achievement)
		end
	end)
	
	local query = sql.Query([[SELECT stats FROM player_stats WHERE steamid = ']]..steamid..[[' ]])
	
	-- Stats
	if (query) then
		for k, v in pairs(util.JSONToTable(query[1].stats)) do
			self.PlayerData["stats"][k] = v
		end
	else
		local tbl = {}
		database.Query([[INSERT INTO player_stats (steamid, stats) VALUES(']]..steamid..[[', ']]..util.TableToJSON(tbl)..[[' )]])
	end

	-- XP
	local query = sql.Query([[SELECT xp, perk, firstjoin FROM player_data WHERE steamid = ']]..steamid..[[']])
	
	if (query) then
		self.PlayerData["xp"] = query[1].xp
		self.PlayerData["perk"] = query[1].perk

		if not (query[1].firstjoin == "1") then
			umsg.Start("questions", self)
			umsg.End()
		end

		if (self.PlayerData["perk"] == "NULL") then
			XPM.SetPlayerPerk(self, "perk_bhop")
		end

		self:SetNWString("perk", self.PlayerData["perk"])
		self:CalculateLevel()
	else
		database.Query([[INSERT INTO player_data (steamid, xp, perk) Values(']]..steamid..[[', '0', 'perk_bhop')]])
	end
	
		-- Hello achv
	XPM.Unlock(self, "achv_misc_hello")
		
	-- AC achv
	if (self:SteamID() == "STEAM_0:0:86092282") then
		for k, v in pairs(player.GetAll()) do
			XPM.Unlock(v, "achv_misc_ac")
		end
	end
		
	-- Jethro
	if (self:SteamID() == "STEAM_0:0:9987939") then
		for k, v in pairs(player.GetAll()) do
			XPM.Unlock(v, "achv_misc_pixie")
		end
	end

	-- Sanne
	if (self:SteamID() == "STEAM_0:0:86092282") then
		for k, v in pairs(player.GetAll()) do
			XPM.Unlock(v, "achv_misc_sanne2")
		end
	end
	
	XPM.SendAchievements(self)

	self:SetNWInt("timeplayed", (XPM.GetStat(self, "timeplayed")))
	
	-- Time played tracking
	timer.Create(self:UniqueID().."_timer", 60, 0, function()
		if (self:IsValid()) then
			XPM.AddStat(self, "timeplayed", 60, true)

			-- Fucking Sanne
			self:SetNWInt("timeplayed", (XPM.GetStat(self, "timeplayed")))

			for k, v in pairs(XPM.AchievementHandlers["timeplayed"]) do
				if (XPM.GetStat(self, "timeplayed") >= v.time) then
					XPM.Unlock(self, v.achv)
				end
			end
		end
	end, self)
end

concommand.Add("_senddata", function(ply)
	ply:LoadAccount()
end)

concommand.Add("questions_finished", function(ply, cmd)
	sql.Query([[UPDATE player_data SET firstjoin = '1' WHERE steamid = ']]..ply:SteamID()..[[']])
end)

concommand.Add("questions_failed", function(ply, cmd, args)
	ply:Kick("You're an idiot.")
end)