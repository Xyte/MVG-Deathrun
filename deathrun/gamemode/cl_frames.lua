if SERVER then return end

local PANEL = {}

function PANEL:Init()
	self:ShowCloseButton(false)
end

function PANEL:Paint( w, h )

	draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), Color(44, 44, 44, 255))
	draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), Color(44, 44, 44, 240))
	
	draw.RoundedBox(4, 1, 1, self:GetWide() - 2, self:GetTall() - 2, Color(0, 0, 0, 255))
	
	-- top
	draw.RoundedBox(4, 3, 40, self:GetWide() - 6, self:GetTall() - 43, Color(25, 25, 25, 255))
	draw.RoundedBoxEx(4, 3, 3, self:GetWide() - 6, 40, Color(44, 44, 44, 240), true, true, false, false)
	
	draw.SimpleText("Player list", "Deathrun_SmoothBig", 10, 2.5, color_white, TEXT_ALIGN_LEFT)
	
	-- orange
	draw.RoundedBox(0, 3, 40, self:GetWide() - 6, 25, Color(32, 32, 75, 220))

end

vgui.Register( "dFrame", PANEL, "DFrame" )