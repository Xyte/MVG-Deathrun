local map = game.GetMap()

local Runner1, Runner2

local function FixAAVector( a, b )
	if ( not isvector( a ) ) or ( not isvector( b ) ) then return end
	return Vector( math.min( a.x, b.x ) + 18, math.min( a.y, b.y ) + 18, math.min( a.z, b.z ) ), Vector( math.max( a.x, b.x ) - 18, math.max( a.y, b.y ) - 18, math.max( a.z, b.z ) )
end


function InitSpawnPointCollector()
	local DeathSpawnPoints = util.JSONToTable( file.Read( "deathrun/startpoints/" .. map .. "/death.txt", "DATA" ) or "[]" )
	if DeathSpawnPoints.P1 then

		local Death1, Death2 = FixAAVector( DeathSpawnPoints.P1, DeathSpawnPoints.P3 )

		function GetDeathSpawnPoint()
			return Vector( math.random( Death1.x, Death2.x ), math.random( Death1.y, Death2.y ), math.random( Death1.z, Death2.z ) )
		end
	else
		function GetDeathSpawnPoint()
			return table.Random( ents.FindByClass( "info_player_terrorist" ) ):GetPos()
		end
	end

	local RunnerSpawnPoints = util.JSONToTable( file.Read( "deathrun/startpoints/" .. map .. "/runner.txt", "DATA" ) or "[]" )
	if RunnerSpawnPoints.P1 then
		Runner1, Runner2 = FixAAVector( RunnerSpawnPoints.P1, RunnerSpawnPoints.P3 )

		function GetRunnerSpawnPoint()
			return Vector( math.random( Runner1.x, Runner2.x ), math.random( Runner1.y, Runner2.y ), math.random( Runner1.z, Runner2.z ) )
		end
	else
		function GetRunnerSpawnPoint()
			return table.Random( ents.FindByClass( "info_player_counterterrorist" ) ):GetPos()
		end
	end
end

InitSpawnPointCollector()

local Fixed1, Fixed2 = Vector(), Vector()
timer.Create( "SpawnKiller", 1, 0, function()
if not Runner1 and Runner2 then return end
if GetRoundState() == ROUND_ACTIVE then
if GetConVarNumber( "dr_roundtime_seconds" ) - ( GetGlobalInt( "Deathrun_RoundTime", CurTime() ) - CurTime() ) > 60 then
for k, v in pairs( ents.FindInBox( Runner1, Runner2 ) ) do
if IsValid(v) and v:IsPlayer() and v:Alive() then
v:TakeDamage( 10, game.GetWorld(), game.GetWorld() )
end
end
end
end
end )
