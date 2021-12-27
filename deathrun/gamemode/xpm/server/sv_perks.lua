
function XPM.SetPlayerPerk(player, perk)
	-- :V
	if not (table.HasValue(player.PlayerData["items"], perk)) then
		player:ChatPrint("Serverside checks bitch!")
		return
	end

	-- Prevents abuse
	if player:Alive() then
		player:ChatPrint("You cannot switch perk while you're alive.")
		return
	end

	player.PlayerData["perk"] = perk
	database.Query([[UPDATE player_data SET perk = ']]..perk..[[' WHERE steamid = ']]..player:SteamID()..[[']])

	player:ChatPrint("You perk has been changed.")
	player:SetNWString("perk", perk)
end

function XPM.GetPlayerPerk(player)
	if not (player.PlayerData) then return end

	return player.PlayerData["perk"] or "perk_bhop"
end

concommand.Add("dr_selectperk", function(pl, cmd, args)
	if not (args[1]) then return end

	XPM.SetPlayerPerk(pl, args[1])
end)