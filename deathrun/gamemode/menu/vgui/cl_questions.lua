local PANEL = {}

print("LOADED")
local questions = {}
local answers = {}

questions[1] = "Do we allow other languages during chat?"
questions[2] = "It is acceptable to swear/insult owners, admins and moderators?"
questions[3] = "Will you read the rules? (f1)"
questions[4] = "Will you ask for points?"

answers[1] = "No."
answers[2] = "No."
answers[3] = "Yes."
answers[4] = "No."

local wrong = 0
local correct = 0

function PANEL:Init()
	self:SetWide(650)
	self:SetTall(550)

	local panel = {}
	local choice = {}
	for k, v in pairs(questions) do
		panel[k] = vgui.Create("DPanel", self)
		panel[k]:SetSize(self:GetWide() - 30, 30)
		panel[k]:SetPos(5, 50 + (k*30))

		panel[k].Paint = function()
			draw.SimpleText(questions[k], "Deathrun_Smooth", 5, 5, color_white, TEXT_ALIGN_LEFT)

			surface.SetDrawColor(Color(255, 255, 255, 200))
			surface.DrawLine(5, 25, self:GetWide(), 25)
		end

		choice[k] = vgui.Create("DComboBox", self)
		choice[k]:SetSize(100, 20)
		choice[k]:SetPos(self:GetWide() - 120, 50 + (k*30))
		choice[k]:AddChoice("Yes.")
		choice[k]:AddChoice("No.")

		choice[k].OnSelect = function(panel, index, value, data)

			if not (answers[k] == value) then
				wrong = wrong + 1
			else
				correct = correct + 1
			end

			if (wrong >= 2) then
				RunConsoleCommand("questions_failed")
				return
			end

			if (correct >= #questions) then
				self:Remove()
				gui.EnableScreenClicker(false)

				RunConsoleCommand("questions_finished")
			end
		end	
	end

	self:SetTall(100 + (#questions * 30))
	self:Center()

	gui.EnableScreenClicker(true)
end

function PANEL:Paint()
	-- background
	draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), Color(44, 44, 44, 255))
	draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), Color(44, 44, 44, 240))
	
	draw.RoundedBox(4, 1, 1, self:GetWide() - 2, self:GetTall() - 2, Color(192, 192, 192, 255))
	
	-- top
	draw.RoundedBox(4, 3, 40, self:GetWide() - 6, self:GetTall() - 43, Color(44, 44, 44, 255))
	draw.RoundedBoxEx(4, 3, 3, self:GetWide() - 6, 40, Color(44, 44, 44, 240), true, true, false, false)
	
	draw.SimpleText("Prove that you're not an idiot.", "Deathrun_SmoothBig", 10, 2.5, color_white, TEXT_ALIGN_LEFT)

	draw.RoundedBox(0, 3, 40, self:GetWide() - 6, 25, Color(231, 138, 37, 150))
end

vgui.Register("DeathrunQuestions", PANEL, "EditablePanel")