local Heroes = {}

local Hero = require("logic.hero")
local Skills = require("logic.skills")
local Effects = require("logic.effects")
local Field = require('logic.field')
local Logic = require('logic.logic')



function VinctumeAttack(self, targets)
	if Field == nil then error("You must specify field") end

	if self.attackSkill:checkTargetsValid(Field, self:getPosition(), {targets[1]:getPosition()}) then
		local damage = 0

		targets[1]:damage(self:getWounds())

	else
		print("Invalid targets")
	end
end



function ManusAttack(self, targets)
	if Field == nil then error("You must specify field") end

	if self.attackSkill:checkTargetsValid(Field, self:getPosition(), {targets[1]:getPosition()}) then
		local damage = 0
		targets[1]:damage(1)
	else
		print("Invalid targets")
	end
end



function BallistarusAttack(self, targets)
	if Field == nil then error("You must specify field") end

	if self.attackSkill:checkTargetsValid(Field, self:getPosition(), {targets[1]:getPosition()}) then
		local damage = 0
		for _, point in ipairs(Field:getStraightLine(self:getPosition(), targets[1]:getPosition())) do
			if Field.cells[point.x][point.y] == Field.Landscapes.Plain or
				Field.cells[point.x][point.y] == Field.Landscapes.Water then
				damage = damage + 1
			end 
		end

		targets[1]:damage(damage-1)

	else
		print("Invalid targets")
	end
end



function MessumAttack(self, targets)
	if Field == nil then error("You must specify field") end

	if self.attackSkill:checkTargetsValid(Field, self:getPosition(), {targets[1]:getPosition()}) and
		targets[1].ownerPlayer ~= self.ownerPlayer then
		local damage = 1
		for _, hero in ipairs(targets[1].ownerPlayer.heroes) do
			if hero ~= targets[1] and Field:isAdjast(targets[1]:getPosition(), hero:getPosition()) then
				damage = 0
				break
			end
		end

		targets[1]:damage(damage)

	else
		print("Invalid targets")
	end
end



function FerrariusAttack(self)
	if Field == nil then error("You must specify field") end

	print "Ferrarius attack"

	if Field:getLandscape(self:getPosition().x, self:getPosition().y) == Field.Landscapes.Water then
		return
	end

	local adjastents = Field:getAdjastentsCoords(self:getPosition())
	print(adjastents)
	for _, targetPos in ipairs(adjastents) do
		local target = Logic:getHero(targetPos)
		print(targetPos.x, targetPos.y)
		if target ~= nil then
			print (target.name)
			if target.ownerPlayer ~= self.ownerPlayer and 
				Field:getLandscape(target:getPosition().x, target:getPosition().y) ~= Field.Landscapes.Water then
				target:damage(1)
			end
		end
	end
end



local Heroes = {
	Vinctume = Hero.new("Vinctume", 4, Skills.AttackSkill.new("Severity of retaliation", "Adjast", VinctumeAttack)),
	Ferrarius = Hero.new("Ferrarius", 4, Skills.AttackSkill.new("Hell crucible", "SixAdjast", FerrariusAttack)),
	Suxum = Hero.new("Suxum", 4, Skills.AttackSkill.new("Burst", "RangeStraight", BallistarusAttack)),
	Cerberus = Hero.new("Cerberus", 3, Skills.AttackSkill.new("Three-head bite", "ThreeAdjast", BallistarusAttack)),
	Redux = Hero.new("Redux", 3, Skills.AttackSkill.new("Bone boomerang", "SixAdjast", FerrariusAttack)),
	Ballistarius = Hero.new("Ballistarius", 3, Skills.AttackSkill.new("Ballista", "RangeStraight", BallistarusAttack)),
	Manus = Hero.new("Manus", 2, Skills.AttackSkill.new("Spiky armor", "Adjast", BallistarusAttack)),
	Messum = Hero.new("Messum", 2, Skills.AttackSkill.new("Reaping", "Any", MessumAttack)), 
	Goecio = Hero.new("Goecio", 2, Skills.AttackSkill.new("Chain lightning", "RangeStraight", BallistarusAttack))
}

return Heroes
