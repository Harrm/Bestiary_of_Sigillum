local Game = {}

local Logic = require('logic.logic')
local Graphic = require('graphic.graphic')
local Heroes = require('logic.heroes')

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

	Graphic:init()
	Graphic.newGameCallback = function() self:newGame() end
	Graphic.exitCallback = function() Game.isOver = true end
	Graphic.tileCheckedCallback = function(x, y) self:tileChecked(x, y) end
	Graphic.nextPhaseCallback = function() self:nextPhase() end
	Graphic.heroCheckedCallback = 
		function(heroName) self:setCurrentHero(Logic:getHero(nil, heroName)) end
	
	self:createHeroesIcons()
	MOAIInputMgr.device.keyboard:setCallback(self.onKeyboardEvent)
end



function Game:newGame()
	Logic:start()
	Graphic:update()
end



function Game:tileChecked(tileX, tileY)
	io.flush()
	local logicCoords = {x=tileX, y=tileY}
	local hero = Logic:getHero(logicCoords)
	if hero ~= nil then
		self:setCurrentHero(hero)

	elseif self.currentHero ~= nil then
		Logic:moveHero(self.currentHero, logicCoords)
		local graphicCoords = self.currentHero:getPosition()
		Graphic:moveHeroIcon(self.currentHero.name, graphicCoords.x, graphicCoords.y)
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
		end
	end
end



return Game
