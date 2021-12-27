local PANEL = {}

-- Initialize
function PANEL:Init()
	self:SetWide(700)
	self:SetTall(225)
	
	self:SetPos((ScrW() / 2) - (self:GetWide() / 2), (ScrH() / 2) - (self:GetTall() / 2))
	
	gui.EnableScreenClicker(true)
	
	self.Scroll = vgui.Create("DScrollPanel", self)
	self.Scroll:SetSize(self:GetWide() - 6, self:GetTall() - 68)
	self.Scroll:SetPos(3, 65)
	
	self.XPLabel = vgui.Create("DLabel", self)
	self.XPLabel:SetPos(10, 5)
	self.XPLabel:SetFont("Deathrun_SmoothMed")
	self.XPLabel:SetText("Total XP")
	self.XPLabel:SizeToContents()
	
	self.XP = vgui.Create("DeathrunProgress", self)
	self.XP:SetPos(10, 30)
	self.XP:SetWide(self.Scroll:GetWide() - 20)
	self.XP:SetProgress(LocalPlayer().PlayerData["xp"], XPM.levels[200].xp)
	
	self.LevelLabel = vgui.Create("DLabel", self)
	self.LevelLabel:SetPos(10, 50)
	self.LevelLabel:SetFont("Deathrun_SmoothMed")
	self.LevelLabel:SetText("LvL")
	self.LevelLabel:SizeToContents()
	
	self.Level = vgui.Create("DeathrunProgress", self)
	self.Level:SetPos(10, 75)
	self.Level:SetWide(self.Scroll:GetWide() - 20)
	self.Level:SetProgress(LocalPlayer().PlayerData["level"], 200)
	
	if not (LocalPlayer().PlayerData["level"] >= 200) then
		self.NextLevelLabel = vgui.Create("DLabel", self)
		self.NextLevelLabel:SetPos(10, 100)
		self.NextLevelLabel:SetText("XP untill next level")
		self.NextLevelLabel:SetFont("Deathrun_SmoothMed")
		self.NextLevelLabel:SizeToContents()
		
		self.NextLevel = vgui.Create("DeathrunProgress", self)
		self.NextLevel:SetPos(10, 125)
		self.NextLevel:SetWide(self.Scroll:GetWide() - 20)
		self.NextLevel:SetProgress(LocalPlayer().PlayerData["xp"], XPM.levels[LocalPlayer().PlayerData["level"]+1].xp)
	end
	
	self.Scroll:Add(self.XPLabel)
	self.Scroll:Add(self.XP)
	self.Scroll:Add(self.LevelLabel)
	self.Scroll:Add(self.Level)
	self.Scroll:Add(self.NextLevelLabel)
	self.Scroll:Add(self.NextLevel)
end

function PANEL:NewThink()
end

function PANEL:Think()
	if not (MainFrame) and not (MainFrame:IsValid()) then
		self:Remove()
	end
	
	self:NewThink()
end

-- Paint
function PANEL:Paint()
	-- background
	draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), Color(44, 44, 44, 255))
	draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), Color(44, 44, 44, 240))
	
	draw.RoundedBox(4, 1, 1, self:GetWide() - 2, self:GetTall() - 2, Color(192, 192, 192, 255))
	
	-- top
	draw.RoundedBox(4, 3, 40, self:GetWide() - 6, self:GetTall() - 43, Color(44, 44, 44, 255))
	draw.RoundedBoxEx(4, 3, 3, self:GetWide() - 6, 40, Color(44, 44, 44, 240), true, true, false, false)
	
	draw.SimpleText("Stats", "Deathrun_SmoothBig", 10, 2.5, color_white, TEXT_ALIGN_LEFT)
	
	-- orange
	draw.RoundedBox(0, 3, 40, self:GetWide() - 6, 25, Color(231, 138, 37, 150))
end

-- Register
vgui.Register("DeathrunStats", PANEL, "EditablePanel")