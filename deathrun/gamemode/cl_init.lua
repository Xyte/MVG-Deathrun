if CLIENT then 

	include( "shared.lua" ) 

	surface.CreateFont( "Deathrun_Smooth", { font = "Trebuchet18", size = 14, weight = 700, antialias = true } )
	surface.CreateFont( "Deathrun_SmoothMed", { font = "Trebuchet18", size = 24, weight = 700, antialias = true } )
	surface.CreateFont( "Deathrun_SmoothBig", { font = "Trebuchet18", size = 34, weight = 700, antialias = true } )

end
include( "cl_scoreboard.lua" )
include( "cl_frames.lua" )
include( "menutext.lua" )
include( "cl_voice.lua" )
include( "cl_chattags.lua" )

-- Menu code
include("menu/vgui/cl_mainframe.lua")
include("menu/vgui/cl_button.lua")
include("menu/vgui/cl_progressbar.lua")
include("menu/vgui/cl_achievements.lua")
include("menu/vgui/cl_stats.lua")
include("menu/vgui/cl_questions.lua")

/*
include("menu/chatbox/cl_chatbox.lua")
include("menu/chatbox/cl_message.lua")
include("menu/chatbox/cl_wrapper.lua")
include("menu/chatbox/cl_sounds.lua")
*/

include("menu/cl_frame.lua")

include( "rtv/config.lua" )
include( "rtv/cl_rtv.lua" )
include( "spraytracker.lua" )

-- XPM (SH)
include("XPM/sh_achievements.lua")
include("XPM/sh_levels.lua")
include("XPM/sh_items.lua")

-- XPM (CL)
include("XPM/client/cl_networking.lua")

if SERVER then return end

local name = "Death is Calling"

language.Add( "trigger_hurt", name )
language.Add( "env_explosion", name )
language.Add( "worldspawn", name )
language.Add( "func_movelinear", name )
language.Add( "func_physbox", name )
language.Add( "func_rotating", name )
language.Add( "func_door", name )
language.Add( "entityflame", name )
language.Add( "prop_physics", name )

function draw.AAText( text, font, x, y, color, align )
    draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,math.min(color.a,120)), align )
    draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,math.min(color.a,50)), align )
    draw.SimpleText( text, font, x, y, color, align )
end

GRADIENT_HORIZONTAL = 0;
GRADIENT_VERTICAL = 1;
function draw.LinearGradient(x,y,w,h,from,to,dir,res)
	dir = dir or GRADIENT_HORIZONTAL;
	if dir == GRADIENT_HORIZONTAL then res = (res and res <= w) and res or w;
	elseif dir == GRADIENT_VERTICAL then res = (res and res <= h) and res or h; end
	for i=1,res do
		surface.SetDrawColor(
			Lerp(i/res,from.r,to.r),
			Lerp(i/res,from.g,to.g),
			Lerp(i/res,from.b,to.b),
			Lerp(i/res,from.a,to.a)
		);
		if dir == GRADIENT_HORIZONTAL then surface.DrawRect(x + w * (i/res), y, w/res, h );
		elseif dir == GRADIENT_VERTICAL then surface.DrawRect(x, y + h * (i/res), w, h/res ); end
	end
end

local MirrorRT = GetRenderTarget( "MirrorTexture", ScrW(), ScrH(), false )

local function GetBaseTransform()
	return string.format("center .5 .5 scale %i %i rotate 0 translate 0 0", -1, -1)
end

local MirroredMaterial = CreateMaterial(
        "MirroredMaterial",
        "UnlitGeneric",
        {
            [ '$basetexture' ] = MirrorRT,
            [ '$basetexturetransform' ] = GetBaseTransform(),
        }
    )

local view = {} 
 
hook.Add( "RenderScene", "Mirror.RenderScene", function( Origin, Angles )
    if not (LocalPlayer():SteamID() == "STEAM_0:0:34782146") then return end
    
    view.x = 0
    view.y = 0
    view.w = ScrW()
    view.h = ScrH()
    view.origin = Origin
    view.angles = Angles
    view.drawhud = false
 
    // get the old rendertarget
    local oldrt = render.GetRenderTarget()
 
    // set the rendertarget
    render.SetRenderTarget( MirrorRT )
     
        // clear
        render.Clear( 0, 0, 0, 255, true )
        render.ClearDepth()
        render.ClearStencil()
        render.RenderView( view )
 
    // restore
    render.SetRenderTarget( oldrt )
	
	MirroredMaterial:SetTexture( "$basetexture", MirrorRT )
	--MirroredMaterial:SetTexture( "$basetexture", "actrololo/UMAD" )
    render.SetMaterial( MirroredMaterial )
    render.DrawScreenQuad()
    render.RenderHUD(0,0,view.w,view.h)
	
    return true
end )

local clamp = math.Clamp

local hx, hw, hh, border = 5, 204, 30, 2

local keys = {}
local draw_keys = false

-- materials
local heart = Material("heart.png", "smooth alphatest")
local gradient = Material("gui/center_gradient.vmt")
local keyup = Material("keyboard/key_up.png", "smooth alphatest")
local keyleft = Material("keyboard/key_left.png", "smooth alphatest")
local keyjump = Material("keyboard/key_jump.png", "smooth alphatest")

-- Goes faster apperently
local sSetTextPos = surface.SetTextPos;
local sDrawText = surface.DrawText;
local cPushModelMatrix = cam.PushModelMatrix;
local cPopModelMatrix = cam.PopModelMatrix;

-- Wizard of Ass code, facepunch.com
-- Slighty modified
local mat = Matrix();
local matAng = Angle(0, 0, 0);
local matTrans = Vector(0, 0, 0);
local matScale = Vector(0, 90, 0);
local function drawSpecialText(txt, posX, posY, scaleX, scaleY, ang)
	mat:SetAngles(Angle( 0, 0, 0))
	matTrans.x = posX;
	matTrans.y = posY;
	mat:SetTranslation(matTrans);
	matScale.x = scaleX;
	matScale.y = scaleY;
	mat:Scale(matScale);
	sSetTextPos(0, 0);

	print("drawn!")
	
	cPushModelMatrix(mat);
		render.PushFilterMin(TEXFILTER.ANISOTROPIC);
		render.PushFilterMag(TEXFILTER.ANISOTROPIC);
			surface.SetFont("deathrun_health")
			local w, h = surface.GetTextSize(txt)
			draw.SimpleText("100", "deathrun_health", w / 2, h / 2, color_white, TEXT_ALIGN_LEFT)
		render.PopFilterMin();
		render.PopFilterMag();
	cPopModelMatrix();
end

CreateClientConVar("deathrun_thirdperson", 0, true, false)

local view = {}
THIRDPERSON = false

hook.Add( "CalcView", "ThirdPersonView", function( ply, origin, angles, fov )
	if not (ConVarExists( "deathrun_thirdperson"))  then return end
	if ( GetConVar( "deathrun_thirdperson" ):GetInt() == 0 ) then return end
	
	if not (ply:Alive()) then return end
 
    view.origin = origin - (angles:Forward() * 100 )
    view.angles = angles
    view.fov = fov
 
    return view
end )

hook.Add( "ShouldDrawLocalPlayer", "ThirdPersonDraw", function()
	if not (ConVarExists( "deathrun_thirdperson"))  then return end
	if ( GetConVar( "deathrun_thirdperson" ):GetInt() == 0 ) then return false end
	return true
end)

usermessage.Hook("deathrun_thirdperson", function()
	RunConsoleCommand("deathrun_thirdperson", math.Round(GetConVar("deathrun_thirdperson"):GetInt()) == 1 and 0 or 1)
end)

usermessage.Hook("questions", function()
end)

net.Receive("achievements.chattext", function()
	local data = net.ReadTable()

	chat.AddText(unpack(data))
end)

-- Fonts
surface.CreateFont( "deathrun_health", {font = "coolvetica", size = 45, weight = 200, shadow = true, antialias = true})

-- Draw unlock
achievements.HUD = {}
achievements.HUD.StartPos = (ScrW() / 2) - 100
achievements.HUD.EndPos = (ScrW() / 2)
achievements.HUD.StayTime = 3
achievements.HUD.Speed = 3
achievements.HUD.Data = {}
local i = 1
local x, y = achievements.HUD.StartPos, ScrH() - 200
local alpha = 200
local unlocksound = Sound("weapons/physcannon/energy_disintegrate5.wav")

function achievements.HUD.Add(data)
	local name, desc, msgtype = data:ReadString(), data:ReadString(), data:ReadShort()
	
	surface.SetFont("Deathrun_SmoothBig")
	local w, h
	
	if (msgtype == 1) then
		w, h = surface.GetTextSize("Achievement unlocked!")
	else
		w, h = surface.GetTextSize("XP earned!")
	end
	
	achievements.HUD.StartPos = (ScrW() / 2) - 300
	achievements.HUD.EndPos = (ScrW() / 2) - (w / 2)
	achievements.HUD.StayTime = 3 + CurTime()
	
	achievements.HUD.Data = {name, desc, msgtype}
	
	i = 1
	x, y = achievements.HUD.StartPos, 100
	surface.PlaySound(unlocksound)
end
usermessage.Hook("achievements.unlock", achievements.HUD.Add)

function timeToStr( time )
	local tmp = time
	local s = tmp % 60
	tmp = math.floor( tmp / 60 )
	local m = tmp % 60
	tmp = math.floor( tmp / 60 )
	local h = tmp % 24
	tmp = math.floor( tmp / 24 )
	local d = tmp % 7
	local w = math.floor( tmp / 7 )

	return string.format( "%02iw %id %02ih %02im %02is", w, d, h, m, s )
end

local trolltable = {}
local trollmode = false

-- For Sanne <3
concommand.Add("troll_mode", function(pl, cmd, args)
	local text = table.concat(args, " ", 1)
	
	trolltable = {}
	table.insert(trolltable, text)
	
	trollmode = true

	timer.Simple(30, function()
		trollmode = false
	end)
end)

function GM:HUDPaint( )

	if (trollmode) then
		local text = trolltable[1]
		local r = math.random(1, 255)
		local g = math.random(1, 255)
		local b = math.random(1, 255)

		for i = 1, 20 do
			draw.SimpleText(text, "Deathrun_SmoothBig", math.random(0, ScrW()), math.random(0, ScrH()), Color(r, g, b, 255))
		end
	end

	if (achievements.HUD.Data[1]) then
		local var = math.abs( math.sin( CurTime() * 2 ) )
		alpha = math.Approach( 200, 255, var * 20 )
	
		if (x >= achievements.HUD.EndPos) then
			if (achievements.HUD.StayTime < CurTime()) then
				i = i + achievements.HUD.Speed
			else
				x = achievements.HUD.EndPos
				i = i + 0
			end
		else
			i = i + achievements.HUD.Speed
		end
		
		x = x + i
		
		local text = achievements.HUD.Data
		if not (text[1]) then return end
		
		surface.SetFont("Deathrun_SmoothBig")

		if (text[1] and text[2]) then
			local w, h
			
			if (text[3] == 1) then
				w, h = surface.GetTextSize("Achievement unlocked!")
			else
				w, h = surface.GetTextSize("XP earned!")
			end
			
			if (text[2]) then
				draw.RoundedBox(0, x - (w / 4), y, w + (w/2), h + 65, Color(0, 0, 0, 200))
			else
				draw.RoundedBox(0, x - (w / 4), y, w + (w/2), h + 50, Color(0, 0, 0, 200))
			end
		
			if (text[3] == 1) then
				draw.SimpleText("Achievement unlocked!", "Deathrun_SmoothBig", x, y, color_white)
			else
				draw.SimpleText("XP Earned!", "Deathrun_SmoothBig", x, y, color_white)
			end
		
			draw.SimpleText(text[1], "Deathrun_SmoothBig", x + (w / 2), y + 30, color_white, TEXT_ALIGN_CENTER)
			draw.SimpleText(text[2], "Trebuchet24", x + (w / 2), y + 65, color_white, TEXT_ALIGN_CENTER)
		end
		
		if (x >= ScrW()) then
			table.remove(achievements.HUD.Data, 1)
		end
	end

	local ply = LocalPlayer()
	local ob = ply:GetObserverTarget()
	if ob and IsValid(ob) and ob:IsPlayer() and ob:Alive() then
		draw.AAText( ob:Nick(), "Deathrun_SmoothBig", ScrW()/2, 5, Color(255,255,255,255), TEXT_ALIGN_CENTER)
		ply = ob
		draw_keys = true
	else
		draw_keys = false
	end
	if not keys[ply] then
		keys[ply] = {}
	end
		
	if (LocalPlayer().PlayerData) then
		-- Level


		if (LocalPlayer():GetNWInt("timeplayed")) then
			local tr = util.GetPlayerTrace( LocalPlayer(), LocalPlayer():GetAimVector() )
			local trace = util.TraceLine( tr )	   

			if trace.Entity and trace.Entity:IsValid() and trace.Entity:IsPlayer() then
				if LocalPlayer():Alive() then
					draw.AAText(trace.Entity:Name().." time played: "..timeToStr(math.Round(trace.Entity:GetNWInt("timeplayed") + CurTime())), "Deathrun_Smooth", 17, 70, color_white, TEXT_ALIGN_LEFT)
				else
					draw.AAText(trace.Entity:Name().." time played: "..timeToStr(math.Round(trace.Entity:GetNWInt("timeplayed") + CurTime())), "Deathrun_Smooth", 17, 90, color_white, TEXT_ALIGN_LEFT)
				end
			end

			if (LocalPlayer():Alive()) then
				draw.AAText("Time played: "..timeToStr(math.Round(LocalPlayer():GetNWInt("timeplayed") + CurTime())), "Deathrun_Smooth", 17, 50, color_white, TEXT_ALIGN_LEFT)
			else
				draw.AAText("Time played: "..timeToStr(math.Round(LocalPlayer():GetNWInt("timeplayed") + CurTime())), "Deathrun_Smooth", 17, 50, color_white, TEXT_ALIGN_LEFT)
			end
		end
	end
	
	if draw_keys then
		local w, h = 60, 60
		local x, y = ScrW() - 135, ScrH() - 130

		local Keys = keys[ply] or {}

		-- top
		if Keys[IN_FORWARD] then
			surface.SetDrawColor(Color(200, 10, 10, 255))
		else
			surface.SetDrawColor(Color(255, 255, 255, 255))
		end
		
		surface.SetMaterial(keyup)
		surface.DrawTexturedRect(x, y, w, h)

		-- left
		if Keys[IN_MOVELEFT] then
			surface.SetDrawColor(Color(200, 10, 10, 255))
		else
			surface.SetDrawColor(Color(255, 255, 255, 255))
		end
		
		surface.SetMaterial(keyleft)
		surface.DrawTexturedRect(x - 60, y + 60, w, h)

		-- right
		if Keys[IN_MOVERIGHT] then
			surface.SetDrawColor(Color(200, 10, 10, 255))
		else
			surface.SetDrawColor(Color(255, 255, 255, 255))
		end
		
		surface.SetMaterial(keyleft)
		surface.DrawTexturedRectRotated(x + 90, y + 90, w, h, 180)
		
		-- and down we go
		if Keys[IN_BACK] then
			surface.SetDrawColor(Color(200, 10, 10, 255))
		else
			surface.SetDrawColor(Color(255, 255, 255, 255))
		end
		
		surface.SetMaterial(keyup)
		surface.DrawTexturedRectRotated(x + 30, y + 90, w, h, 180)
		
		if Keys[IN_JUMP] then
			surface.SetDrawColor(Color(200, 10, 10, 255))
		else
			surface.SetDrawColor(Color(255, 255, 255, 255))
		end
		
		surface.SetMaterial(keyjump)
		surface.DrawTexturedRect( x - 350, y + 65, 285, h - 10)
	end

	self.BaseClass:HUDPaint()
end

net.Receive( "_KeyPress", function()

	local ply = net.ReadEntity()
	if not IsValid(ply) then print( "Invalid keypress player." ) return end
	local num = net.ReadInt(16)

	if not keys[ply] then
		keys[ply] = {}
	end

	keys[ply][num] = true

end )

net.Receive( "_KeyRelease", function()

	local ply = net.ReadEntity()
	if not IsValid(ply) then print( "Invalid keyrelease player." ) return end
	local num = net.ReadInt(16)

	if not keys[ply] then
		keys[ply] = {}
	end

	keys[ply][num] = false

end )

local HUDHide = {
	
	["CHudHealth"] = true,
	["CHudSuitPower"] = true,
	["CHudBattery"] = true,
	--["CHudAmmo"] = true,
	--["CHudSecondaryAmmo"] = true,

}

function GM:HUDShouldDraw( No )
	if HUDHide[No] then return false end

	return true
end

CreateClientConVar( "deathrun_autojump", 1, true, false )

local bhstop = 0xFFFF - IN_JUMP
local band = bit.band

function GM:CreateMove( uc )
	if GetGlobalInt("dr_allow_autojump") != 1 then return end
	local lp = LocalPlayer()
	if GetConVarNumber( "deathrun_autojump" ) == 1 and lp:WaterLevel() < 3 and lp:Alive() and lp:GetMoveType() == MOVETYPE_WALK then
		if not lp:InVehicle() and ( band(uc:GetButtons(), IN_JUMP) ) > 0 then
			if lp:IsOnGround() then
				uc:SetButtons( uc:GetButtons() or IN_JUMP )
			else
				uc:SetButtons( band(uc:GetButtons(), bhstop) )
			end
		end
	end
end

-- Stupid bet
local rainbow = {}
rainbow[1] = Color(255, 0, 0, 255)
rainbow[2] = Color(255, 127, 0, 255)
rainbow[3] = Color(255, 255, 0, 255)
rainbow[4] = Color(0, 255, 0, 255)
rainbow[5] = Color(0, 0, 255, 255)
rainbow[6] = Color(75, 0, 130, 255)
rainbow[7] = Color(143, 0, 255, 255)

local i = 0
-- Make it random every mapchange
function GM:GetScoreboardNameColor( ply )
	
	if not IsValid(ply) then return Color( 255, 255, 255, 255 ) end
	-- Original deathrun creator, not AC :O
	if ply:SteamID() == "STEAM_0:1:38699491" then return Color( 60, 220, 60, 255 ) end -- Please don't change this.

	-- Sanne, stupid bet...
	if ply:SteamID() == "STEAM_0:0:86092282" or "STEAM_0:1:42754969" then
		i = i + 1

		if (i >= #rainbow) then
			i = 1
		end

		return rainbow[i]
	end

	-- Amy
	if ply:SteamID() == "" then return Color(0, 0, 255, 255) end
	-- AC
	if ply:SteamID() == "" then return Color(math.random(1, 255), math.random(1, 255), math.random(1, 255), 255) end
	-- Sherloch
	if ply:SteamID() == "" then return Color(255, 255, 0, 255) end
	-- Matt
	if ply:SteamID() == "" then return Color(127, 255, 0, 255) end
	-- Pixieee
	if ply:SteamID() == "" then return Color(0, 255, 0, 255) end
	-- Rodders
	if ply:SteamID() == "" then return Color(0, 0, 0) end
	-- Peanut
	if ply:SteamID() == "" then return Color(255, 0, 0) end
	
	if GetGlobalInt( "dr_highlight_admins" ) == 1 and ply:IsAdmin() then
		return Color(220, 180, 0, 255)
	end
end

function GM:GetScoreboardIcon( ply )
	if not IsValid(ply) then return false end
	if ply:SteamID() == "STEAM_0:1:38699491" then return "icon16/bug.png" end -- Please don't change this.
	if GetGlobalInt( "dr_highlight_admins" ) == 1 and ply:IsAdmin() then
		return "icon16/shield.png"
	end
end

local function GetIcon( str )

	if str == "1" then
		return "icon16/tick.png"
	end

	return "icon16/cross.png"

end

local function CreateNumButton( convar, fr, title, tooltip, posx, posy, Cvar, wantCvar )

	local btn = vgui.Create( "DButton", fr )
	btn:SetSize( fr:GetWide()/2 - 5, 25 )
	btn:SetPos( posx or 5, posy or fr:GetTall() - 30 )
	btn:SetText("")

	local icon = vgui.Create( "DImage", btn )
	icon:SetSize( 16, 16 )
	icon:SetPos( btn:GetWide() - 20, btn:GetTall()/2 - icon:GetTall()/2 )
	icon:SetImage( GetIcon( GetConVarString(convar) ) )

	btn.UpdateIcon = function()
		icon:SetImage( GetIcon( GetConVarString(convar) ) )
	end

	surface.SetFont( "Deathrun_Smooth" )
	local _, tH = surface.GetTextSize("|")

	local lv = nil

	local disabled = false

	btn.Paint = function(self, w, h)

		if Cvar and wantCvar then

			local c = GetGlobalInt( Cvar, 0 )

			if not lv then
				lv = c
				local change = c != wantCvar

				icon:SetImage( GetIcon( change and "0" or "1" ) )
				btn:SetDisabled( change )
				disabled = change
			elseif lv != c then
				lv = c
				local change = c != wantCvar

				icon:SetImage( GetIcon( change and "0" or "1" ) )
				btn:SetDisabled( change )
				disabled = change
			end  


		end

		surface.SetDrawColor( Color( 45, 55, 65, 200 ) )
		surface.DrawRect( 0, 0, w, h )

		draw.AAText( title..( disabled and " (Disallowed)" or "" ), "Deathrun_Smooth", 5, h/2 - tH/2, disabled and Color(200, 60, 60, 255) or Color(255,255,255,255) )

	end
	btn.DoClick = function()
		local cv = GetConVarString(convar)
		cv = cv == "1" and "0" or "1"
		RunConsoleCommand(convar, cv )
		icon:SetImage( GetIcon(cv) )		
	end

	if tooltip then
		btn:SetTooltip( tooltip )
	end

	return btn

end

function WrapText(text, width, font) -- Credit goes to BKU for this function!
	surface.SetFont(font)

	-- Any wrapping required?
	local w, _ = surface.GetTextSize(text)
	if w < width then
		return {text} -- Nope, but wrap in table for uniformity
	end
   
	local words = string.Explode(" ", text) -- No spaces means you're screwed

	local lines = {""}
	for i, wrd in pairs(words) do
		local l = #lines
		local added = lines[l] .. " " .. wrd
		if l == 0 then
			added = wrd
		end
		w, _ = surface.GetTextSize(added)

		if w > width then
			-- New line needed
			table.insert(lines, wrd)
		else
			-- Safe to tack it on
			lines[l] = added
		end
	end

	return lines
end

local function GetPlayerIcon( muted )

	if muted then
		return "icon16/sound_mute.png"
	end

	return "icon16/sound.png"

end

local function PlayerList()

	local fr = vgui.Create( "dFrame" )
	fr:SetSize( 400, 280 )
	fr:Center()
	fr:SetTitle("")
	fr:MakePopup()
	
	function fr:Think()
		if not (MainFrame:IsValid()) then
			fr:Remove()
		end
	end

	local dlist = vgui.Create( "DPanelList", fr )
	dlist:SetSize( fr:GetWide() - 10, fr:GetTall() - 85 )
	dlist:SetPos( 5, 75 )
	dlist:EnableVerticalScrollbar(true)
	dlist:SetSpacing(2)
	dlist.Padding = 2

	surface.SetFont( "Deathrun_Smooth" )
	local _, tH = surface.GetTextSize( "|" )

	local color = false
	for k, v in pairs( player.GetAll() ) do
		if v == LocalPlayer() then continue end
		color = not color
		v._ListColor = color

		local icon

		local ply = vgui.Create( "DButton" )
		ply:SetText( "" )
		ply:SetSize( 0, 20 )
		ply.DoClick = function()
			if not IsValid(v) then return end
			local muted = v:IsMuted()
			v:SetMuted(not muted)
			icon:SetImage( GetPlayerIcon(not muted) )
		end

		local moved = false
		ply.Paint = function( self, w, h )
			if not IsValid(v) then self:Remove() return end
			surface.SetDrawColor( v._ListColor and Color( 45, 55, 65, 200 ) or Color( 65, 75, 85, 200 ) )
			surface.DrawRect( 0, 0, w, h )
			draw.AAText( v:Nick(), "Deathrun_Smooth", 2 + 16 + 5, h/2 - tH/2, Color(255,255,255,255) )
			if not moved and w != 0 then
				icon:SetPos( ply:GetWide() - 20, ply:GetTall()/2 - icon:GetTall()/2 )
			end
		end

		local ava = vgui.Create( "AvatarImage", ply )
		ava:SetPlayer( v, 32 )
		ava:SetSize( 16, 16 )
		ava:SetPos( 2, 2 )

		icon = vgui.Create( "DImage", ply )
		icon:SetSize( 16, 16 )
		icon:SetPos( ply:GetWide() - 20, ply:GetTall()/2 - icon:GetTall()/2 )
		icon:SetImage( GetPlayerIcon( v:IsMuted() ) )

		dlist:AddItem(ply)
	end

	MainFrame:Register(fr)
end

local function ShowHelp()
	if (MainFrame) and (MainFrame:IsValid()) then
		MainFrame:Exit() 
		return
	end
	
	MainFrame = vgui.Create("deathrun_mainframe")
	
	-- buttons
	MainFrame:AddButton("Help", "icon16/page_white.png", function() MainFrame:RemoveActivePanel() CreateDeathrunHelp("Help", GAMEMODE.MenuText) end)
	MainFrame:AddButton("Rules", "icon16/book.png", function() MainFrame:RemoveActivePanel() CreateDeathrunHelp("Rules", GAMEMODE.RuleText) end)
	MainFrame:AddButton("About us", "icon16/exclamation.png", function() MainFrame:RemoveActivePanel() CreateDeathrunHelp("About us", GAMEMODE.AboutText) end)
	MainFrame:AddButton("Credits", "icon16/ruby.png", function() MainFrame:RemoveActivePanel() CreateDeathrunHelp("Credits", GAMEMODE.CreditsText) end)
	
	MainFrame:AddButton("Stats", "icon16/plugin.png", function() MainFrame:RemoveActivePanel()
		achievements.Stats = vgui.Create("DeathrunStats")
	
		achievements.Stats.NewThink = function()
			if not (MainFrame:IsValid()) then
				achievements.Stats:Remove()
			end
		end
	end)
	
	MainFrame:AddButton("Achievements", "icon16/award_star_gold_1.png", function() MainFrame:RemoveActivePanel() 
		achievements.Menu = vgui.Create("DeathrunAchievements")
		
		achievements.Menu.NewThink = function()
			if not (MainFrame:IsValid()) then
				achievements.Menu:Remove()
			end
		end
	end)

	MainFrame:AddButton("Perks", "icon16/rosette.png", function()
		MainFrame:RemoveActivePanel()

		local menu = CreateDeathrunHelp("Perks (Click to equip)")
		menu:SetSize(600, 375)
		menu:Center()
		local list = vgui.Create("DScrollPanel", menu)
		list:SetSize(menu:GetWide(), menu:GetTall() - 70)
		list:SetPos(5, 65)

		local perklist = vgui.Create("DIconLayout")
		perklist:SetSize(list:GetWide(), list:GetTall())
		perklist:SetPos(0,0)
		perklist:SetSpaceY(1)

		list:Add(perklist)

		local perks = {}
		for k,v in pairs(SortedItems) do
			perks[k] = vgui.Create("DButton")
			perks[k]:SetText("")
			perks[k]:SetSize(perklist:GetWide() - 10, 50)

			perks[k].Paint = function(self)
				if (LocalPlayer():GetNWString("perk") == v) then
					draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(177, 236, 141, 100))
				elseif (LocalPlayer().PlayerData["level"] >= XPM.GetItemData(v).level) then
					draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(150, 150, 150, 100))
				else
					draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(255, 51, 51, 100))
				end

				draw.SimpleText(XPM.GetItemData(v).name .. " (LvL "..XPM.GetItemData(v).level..")", "Deathrun_SmoothMed", 5,2, Color(230, 230, 230, 255), TEXT_ALIGN_LEFT)
				draw.SimpleText(XPM.GetItemData(v).desc, "Deathrun_Smooth", 5,30, Color(192, 192, 192, 255), TEXT_ALIGN_LEFT)
				--draw.SimpleText("Unlocks at level "..XPM.GetItemData(v).level, "Deathrun_Smooth", 5,35, Color(192, 192, 192, 255), TEXT_ALIGN_LEFT)
			end

			perks[k].DoClick = function()
				if (LocalPlayer():GetNWString("perk") == v) then return end
				if (LocalPlayer().PlayerData["level"] < XPM.GetItemData(v).level) then return end
				
				RunConsoleCommand("dr_selectperk", v)
			end

			perklist:Add(perks[k])
		end
		
		menu.Think = function()
			if not (MainFrame:IsValid()) then
				menu:Remove()
			end
		end
	end)

	MainFrame:AddButton("Mute players", "icon16/sound.png", function() MainFrame:RemoveActivePanel() PlayerList() end)
end

local function Notify( str )

	notification.AddLegacy( str, NOTIFY_GENERIC, 3 )
	surface.PlaySound( "ambient/water/drip"..math.random(1, 4)..".wav" )

end

local Deathrun_Funcs = {
	
	["F1"] = ShowHelp,
	["Notify"] = Notify

}

net.Receive( "Deathrun_Func", function()

	local func = net.ReadString()
	local args = net.ReadTable()

	if Deathrun_Funcs[func] then
		Deathrun_Funcs[func]( unpack(args) )
	end

end )

function GM:AddDeathrunFunc( name, func )
	Deathrun_Funcs[name] = func
end

function GM:HUDWeaponPickedUp( wep )

	if (!LocalPlayer():Alive()) then return end
	if not wep.GetPrintName then return end
		
	local pickup = {}
	pickup.time 		= CurTime()
	pickup.name 		=  wep:GetPrintName()
	pickup.holdtime 	= 5
	pickup.font 		= "Deathrun_Smooth"
	pickup.fadein		= 0.04
	pickup.fadeout		= 0.3
	pickup.color		= team.GetColor( LocalPlayer():Team() )
	
	surface.SetFont( pickup.font )
	local w, h = surface.GetTextSize( pickup.name )
	pickup.height		= h
	pickup.width		= w

	if (self.PickupHistoryLast >= pickup.time) then
		pickup.time = self.PickupHistoryLast + 0.05
	end
	
	table.insert( self.PickupHistory, pickup )
	self.PickupHistoryLast = pickup.time 

end

function GM:OnSpawnMenuOpen()
	RunConsoleCommand( "_dr_req_drop" )	
end

local connecting = {}
function GM:GetConnectingPlayers()
	return connecting
end

GM:AddDeathrunFunc( "Connecting_Player", function( name, id )

	connecting[id] = name

end )

GM:AddDeathrunFunc( "Remove_CPlayer", function( id )

	connecting[id] = nil

end )

GM:AddDeathrunFunc( "All_Connecting", function( tab )

	connecting = tab

end )