local tags = 
{
--Group    --Tag     --Color	--Whitechat
{"Server Admin", "[Admin] ", Color(255,255,0), false },
{"superadmin", "[S. Admin] ", Color(192,64,0), false },
{"owner", "[Owner] ", Color(0,255,255), false },
{"co-owner", "[Co-Owner] ", Color(0,128,0), false },
{"Server Moderator", "[Mod] ", Color(0,255,0), false },
{"trial moderator", "[Trial Mod] ", Color(255,255,0), false },
{"donator", "[Donator] ", Color(0,255,255), false },
{"user", "[User] ", Color(0,0,255), true },
{"Server Developer", "[Dev] ", Color(102,205,170), false },
{"Server Trusted", "[Trusted] ", Color(138,43,226), true },
{"Server Trusted+", "[Trusted+] ", Color(0,0,0), true },
{"Server Donator", "[Donator] ", Color(255,20,147), true },
{"Server God", "[Server God] ", Color(255,0,0), true }, 
{"Server Awesome", "[Conner's Pet] ", Color(227,7,255), false },
{"Server VIP", "[VIP] ", Color(255,69,0), true },
{"Server Squeaker", "[Squeaker] ", Color(10,25,255), true },
{"Server Nameless", "[Sexy] ", Color(218,112,214), false },
{"Beta Tester", "[Tester]", Color(255,243,0), false }
}

local function findchattagtable(tag) -- returns a table from tags based on the input.
	for i = 1, #tags do
		if tags[i][1] == tag then
			return tags[i]
		end
	end
end

local function ChatTag(player)
	for k, v in pairs(tags) do
		if (player:IsUserGroup(v[1])) or player:GetUserGroup() == v[1] then
			return v
		end
	end
	local tag = findchattagtable(player:GetUserGroup()) --Third attempt
	if tag then return tag end
	
	--strange... Garry broke this.
	print("No chat tag found... defaulting to [User].")
	return { "user", "[User] ", Color(0,0,255) }
end

local function ChatValid(ply)
	if type(ply) == "Player" then return true, ply end -- type == player?
	if IsValid(ply) then return true, ply end -- if type ~= player is it valid?
	for k,v in pairs(player.GetAll()) do -- not valid? check all players.
		if v == ply then
			return true, v
		end
	end
	for k,v in pairs(ents.GetAll()) do -- not in the player list? WUUT? check entities.
		if v == ply then
			return true, v
		end
	end
	return false, ply --Well fuck it I tried.
end

function GM:OnPlayerChat( player, strText, bTeamOnly, bPlayerIsDead )
 
 	local tab = {}
 	
	local Valid, player = ChatValid(player)
	
	if Valid then
		if player:GetUserGroup() == "owner" then
			local v = findchattagtable("owner")
			local tag = v[2]
			local length = string.len(tag)
			local asd = 255/length
			for i = 1, length do
				table.insert(tab, HSVToColor( i * asd, 1, 1 ))
				table.insert(tab, string.GetChar(tag, i))
			end
			table.insert(tab, player)
			table.insert(tab, Color(255, 255, 255))
			table.insert(tab, ": ")
			if v[4] then
				table.insert(tab, Color( 255, 255, 255 )) -- argument 4 was true. chat is white.
			else
				table.insert(tab, v[3])
			end
			table.insert(tab, strText)
		else
			local v = ChatTag(player)
			table.insert(tab, v[3])
			table.insert(tab, v[2])
			table.insert(tab, player)
			table.insert(tab, Color(255, 255, 255))
			table.insert(tab, ": ")
			if v[4] then
				table.insert(tab, Color( 255, 255, 255 )) -- argument 4 was true. chat is white.
			else
				table.insert(tab, v[3])
			end
			table.insert(tab, strText)
		end
	else
	 	return true -- not a player and not the console. goodbye.
 	end

 	chat.AddText(unpack( tab ))
	return true
end
