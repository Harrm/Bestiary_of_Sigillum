local Skills = {}


local Skill = {}
function Skill.new(name, targetsNum, checkTargetsValidCallback, castCallback)
	local newSkill = {}
	newSkill.name = name or error("You must specify skill name")
	newSkill.checkTargetsValidCallback = checkTargetsValidCallback or error("You must specify checkTargetsValidCallback")
	newSkill.cast = castCallback or error("You must specify cast callback")

	setmetatable(newSkill, {__index = Skill})
	return newSkill
end



Skills.AttackSkill = {}
setmetatable(Skills.AttackSkill, {__index = Skill})



Skills.SupportSkill = {}
setmetatable(Skills.SupportSkill, {__index = Skill})

function Skills.SupportSkill.new(name, targetsNum, checkTargetsValidCallback, castCallback)
	local newSkill = Skill.new(name, targetsNum, checkTargetsValidCallback, castCallback)
	newSkill.timeToRecharge = 0

	setmetatable(newSkill, {__index = Skills.SupportSkill})
	return newSkill
end

function Skills.SupportSkill.getValidTimeToRecharge(timeToRecharge)
	if timeToRecharge ~= nil then
		if timeToRecharge < 1 then
			return 1
		elseif timeToRecharge > 6 then
			return 6
		else
			return timeToRecharge
		end

	else
		error("You must specify skill recharge time")
	end
end

return Skills