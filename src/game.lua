local Game = {}

local Field = require("field")
local Graphic = require("graphic")
local HeroPickScreen = require("hero_pick_screen")

function Game:start()
	self:init()

	while true do
		self:processInput()
		coroutine.yield()
	end
end



function Game:init()
	self:initLogic()
	self:initGraphic()
	HeroPickScreen:init(self.players.first, self.players.second)
	HeroPickScreen:show()
end



function Game:initGraphic()
	Graphic:init()
	Graphic:setField(self.field)
end



function Game:initLogic()
	self.players = {}
	self.players.first = {name="Radiant", hp=17, heroes={}}
	self.players.second = {name="Dire", hp=17, heroes={}}
	self.players.current = self.players.first

	self.field = Field.new(unpack(self.players))
end



function Game:processInput()
	if MOAIInputMgr.device.keyboard:keyDown(27) then
		if HeroPickScreen.shown then
			HeroPickScreen:hide()
			Graphic:show()
		end
	end

	if MOAIInputMgr.device.mouseLeft:isDown() and not self.isMouseLeftDown then
		local x, y = MOAIInputMgr.device.pointer:getLoc()
		if HeroPickScreen.shown then
		 	local worldX, worldY = HeroPickScreen.layer:wndToWorld(x, y)
			if HeroPickScreen.tilesProp:inside(worldX, worldY) then
				HeroPickScreen:proccessInput(worldX, worldY)
			end
			print(self.players.first.heroes[1].name)

		else
			local worldX, worldY = Graphic.layer:wndToWorld(x, y)
			local modelX, modelY = Graphic.tilesProp:worldToModel(worldX, worldY)
			local tileX, tileY = Graphic.grid:locToCoord(modelX, modelY)
			if self.field:getCell(tileX, tileY) ~= nil then
				Graphic.grid:setTile(tileX, tileY, 2)
			end
		end
	end

	if MOAIInputMgr.device.mouseLeft:isDown() then
		self.isMouseLeftDown = true
	else
		self.isMouseLeftDown = false
	end
end



function Game:pickHeroes()

end



function Game:isOver()
	return self.players.first.hp < 1 or self.players.second.hp < 1
end



function Game:updateSkills()
	for player, _ in pairs(self.players) do
		for hero, _ in pairs(players[player].heroes) do
			for skill, _ in pairs(players[player].heroes[hero].supportSkills) do
				local skill = players[player].heroes[hero].supportSkills[skill]
				skill.timeToRecharge = skill.timeToRecharge - 1
			end
		end
	end
end

function Game:siegePhase()
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

return Game