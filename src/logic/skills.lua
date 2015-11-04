local Skills = {}


local Skill = {}
function Skill.new(name, scope, castCallback)
	local newSkill = {}
	newSkill.name = name or error("You must specify skill name")
	newSkill.scope = scope or error("You must specify skill scope")
	newSkill.cast = castCallback or error("You must specify skill cast callback")

	setmetatable(newSkill, {__index = Skill})
	return newSkill
end


Skill.SingleScopes = {
	Self = 1, Adjast = 2, ThroughOne = 3, RangeStraight = 4, Any = 5
}

Skill.MassScopes = {
	ThreeAdjast, ThreeRange, FiveAdjastToAdjast, SixAdjast, SixAdjastAndSelf
}

local Field = require("field")
function Skill.isObjectInScope(startPosition, objectPosition, scope)
	if scope == Skill.SingleScopes.Self then
		if startPosition.x == objectPosition.x and 
			startPosition.y == objectPosition.y then
			return true
		end

	elseif scope == Skill.SingleScopes.Adjast then
		if Field.isAdjast(startPosition, objectPosition) then
			return true
		end

	elseif scope == Skill.SingleScopes.ThroughOne then
		


	end

	return false
end


Skills.AttackSkill = {}
setmetatable(Skills.AttackSkill, {__index = Skill})



Skills.SupportSkill = {}
setmetatable(Skills.SupportSkill, {__index = Skill})



function Skills.SupportSkill.new(name, scope, castCallback)
	local newSkill = Skill.new(name, scope, castCallback)
	newSkill.cooldown = 0

	setmetatable(newSkill, {__index = Skills.SupportSkill})
	return newSkill
end

function Skills.SupportSkill.getCooldownRange(cooldown)
	if cooldown < 1 then
		return 1
	elseif cooldown > 6 then
		return 6
	else
		return cooldown
	end
end

return Skills