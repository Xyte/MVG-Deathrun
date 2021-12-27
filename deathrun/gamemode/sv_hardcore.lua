
-- Vars
local CanHardcore = true

AddChatCommand("!hardcore", function(player)
	-- Too late
	if (CanHardcore == false) then 
		player:ChatPrint("You can't enable hardcore anymore. Wait till next round.")
		return
	end

	-- Dead
	if not (player:Alive()) and not (GetGlobalInt("Deathrun_RoundPhase") == ROUND_ACTIVE) then
		player:ChatPrint("Can't hardcore when you're dead bro.")
		return
	end

	-- Death
	if (player:Team() == TEAM_DEATH) and (player:Alive()) and not (GetGlobalInt("Deathrun_RoundPhase") == ROUND_ACTIVE) then
		player:ChatPrint("Can't enable hardcore when you are death.")
		return
	end

	-- WAAAAAAAAAAAAAAAR
	player.hardcore = true

	-- Da rules
	player:ChatPrint("HARDCORE MODE RULES:")
	player:ChatPrint("You must finish the map with one health and kill atleast one death with a melee weapon.")
	player:ChatPrint("If you pickup any health you are out.")
	player:ChatPrint("RTD has been disabled in hardcore.")
end)

hook.Add("OnRoundSet", "Hardcoremode", function(round, winner)
	if (round == ROUND_ACTIVE) then
		CanHardcore = false

		for k, v in pairs(player.GetAll()) do
			if (v.hardcore) then
				if (v:Team() == TEAM_RUNNER) then
					v:SetHealth(1)
				else
					v.hardcore = false
					v:SetHealth(100)
				end
			end
		end
	elseif (round == ROUND_ENDING) then
		CanHardcore = true

		for k, v in pairs(player.GetAll()) do
			v:ChatPrint("Type !hardcore to enable hardcore mode next round.")

			if not (winner == 123) then
				if (v.hardcore and v.haskilled) and (v:Team() == winner) and (v:Health() == 1) then
					v:ChatPrint("You won on hardcore, have 1000 points.")
					v:PS_GivePoints(1000)
				end
			end

			v.hardcore = false
			v.haskilled = false
		end
	end
end)