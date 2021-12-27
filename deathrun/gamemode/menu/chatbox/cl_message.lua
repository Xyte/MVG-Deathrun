local PANEL = {}

function PANEL:Init()
	self.text = ""
	self.textsize = ""
	
	self.Alpha = 255
	
	self.width = 0
	self.height = 0
	
	self.ScrollY = 0
	self.ChatLines = {}
end

function PANEL:SetIcon( str )
	if not ( str ) then return end
	
	if ( icons[str] ) then
		self.icon = icons[str]
	end
end

function PANEL:GetIcon()
	return icons[self.icon] or "notify"
end

function PANEL:AddLine(linedata)        
	local wrapped = ChatBox.WrapString(linedata, ChatBox.Wide )
	
	for k,v in pairs(wrapped) do     
		v.alpha = 255
		table.insert(self.ChatLines, v)                                                                                 
	end
	
	if #self.ChatLines >= math.ceil(ChatBox.Wide / ChatBox.LineSpacing) then
		self.ScrollY = (#self.ChatLines - math.ceil(ChatBox.Wide / ChatBox.LineSpacing)) * ChatBox.LineSpacing
	end
	
	for k, v in pairs(self.ChatLines) do
		if k ~= #self.ChatLines then
			v.shouldfade = true
		end
	end
	
	local w, h = 0, 0
	local num = #self.ChatLines 
	local tall = self:GetTall()
	h = h + ChatBox.LineSpacing * num
	
	for i, j in pairs( self.ChatLines ) do
		for k, v in pairs( j.textdata ) do
			if type(v) == "string" then
				tall = h + (self.ScrollY * -1)
			end
		end
	end
	
	self:SetTall( h )
end

function PANEL:DrawLine(num, data)
	surface.SetFont( "ChatFont" )
	local linewidth = 0
	local num = num - 1
	local w, h = 0, 0
	data.alpha = math.Approach(data.alpha, 0, 0.35)
	h = h + ChatBox.LineSpacing * num
	surface.SetDrawColor( Color( 255, 255, 255, data.alpha ) )
	for _, elem in pairs(data.textdata) do
		if ( ChatBox.Chat.Enabled == true ) then data.alpha = 255 end
		
		if type(elem) == "table" and elem.r and elem.g and elem.b then
			surface.SetTextColor(Color(elem.r, elem.g, elem.b, data.alpha))
		end
		
		if type(elem) == "string" then
			w, _ = surface.GetTextSize(elem)
			
			if ( data.icon ) then
				if (string.find(tostring(data.icon), "icon16" )) then
					surface.SetTextPos( linewidth + ( data.icon and 22 or 0 ), h + (self.ScrollY * -1))
				else
					surface.SetTextPos( linewidth + ( data.icon and 30 or 0 ), h + (self.ScrollY * -1))
				end
			else
				surface.SetTextPos( linewidth + ( data.icon and 22 or 0 ), h + (self.ScrollY * -1))
			end
			
			surface.DrawText(elem)
			linewidth = linewidth + w
		end
	end         

	if (data.icon) then
		surface.SetDrawColor(Color(255, 255, 255, data.alpha))
		surface.SetMaterial(data.icon)
		if (string.find(tostring(data.icon), "icon16" )) then
			surface.DrawTexturedRect(2, h + self.ScrollY * -1, ChatBox.LineSpacing + 2, ChatBox.LineSpacing + 1 )  
		else
			surface.DrawTexturedRect(2, h + self.ScrollY * -1, ChatBox.LineSpacing + 10, ChatBox.LineSpacing + 1 )  
		end
	end
	
	surface.SetTextColor( color_white ) --Reset the color                                                                 
end                                                                                                                     


function PANEL:Paint()
	for k, v in ipairs(self.ChatLines) do
		self:DrawLine(k, v)
	end
end

vgui.Register( "chatline", PANEL, "EditablePanel" )
