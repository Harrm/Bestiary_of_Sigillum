M = {}



M.Effects = {Paralysed=1, DoubleAttack=2, IncreaseDefence=3, Immunity=4, LowVision=5, 
			 IncreaseArmor=6, DecreaseArmor=7, 
			 IncreaseAttack=8, DecreaseAttack=9,
			 IncreaseChaos=10, DecreaseChaos=11,
			 IncreaseCooldown=12, DecreaseCooldown=13,
			 }

local NegativeEffects = {M.Effects.Paralysed, M.Effects.LowVision, M.Effects.DecreaseArmor, M.Effects.DecreaseAttack, M.Effects.DecreaseChaos, M.Effects.IncreaseCooldown}
local PositiveEffects = {M.Effects.DoubleAttack, M.Effects.IncreaseDefence, M.Effects.Immunity, M.Effects.IncreaseArmor, M.Effects.IncreaseAttack, M.Effects.IncreaseChaos}
local function isEffectNegative(effect)
	for _, ieffect in pairs(NegativeEffects) do
		if ieffect == effect then
			return true
		end
	end
	return false
end



local Skill = {}
function Skill.new(name, targetsNum, isValidTargetsCallback, castCallback)
	local newSkill = {}
	newSkill.name = name or error("You must specify skill name")
	newSkill.targetsNum = targetsNum or errorerror("You must specify skill targets num")
	newSkill.isValidTargets = isValidTargetsCallback or error("You must specify isValidTargets callback")
	newSkill.cast = castCallback or error("You must specify cast callback")

	setmetatable(newSkill, {__index = Skill})
	return newSkill
end

function Skill:isValidTarget(start, target)
	if self.range.self == false then
		if target.x == start.x and target.y == start.y then
			return false
		end
	end

	if  math.abs(start.y-targets.y) > self.range.distance or 
		math.abs(start.y-targets.y) > self.range.distance then
		return false
	end

	if self.range.onlyStraight then
		-- TODO
	end

end



M.AttackSkill = {}
setmetatable(M.AttackSkill, {__index = Skill})



M.SupportSkill = {}
setmetatable(M.SupportSkill, {__index = Skill})
function M.SupportSkill.new(name, targetsNum, isValidCallback, castCallback)
	local newSkill = Skill.new(name, targetsNum, isValidCallback, castCallback)
	newSkill.timeToRecharge = 0

	setmetatable(newSkill, {__index = M.SupportSkill})
	return newSkill
end

function M.SupportSkill.getValidTimeToRecharge(timeToRecharge)
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



M.Hero = {}
M.Hero.__index = M.Hero
function M.Hero.new(name, maxHP, attackSkill, supportSkill1, supportSkill2)
	local newHero = {}
	newHero.name = name or error("You must specify hero name")
	newHero.coords = {x=1, y=1}
	newHero.maxHP = maxHP or error("You must specify hero health power")
	newHero.wounds = 0
	newHero.effectsNum = {}
	for effectName, _ in pairs(M.Effects) do
		newHero.effectsNum[effectName] = 0
	end

	newHero.attackSkill = attackSkill or error("You must specify attack skill")
	newHero.supportSkills = {}
	newHero.supportSkills[1] = supportSkill1 or error("You must specify first support skill")
	newHero.supportSkills[2] = supportSkill2 or error("You must specify second support skill")
	setmetatable(newHero, {__index = M.Hero})
	return newHero
end

function M.Hero:setAttackSkill(skill)
	self.attackSkill = skill
end

function M.Hero:castAttackSkill(targets)
	if self.effects.LowVision > 0 then
	end

	local size
	for _, _ in pairs(targets) do
		size = size + 1
	end

	if size == self.targetsNum and self.attackSkill.isValidTargets(self.coords, targets) then
		self.attackSkill.cast(self, targets)

	else
		error("Invalid targets")

	end
end

function M.Hero:setSupportSkill(skill, id)
	if id > 0 and id < 3 then
		self.supportSkills[id] = skill
	else
		error("Invalid skill id. Hero can have only two support skills")
	end
end

function M.Hero:castSupportSkill(targets, id)
	if id > 0 and id < 3 then
		local skill = self.supportSkills[id]
		if skill.timeToRecharge ~= 0 then
			error("Skill is not ready")
		end

		local size
		for _, _ in pairs(targets) do
			size = size + 1
		end

		if size == self.targetsNum and self.supportSkills[id].isValidTargets(self.coords, targets) then
			skill.cast(self, targets)

			skill.timeToRecharge = M.SupportSkill.getValidTimeToRecharge(skill.timeToRecharge)

		else
			error("Invalid targets")
		end
	else
		error("Invalid skill id. Hero have only two support skills")
	end
end


function M.Hero:getArmor()
	local armor = 0
	armor = armor + self.effectsNum.IncreaseArmor
	armor = armor - self.effectsNum.DecreaseArmor
	if armor < 0 then
		armor = 0
	end

	return armor
end

function M.Hero:getAttackModifier()
	local modifier = 0
	modifier = modifier + self.effectsNum.IncreaseAttack
	modifier = modifier - self.effectsNum.DecreaseAttack

	return modifier
end

function M.Hero:damage(damage)
	damage = damage - self:getArmor()

	if damage > 0 then
		self.wounds = self.wounds + damage
	end
end

function M.Hero:move(x, y)
	if self.effectsNum.Paralysed > 0 then
		return
	end

	self.coords = {x=x, y=y}
end

function M.Hero:applyEffect(effectName)
	if self.effectsNum.Immunity > 0 then
		if isEffectNegative(effect) then
			return
		end
	end
	
	self.effectsNum[effectName] = self.effectsNum[effectName] + 1
end

return M