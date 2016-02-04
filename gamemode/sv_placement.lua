util.AddNetworkString( "send_placement_mode" )
util.AddNetworkString( "send_placement_data" )

hook.Add( "PlayerInitalSpawn", "SetPlayerMode", function(ply)
	ply.InPlacementMode = false
end )

concommand.Add( "dr_spawnpoint", function( ply )
	if not ply:IsSuperAdmin() then 
		return
	end

	if ply.InPlacementMode then
		StopPlacementMode( ply )
	else
		StartPlacementMode( ply )
	end
	ply.InPlacementMode = !ply.InPlacementMode
end )

function StartPlacementMode( ply )
	ply.LastPos = ply:GetPos()
	ply:SetMoveType( MOVETYPE_NOCLIP )
	net.Start( "send_placement_mode" )
	net.WriteFloat( 1 )
	net.Send( ply )
end

function StopPlacementMode( ply )
	ply:SetPos( ply.LastPos )
	ply:SetMoveType( MOVETYPE_WALK )
	net.Start( "send_placement_mode" )
	net.WriteFloat( 0 )
	net.Send( ply )
end

local map = game.GetMap()
net.Receive( "send_placement_data", function( len, ply )
	if ply:IsSuperAdmin() then                                                                                                                                                      
		ply:ConCommand( "bhop_placement_mode" )
		local tbl = net.ReadTable()

		file.CreateDir( "deathrun" )
		file.CreateDir( "deathrun/startpoints/" )
		file.CreateDir( "deathrun/startpoints/" .. map )

		if tbl.TYPE == "Runner" then
			file.Write( "deathrun/startpoints/" .. map .. "/runner.txt", util.TableToJSON( { P1 = tbl.P1, P3 = tbl.P3 } ) )
		elseif tbl.TYPE == "Death" then
			file.Write( "deathrun/startpoints/" .. map .. "/death.txt", util.TableToJSON( { P1 = tbl.P1, P3 = tbl.P3 } ) )
		end
		InitSpawnPointCollector()
	end
end )
