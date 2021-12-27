
local PANEL = {}
local queue = {}

net.Receive("jukebox.queue", function()
	queue = net.ReadTable()
	
	for k, v in pairs(queue) do
		queue[k] = {name = v}
	end
end)

-- Initialize
function PANEL:Init()
	self:SetWide(600)
	self:SetTall(500)
	
	self:SetPos((ScrW() / 2) - (self:GetWide() / 2), (ScrH() / 2) - (self:GetTall() / 2))
	
	self.List = vgui.Create("DButton", self)
	self.List:SetSize(75, 30)
	self.List:SetPos(5, 35)
	self.List:SetText("")
	
	self.List.Paint = function(self)
		draw.RoundedBox(0, 0, 10, self:GetWide(), self:GetTall(), Color(0, 0, 0, 200))
		surface.SetFont("Deathrun_Smooth")
		local w, h = surface.GetTextSize("Songs")
			
		draw.SimpleText("Songs", "Deathrun_Smooth", (self:GetWide() / 2) - (w / 2), (self:GetTall() / 2) - (h / 2) + 5, color_white)
	end
	
	self.Options = vgui.Create("DButton", self)
	self.Options:SetSize(75, 30)
	self.Options:SetPos(85, 35)
	self.Options:SetText("")
	
	self.Options.Paint = function(self)
		draw.RoundedBox(0, 0, 10, self:GetWide(), self:GetTall(), Color(0, 0, 0, 200))
		surface.SetFont("Deathrun_Smooth")
		local w, h = surface.GetTextSize("Queue")
			
		draw.SimpleText("Queue", "Deathrun_Smooth", (self:GetWide() / 2) - (w / 2), (self:GetTall() / 2) - (h / 2) + 5, color_white)
	end
	
	self.Scroll = vgui.Create("DScrollPanel", self)
	self.Scroll:SetSize(self:GetWide() - 6, self:GetTall() - 100)
	self.Scroll:SetPos(3, 65)
	
	self.Panel = vgui.Create("DIconLayout", self.Scroll)
	self.Panel:SetSize(self.Scroll:GetWide(), self.Scroll:GetTall())
	self.Panel:SetPos(0, 0)
	self.Panel:SetSpaceX(0)
	self.Panel:SetSpaceY(0)
	
	local function CreateList(tbl)
		self.Panel:Clear()
		local panel = {}
	
		for k, v in pairs(tbl) do
			panel[k] = vgui.Create("DButton")
			panel[k]:SetSize(self.Panel:GetWide(), 20)
			panel[k]:SetText("")
			panel[k].Color = Color(238, 238, 238, 255)
			
			panel[k].Paint = function(self)
				draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), panel[k].Color)
				draw.SimpleText(v.name, "Deathrun_Smooth", 5, 2, Color(192, 192, 192, 255), TEXT_ALIGN_LEFT)
				draw.SimpleText(string.ToMinutesSeconds(jukebox.GetTimeFromSong(v.name)), "Deathrun_Smooth", self:GetWide() - 20, 2, Color(192, 192, 192, 255), TEXT_ALIGN_RIGHT)
				draw.LinearGradient(0, self:GetTall() - 2, self:GetWide(), 1, Color(17,17,17,255), Color(0, 0, 0, 200), GRADIENT_VERTICAL)	
			end
			
			panel[k].OnCursorEntered = function()
				panel[k].Color = Color(32, 124, 150, 220)
			end
			
			panel[k].OnCursorExited = function()
				panel[k].Color = Color(238, 238, 238, 255)
			end
			
			panel[k].DoClick = function()
				MainFrame:Exit()
				RunConsoleCommand("jukebox_add", v.name)
			end

			self.Panel:Add(panel[k])
		end
	end
	
	CreateList(jukebox.SongsSorted)
	
	self.Options.DoClick = function()
		CreateList(queue or {})
	end
	
	self.List.DoClick = function()
		CreateList(jukebox.SongsSorted)
	end
	
	self.Mute = vgui.Create("DButton", self)
	self.Mute:SetPos(self:GetWide() - 110, self:GetTall() - 30)
	
	if (GetConVar("jukebox_mute"):GetInt() == 1) then
		self.Mute:SetText("Mute: On")
	else
		self.Mute:SetText("Mute: Off")
	end
	
	self.Mute.DoClick = function()
		if (GetConVar("jukebox_mute"):GetInt() == 1) then
			RunConsoleCommand("jukebox_mute", 0)
			self.Mute:SetText("Mute: Off")
		else
			RunConsoleCommand("jukebox_mute", 1)
			self.Mute:SetText("Mute: On")
		end
	end
	
	self.Mute:SetSize(100, 25)
	
	self.Volume = vgui.Create( "Slider", self) 
	self.Volume:SetPos( 5, self:GetTall() - 30)
	self.Volume:SetWide(self.Panel:GetWide() - 100)
	self.Volume:SetText( "Volume" )
	self.Volume:SetMin(0) 
	self.Volume:SetMax(1) 
	self.Volume:SetDecimals(1)
	self.Volume:SetValue(tonumber(GetConVarNumber("jukebox_volume")))
	self.Volume:SetConVar("jukebox_volume") 
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
	
	draw.SimpleText("Jukebox", "Deathrun_SmoothBig", 10, 2.5, color_white, TEXT_ALIGN_LEFT)

	-- orange
	draw.RoundedBox(0, 3, 40, self:GetWide() - 6, 25, Color(231, 138, 37, 150))
end

vgui.Register("DeathrunJukebox", PANEL, "EditablePanel")