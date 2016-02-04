-- Birthday.lua

-- Bitch is fine, see you walking by. 

-- High heels on a pretty feet.

-- Hello? It's me

-- Too many song lyrics not going to lie

-- Store everything in a table

local birthday = {}



-- Material

birthday.image_happybd = Material("actrololo/happybd.png", "smooth")

birthday.image_cake = Material("actrololo/birthday_cake.png", "smooth")

birthday.image_balloon = Material("actrololo/birthday_balloon.png", "smooth")



-- Convar

birthday.showcvar = CreateClientConVar("birthday_togglecard", "1", true, false)



-- Who's birthday is it?

birthday.name = "ClockWorkDragon"

birthday.steamid = "STEAM_0:1:42754969"



-- Fonts

surface.CreateFont("balloons_big", {font = "PARTYBALLOONS", size = ScreenScale(100), antialias = true})

surface.CreateFont("balloons", {font = "Arial", size = ScreenScale(40), weigth = 500, blursize = .5, antialias = true})



-- Local vars

local _explodedname = string.Explode("", birthday.name)

local _colors = {}

local _lastchange = 0

local _col = Color(72,209,204, 255)



if birthday.steamid == "" then return end



-- Changes the color of the letters

local function GenerateRandomColors()

	-- Reset

	_colors = {}



	-- Make new colors

	for k, v in pairs(_explodedname) do

		_colors[k] = Color(math.random(1, 255), math.random(1, 255), math.random(1, 255))

	end

end



-- Panel

function birthday.ShowCard()

	-- DFrame, easy

	local panel = vgui.Create("DFrame")

	-- Setup default things

	panel:SetSize(801, 601)

	panel:Center()

	panel:SetTitle("")

	panel:ShowCloseButton(true) -- Only enabled for development purpose

	panel:MakePopup()





	-- Override paint, draw card and text

	panel.Paint = function()

		-- Black border

		draw.RoundedBox(0, 0, 0, 800, 600, Color(0, 0, 0, 200))



		-- Card itself

		surface.SetDrawColor(color_white)

		surface.SetMaterial(birthday.image_happybd)

		surface.DrawTexturedRect(1, 1, 798, 598)



		-- Background

		draw.RoundedBox(0, 0, (panel:GetTall() / 2) - 25, panel:GetWide(), 105, Color(0, 0, 0, 200))

		draw.RoundedBox(0, 0, (panel:GetTall() / 2) + 125, panel:GetWide() - 2, (panel:GetTall() - (panel:GetTall() / 2) + 125) - 2, Color(0, 0, 0, 200))



		-- All letters

		for k, v in pairs(_explodedname) do

			-- Draw them

			draw.SimpleText(v, "balloons_big", 185 + (k * 75), (panel:GetTall() / 2) + 50, _colors[k], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)



			-- Change colors every x seconds

			if (CurTime() > _lastchange) then

				-- Change colors

				GenerateRandomColors()



				-- Update timer

				_lastchange = CurTime() + 1

			end

		end



		-- Other text

		for i = 1, #_colors do

			_col = _colors[i]

		end



		draw.SimpleText("MVG wishes you a", "balloons", (panel:GetWide() / 2), (panel:GetTall() - 125), _col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		draw.SimpleText("happy birthday!", "balloons", (panel:GetWide()  / 2), (panel:GetTall() - 50), _col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	end



	panel.OnClose = function()

		RunConsoleCommand("birthday_togglecard", "0")

		debugprint( "file: Birthday, line: 96" )

	end

end



-- Hooks

hook.Add("Think", "Birthdays_Think", function()

	if (LocalPlayer():IsValid()) then

		if (LocalPlayer():SteamID() == birthday.steamid) then

			if (birthday.showcvar:GetString() == "1") then

				birthday.ShowCard()

			end

		end



		-- Remove anyway

		hook.Remove("Think", "Birthdays_Think")

	end

end)



local _balloons = {}

local _ballooncolors = {Color(255, 255, 255), Color(0, 255, 255), Color(0, 255, 0), Color(255, 0, 255), Color(255, 255, 0), Color(0, 0, 255)}





for i = 1, 10 do

	_balloons[i] = {x = math.random(-128, 128), y = 100, speed = math.Rand(0.015, 0.085), alpha = 255, col = table.Random(_ballooncolors)}

end



hook.Add("PostPlayerDraw", "Birthday_DrawPlayer", function(ply)

	for i,j in pairs(player.GetAll()) do

		if (j:SteamID() == birthday.steamid) and (j:Alive()) then

			if not (j == LocalPlayer()) then 

				local ang = ply:EyeAngles()

				local pos = j:GetPos() + Vector(0, 0, 100)

			 

				ang:RotateAroundAxis( ang:Forward(), 90 )

				ang:RotateAroundAxis( ang:Right(), 90 )



				cam.Start3D2D(pos, Angle( 0, ang.y, 90 ), 0.25 )

					surface.SetDrawColor(color_white)

					surface.SetMaterial(birthday.image_cake)

					surface.DrawTexturedRect(-64, 0, 128, 128)



					for k, v in pairs(_balloons) do

						v.col.a = v.alpha

						surface.SetDrawColor(v.col)

						surface.SetMaterial(birthday.image_balloon)



						v.y = v.y - v.speed



						--print(v.y)



						if (v.y <= -125) then

							v.alpha = v.alpha - .1

						end



						if (v.alpha <= 0) then

							v.alpha = 255

							v.y = 100

							v.speed = math.Rand(0.015, 0.085)

							v.col = table.Random(_ballooncolors)

						end



						surface.DrawTexturedRect(v.x, v.y, 32, 32)

					end

				cam.End3D2D()

			end

		end

	end

end)



-- Consolecommand

concommand.Add("birthday_showcard", birthday.ShowCard)

