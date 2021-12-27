
-- Object
XPM.Items = {}
XPM.ItemData = {}

-- Register an item
local i = 1
function XPM.RegisterItem(id, name, desc, level)
	XPM.Items[id] = {id = id, name = name, desc = desc, level = level, sort = i}
	i = i + 1
end

-- Get item rewards
function XPM.GetLevelReward(lvl)
	local rewards = {}
	
	for k, v in pairs(XPM.Items) do
		if (v.level <= lvl) then
			table.insert(rewards, v.id)
		end
	end
	
	return rewards
end

-- Get shit
function XPM.GetItemData(id)
	return XPM.Items[id] or {}
end

-- Register items
XPM.RegisterItem("perk_xp", "XP Booster", "Earn double XP!", 10)
XPM.RegisterItem("perk_health", "Juggernaut", "Spawn with 25% more health.", 25)
XPM.RegisterItem("perk_jump", "Jumper", "Jump 25% higher", 35)
XPM.RegisterItem("perk_speed", "Runner", "Run 25% faster.", 40)
XPM.RegisterItem("perk_armor", "Balls of steel", "Take less damage.", 55)
XPM.RegisterItem("perk_ladyluck", "Lady luck", "Let the luck shine upon you, increase chance with rtd.", 60)
XPM.RegisterItem("perk_regen", "Regeneration", "Your health will slowly recover.", 80)

SortedItems = {}

for k, v in pairs(XPM.Items) do
	SortedItems[v.sort] = k
end


