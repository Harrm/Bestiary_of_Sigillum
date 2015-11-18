local Game = {}

local Logic = require('logic.logic')
local Graphic = require('graphic.graphic')
local Heroes = require('logic.heroes')

Game.Modes = {Move=1, Attack=2, Support=3}

function Game:start()
	self:init()

	while not self.isOver do
		Graphic:processMouse()
		coroutine.yield()
	end

	os.exit()
end



function Game:init()
	Logic:init("Radiant", "Dire")
	Logic:addHero("Radiant", Heroes.Vinctume)
	Logic:addHero("Radiant", Heroes.Redux)
	Logic:addHero("Radiant", Heroes.Manus)
	Logic:addHero("Dire", Heroes.Ferrarius)
	Logic:addHero("Dire", Heroes.Ballistarius)
	Logic:addHero("Dire", Heroes.Messum)

	Heroes.Field = Logic.field

	Graphic:init()
	Graphic.newGameCallback = function() self:newGame() end
	Graphic.exitCallback = function() Game.isOver = true end
	Graphic.tileCheckedCallback = function(x, y) self:tileChecked(x, y) end
	Graphic.nextPhaseCallback = function() self:nextPhase() end
	Graphic.heroCheckedCallback = 
		function(heroName) self:setCurrentHero(Logic:getHero(nil, heroName)) end
	
	self:createHeroesIcons()
	MOAIInputMgr.device.keyboard:setCallback(self.onKeyboardEvent)

	self.mode = Game.Modes.Move
end



function Game:newGame()
	Logic:start()
	Graphic:update()
	self.mode = Game.Modes.Move
	Graphic.gui.stateTextbox:setString("Move mode")

end



function Game:tileChecked(tileX, tileY)
	io.flush()
	local logicCoords = {x=tileX, y=tileY}
	local hero = Logic:getHero(logicCoords)
	if self.mode == Game.Modes.Move then
		if hero ~= nil then
			self:setCurrentHero(hero)

		elseif self.currentHero ~= nil then
			print("Move hero", self.currentHero.name, "to", logicCoords.x, logicCoords.y)
			Logic:moveHero(self.currentHero, logicCoords)
			local graphicCoords = self.currentHero:getPosition()
			Graphic:moveHeroIcon(self.currentHero.name, graphicCoords.x, graphicCoords.y)
		end

	elseif self.mode == Game.Modes.Attack then
		if self.currentHero == nil then
			self.currentHero = hero

		elseif self.currentHero ~= nil then
			print 'cast skill'

			if self.currentHero.attackSkill.scope == "SixAdjast" then
				Logic:castSkill(self.currentHero, nil)
			else
				if hero ~= nil then
					Logic:castSkill(self.currentHero, {hero})
				end
			end
			self.mode = Game.Modes.Move
			Graphic.gui.stateTextbox:setString("Move mode")
		end
	end

	Graphic:update()
	io.flush()
end



function Game:setCurrentHero(hero)
	if self.currentHero ~= nil then
		Graphic.heroesIcons.icons[self.currentHero.name]:setScl(1)
	end
	self.currentHero = hero
	Graphic.heroesIcons.icons[hero.name]:setScl(0.9)
end



function Game:nextPhase()
	Logic:nextPhase()
	if Logic:isGameOver() then
		Graphic:showVictoryScreen(Logic.currentPlayer.name)
	elseif Logic.phase == Logic.PhasesPriorities[1] then
		Graphic.heroesIcons:swapAuras()
	end
end



function Game:createHeroesIcons()
	for _, hero in pairs(Logic.players.first.heroes) do
		local tile = hero:getPosition()
		Graphic:addHeroIcon(hero.name, tile.x, tile.y, false)
	end

	for _, hero in pairs(Logic.players.second.heroes) do
		local tile = hero:getPosition()
		Graphic:addHeroIcon(hero.name, tile.x, tile.y, true)
	end


end



function Game.onKeyboardEvent(key, down)
	if down then
		if key == 27 then
			Graphic:showMenu()
		
		elseif key == string.byte('a') then
			Game.mode = Game.Modes.Attack
			Graphic.gui.stateTextbox:setString("Attack mode")

		elseif key == string.byte('m') then
			Game.mode = Game.Modes.Move
			Graphic.gui.stateTextbox:setString("Move mode")
		end
	end
end



return Game
