local Heroes = {}

local Hero = require("logic.hero")
local Skills = require("logic.skills")
local Effects = require("logic.effects")
--[[
local AttackSkills = {}
AttackSkills.SeverityOfRetaliation = {}


function AttackSkills.SeverityOfRetaliation.castCallback(self, targets)
	target:damage(self.wounds)
end

AttackSkills.SeverityOfRetaliation = Skills.AttackSkill.new("Severity of retaliation",
														    1,
									    		    		AttackSkills.SeverityOfRetaliation.isValidCallback,
												 		    AttackSkills.SeverityOfRetaliation.castCallback)


function AttackSkills.CrucibleOfHell.isValidCallback(start, targets)
	
end

function AttackSkills.CrucibleOfHell.castCallback(self, targets)
	target:damage(self.wounds)
end

AttackSkills.CrucibleOfHell = Skills.AttackSkill.new("Crucible of hell",
													 1,
									    		     AttackSkills.CrucibleOfHell.isValidCallback,
												 	 AttackSkills.CrucibleOfHell.castCallback)


local SupportSkills = {}
SupportSkills.IronMask = {}
function SupportSkills.IronMask.isValidCallback(start, targets)
	if Field.isAdjast(unpack(start), unpack(target.coords)) then
		return true
	end
end

function SupportSkills.IronMask.castCallback(self, targets)
	targets[1]:move(targets[1].coords.x - self.coords.x,
					targets[1].coords.y - self.coords.y)
end

SupportSkills.IronMask = Skills.SupportSkill.new("IronMask",
												1,
												SupportSkills.IronMask.isValidCallback,
												SupportSkills.IronMask.castCallback)
SupportSkills.PrisonerSnackles = {}
function SupportSkills.PrisonerSnackles.isValidCallback(start, targets)
	if Field.isAdjast(unpack(start), unpack(target.coords)) then
		return true
	end
end

function SupportSkills.PrisonerSnackles.castCallback(self, targets)
	target:applyEffect(Effects.Paralyzed)
end

SupportSkills.PrisonerSnackles = Skills.SupportSkill.new("Prisoner Snackles",
											   1,
									    	   SupportSkills.PrisonerSnackles.isValidCallback,
											   SupportSkills.PrisonerSnackles.castCallback)


]]
Heroes.Field = nil


function BallistarusAttack(self, targets)
	if Heroes.Field == nil then error("You must specify field") end

	if Skill.checkTargetsValid(Heroes.Field, self:getPosition(), targets[1]:getPosition()) then
		local damage = 0
		for _, point in Heroes.Field:getStraightLine(self:getPosition(), targets[1]:getPosition()) do
			if Heroes.Field.cells[point.x][point.y] == Field.Landscapes.Plain or
				Heroes.Field.cells[point.x][point.y] == Field.Landscapes.Water then
				damage = damage + 1
			end 
		end

		targets[1]:damage(damage)

	else
		error("Invalid targets")
	end


end


local Heroes = {
	Vinctume = Hero.new("Vinctume", 4),
	Ferrarius = Hero.new("Ferrarius", 4),
	Suxum = Hero.new("Suxum", 4),
	Cerberus = Hero.new("Cerberus", 3),
	Redux = Hero.new("Redux", 3), 
	Ballistarius = Hero.new("Ballistarius", 3),
	Manus = Hero.new("Manus", 2), 
	Messum = Hero.new("Messum", 2), 
	Goecio = Hero.new("Goecio", 2)
}

return Heroes