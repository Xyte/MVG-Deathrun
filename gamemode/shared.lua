DeriveGamemode( "base" )

GM.Name 	= "Deathrun"
GM.Author 	= "Mr. Gash"
GM.Email 	= ""
GM.Website 	= "nonerdsjustgeeks.com"

function GM:CreateTeams()
	TEAM_DEATH = 2
	team.SetUp( TEAM_DEATH, "Death", Color( 180, 60, 60, 255 ), false )
	team.SetSpawnPoint( TEAM_DEATH, "info_player_terrorist" )

	TEAM_RUNNER = 3
	team.SetUp( TEAM_RUNNER, "Runner", Color( 60, 60, 180, 255 ), false )
	team.SetSpawnPoint( TEAM_RUNNER, "info_player_counterterrorist" )

	team.SetUp( TEAM_SPECTATOR, "Spectator", Color( 125, 125, 125, 255 ), true )
end

local meta = FindMetaTable( "Player" )

function GM:PhysgunPickup( ply, ent )
	if not ply:IsSuperAdmin() then return false end
	if true then return true end
	if not IsValid(ent) then return false end
	if not ent:IsWeapon() then return false end
	return true
end

function GM:PlayerNoClip( ply, on )
	if not ply:IsAdmin() then return false end

	if SERVER then
		PrintMessage( HUD_PRINTCONSOLE, "Admin '"..ply:Nick().."' has "..(on and "enabled" or "disabled").." noclip." )
	end
	return true
end

function GM:PlayerUse( ply )
	if not ply:Alive() then return false end

	return true
end

function GM:GetRound()
	return GetGlobalInt( "Deathrun_RoundPhase" )
end

function GM:GetRoundTime()
	return math.Round(math.max( GetGlobalInt( "Deathrun_RoundTime" ) - CurTime(), 0 ))
end

meta.OldAlive = meta.OldAlive or meta.Alive

function meta:Alive()
	if self:Team() == TEAM_SPECTATOR then return false end

	return self:OldAlive()
end

-- This is some sick shit. Keep it.
function string.FormattedTime( seconds, Format )
	if not seconds then seconds = 0 end
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor((seconds / 60) % 60)
	local millisecs = ( seconds - math.floor( seconds ) ) * 100
	seconds = seconds % 60
    
	if Format then
		return string.format( Format, minutes, seconds, millisecs )
	else
		return { h=hours, m=minutes, s=seconds, ms=millisecs }
	end
end

local gf = {}
function GM:Move( ply, movedata )
 if !ply:Alive() or ply:IsOnGround() or ply:WaterLevel() > 0 then return end
 
 local og = ply:IsFlagSet( FL_ONGROUND )
 if og and not gf[ ply ] then
  gf[ ply ] = 0
 elseif og and gf[ ply ] then
  gf[ ply ] = gf[ ply ] + 1
  if gf[ ply ] > 4 then
   ply:SetDuckSpeed( 0.4 )
   ply:SetUnDuckSpeed( 0.2 )
  end
 end

 if og or not ply:Alive() then return end

 local vel = movedata:GetVelocity()
 if vel:Length2D() > 350 then
   gf[ ply ] = 0
   ply:SetDuckSpeed(0)
   ply:SetUnDuckSpeed(0)
 else
   gf[ ply ] = 0
   ply:SetDuckSpeed( 0.4 )
   ply:SetUnDuckSpeed( 0.2 )
 end

 local fmove = movedata:GetForwardSpeed()
 local smove = movedata:GetSideSpeed()
 if fmove == 0 and smove == 0 then return end
 
 local aim = movedata:GetMoveAngles()
 local forward, right = aim:Forward(), aim:Right()

 forward.z = 0
 forward:Normalize()

 local wishvel = forward * fmove + right * smove
 local wishspeed = wishvel:Length2D()

 wishvel = wishspeed > 0 and wishvel * (movedata:GetMaxSpeed()/wishspeed) or wishvel
 wishvel:Normalize()

 local vel = movedata:GetVelocity()
 local addspeed = (wishspeed == 0 and 0 or 35) - vel:Dot(wishvel)

 if addspeed <= 0 then return end

 movedata:SetVelocity(vel + (wishvel * addspeed))
 return false
end
