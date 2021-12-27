
-- Object
XPM = {}
XPM.list = {}
XPM.Stats = {}
XPM.AchievementHandlers = {}

-- Register a new achievement
local i = 1
function XPM.RegisterAchievement(id, name, desc, reward, image, sort)
	XPM.list[id] = {name = name, desc = desc, reward = reward, image = image, sort = tonumber(i)}
	i = i + 1
end

-- Register a new stat to track
function XPM.RegisterStat(id)
	XPM.Stats[id] = id
end

-- See if an achievement is registered
function XPM.IsValid(id)
	return util.tobool(XPM.list[id]) or false
end

-- See if a stat is valid
function XPM.IsValidStat(id)
	return util.tobool(XPM.Stats[id]) or false
end

-- See if a player has an achievement
function XPM.IsUnlocked(player, achvid)
		if (player.PlayerData) and (player.PlayerData["achievements"]) then
			return table.HasValue(player.PlayerData["achievements"], achvid)
		end
	return false
end

-- Get data from an achievement
function XPM.GetData(id)
	if (XPM.IsValid(id)) then
		return XPM.list[id]
	end
	
	return {}
end

-- Misc
XPM.RegisterAchievement("achv_misc_hello", "Hello world", "Join the server for the first time.", 400, "achievement/hello.png")
XPM.RegisterAchievement("achv_misc_ac", "Meet the developer", "Play with Conner.", 500, "achievement/ac.png")
XPM.RegisterAchievement("achv_misc_zolack", "Depresso Expresso", "Kill Whitey", 300, "achievement/drunk.png")
XPM.RegisterAchievement("achv_misc_bottle", "Here's ya bottle opener!", "Find Zolacks bottle opener", 1337, "achievement/bottle.png")
XPM.RegisterAchievement("achv_misc_secret", "The secret", "Uh oh.", 2500, "achievement/secret.png")
XPM.RegisterAchievement("achv_misc_lucky", "Lucky basterd", "Win a round having 10 health or less", 3000, "achievement/lucky.png")
XPM.RegisterAchievement("achv_misc_drown", "I hate water", "Drown", 500, "achievement/drown.png")
XPM.RegisterAchievement("achv_misc_sanne", "You're in trouble", "Kill Conner", 200, "achievement/sanne.png")
XPM.RegisterAchievement("achv_misc_sanne2", "My fleshlight!", "Play with Conner (if you catch my meaning hehe)", 400, "achievement/derp.png")
XPM.RegisterAchievement("achv_misc_dildo", "The golden fleshlight", "Find Conner his Fleshlight", 1337, "achievement/dildo.png")

-- Level achievements
XPM.RegisterAchievement("achv_level5", "Noob", "Reach Level 5.", 2000, "achievement/level5.png")
XPM.RegisterAchievement("achv_level10", "Beginner", "Reach Level 10.", 4000, "achievement/level10.png")
XPM.RegisterAchievement("achv_level15", "Better and better", "Reach Level 15.", 6000, "achievement/level15.png")
XPM.RegisterAchievement("achv_level20", "I stay", "Reach Level 20.", 10000, "achievement/level20.png")
XPM.RegisterAchievement("achv_level25", "1/4", "Reach Level 25.", 12500, "achievement/level25.png")
XPM.RegisterAchievement("achv_level30", "Dreamer", "Reach Level 30.", 15000, "achievement/level30.png")
XPM.RegisterAchievement("achv_level35", "So close, yet so far", "Reach Level 35.", 20000, "achievement/level35.png")
XPM.RegisterAchievement("achv_level40", "Almost half", "Reach Level 40.", 30000, "achievement/level40.png")
XPM.RegisterAchievement("achv_level45", "5%", "Reach Level 45.", 35000, "achievement/level45.png")
XPM.RegisterAchievement("achv_level50", "Half way there", "Reach Level 50.", 40000, "achievement/level50.png")
XPM.RegisterAchievement("achv_level60", "My favourite number", "Reach Level 60.", 40000, "achievement/level60.png")
XPM.RegisterAchievement("achv_level70", "Almost", "Reach Level 70.", 40000, "achievement/level70.png")
XPM.RegisterAchievement("achv_level80", "So close", "Reach Level 80.", 40000, "achievement/level80.png")
XPM.RegisterAchievement("achv_level90", "10 more", "Reach Level 90.", 40000, "achievement/level90.png")
XPM.RegisterAchievement("achv_level99", "Your Woodcutting level is now 99", "Reach Level 99.", 40000, "achievement/level90.png")
XPM.RegisterAchievement("achv_level100", "Deathrun Master", "Reach Level 100.", 50000, "achievement/level100.png")
XPM.RegisterAchievement("achv_level200", "OMEGALUL YOU WASTED YOUR LIFE", "Reach Level 200.", 50000, "achievement/level100.png")

-- Death achievements
XPM.RegisterAchievement("achv_death_explosion", "EXPLOSIONS?!", "Die by an explosion", 1000, "achievement/explosion.png")
XPM.RegisterAchievement("achv_death_rtd", "Fucking dice", "Die by rolling the dice", 500, "achievement/dice.png")
XPM.RegisterAchievement("achv_deaths5", "I suck", "Die a total of 5 times.", 1000, "achievement/deaths5.png")
XPM.RegisterAchievement("achv_deaths10", "No heaven for me", "Die a total of 10 times.", 1000, "achievement/deaths10.png")
XPM.RegisterAchievement("achv_deaths20", "I hate hell", "Die a total of 20 times.", 2000, "achievement/deaths20.png")
XPM.RegisterAchievement("achv_deaths40", "The grave", "Die a total of 40 times.", 4000, "achievement/deaths40.png")
XPM.RegisterAchievement("achv_deaths75", "From hell", "Die a total of 75 times.", 4000, "achievement/deaths75.png")
XPM.RegisterAchievement("achv_deaths100", "Devils bitch", "Die a total of 100 times.", 4000, "achievement/deaths100.png")
XPM.RegisterAchievement("achv_deaths500", "I like to die", "Die a total of 500 times.", 4500, "achievement/deaths500.png")
XPM.RegisterAchievement("achv_deaths1000", "Ahh Hell", "Die a total of 1000 times.", 4500, "achievement/deaths500.png")

-- Win achievements
XPM.RegisterAchievement("achv_win5", "Yes!", "Win a total of 5 times (as runner).", 1000, "achievement/win5.png")
XPM.RegisterAchievement("achv_win10", "Not bad", "Win a total of 10 times (as runner).", 1000, "achievement/win10.png")
XPM.RegisterAchievement("achv_win20", "It's a start", "Win a total of 20 times (as runner).", 1250, "achievement/win20.png")
XPM.RegisterAchievement("achv_win40", "Fast runner", "Win a total of 40 times (as runner).", 2500, "achievement/win40.png")
XPM.RegisterAchievement("achv_win75", "Run as fast as you can", "Win a total of 75 times (as runner).", 7500, "achievement/win75.png")
XPM.RegisterAchievement("achv_win100", "Pro runner", "Win a total of 100 times (as runner).", 10000, "achievement/win100.png")
XPM.RegisterAchievement("achv_win200", "Pro", "Win a total of 200 times (as runner).", 10000, "achievement/win200.png")
XPM.RegisterAchievement("achv_win500", "Elite", "Win a total of 500 times (as runner).", 10000, "achievement/win200.png")
XPM.RegisterAchievement("achv_win1000", "Hero", "Win a total of 1000 times (as runner).", 10000, "achievement/win200.png")

-- Kill achievements
XPM.RegisterAchievement("achv_kills5", "Take that!", "Kill a total of 5 players.", 1000, "achievement/kills5.png")
XPM.RegisterAchievement("achv_kills20", "Painbar!", "Kill a total of 15 players.", 2000, "achievement/kills15.png")
XPM.RegisterAchievement("achv_kills40", "Bloody hell!", "Kill a total of 40 players.", 4000, "achievement/kills40.png")
XPM.RegisterAchievement("achv_kills60", "Blood money!", "Kill a total of 60 players.", 6000, "achievement/kills60.png")
XPM.RegisterAchievement("achv_kills80", "More blood, more pain", "Kill a total of 80 players.", 8000, "achievement/kills80.png")
XPM.RegisterAchievement("achv_kills100", "It begins now", "Kill a total of 100 players.", 8000, "achievement/kills100.png")
XPM.RegisterAchievement("achv_kills500", "MORE", "Kill a total of 500 players.", 10000, "achievement/kills500.png")
XPM.RegisterAchievement("achv_kills750", "MORE BLOOD", "Kill a total of 750 players.", 10000, "achievement/kills750.png")
XPM.RegisterAchievement("achv_kills1000", "1000", "Kill a total of 1000 players.", 10000, "achievement/kills1000.png")

-- Damage achievements
XPM.RegisterAchievement("achv_damage100", "A bit of blood", "Deal a total of 100 damage.", 100, "achievement/damage5.png")
XPM.RegisterAchievement("achv_damage500", "Easy damage", "Deal a total of 500 damage.", 500, "achievement/damage500.png")
XPM.RegisterAchievement("achv_damage1000", "If it bleeds", "Deal a total of 1000 damage.", 1000, "achievement/damage1000.png")
XPM.RegisterAchievement("achv_damage5000", "Pain bringer", "Deal a total of 5000 damage.", 2000, "achievement/damage5000.png")
XPM.RegisterAchievement("achv_damage7500", "NEVER STOP THE KILLING", "Deal a total of 7500 damage.", 3000, "achievement/damage7500.png")
XPM.RegisterAchievement("achv_damage10000", "Army of pain", "Deal a total of 10000 damage.", 5000, "achievement/damage10000.png")

-- Time achievement
XPM.RegisterAchievement("achv_time5", "5 minutes", "Play a total of five minutes.", 1000, "achievement/time5.png")
XPM.RegisterAchievement("achv_time60", "One hour", "Play a total of one hour.", 2500, "achievement/time60.png")
XPM.RegisterAchievement("achv_time1200", "Two hours", "Play a total of two hours.", 3000, "achievement/time1200.png")
XPM.RegisterAchievement("achv_time6000", "Five hours", "Play a total of five hours.", 4000, "achievement/time6000.png")
XPM.RegisterAchievement("achv_time86400", "One day", "Play a total of one day.", 4500, "achievement/time86400.png")
XPM.RegisterAchievement("achv_timetwodays", "Two days", "Play a total of two days.", 5000, "achievement/timetwodays.png")
XPM.RegisterAchievement("achv_timeweek", "That was fast", "Play a week.", 5000, "achievement/timetwodays.png")
XPM.RegisterAchievement("achv_timemonth", "One month", "You need to get outside...", 7000, "achievement/timemonth.png")
XPM.RegisterAchievement("achv_timeyear", "Wow", "You wasted a year, you know that?", 10000, "achievement/timemonth.png")

-- Unlock above achievements
-- keelz
XPM.AchievementHandlers["kills"] = {}
XPM.AchievementHandlers["kills"][5] = "achv_kills5"
XPM.AchievementHandlers["kills"][20] = "achv_kills20"
XPM.AchievementHandlers["kills"][40] = "achv_kills40"
XPM.AchievementHandlers["kills"][60] = "achv_kills60"
XPM.AchievementHandlers["kills"][80] = "achv_kills80"
XPM.AchievementHandlers["kills"][100] = "achv_kills100"
XPM.AchievementHandlers["kills"][500] = "achv_kills500"
XPM.AchievementHandlers["kills"][750] = "achv_kills750"
XPM.AchievementHandlers["kills"][1000] = "achv_kills1000"

-- damage
XPM.AchievementHandlers["damage"] = {}
XPM.AchievementHandlers["damage"][100] = "achv_damage100"
XPM.AchievementHandlers["damage"][500] = "achv_damage500"
XPM.AchievementHandlers["damage"][1000] = "achv_damage1000"
XPM.AchievementHandlers["damage"][5000] = "achv_damage5000"
XPM.AchievementHandlers["damage"][7500] = "achv_damage7500"
XPM.AchievementHandlers["damage"][10000] = "achv_damage10000"

-- wins
XPM.AchievementHandlers["wins"] = {}
XPM.AchievementHandlers["wins"][5] = "achv_win5"
XPM.AchievementHandlers["wins"][10] = "achv_win10"
XPM.AchievementHandlers["wins"][20] = "achv_win20"
XPM.AchievementHandlers["wins"][40] = "achv_win40"
XPM.AchievementHandlers["wins"][75] = "achv_win75"
XPM.AchievementHandlers["wins"][100] = "achv_win100"
XPM.AchievementHandlers["wins"][200] = "achv_win200"
XPM.AchievementHandlers["wins"][500] = "achv_win500"
XPM.AchievementHandlers["wins"][1000] = "achv_win1000"

-- deaths
XPM.AchievementHandlers["deaths"] = {}
XPM.AchievementHandlers["deaths"][5] = "achv_deaths5"
XPM.AchievementHandlers["deaths"][10] = "achv_deaths10"
XPM.AchievementHandlers["deaths"][20] = "achv_deaths20"
XPM.AchievementHandlers["deaths"][40] = "achv_deaths40"
XPM.AchievementHandlers["deaths"][75] = "achv_deaths75"
XPM.AchievementHandlers["deaths"][100] = "achv_deaths100"
XPM.AchievementHandlers["deaths"][500] = "achv_deaths500"
XPM.AchievementHandlers["deaths"][1000] = "achv_deaths1000"

-- time
-- in seconds
XPM.AchievementHandlers["timeplayed"] = {}
XPM.AchievementHandlers["timeplayed"][1] = {achv = "achv_time5", time = 300}
XPM.AchievementHandlers["timeplayed"][2] = {achv = "achv_time60", time = 3600}
XPM.AchievementHandlers["timeplayed"][3] = {achv = "achv_time1200", time = 7200}
XPM.AchievementHandlers["timeplayed"][4] = {achv = "achv_time6000", time = 18000}
XPM.AchievementHandlers["timeplayed"][5] = {achv = "achv_time86400", time = 86400}
XPM.AchievementHandlers["timeplayed"][6] = {achv = "achv_timetwodays", time = 86400*2}
XPM.AchievementHandlers["timeplayed"][7] = {achv = "achv_timeweek", time = 86400*7}
XPM.AchievementHandlers["timeplayed"][8] = {achv = "achv_timemonth", time = 2629743}
XPM.AchievementHandlers["timeplayed"][9] = {achv = "achv_timeyear", time = 31556926}

-- Stats
XPM.RegisterStat("kills")
XPM.RegisterStat("wins")
XPM.RegisterStat("deaths")
XPM.RegisterStat("damage")
XPM.RegisterStat("timeplayed")

-- Sort this shit
Sortedlist = {}

for k, v in pairs(XPM.list) do
	Sortedlist[v.sort] = k
end