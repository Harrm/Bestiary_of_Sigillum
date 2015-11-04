local Heroes = {}

local Hero = require("hero")
local Field = require("field")
local Skills = require("skills")
local Effects = require("effects")

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



Heroes = {
	Vinctume = Hero.new("Vinctume", 4, AttackSkills.SeverityOfRetaliation, SupportSkills.IronMask, SupportSkills.PrisonerSnackles)
}

return Heroes