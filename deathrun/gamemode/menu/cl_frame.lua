
function CreateDeathrunHelp(title, stringtext)
	if not (MainFrame) then return end
	
	local menu = vgui.Create("DFrame")
	local x, y = MainFrame:GetPos()
	menu:SetPos(x + 100 + 300, (ScrH() / 2) - (325 / 2))
	menu:SetSize(600, 325)
	menu:ShowCloseButton(false)
	menu:SetTitle("")
	
	menu.Paint = function(self)
		draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), Color(44, 44, 44, 255))
		draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), Color(44, 44, 44, 240))
		
		draw.RoundedBox(4, 1, 1, self:GetWide() - 2, self:GetTall() - 2, Color(0, 0, 0, 255))
		
		-- top
		draw.RoundedBox(4, 3, 40, self:GetWide() - 6, self:GetTall() - 43, Color(25, 25, 25, 255))
		draw.RoundedBoxEx(4, 3, 3, self:GetWide() - 6, 40, Color(44, 44, 44, 240), true, true, false, false)
		
		draw.SimpleText(title or "#Default Title", "Deathrun_SmoothBig", 10, 2.5, color_white, TEXT_ALIGN_LEFT)
	
		-- orange
		draw.RoundedBox(0, 3, 40, self:GetWide() - 6, 25, Color(32, 32, 75, 220))
	end
	
	function menu:Think()
		if not (MainFrame:IsValid()) then
			menu:Remove()
		end
	end
	
	/*
	local bar = vgui.Create("DeathrunProgress", menu)
	bar:SetPos(100, 50)
	bar:SetWide(100)
	local xp = LocalPlayer().PlayerData["xp"]
	local level = LocalPlayer().PlayerData["level"]
	local max_xp = XPM.levels[level+1].xp
	
	if (level == 100) then
		bar:SetProgress(1000000, 1000000)
	else
		bar:SetProgress(xp, max_xp)
	end*/
	
	if (stringtext) then
		local dlist = vgui.Create( "DPanelList", menu)
		dlist:SetSize(menu:GetWide() - 20, menu:GetTall() - 80)
		dlist:SetPos(15, 75)
		dlist:EnableVerticalScrollbar(true)

		local text = string.Explode( "\n", stringtext)

		for k, v in pairs(text) do
			v = WrapText( v, dlist:GetWide() - 15, "Deathrun_Smooth" )
			
			if #v > 1 then
				v[1] = string.sub( v[1], 2 )
			end

			for _, text in pairs( v ) do
				local label = vgui.Create( "DLabel" )
				label:SetFont( "Deathrun_Smooth" )
				label:SetText( text )
				label:SizeToContents()

				dlist:AddItem(label)
			end
		end
	end

	MainFrame:Register(menu)

	return menu
end