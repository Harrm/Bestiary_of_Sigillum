local Hero = {}

local Effects = require("effects")
local Skills = require("skills")

function Hero.new(name, maxHP, attackSkill, supportSkill1, supportSkill2)
	local newHero = {}
	newHero.name = name or error("You must specify hero name")
	newHero.coords = {x=1, y=1}
	newHero.maxHP = maxHP or error("You must specify hero health power")
	newHero.wounds = 0
	newHero.effectsNum = {}
	for effectName, _ in pairs(Effects) do
		newHero.effectsNum[effectName] = 0
	end

	newHero.attackSkill = attackSkill or error("You must specify attack skill")
	newHero.supportSkills = {}
	newHero.supportSkills[1] = supportSkill1 or error("You must specify first support skill")
	newHero.supportSkills[2] = supportSkill2 or error("You must specify second support skill")
	setmetatable(newHero, {__index = Hero})
	return newHero
end

function Hero:setAttackSkill(skill)
	self.attackSkill = skill
end

function Hero:castAttackSkill(targets)
	if self.effects.LowVision > 0 then
	end

	local size
	for _, _ in pairs(targets) do
		size = size + 1
	end

	if size == self.targetsNum and self.attackSkill.checkTargetsValidCallback(self.coords, targets) then
		self.attackSkill.cast(self, targets)

	else
		error("Invalid targets")

	end
end

function Hero:setSupportSkill(skill, id)
	if id > 0 and id < 3 then
		self.supportSkills[id] = skill
	else
		error("Invalid skill id. Hero can have only two support skills")
	end
end

function Hero:castSupportSkill(targets, id)
	if id > 0 and id < 3 then
		local skill = self.supportSkills[id]
		if skill.timeToRecharge ~= 0 then
			error("Skill is not ready")
		end

		local size
		for _, _ in pairs(targets) do
			size = size + 1
		end

		if size == self.targetsNum and self.supportSkills[id].checkTargetsValidCallback(self.coords, targets) then
			skill.cast(self, targets)

			skill.timeToRecharge = Skills.SupportSkill.getValidTimeToRecharge(skill.timeToRecharge)

		else
			error("Invalid targets")
		end
	else
		error("Invalid skill id. Hero have only two support skills")
	end
end


function Hero:getArmor()
	local armor = 0
	armor = armor + self.effectsNum.IncreaseArmor
	armor = armor - self.effectsNum.DecreaseArmor
	if armor < 0 then
		armor = 0
	end

	return armor
end

function Hero:getAttackModifier()
	local modifier = 0
	modifier = modifier + self.effectsNum.IncreaseAttack
	modifier = modifier - self.effectsNum.DecreaseAttack

	return modifier
end

function Hero:damage(damage)
	damage = damage - self:getArmor()

	if damage > 0 then
		self.wounds = self.wounds + damage
	end
end

function Hero:moveOn(x, y)
	if self.effectsNum.Paralysed > 0 then
		return
	end

	self.coords.x = self.coords.x+x
	self.coords.y = self.coords.x+y
end

function Hero:applyEffect(effectName)
	if self.effectsNum.Immunity > 0 then
		if Effects.isEffectNegative(effect) then
			return
		end
	end
	
	self.effectsNum[effectName] = self.effectsNum[effectName] + 1
end

return Hero