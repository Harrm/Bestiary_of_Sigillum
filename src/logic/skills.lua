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
	"Self", "Adjast", "ThroughOne", "RangeStraight", "Any"
}

Skill.MassScopes = {
	"ThreeAdjast", "ThreeRange", "FiveAdjastToAdjast", "SixAdjast", "SixAdjastAndSelf"
}

function Skill:checkTargetsValid(field, startPos, targetsPos)
	print 'Check target valid'
	for _, scope in ipairs(Skill.SingleScopes) do
		if scope == self.scope then
			if #targetsPos ~= 1 then
				error("Skill have single scope, targets num must be 1")
			end

			if scope == "Self" then
				if startPos == targetsPos[1] then
					return true
				end
			elseif scope == "Adjast" then
				if field:isAdjast(startPos, targetsPos[1]) then
					return true
				end
			elseif scope == "ThroughOne" then
				for _, adjast in ipairs(field:getAdjastentsCoords(startPos)) do
					if field:isAdjast(adjast, targetsPos[1]) then
						return true
					end
				end
			elseif scope == "RangeStraight" then
				print("Line", field:getStraightLine(startPos, targetsPos[1]))
				io.flush()
				if field:getStraightLine(startPos, targetsPos[1]) ~= nil then
					return true
				end
			elseif scope == "Any" then
				return true
			end
			return false
		end
	end

	for _, scope in ipairs(Skill.MassScopes) do
		if scope == self.scope then
			if scope == "ThreeAdjast" then
				for _, targetPos in ipairs(targetsPos) do
					if not field:isAdjast(targetPos, startPos) then
						return false
					end
				end
				return true

			elseif scope == "ThreeRange" then
				if #targetsPos ~= 3 then
					return false 
				end
			elseif scope == "FiveAdjastToAdjast" then
				for _, adjast in ipairs(field:getAdjastentsCoords(startPos)) do
					local adjastsTargets = 0
					for _, target in ipairs(targetsPos) do
						if field:isAdjast(target, adjast) then 
							adjastsTargets = adjastsTargets + 1
							break
						end
					end
					if adjastsTargets == 5 then
						return true
					end
				end
				return false

			elseif scope == "SixAdjast" then
				for _, target in ipairs(targetsPos) do
					if not field:isAdjast(target, startPos) then
						return false
					end
				end
			elseif scope == "SixAdjastAndSelf" then
				for _, target in ipairs(targetsPos) do
					if not field:isAdjast(target, startPos) then
						return false
					end
				end
			end 
		end
	end
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
