local PANEL = {}

-- Initialize
function PANEL:Init()
	-- color
	self.bgColor = Color(32, 32, 32, 220)
end

function PANEL:OnCursorEntered()
	self.bgColor = Color(32, 124, 150, 220)
end
	
function PANEL:OnCursorExited()
	self.bgColor = Color(32, 32, 32, 220)
end

function PANEL:SetIcon(icon)
	self.Icon = Material(icon)
end

function PANEL:Paint()	
	surface.SetDrawColor(self.bgColor)
	surface.DrawRect(0, 4, self:GetWide(), self:GetTall() - 4)
		
	surface.SetFont("Deathrun_SmoothMed")
	local w, h = surface.GetTextSize(self:GetText())
	
	if (self.Icon) then
		surface.SetDrawColor(Color(255,255,255,255))
		surface.SetMaterial(self.Icon)
		surface.DrawTexturedRect(10, (self:GetTall() / 2) - 6, 16, 16)
	end
		
	draw.SimpleText(self:GetText(), "Deathrun_SmoothMed", 10 + 16 + 10, (self:GetTall() / 2) + 1, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	
	draw.LinearGradient(0, 48, self:GetWide(), 4, Color(17,17,17,255), Color(0, 0, 0, 200), GRADIENT_VERTICAL)	
	return true
end


vgui.Register( "deathrun_button", PANEL, "Button")