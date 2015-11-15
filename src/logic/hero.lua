local Hero = {}

local Effects = require("logic.effects")
local Skills = require("logic.skills")

function Hero.new(name, maxHP, attackSkill, supportSkill1, supportSkill2)
	local newHero = {}
	newHero.name = name or error("You must specify hero name")
	newHero._position = {x=1, y=1}
	newHero._maxHP = maxHP or error("You must specify hero health power")
	newHero._wounds = 0
	newHero.effects = {}

	newHero.attackSkill = attackSkill
	--[[newHero.supportSkills = {}
	newHero.supportSkills[1] = supportSkill1
	newHero.supportSkills[2] = supportSkill2]]
	setmetatable(newHero, {__index = Hero})
	return newHero
end



function checkTargetsValid(targets, skill)
	for _, target in pairs(targets) do
		if Skill.objectInScope(targets, skill.scope) then
			return false
		end
	end

	return true
end



function Hero:setAttackSkill(skill)
	self.attackSkill = skill
end



function Hero:castAttackSkill(targets)
	if not self.effects.Paralyse then
		if not checkTargetsValid(targets, self.attackSkill) then
			error("Target "..target.name.." isn`t in scope")
		end

		self.attackSkill.cast(self, targets)
	end
end



function Hero:setSupportSkill(skill, id)
	if id > 0 and id < 3 then
		self.supportSkills[id] = skill
	else
		error("Invalid skill id. Hero can have only two support skills")
	end
end



function Hero:castSupportSkill(id, targets)
	if not self.effects.Paralyse then
		if id > 0 and id < 3 then
			local skill = self.supportSkills[id]

			if skill.cooldown ~= 0 then
				error("Skill is not ready")
			end

			if not checkTargetsValid(targets, skill) then
				error("Target "..target.name.." isn`t in scope")
			end

			skill.cast(self, targets)

			skill.cooldown = Skills.SupportSkill.getValidTimeToRecharge(skill.cooldown)

		else
			error("Invalid skill id. Hero have only two support skills")
		end
	end
end


function Hero:getMaxHP()
	return self._maxHP
end



function Hero:getWounds()
	return self._wounds
end



function Hero:getArmor()
	local armor = 0
	armor = armor + self.effects.IncreaseArmor
				  - self.effects.DecreaseArmor
	if armor < 0 then
		armor = 0
	end

	return armor
end



function Hero:getAttackModifier()
	local modifier = 0
	modifier = modifier + self.effects.IncreaseAttack
						- self.effects.DecreaseAttack

	return modifier
end



function Hero:damage(damage)
	damage = damage - self:getArmor()

	if damage > 0 then
		self._wounds = self._wounds + damage
	end
end



function Hero:moveTo(pos)
	if self.effects.Paralysed then
		return
	end
	self._position.x = pos.x
	self._position.y = pos.y
end



function Hero:getPosition()
	local position = {x=self._position.x, y=self._position.y}

	return position
end



function Hero:applyEffect(effect)
	if self.effects.Immunity then
		if Effects.isNegative(effect) then
			return
		end
	end

	if effect == Effects.Immunity then
		self.effects.Immunity = true

	elseif effect == Effects.LowVision then
		self.LowVision = true

	elseif effect == Effects.Paralysed then
		self.effects.Paralysed = true
	
	else
		if self.effects[effect] ~= nil then
			self.effects[effect] = self.effects[effect]+1
		end
	end
end

return Hero