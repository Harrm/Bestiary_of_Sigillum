local Logic = {}



local Field = require("logic.field")
Logic.PhasesPriorities = {[1]="Siege", [2]="Attack", [3]="Prepare", [4]="Support"}
Logic.Rates = {Slow = 1, Average = 2, Fast = 3}


function Logic:init(firstPlayerName, secondPlayerName, rate)
	print("Logic init:")
	print("First player name:", firstPlayerName)
	print("Second player name:", secondPlayerName)
	print("Rate:", rate)
	
	self.players = {}
	self.players.first = {name = firstPlayerName, hp = 16, heroes = {}, basePos = {x=2, y=1}}
	self.players.second = {name = secondPlayerName, hp = 16, heroes = {}, basePos = {x=2, y=9}}
	self.currentPlayer = self.players.first

	self.phase = self.PhasesPriorities[1]

	self.field = Field:init()
end



function Logic:start()
	print("Logic start:")
	self.currentPlayer = self.players.first
	print("Current player:", self.currentPlayer.name)
	self.phase = self.PhasesPriorities[1]
	print("Phase:", self.phase)

	self.players.first.hp = 16
	self.players.second.hp = 16
	for _, hero in ipairs(self.players.first.heroes) do
		hero:moveTo(hero.ownerPlayer.basePos)
		hero._wounds = 0
	end
	
	for _, hero in ipairs(self.players.second.heroes) do
		hero:moveTo(hero.ownerPlayer.basePos)
		hero._wounds = 0
	end

	self:doCurrentPhase()
end



function Logic:isGameOver()
	return self.players.first.hp < 1 or self.players.second.hp < 1
end



function Logic:nextPhase()
	local currentPriority = 0
	for priority, phase in pairs(self.PhasesPriorities) do
		if phase == self.phase then
			currentPriority = priority
		end
	end

	if currentPriority < 4 then
		currentPriority = currentPriority+1
	else
		currentPriority = 1
		self:nextPlayer()
		if self.currentPlayer == self.players.first then
			self:updateSkillsCD()
		end
	end
	self.phase = self.PhasesPriorities[currentPriority]
	print("Next phase: ", self.phase)

	for _, hero in ipairs(self.players.first.heroes) do
		hero.acted = false
	end
	
	for _, hero in ipairs(self.players.second.heroes) do
		hero.acted = false
	end

	self:doCurrentPhase()
end



function Logic:doCurrentPhase()
	print(self.phase, "phase, current player", self.currentPlayer.name)
	if self.phase == "Siege" then
		self:siegePhase()

	elseif self.phase == "Attack" then
		self:attackPhase()

	elseif self.phase == "Prepare" then
		self:preparePhase()

	elseif self.phase == "Support" then
		self:supportPhase()
	end
end



function Logic:siegePhase()
	-- for current player
	for _, tower in ipairs(self.field.towers) do
		local influence = self:getInfluenceOnTower(self.currentPlayer, tower)
	
		-- for opposite player
		self:nextPlayer()
		influence = influence - self:getInfluenceOnTower(self.currentPlayer, tower)

		if influence > 0 then
			self.currentPlayer.hp = self.currentPlayer.hp - 1
		end

		-- restore current player
		self:nextPlayer()
	end
end



function Logic:getInfluenceOnTower(player, towerPos)
	local influence = 0

	for _, hero in ipairs(player.heroes) do
		if self.field:isAdjast(towerPos, hero:getPosition()) then
			influence = influence+1
		end
	end

	return influence
end



function Logic:attackPhase()

end



function Logic:preparePhase()
	-- for current player
	for _, hero in ipairs(self.currentPlayer.heroes) do
		for effect, _ in pairs(hero.effects) do
			if not Effects.isNegative(effect) then
				hero.effects[effect] = nil
			end
		end
	end
	-- for opposite player
	self:nextPlayer()
	for _, hero in ipairs(self.currentPlayer.heroes) do
		for effect, _ in pairs(hero.effects) do
			if Effects.isNegative(effect) then
				hero.effects[effect] = nil
			end
		end
	end
	-- restore current player
	self:nextPlayer()
end



function Logic:supportPhase()

end



function Logic:updateSkillsCD()
	for _, player in ipairs(self.players) do
		for _, hero in ipairs(player.heroes) do
			for _, skill in ipairs(hero.supportSkills) do
				if skill.cooldown > 1 then
					skill.cooldown = skill.cooldown - 1
				end
			end
		end
	end
end



function Logic:setRate(rate)
	if rate == Logic.Rates.Slow then
		self.PhasesPriorities = {[1]="Siege", [2]="Attack", [3]="Prepare", [4]="Support"}

	elseif rate == Logic.Rates.Average then
		self.PhasesPriorities = {[4]="Siege", [1]="Attack", [2]="Prepare", [3]="Support"}

	elseif rate == Logic.Rates.Fast then
		self.PhasesPriorities = {[4]="Siege", [3]="Attack", [1]="Prepare", [2]="Support"}
	end
end



function Logic:castSkill(caster, targets, supportSkillId)
	for _, hero in ipairs(self.currentPlayer.heroes) do
		if caster.name == hero.name then
			print(hero.name, "cast skill")
			if not hero.acted then
				if self.phase == "Attack" then
					caster:castAttackSkill(targets)
					hero.acted = true

				elseif self.phase == "Support" then
					caster:castSupportSkill(supportSkillId, targets)
					hero.acted = true
				else
					print("Invalid phase, can`t cast skill")
				end
				return
			end
		end
	end

	print("Invalid caster")
end



function Logic:moveHero(hero, pos)
	if self.phase == "Attack" then
		for _, player_hero in pairs(self.currentPlayer.heroes) do
			if hero ==  player_hero then
				if not hero.acted then
					if self.field:isAdjast(hero:getPosition(), pos) and self.field:getLandscape(pos.x, pos.y) ~= nil then
						hero:moveTo(pos)
						hero.acted = true
					else
						print ("Not adjast;",
							hero:getPosition().x, hero:getPosition().y,
							pos.x, pos.y)
					end
				end
			end
		end
	else
		print 'Incorrect phase'
	end
end



function Logic:getHero(pos, name)
	if pos == nil and name == nil then
		error("You must specify hero position and/or name")
	end

	for _, hero in ipairs(self.players.first.heroes) do
		if (pos ~= nil and hero:getPosition().x == pos.x and hero:getPosition().y == pos.y) or
			(name ~= nil and hero.name == name) then
			return hero
		end
	end

	for _, hero in ipairs(self.players.second.heroes) do
		if (pos ~= nil and hero:getPosition().x == pos.x and hero:getPosition().y == pos.y) or
			(name ~= nil and hero.name == name) then
			return hero
		end
	end


	return nil
end



function Logic:addHero(playerName, hero)
	local player

	if self.players.first.name == playerName then
		player = self.players.first

	elseif self.players.second.name == playerName then
		player = self.players.second
		
	else
		error("Who is "..playerName.."?!")
	end

	if #player.heroes < 3 then
		table.insert(player.heroes, hero)
		hero.ownerPlayer = player
		hero:moveTo(player.basePos)
	else
		error("Player can`t own more then 3 heroes")
	end
end



function Logic:nextPlayer()
	if self.currentPlayer == self.players.first then
		self.currentPlayer = self.players.second
	else
		self.currentPlayer = self.players.first
	end
end

return Logic
