Player = {}
function Player.new(name)
	local newPlayer = {}
	newPlayer.name = name or "Anonymous"
	newPlayer.heroes = {}
	newPlayer.hp = 17

	setmetatable(newPlayer, {__index = Player})
	return newPlayer;
end

function Player:addHero(hero)
	if #self.heroes < 4 then
		self.heroes[#self.heroes+1] = hero
		hero.ownerPlayer = self

	else
		error("Player can`t own more than 3 heroes")
	end
end
players = { first = Player.new("Radiant"), 
 			second = Player.new("Dire")}
currentPlayer = players.first

Field = require("field")
field = Field.createField(players.first, players.second)
HeroBuilder = require("hero")



function pickHeroes()

end

function isEnd()
	return players.first.hp < 1 or players.second.hp < 1
end

function updateSkills()
	for player, _ in pairs(players) do
		for hero, _ in pairs(players[player].heroes) do
			for skill, _ in pairs(players[player].heroes[hero].supportSkills) do
				local skill = players[player].heroes[hero].supportSkills[skill]
				skill.timeToRecharge = skill.timeToRecharge - 1
			end
		end
	end
end

function siegePhase()
	for _, tower in pairs(field.towers) do
		local defence = {firstPlayer = 0, secondPlayer = 0}
		for _, cell in pairs(field:getAdjastentCells(tower.x, tower.y)) do
			cell = field[cell.x][cell.y]
			if cell.occupyingHero ~= nil then
				if cell.occupyingHero.ownerPlayer == players.first then
					defence.firstPlayer = defence.firstPlayer + 1 + cell.occupyingHero.effectsNum.IncreaseDefence
				elseif cell.occupyingHero.ownerPlayer == players.second then
					defence.secondPlayer = defence.secondPlayer + 1 + cell.occupyingHero.effectsNum.IncreaseDefence
				else
					error("Invalid hero owner player")
				end
			end
		end
		if currentPlayer == players.first and defence.firstPlayer > defence.secondPlayer then
			players.second.hp = players.second.hp - 1

		elseif currentPlayer == players.second and defence.secondPlayer > defence.firstPlayer then
			players.first.hp = players.first.hp - 1
		end
	end
end

function attackPhase()
	if #currentPlayer.heroes > 0 then
		print(currentPlayer.name, "check attaking hero:")
		local name = io.read()
		for _, hero in pairs(currentPlayer.heroes) do
			if hero.name == name then
				print("Check targets")
				local targets = {}
				for x = 1, hero.attackSkill.targetsNum do
					local x = 0
					local y = 0
					x = io.read("*n")
					y = io.read("*n")
					table.insert(targets, 1, field[x][y].occupyingHero)
				end
				hero:castAttackSkill(targets)
			end
		end
	end
end

function preparePhase()

end

function supportPhase()

end

function period()
	updateSkills()

	for _, player in pairs(players) do
		currentPlayer = player
		print(currentPlayer.name)
		siegePhase()
		attackPhase()
		preparePhase()
		supportPhase()
	end
end


pickHeroes()
HeroBuilder = require("hero")
attackSkill = HeroBuilder.AttackSkill.new("Attack", 1, function()return true end, function()end)
supportSkill1 = HeroBuilder.SupportSkill.new("Support1", 1, function()return true end, function()end)
supportSkill2 = HeroBuilder.SupportSkill.new("Support2", 1, function()return true end, function()end)

hero = HeroBuilder.Hero.new("Anonymous", 3, attackSkill, supportSkill1, supportSkill2)
players.second:addHero(hero)
field[1][1].occupyingHero = hero

field.draw(field)

local counter = 0
while not isEnd() do
	counter = counter + 1
	if counter > 1000 then
		print("Moar!!!")
	end
	print("turn", counter)
	period()
	--field:draw()
end