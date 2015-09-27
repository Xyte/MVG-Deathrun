local ChatCommands = {}

-- Add a chatcommand
function AddChatCommand( command, func, show )
	-- Small check
	for k, v in pairs(ChatCommands) do
		if (v.command == command) then
			print( "[ADB] There is already a chatcommand with that name!" )
			return
		end
	end
	
	-- Insert
	ChatCommands[command:lower()] = {["func"] = func, ["show"] = show or false}
end

function RunChatCommand(player, command, arguments)
	local funct
	
	-- Find it
	if (ChatCommands[command]) then
		funct = ChatCommands[command].func
	end
	
	-- Simple check
	if not(funct) then
		return
	end
	
	-- Call functions
	funct(player, command, arguments)
end

local gimpSays = {}
gimpSays[1] = "AC IS AWESOME"
gimpSays[2] = "Please pee on me"
gimpSays[3] = "plz ban me"
gimpSays[4] = "dun dun dun"
gimpSays[5] = "Sanne is the best"
gimpSays[6] = "Dildos are awesome"
gimpSays[7] = "I'm crazy"
gimpSays[8] = "I love Sanne"
gimpSays[9] = "AC has a nice butthole"

local prankSays = {}
prankSays[1] = "01010000011100100110000101101110011010110110010101100100"
prankSays[2] = "01101110011011110110111101100010"
prankSays[3] = "01100010011010010110111001100001011100100111100100100001"
prankSays[4] = "0011110000110011001000000100000101000011"
prankSays[5] = "010000010100001100100000010001100101010001010111"

hook.Add( "PlayerSay", "OnPlayerSay", function(player, text)
	-- Mute plugin
	if (player.gimp) then
		if (player.gimp == 2) then return "" end

		if player.gimp == 1 then
		if #gimpSays < 1 then return nil end
			return gimpSays[ math.random( #gimpSays ) ]
		end
	end
	
	if (string.lower(text) == "who are you to wave your finger?") then
		XPM.Unlock(player, "achv_misc_secret")
		return ""
	end
	
	-- Taking from Rabbish chatcommand module
	local txt = text
	txt = txt:sub( 1 )

	local cmd = txt:match( "^(%S+)" )
	txt = txt:gsub( "^(%S+)", "",10 )

	local quote = txt:sub( 1, 1 ) ~= '"'
	local ret = {}
	for chunk in txt:gmatch( '[^"]+' ) do
		quote = not quote
		if quote then
			table.insert( ret, chunk )
		else
			for chunk in chunk:gmatch( "%S+" ) do
				table.insert( ret, chunk )
			end
		end
	end

	-- Run it
	RunChatCommand(player, cmd, ret)
	
	-- Show it or not
	if (ChatCommands[cmd]) then
		if not (ChatCommands[cmd].show) then
			return ""
		end
	end
	
	return text
end)