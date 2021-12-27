local PANEL = {}

-- Initialize
function PANEL:Init()
	self:SetTall(20)
	
	self.BarSize = 0
	self.Text = "#Not defined"
	self.ProgressData = {}
end

-- Set text
function PANEL:SetText(txt)
	self.Text = txt
end

-- Set progress
function PANEL:SetProgress(number, max)
	local width = self:GetWide()
	
	self.BarSize = (width / max) * number
	self.ProgressData = {number = number, max = max}
end

-- PAINT
function PANEL:Paint()
	surface.SetDrawColor(Color(62, 62, 62, 230))
	surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
	
	surface.SetDrawColor(Color(32, 124, 150, 220))
	surface.DrawRect(0, 0, self.BarSize, self:GetTall())
	
	surface.SetDrawColor(Color(32, 32, 32, 230))
	surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
	
	draw.SimpleText(self.ProgressData["number"].. "/" .. self.ProgressData["max"], "Deathrun_Smooth", self:GetWide() / 2, self:GetTall() / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

vgui.Register("DeathrunProgress", PANEL, "EditablePanel")