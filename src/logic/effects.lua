local Effects = {Paralysed=1, DoubleAttack=2, IncreaseDefence=3, Immunity=4, LowVision=5, 
				IncreaseArmor=6, DecreaseArmor=7, 
				IncreaseAttack=8, DecreaseAttack=9,
			 	IncreaseChaos=10, DecreaseChaos=11,
			 	IncreaseCooldown=12, DecreaseCooldown=13,
			 	}

local NegativeEffects = {Effects.Paralysed, Effects.LowVision, 
						 Effects.DecreaseArmor, Effects.DecreaseAttack, 
						 Effects.DecreaseChaos, Effects.IncreaseCooldown}
local PositiveEffects = {Effects.DoubleAttack, Effects.IncreaseDefence, 
						 Effects.Immunity, Effects.IncreaseArmor, 
						 Effects.IncreaseAttack, Effects.IncreaseChaos}
function Effects.isNegative(effect)
	for _, ieffect in pairs(NegativeEffects) do
		if ieffect == effect then
			return true
		end
	end
	return false
end

return Effects