local PANEL = {}
local categories = {"Level", "Death", "Win", "Damage", "Kill", "Time", "Misc"}

local function GetAchievementFromID(id)
	for k, v in pairs(Sortedlist) do
		if (k == id) then
			return v
		end
	end
	
	return {}
end

-- Initialize
function PANEL:Init()
	self:SetWide(700)
	self:SetTall(550)
	
	self:SetPos((ScrW() / 2) - (self:GetWide() / 2), (ScrH() / 2) - (self:GetTall() / 2))
	
	/*
	self.Close = vgui.Create("DButton", self)
	self.Close:SetPos(self:GetWide() - 35, 9)
	self.Close:SetSize(25, 25)
	self.Close:SetText("")
	
	self.Close.Paint = function(self)
		draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), Color(192, 192, 192, 230))
		
		draw.RoundedBox(4, 1, 1, self:GetWide() - 2, self:GetTall() - 2 ,Color(44, 44, 44, 255))
		
		draw.SimpleText("X", "Deathrun_Smooth", self:GetWide() / 2, self:GetTall() / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	self.Close.DoClick = function()
		self:Remove()
		gui.EnableScreenClicker(false)
	end
	*/
	
	gui.EnableScreenClicker(true)
	
	self.Scroll = vgui.Create("DScrollPanel", self)
	self.Scroll:SetSize(self:GetWide() - 6, self:GetTall() - 68)
	self.Scroll:SetPos(3, 65)
	
	self.Panel = vgui.Create("DIconLayout", self.Scroll)
	self.Panel:SetSize(self.Scroll:GetWide(), self.Scroll:GetTall())
	self.Panel:SetPos(0, 0)
	self.Panel:SetSpaceX(0)
	self.Panel:SetSpaceY(0)
	
	local function CreateTab(str)
	self.Panel:Clear()
	local i = 0
	
	for j, p in pairs(Sortedlist) do
	local k = Sortedlist[j]
	local v = XPM.list[k]
		if (string.find(k, str)) then
			local b = vgui.Create("DButton")
			b:SetSize(self.Panel:GetWide(), 50)
			b:SetText("")
			b:SetToolTip(table.HasValue(LocalPlayer().PlayerData["achievements"], k) and "This achievement is unlocked" or "This achievement is locked")
			
			local unlocked = Material("icon16/tick.png")
			local locked = Material("icon16/cross.png")
				
			b.Paint = function(self)
				if (table.HasValue(LocalPlayer().PlayerData["achievements"], k)) then
					draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(177, 236, 141, 255))
				else
					draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(238, 238, 238, 255))
				end
				
				surface.SetDrawColor(Color(255, 255, 255, 255))
				surface.SetMaterial(table.HasValue(LocalPlayer().PlayerData["achievements"], k) and unlocked or locked)
				surface.DrawTexturedRect(self.Panel:GetWide() - 40, (self.Panel:GetTall() / 2) - 8, 16, 16)
					
				draw.SimpleText(v.name, "Deathrun_SmoothMed", 5, 2, Color(192, 192, 192, 255), TEXT_ALIGN_LEFT)
				draw.SimpleText(v.desc, "Deathrun_Smooth", 5, self.Panel:GetTall() - 20, Color(192, 192, 192, 255), TEXT_ALIGN_LEFT)
					
				draw.LinearGradient(0, 48, self:GetWide(), 4, Color(17,17,17,255), Color(0, 0, 0, 200), GRADIENT_VERTICAL)	
			end
				
				self.Panel:Add(b)
				
				i = i + 1
				
				if (i <= 11) then
					self:SetTall(68 + (i * 50))
				else
					self:SetTall(550)
				end
				
				self.Scroll:SetSize(self:GetWide() - 6, self:GetTall() - 68)
				self.Panel:SetSize(self.Scroll:GetWide(), self.Scroll:GetTall())
				self:Center()
			end
		end
	end
	
	CreateTab("achv_level")
	
	local buttons = {}
	for k, v in pairs(categories) do
		buttons[k] = vgui.Create("DButton", self)
		buttons[k]:SetSize(75, 30)
		
		if (k > 1) then
			local x, y = buttons[k-1]:GetPos()
			buttons[k]:SetPos(x + 80, y)
		else
			buttons[k]:SetPos(5, 35)
		end
		
		buttons[k]:SetText("")
		
		buttons[k].DoClick = function()
			local txt = v
			
			CreateTab(string.lower(txt))
		end
		
		buttons[k].Paint = function(self)
			draw.RoundedBox(0, 0, 10, self:GetWide(), self:GetTall(), Color(0, 0, 0, 200))
			surface.SetFont("Deathrun_Smooth")
			local w, h = surface.GetTextSize(v)
			
			draw.SimpleText(v, "Deathrun_Smooth", (self:GetWide() / 2) - (w / 2), (self:GetTall() / 2) - (h / 2) + 5, color_white)
		end
	end
	
	self.Panel.Paint = function(self)
		surface.SetDrawColor(0, 0, 0, 200)
		surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
	end
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
	
	draw.SimpleText("Achievements", "Deathrun_SmoothBig", 10, 2.5, color_white, TEXT_ALIGN_LEFT)
	
	local total = math.Round((#LocalPlayer().PlayerData["achievements"]/ 100) * table.Count(XPM.list) ) or 0
	draw.SimpleText(total.."%", "Deathrun_SmoothBig", self:GetWide() - 10, 2.5, color_white, TEXT_ALIGN_RIGHT)
	
	-- orange
	draw.RoundedBox(0, 3, 40, self:GetWide() - 6, 25, Color(231, 138, 37, 150))
end

-- Register
vgui.Register("DeathrunAchievements", PANEL, "EditablePanel")