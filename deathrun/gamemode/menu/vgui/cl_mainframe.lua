local PANEL = {}

-- materials
local moneyicon = Material("icon16/star.png")
local rankicon = Material("icon16/shield.png")

-- Initialize
function PANEL:Init()
	-- vars
	self.CanBeRemoved = false
	self.Childeren = {}
	self.Buttons = {}
	
	-- Size
	self:SetWide(300)
	self:SetTall(ScrH())
	
	-- Pos
	self:SetPos(-300, 0)
	
	-- Animate
	self:MoveTo(0, 0, 0.5, 0)
	
	-- Avatar
	self.Avatar = vgui.Create("AvatarImage", self)
	self.Avatar:SetSize(64, 64)
	self.Avatar:SetPlayer(LocalPlayer(), 64)
	self.Avatar:SetPos((self:GetWide() / 2) - (64 / 2) - 85, 16)
	
	-- color
	self.bgColor = Color(32, 32, 32, 220)
	
	self.Close = vgui.Create("DButton", self)
	self.Close:SetPos(0, self:GetTall() - 50)
	self.Close:SetSize(self:GetTall(), 50)
	self.Close:SetText("")
	
	self.Close.DoClick = function()
		self:Exit()
	end
	
	self.Close.OnCursorEntered = function()
		self.bgColor = Color(32, 124, 150, 220)
	end
	
	self.Close.OnCursorExited = function()
		self.bgColor = Color(32, 32, 32, 220)
	end
	
	self.Close.Paint = function()
		draw.LinearGradient(-1, 0, self.Close:GetWide(), 4, Color(17,17,17,255), Color(0, 0, 0, 200), GRADIENT_HORIZONTAL)
		
		surface.SetDrawColor(self.bgColor)
		surface.DrawRect(0, 4, self.Close:GetWide(), self.Close:GetTall())
		
		draw.RoundedBoxEx(6, 5, 10, 290, self.Close:GetTall() - 15, Color(128, 128, 128, 20), false, false, true, true)
		
		surface.SetFont("Deathrun_SmoothMed")
		local w, h = surface.GetTextSize("X")
		
		draw.SimpleText("X", "Deathrun_SmoothMed", 150 - (w / 2), (self.Close:GetTall() / 2) + 1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	-- mouse
	gui.EnableScreenClicker(true)
end

-- Register
function PANEL:Register(panel)
	self.CurrentPanel = panel
end

-- Remove a panel
function PANEL:RemoveActivePanel()
	if (achievements.Menu) and (achievements.Menu:IsValid()) then
		achievements.Menu:Remove()
	end
	
	if (achievements.Stats) and (achievements.Stats:IsValid()) then
		achievements.Stats:Remove()
	end	
	
	if (self.CurrentPanel) and (self.CurrentPanel:IsValid()) then
		self.CurrentPanel:Remove()
	end
end

-- Exit
function PANEL:Exit()
	-- Animate
	self:MoveTo(-300, 0, 0.5, 0)
	
	-- Set var
	self.CanBeRemoved = true
	
	-- mouse
	gui.EnableScreenClicker(false)
end

function PANEL:AddButton(text, icon, func)
	local i = #self.Buttons
	
	self.Buttons[i+1] = vgui.Create("deathrun_button", self)
	self.Buttons[i+1]:SetSize(self:GetWide(), 50)
		
	self.Buttons[i+1]:SetPos(0, 100 + (i * 45))
		
	self.Buttons[i+1]:SetIcon(icon)
	self.Buttons[i+1]:SetText(text)
	self.Buttons[i+1].DoClick = func
		
	table.insert(self.Childeren, self.Buttons[i+1])
end

function PANEL:Think()
	local x, y = self:GetPos()
	
	if (x == -300) and (self.CanBeRemoved) then
		self:Remove()
	end
end

-- Paint
function PANEL:Paint()
	-- Blur
	--Derma_DrawBackgroundBlur(self, 0)
	
	-- colors
	surface.SetDrawColor(Color(0, 0, 0, 200))
	surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
	
	surface.SetDrawColor(Color(32, 32, 32, 220))
	surface.DrawRect(0, 0, self:GetWide(), 100)
	
	draw.RoundedBoxEx(6, 5, 5, self:GetWide() - 10, 90, Color(128, 128, 128, 20), true, true, false, false)
	
	-- Get the pos of the avatar image
	local x, y = self.Avatar:GetPos()
	
	draw.SimpleText(LocalPlayer():Name(), "Deathrun_Smooth", (x + 64) + 5, y, color_white, TEXT_ALIGN_LEFT)
	draw.SimpleText(LocalPlayer():SteamID(), "Deathrun_Smooth", (x + 64) + 5, y + 15, color_white, TEXT_ALIGN_LEFT)
	
	surface.SetFont("Deathrun_Smooth")
	local w, h = surface.GetTextSize(LocalPlayer():SteamID())
	
	surface.SetDrawColor(Color(255, 255, 255, 255))
	surface.SetMaterial(moneyicon)
	surface.DrawTexturedRect(x + 64 + 5 + w - 16, y + 30, 16, 16)
	
	surface.SetMaterial(rankicon)
	surface.DrawTexturedRect(x + 64 + 5 + w - 16, y + 45, 16, 16)
	
	draw.SimpleText("LvL "..(LocalPlayer().PlayerData["level"] or 0), "Deathrun_Smooth", (x + 64) + 5, y + 30, color_white, TEXT_ALIGN_LEFT)
	draw.SimpleText(LocalPlayer():IsAdmin() and "Admin" or "Guest", "Deathrun_Smooth", (x + 64) + 5, y + 45, color_white, TEXT_ALIGN_LEFT)
	
	draw.LinearGradient(0, 99, self:GetWide(), 4, Color(17,17,17,255), Color(0, 0, 0, 200), GRADIENT_VERTICAL)
	draw.LinearGradient(298, 0, 2, self:GetTall(), Color(17,17,17,255), Color(0, 0, 0, 200), GRADIENT_HORIZONTAL)
end

vgui.Register("deathrun_mainframe", PANEL, "EditablePanel")