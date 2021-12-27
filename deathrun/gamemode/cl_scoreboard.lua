--[[
		Scoreboard

		Please do not modifiy any code below.

		Credits:
		AC² - Main code
		BlackVoid - Help with vgui.RegisterTable and his deathrun scoreboard
		The internet - Images
--]]


-- Safe
if (gScoreboard) then
	gScoreboard:Remove()
end

-- Cache materials we will use.
local bg = Material("materials/background/Flaming_Crystal_Scoreboard.png", "smooth alphatest")
local adminicon = Material("icon16/shield.png")
local usericon = Material("icon16/user.png")

-- How to sort teams
local SortedTeams = {
	[3] = 1000,
	[2] = 0,
	[1] = 2000,
}

-- Background effects for certain players
local pBackgrounds = {}
pBackgrounds["STEAM_0:0:86092282"] = Material("", "smooth")

--[[
	Create a table that will hold all our functions for a player line in the scorebaord
--]]

local textpos = 150

local PLAYER_LINE_PRE = {
	-- Initialize
	Init = function(self, pl)
	
		self.pPlayer = pl
		
		-- Default
		self:SetWide(800)
		self:SetTall(35)
		
		self.AvatarButton = self:Add( "DButton" )
		self.AvatarButton:SetPos(1, 0)
		self.AvatarButton:SetSize(34, 34)
		self.AvatarButton.DoClick = function() self.pPlayer:ShowProfile() gScoreboard:Hide() end

		-- Avatar
		self.pAvatar = self:Add("AvatarImage")
		self.pAvatar:SetPos(1, 0)
		self.pAvatar:SetSize(34, 34)
		self.pAvatar:SetMouseInputEnabled( false )

		-- Name
		self.pName = self:Add("DLabel")
		self.pName:SetFont("Deathrun_Smooth")
		self.pName:SetPos(40, 9)

		-- Level
	end,

	-- Define player, update labels, etc
	Setup = function(self, pl)
		-- Cache
		self.pPlayer = pl

		-- Avatar
		self.pAvatar:SetPlayer(pl)
		self.AvatarButton:SetPlayer(pl)
		-- Name
		self.pName:SetText(pl:Nick())
		self.pName:SizeToContents()
		-- Update
		self:Think(self)
	end,

	-- Update thigns
	Think = function(self)
		-- Valid
		if not (IsValid(self.pPlayer)) then
			self:Remove()
			return
		end

		local team = self.pPlayer:Team()

		if not (self.pPlayer:Alive()) then
			team = 1
		end

		-- Sort alive
		self:SetZPos(SortedTeams[team] or 2000)
	end,

	-- Draw etc
	Paint = function(self, w, h)
		-- Valid 
		if not (IsValid(self.pPlayer)) then
			return
		end

		-- Team color
		if (self.pPlayer:Team() == TEAM_DEATH) and (self.pPlayer:Alive()) then
			surface.SetDrawColor(Color(149, 14, 14, 155))
		elseif (self.pPlayer:Team() == TEAM_RUNNER) and (self.pPlayer:Alive()) then
			surface.SetDrawColor(Color(50, 50, 160, 200))
		else
			surface.SetDrawColor(Color(160, 160, 160, 233))
		end

		-- Background
		surface.DrawRect(0,0, self:GetWide(), self:GetTall())

		-- Border
		surface.SetDrawColor(Color(17, 17, 17, 255))
		surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())

                -- Special kinds of backgrounds
		if (pBackgrounds[self.pPlayer:SteamID()]) then
			surface.SetDrawColor(Color(255, 255, 255, 100))
			surface.SetMaterial(pBackgrounds[self.pPlayer:SteamID()])
			surface.DrawTexturedRect(0, 0, w, h)
		end

		-- Reset draw color
		surface.SetDrawColor(Color(255, 255, 255, 255))

		-- Icon
		if (self.pPlayer:IsAdmin()) then
			surface.SetMaterial(adminicon)
		else
			surface.SetMaterial(usericon)
		end
		-- User/Admin icon
		surface.DrawTexturedRect(self:GetWide() - 66, 8, 16, 16)

		-- Background behind 'ping'
		draw.RoundedBox(0, self:GetWide() - 40, 0, 30, self:GetTall(), Color(0, 0, 0, 100))

		-- Ping
		draw.SimpleText(self.pPlayer:Ping(), "Deathrun_Smooth", self:GetWide() - 25, 9, color_white, TEXT_ALIGN_CENTER)
	end
}

-- Register
PLAYER_LINE = vgui.RegisterTable(PLAYER_LINE_PRE, "DPanel")

--[[
	Basiclly, the scoreboard itself, holds players and header
--]]
SCOREBOARD = {
	-- Initialize
	Init = function(self)
		-- Size
		self:SetWide(800)
		self:SetTall(567)

		-- Center
		self:Center()

		-- Scrollbar
		self.ScrollList = self:Add("DScrollPanel")
		self.ScrollList:SetSize(self:GetWide() - 2, self:GetTall() - textpos + 15)
		self.ScrollList:SetPos(1, textpos + 15)

		self.pPlayerList = self.ScrollList:Add("DIconLayout")
		self.pPlayerList:SetWide(self.ScrollList:GetWide())
	end,

	PerformLayout = function(self)
		-- Recalculate height
		self:SetTall(textpos + 15 + (#player.GetAll() * 35))

		-- Maximume
		if (self:GetTall() >= 600) then
			self:SetTall(600)
		end

		-- Center
		self:Center()
	end,

	-- Think
	Think = function(self)
		-- Cache
		local players = player.GetAll()
		
		-- Loop through all the players and create a line if non exists
		for k, v in pairs(players) do
			if (v.pPlayerLine and v.pPlayerLine:IsValid()) then
				v.pPlayerLine:Setup(v)

				-- Scrollbar
				if (self:GetTall() >= 600) then
			 		v.pPlayerLine:SetWide(800 - 16)
				end
			end

			-- New line
			if not (v.pPlayerLine and v.pPlayerLine:IsValid()) then
				if (v:IsValid()) then 
					-- Create a new line for a NEW player
					v.pPlayerLine = vgui.CreateFromTable(PLAYER_LINE)
					v.pPlayerLine:Setup(v)
					v.pPlayerLine:SetWide(self.pPlayerList:GetWide())

					-- AddItem != Add
					self.pPlayerList:Add(v.pPlayerLine)
				end
			end
		end

		-- Sorts everything, hope this doesn't destroy and re-create
		self.pPlayerList:Layout()
	end,

	-- Draw etc
	Paint = function(self, w, h)
		-- Main frame
		draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(30, 30, 30, 255))

		-- Header
		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.SetMaterial(bg)
		surface.DrawTexturedRect(2, 2, self:GetWide() - 4, 170 * self:GetWide() / 940)

		-- Header text and such
		draw.SimpleText("Name", "HudHintTextSmall", 40, textpos, color_white, TEXT_ALIGN_LEFT)

		if (h >= 600) then
			draw.SimpleText("Rank", "HudHintTextSmall", self:GetWide() - 50 - 16, textpos, color_white, TEXT_ALIGN_RIGHT)
			draw.SimpleText("Ping", "HudHintTextSmall", self:GetWide() - 20 - 16, textpos, color_white, TEXT_ALIGN_RIGHT)
		else
			draw.SimpleText("Rank", "HudHintTextSmall", self:GetWide() - 50, textpos, color_white, TEXT_ALIGN_RIGHT)
			draw.SimpleText("Ping", "HudHintTextSmall", self:GetWide() - 20, textpos, color_white, TEXT_ALIGN_RIGHT)
		end
	end,
}

-- Register
SCOREBOARD = vgui.RegisterTable(SCOREBOARD, "EditablePanel")

-- Called when pressing tab
function GM:ScoreboardShow()
	if not (IsValid(gScoreboard)) then
		gScoreboard = vgui.CreateFromTable(SCOREBOARD)
	end

	if (IsValid( gScoreboard)) then
		gScoreboard:Show()
		gScoreboard:MakePopup()
		gScoreboard:SetKeyboardInputEnabled(false)
	end
end

-- Called when stopped pressing tab
function GM:ScoreboardHide()
	if (IsValid(gScoreboard)) then
		gScoreboard:Hide()
	end
end

-- No idea
function GM:HUDDrawScoreBoard()
end