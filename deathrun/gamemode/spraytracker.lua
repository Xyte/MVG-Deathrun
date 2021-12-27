
// TODO: Rewrite this

if SERVER then
	function STA_OnPlayerSprayed( ply )
		STA_BaseTable = STA_BaseTable or {}
		local shootpos = ply:GetShootPos()
		local trace = ply:GetEyeTrace()
		local steamid = ply:SteamID()
		STA_BaseTable[steamid] = {}
		STA_BaseTable[steamid].pos = trace.HitPos
		STA_BaseTable[steamid].ang = trace.HitNormal
		STA_BaseTable[steamid].name = ply:Name()
		umsg.Start("_STA_Update3D2DSprayTracker_Clean")
		umsg.End()
		for k,v in pairs(STA_BaseTable) do
			umsg.Start("_STA_Update3D2DSprayTracker_Add")
				umsg.Vector(v.pos)
				umsg.Vector(v.ang)
				umsg.String(k)
				umsg.String(v.name)
			umsg.End()
		end
	end
	hook.Add( "PlayerSpray", "STA_OnPlayerSprayed", STA_OnPlayerSprayed )
	
	function STA_CheckAdmin( ply )
		if not STA_EnableCustomRanks then return end
		for k,v in pairs(STA_CustomRanks) do
			if ply:IsUserGroup(v) then
				return true
			end
		end
		return false
	end
	
	function STA_OnPlayerSprayed( ply )
		STA_BaseTable = STA_BaseTable or {}
		timer.Simple(5,function()
			-- It really is!
			//ply:ChatPrint("[ Seriously, this spraytracker script is shit. ]")
			umsg.Start("_STA_Update3D2DSprayTracker_Clean")
			umsg.End()
			for k,v in pairs(STA_BaseTable) do
				umsg.Start("_STA_Update3D2DSprayTracker_Add")
					umsg.Vector(v.pos)
					umsg.Vector(v.ang)
					umsg.String(k)
					umsg.String(v.name)
				umsg.End()
			end
		end)
	end
	hook.Add("PlayerInitialSpawn","STA_OnPlayerSprayed",STA_OnPlayerSprayed)
	
	function STA_PlayerSay_ToggleSTA(ply)
		if ply.STA_Enabled then
			ply:SendLua([[STA_Is_Enabled = false]])
			ply:ChatPrint("Spray tracker disabled!")
			ply.STA_Enabled = false
		else
			ply:ChatPrint("Spray tracker enabled!")
			ply.STA_Enabled = true
			ply:SendLua([[STA_Is_Enabled = true]])
		end
	end
	AddChatCommand("!togglesp", function(ply) STA_PlayerSay_ToggleSTA(ply) end, true)
	
else
	function STA_PaintHUDSprays()
		if not STA_Is_Enabled then return end
		STA_ClientBaseTable = STA_ClientBaseTable or {}
		for k,v in pairs(STA_ClientBaseTable) do
			local pos = (v[1]):ToScreen()
			local distance = (v[1]-LocalPlayer():GetShootPos()):Length()
			local alpha = math.Clamp(300-distance,0,255)
			draw.DrawText("Spray By:", "Deathrun_Smooth", pos.x, pos.y-15, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT )
			draw.DrawText(v[3], "ChatFont", pos.x, pos.y, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			draw.DrawText("("..k..")", "ChatFont", pos.x, pos.y+15, Color(255, 255, 255, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_RIGHT )
		end
	end
	hook.Add("HUDPaint","STA_PaintHUDSprays",STA_PaintHUDSprays)

	function STA_Update3D2DSprayTracker( data )
		STA_ClientBaseTable = STA_ClientBaseTable or {}
		local pos = data:ReadVector()
		local ang = data:ReadVector()
		local id = data:ReadString()
		local name = data:ReadString()
		STA_ClientBaseTable[id] = {pos,ang,name}
	end
	usermessage.Hook("_STA_Update3D2DSprayTracker_Add",STA_Update3D2DSprayTracker)
	
	function STA_Update3D2DSprayTracker( data )
		STA_ClientBaseTable = {}
	end
	usermessage.Hook("_STA_Update3D2DSprayTracker_Clean",STA_Update3D2DSprayTracker)
	
end