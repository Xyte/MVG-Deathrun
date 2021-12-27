
ChatBox = {}
ChatBox.Chat = {}
ChatBox.Lines = {}
ChatBox.Sounds = {}

ChatBox.Icons = {}
ChatBox.Icons["notify"] = Material( "icon16/world.png" )
ChatBox.Icons["warning"] = Material( "icon16/exclamation.png" )
ChatBox.Icons["join"] = Material( "icon16/tick.png" )
ChatBox.Icons["leave"] = Material( "icon16/cross.png" )
ChatBox.Icons["star"] = Material( "icon16/star.png" )
ChatBox.Icons["shield"] = Material( "icon16/shield.png" )
ChatBox.Icons["user"] = Material( "icon16/user.png" )
ChatBox.Icons["wrench"] = Material( "icon16/wrench.png" )
ChatBox.Icons["heart"] = Material( "icon16/heart.png" )

ChatBox.ChatColors = {
	["<red>"] = Color(255, 0, 0),
	["<green>"] = Color(0, 255, 0),
	["<blue>"] = Color(0, 0, 255),
	["<yellow>"] = Color(255, 255, 0),
	["<black>"]= Color(0, 0, 0),
	["<white>"] = Color(255, 255, 255),
	["<grey>"] = Color(115, 115, 115),
	["<gray>"] = Color(115, 115, 115), -- for the american spelling
	["<lightblue>"] = Color(152, 245, 255),
	["<aqua>"] = Color(127, 255, 212),
	["<orange>"] = Color(205, 127, 50),
	["<purple>"] = Color(127, 0, 255),
	["<lightgreen>"] = Color(202, 255, 112),
	["<pink>"] = Color(255, 20, 147),
	["<darkred>"] = Color(139, 26, 26)
}

do
	surface.SetFont("ChatFont")
	local w, h = surface.GetTextSize("0")
	ChatBox.LineSpacing = h 
end

ChatBox.Wide = 500

local lines = {}
function ChatBox.CreateChat()
	ChatBox.Chat.Frame = vgui.Create( "DFrame" )
	ChatBox.Chat.Frame:SetSize( 550 , 275 )
	ChatBox.Chat.Frame:SetPos( 20, ScrH() - 400 )
	ChatBox.Chat.Frame:SetTitle( "" )
	ChatBox.Chat.Frame:ShowCloseButton( false )
	ChatBox.Chat.Frame:SetDraggable( false )
	
	ChatBox.Chat.Frame.Paint = function( self )
	end
	
	local w, h = ChatBox.Chat.Frame:GetSize()
	local x, y = ChatBox.Chat.Frame:GetPos()
	
	ChatBox.Chat.ChatEntry = vgui.Create( "DTextEntry", ChatBox.Chat.Frame )
	ChatBox.Chat.ChatEntry:SetSize( w - 7, 20 )
	ChatBox.Chat.ChatEntry:SetPos( 5, h - 20 )
	ChatBox.Chat.ChatEntry:SetEditable( true )
	ChatBox.Chat.ChatEntry:SetMultiline( false )
	ChatBox.Chat.ChatEntry:SetAllowNonAsciiCharacters( true )
	ChatBox.Chat.ChatEntry:SetEnterAllowed( true )
	ChatBox.Chat.ChatEntry:SetVisible( false )
	ChatBox.Chat.ChatEntry:RequestFocus()
	
	ChatBox.Chat.ChatEntry.Paint = function( self )		
		surface.SetDrawColor( 0, 0, 0, 200 )
		surface.DrawOutlinedRect( 0, 0, self:GetWide(), self:GetTall() )
		
		surface.SetDrawColor( Color( 62, 62, 62, 200 ) )
		surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
		
		self:DrawTextEntryText( Color(255, 255, 255), Color(30, 130, 255), Color(255, 255, 255) )
	end
	
	ChatBox.Chat.ChatEntry.OnTextChanged = function(bah)
		if ( string.len( ChatBox.Chat.ChatEntry:GetValue() ) >= 100 ) then
			surface.PlaySound( "ui/buttonclickrelease.wav" )
			ChatBox.Chat.ChatEntry:SetText( ChatBox.Chat.ChatEntry:GetText() )
		end
	end
	
	ChatBox.Chat.ChatEntry.OnEnter = function( self )
		if ( string.len( self:GetText() ) >= 100 ) then
			surface.PlaySound( "ui/buttonclickrelease.wav" )
			ChatBox.Chat.ChatEntry:RequestFocus()
		end
		
		RunConsoleCommand( "say", self:GetText() )
		ChatBox.Chat.ChatEntry:SetText( "" )
		gui.EnableScreenClicker(false)
		ChatBox.CloseChat()
	end
	
	if not ( ChatBox.Chat.ChatFrame ) then
		ChatBox.Chat.ChatFrameMenu = vgui.Create( "DFrame" )
		ChatBox.Chat.ChatFrameMenu:SetSize( w - 5, h - 40 )
		ChatBox.Chat.ChatFrameMenu:SetPos( x + 5, y + 10 )
		ChatBox.Chat.ChatFrameMenu:SetTitle( "" )
		ChatBox.Chat.ChatFrameMenu:ShowCloseButton( false )
		ChatBox.Chat.ChatFrameMenu:SetDraggable( false )
		
		ChatBox.Chat.ChatFrameMenu.Paint = function() end
		
		ChatBox.Chat.ChatFrame = vgui.Create( "DScrollPanel")
		ChatBox.Chat.ChatFrame:SetSize( w - 5, h - 35 )
		ChatBox.Chat.ChatFrame:SetPos( x + 5, y + 10 )
		Chatbox.Chat.ChatFrame:EnableVerticalScrollBar(true)
		ChatBox.Chat.ChatFrame:SetSpaceX( 0 )
		ChatBox.Chat.ChatFrame:SetSpaceY( 10 )
		
		ChatBox.Chat.ChatFrame.Paint = function( self )
			if ( ChatBox.Chat.Enabled ) then
				surface.SetDrawColor( 0, 0, 0, 200 )
				surface.DrawRect( 0, 0, self:GetWide(), self:GetTall() )
			end
		end

/*
		ChatBox.Chat.ChatFrame.VBar.btnUp.Paint = function(self)
		end
		
		ChatBox.Chat.ChatFrame.VBar.btnDown.Paint = function(self)	
		end
			
		ChatBox.Chat.ChatFrame.VBar.btnGrip.Paint = function(self)
		end
			
		ChatBox.Chat.ChatFrame.VBar.Paint = function(self)
		end
*/
		
		function ChatBox.Chat.UpdateScrollBar(child)
			if( ChatBox.Chat.ChatFrame.VBar ) then
				ChatBox.Chat.ChatFrame.VBar:ScrollToChild(child);
			end
		end
		
		--timer.Simple(0.1, function() ChatBox.Chat.UpdateScrollBar() end)
	end
	
	--ChatBox.Chat.Refresh()
	ChatBox.Chat.Frame:SetVisible( false )
end
hook.Add( "Initialize", "ChatBox.CreateChat", ChatBox.CreateChat )

function ChatBox.AddMessage( um )
	local args = {}
	local text = um:ReadString()
	local icon = um:ReadString()
	icon = ChatBox.Icons[icon]
	local i = #lines
	
	table.insert( args, text )
	table.insert( args, {["icon"] = icon or "notify"} )

	chat.AddText( unpack(args) )
	--timer.Simple(0.1, function() ChatBox.Chat.UpdateScrollBar() end)
end
usermessage.Hook( "chatbox_line", ChatBox.AddMessage )

function ChatBox.AddLine( data )
	local i = #lines
	local tijd = CurTime() + 7
	
	if ( i >= 9 ) then
		lines[i - ( i - 1 )]:Remove()
	end
		
	lines[i] = vgui.Create("chatline")
	lines[i]:AddLine(data)
	
	ChatBox.Chat.ChatFrame:AddItem( lines[i] )
	timer.Simple(0.1, function() ChatBox.Chat.ChatFrame:ScrollToChild(lines[i]) end)
end

function ChatBox.CloseChat()
	if ( ChatBox.Chat.Frame:IsValid() ) then
		ChatBox.Chat.Frame:SetVisible( false )
		ChatBox.Chat.ChatEntry:SetVisible( false )
		ChatBox.Chat.Enabled = false
	end
	
	--ChatBox.Chat.Refresh()
end

function ChatBox.FinishChat()
	return true
end
hook.Add( "FinishChat", "ChatBox.FinishChat", ChatBox.FinishChat )

function ChatBox.StartChat()
	ChatBox.Chat.Frame:SetVisible( true )

	ChatBox.Chat.Frame:MakePopup()
	ChatBox.Chat.ChatEntry:SetVisible( true )
	ChatBox.Chat.ChatEntry:RequestFocus()
	
	ChatBox.Chat.Enabled = true
	gui.EnableScreenClicker( true )
	--ChatBox.Chat.Refresh()
	return true
end

function ChatBox.HandleStartChat()
	return true
end
hook.Add( "StartChat", "ChatBox.HandleStartChat", ChatBox.HandleStartChat)

function ChatBox.ChatText( playerindex, playername, text, messagetype )
	if messagetype == "joinleave" then
		args = {}
		local color = color_white
		local icon = "join"
			
		table.insert( args, Color( 255, 255, 255 ) )
	
		for s in string.gmatch(text, "%s?[(%S)]+[^.]?") do --HEIL PATTERN
			table.insert(args, s)
		end
			
		chat.AddText( unpack(args) )
		timer.Simple(0.1, function() ChatBox.Chat.UpdateScrollBar() end)
		return 
	end
		
	if messagetype == "none" then
		args = {}
			
		table.insert( args, Color( 232, 232, 00 ) )
			
		for s in string.gmatch(text, "%s?[(%S)]+[^.]?") do
			table.insert(args, s)
		end
			
		chat.AddText( unpack(args) )
		--timer.Simple(0.1, function() ChatBox.Chat.UpdateScrollBar() end)
	end
end
hook.Add( "ChatText", "ChatBox.ChatText", ChatBox.ChatText )

function chat.AddText(...)
	local pargs = {...}
	local colorsparsed = false
	local playerchat = false
	local ChatIcon = nil
	timer.Simple(0, function()
		local ind = 1
		local args = {}
		for k, v in pairs(pargs) do
			if ChatBox.IsColor(v) then
				local fixedcolor = Color(v.r, v.g, v.b, 255)
				table.insert(args, fixedcolor)
			end
			
			if type(v) == "Player" then
				table.insert(args, team.GetColor(v:Team()))
				table.insert(args, v:Nick())
			end
			
			if not ( type(pargs[2]) == "string" ) then
				if ( pargs[2] ) and ( pargs[2].icon ) then
					if type(pargs[2].icon) == "IMaterial" then
						ChatIcon = pargs[2].icon
					end
				end
			end
			
			if type(v) == "string" then
				for s in string.gmatch(v, "%s?[(%S)]+[^.]?") do --HEIL MEIN PATTERN
				local start = 0 --credit to Divran
					for startpos, center, endpos in string.gmatch(s, "()(%b<>)()" ) do
						--print(startpos, center, endpos)
						if ChatBox.ChatColors[center] then
							colorsparsed = true
							table.insert(args, string.sub(s, start, startpos - 1))
							table.insert(args, ChatBox.ChatColors[center])
							start = endpos
						end
					end
					
					if colorsparsed then
						table.insert(args, string.sub(s, start))
						s = ""
					end
					
					surface.SetFont("ChatFont")
					local w, _ = surface.GetTextSize(s)
					local singlew, _ = surface.GetTextSize("O")
					if w >= ChatBox.Wide then
						local lastchar = 0
						local maxchars = ChatBox.Wide / singlew
						for i = 0, math.ceil(w / ChatBox.Wide) do
							local cutstr = string.sub(s, lastchar + 1, lastchar + maxchars)
							table.insert(args, cutstr)
							lastchar = lastchar + string.len(cutstr)
						end
					else
						table.insert(args, s)
					end
				end
			end
		end
		

		ChatBox.AddLine( { icon = ChatIcon, textdata = args} )
	end)
end

function ChatBox.OnPlayerChat( ply, strText, bTeamOnly, bPlayerIsDead )
 
	-- I've made this all look more complicated than it is. Here's the easy version
	-- chat.AddText( ply:GetName(), Color( 255, 255, 255 ), ": ", strText )
 
	local tab = {}
	
	if not ply.LastTrigger then
		ply.LastTrigger = 0
	end
 
	--if ( ply:IsAdmin() ) then
	--else
	--	table.insert( tab, {["icon"] = nil} )
	--end

	if ( IsValid( ply ) ) then
		table.insert( tab, team.GetColor( ply:Team() )  )
		
		if (ply.ShopData) and (ply.ShopData["tag"]) then
			table.insert( tab, {["icon"] = Material( ply.ShopData["tag"])} )
		else
			if ( ply:IsSuperAdmin() ) then
				table.insert( tab, {["icon"] = ChatBox.Icons["star"] } )
			elseif( ply:IsAdmin() ) then
				table.insert( tab, {["icon"] = ChatBox.Icons["shield"] } )
			elseif ( ply:IsVIP() ) then
				table.insert( tab, {["icon"] = ChatBox.Icons["heart"] } )
			end
		end
		
		table.insert( tab, ply:GetName() )
	else
		table.insert( tab, Color( 255, 0, 0 ) )
		table.insert( tab, "Console" )
	end
 
	table.insert( tab, Color( 255, 255, 255 ) )
	table.insert( tab, ": "..strText )
	chat.AddText( unpack(tab) )
	
	for k, v in pairs( ChatBox.Sounds ) do
		if ( ChatBox.Sounds[k].trigger == string.lower(strText) ) and ply:IsValid() and ply.LastTrigger < CurTime() then
			surface.PlaySound( ChatBox.Sounds[k]["sound"][math.random( 1, #ChatBox.Sounds[k]["sound"] )] )
			
			--if ( ply:IsVIP() ) then
			--	ply.LastTrigger = CurTime() + 10
			--else
				ply.LastTrigger = CurTime() + 25
			--end
		end
	end

	--timer.Simple(0.1, function() ChatBox.Chat.UpdateScrollBar() end)
	return true
end
hook.Add( "OnPlayerChat", "ChatBox.HandlePlayerChat", ChatBox.OnPlayerChat )

function ChatBox.RemoveOldChatBox( element )
	if ( element == "CHudChat" ) then
		return false
	end
end
hook.Add( "HUDShouldDraw", "ChatBox.RemoveOldChatBox", ChatBox.RemoveOldChatBox )

function ChatBox.PlayerBindPress( ply, bind, pressed )
    if pressed and string.find( bind, "messagemode" ) then
        local teamchat = string.find( bind, "messagemode2" ) != nil
        ChatBox.StartChat()
        return true -- Disable the command from being processed any further
    end
end
hook.Add("PlayerBindPress", "ChatBox.PlayerBindPress", ChatBox.PlayerBindPress )
